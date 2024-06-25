#!/bin/bash

# Check if adb is installed
if ! command -v adb &>/dev/null; then
    echo "Error: adb (Android Debug Bridge) is not installed."
    echo "Please install adb and make sure it's in your system's PATH."
    exit 1
fi

# Check if droidcam-cli is installed
if ! command -v droidcam-cli &>/dev/null; then
    echo "Error: droidcam-cli is not installed."
    echo "Please install droidcam-cli and make sure it's in your system's PATH."
    exit 1
fi

# Send key event to navigate to the home screen on the Android device
adb shell input keyevent KEYCODE_HOME

# Force-stop DroidCamX
adb shell am force-stop com.dev47apps.droidcamx

# Start DroidCamX
adb shell am start -n com.dev47apps.droidcamx/com.dev47apps.droidcamx.DroidCamX -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

# Wait for initialization
sleep 1.5

# Connect to computer using droidcam-cli over ADB on port 4747
droidcam-cli adb 4747

# Force-stop DroidCamX
adb shell am force-stop com.dev47apps.droidcamx

# Wait for DroidCamX to stop
sleep 0.5

# Remove activity from recent apps
adb shell input keyevent KEYCODE_APP_SWITCH
adb shell input keyevent KEYCODE_TAB
adb shell input keyevent DEL
adb shell input keyevent DEL
adb shell input keyevent DEL
adb shell input keyevent DEL
adb shell input keyevent DEL

# Leave the screen off
adb shell input keyevent KEYCODE_HOME
adb shell input keyevent KEYCODE_SLEEP
