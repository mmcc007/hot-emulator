#!/usr/bin/env bash

# create avd and quickstart snapshot

show_help() {
  printf "usage: $0 [command]

Utility for creating an AVD and a quickstart snapshot

Commands:
    --avd
        creates an AVD
    --snapshot
        creates quickstart snapshot
    --archive
        archives avd with quickstart snapshot
"
}

emu_name='test'

create_avd(){
  echo creating avd...

EMULATOR_API_LEVEL=22; ANDROID_ABI="default;armeabi-v7a"
#EMULATOR_API_LEVEL=25; ANDROID_ABI="google_apis;armeabi-v7a"
#EMULATOR_API_LEVEL=24; ANDROID_ABI="default;armeabi-v7a"

# stop emulator (have to wait for emulator to stop)
#adb emu kill

# restart only or also create new avd?
  # install images and create new avd

  # setup and launch emulator inside the container
  # create a new Android Virtual Device
  #echo "no" | avdmanager create avd -n test -k "system-images;android-25;google_apis;armeabi-v7a"
  # launch emulator
  #emulator64-arm -avd test -noaudio -no-boot-anim -accel on -gpu swiftshader_indirect &
  #emulator -avd test -noaudio -no-boot-anim -accel on -gpu swiftshader_indirect &
  #emulator64-arm -avd test -noaudio -no-boot-anim -gpu offscreen
  #emulator -avd test -noaudio -no-boot-anim -gpu swiftshader &
  
  # Install system image and create avd
  #sdkmanager "system-images;android-$EMULATOR_API_LEVEL;$ANDROID_ABI" > /dev/null
  sdkmanager "system-images;android-$EMULATOR_API_LEVEL;$ANDROID_ABI"
  sdkmanager --list | head -15
  echo no | avdmanager create avd --force -n $emu_name -k "system-images;android-$EMULATOR_API_LEVEL;$ANDROID_ABI"
  # increase avd ram (from 96 MB)
  echo "hw.ramSize=1024" >> /root/.android/avd/$emu_name.avd/config.ini
}

create_snapshot(){
  echo creating quickstart snapshot...

#emu_options="-no-audio -no-window -gpu swiftshader"
#emu_options="-no-audio -no-boot-anim -gpu swiftshader"
#emu_options="-no-audio -no-window -no-boot-anim -gpu off"
emu_options="-no-audio -no-window -no-boot-anim -gpu swiftshader"

  # start emu (if restarting, uses default snapshot)
  $ANDROID_HOME/emulator/emulator -avd $emu_name $emu_options &
#  echo Starting emulator $emu_name with api $EMULATOR_API_LEVEL and ABI ${ANDROID_ABI} in background...
  
  # wait for emulator to start
  ./script/android-wait-for-emulator.sh

  # stop emulator to create quickstart snapshot
  adb emu kill
}

archive_avd(){
  echo archiving avd with quickstart snapshot...
  (cd ~/.android; tar czvf avd.tar.gz avd)
}

# if no command passed
if [ -z $1 ]; then
  echo Error: command required
  show_help
else
  case $1 in
    --avd)
	create_avd
        ;;
    --snapshot)
	create_snapshot
        ;;
    --archive)
	archive_avd
        ;;
    *)
        echo Unknown command: $1
        show_help
        ;;
  esac
fi
