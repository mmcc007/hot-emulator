#!/usr/bin/env bash

# start emulator from an existing avd with a default snapshot

emu_name='test'
emu_options="-no-audio -no-window -no-boot-anim -gpu swiftshader"
$ANDROID_HOME/emulator/emulator -avd $emu_name $emu_options &

# wait for emulator to start up
./script/android-wait-for-emulator.sh
