#!/usr/bin/env bash

# start emulator from an existing avd (with a quickboot snapshot)

# fail on any error
set -e

emu_name='test'
emu_options="-no-audio -no-window -no-boot-anim -gpu swiftshader"
# redirect stdin, stdout and stderr to avoid hanging if called from ssh
/opt/android-sdk/emulator/emulator -avd $emu_name $emu_options > emulator.out 2> emulator.err < /dev/null &
cat emulator.out
cat emulator.err
