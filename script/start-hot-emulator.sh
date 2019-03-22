#!/usr/bin/env bash

# start emulator from an existing avd with a default snapshot

emu_name='test'
emu_options="-no-audio -no-window -no-boot-anim -gpu swiftshader"
nohup $ANDROID_HOME/emulator/emulator -avd $emu_name $emu_options &

# disown emulator process to allow shell to exit
#emu_pid=$(ps x| grep emulator64-arm| tail -n1 | awk '{print $1}')
#disown -h $emu_pid

# wait for emulator to start up
#./script/android-wait-for-emulator.sh
