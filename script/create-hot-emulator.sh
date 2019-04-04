#!/usr/bin/env bash

# create avd and quickstart snapshot

# fail on any error
set -e

show_usage() {
  printf "usage: $0 <option>

Utility for creating an AVD and a quickstart snapshot

Options:
    --snapshot
        creates quickstart snapshot
    --archive
        create tar file of snapshot
	(run before starting emulator)
    --start
        start hot emulator (as a test)
"
}

usage_fail() { echo "$@";  show_usage; exit 111; }

# check for required pre-defined vars
check_predefined_vars(){
  required_vars=(android_home emu_name android_abi emulator_api emu_options)
  for name in "${required_vars[@]}"; do 
    eval var='$'$name
    [ -z "${var}" ] && { echo "$name not defined"; exit 1; }
  done
  return 0
}


# creates a new avd
create_avd(){
  echo creating avd...

  # stop emulator (if running)
  SERVICE="emulator"
  if pgrep "$SERVICE" >/dev/null; then
    adb emu kill
  fi

  # clear old avd directory
  rm -rf ~/.android/avd

  # Install system image and create avd
  sdkmanager "system-images;android-$emulator_api;$android_abi"
  sdkmanager --list | head -15
  echo no | avdmanager create avd --force -n $emu_name -k "system-images;android-$emulator_api;$android_abi"
  # increase avd ram (from 96 MB)
  echo "hw.ramSize=1024" >> $HOME/.android/avd/$emu_name.avd/config.ini
}

create_snapshot(){
  create_avd
  echo creating quickstart snapshot...

  # start emu (if restarting, uses default snapshot)
  $ANDROID_HOME/emulator/emulator -avd $emu_name $emu_options &
  
  # wait for emulator to start
  ./script/android-wait-for-emulator.sh

  # stop emulator to create quickstart snapshot
  adb emu kill

  #archive_avd
}

archive_avd(){
  echo archiving avd with quickstart snapshot...
  (cd ~/.android; tar czvf avd.tar.gz avd)
  mv ~/.android/avd.tar.gz .

  # copy archive to web server
  sudo cp avd.tar.gz /var/www/html
}

# start the hot emulator to confirm it is working
start_hot_emulator(){
  # redirect stdin, stdout and stderr to avoid hanging if called from ssh
  #emulator -avd $emu_name $emu_options > emulator.out 2> emulator.err < /dev/null &
  #cat emulator.out
  #cat emulator.err
  $ANDROID_HOME/emulator/emulator -avd $emu_name $emu_options -no-snapshot-save &

  # wait for emulator to start
  ./script/android-wait-for-emulator.sh

  # stop emulator to create quickstart snapshot
  adb emu kill

}

source create-hot-emulator.env
check_predefined_vars

# if no option passed
if [ -z $1 ]; then
  usage_fail Error: option required
else
  case $1 in
    --snapshot)
	create_snapshot
        ;;
    --archive)
	archive_avd
        ;;
    --start)
	start_hot_emulator
        ;;
    *)
	usage_fail Error: unknown option: $1
        ;;
  esac
fi
