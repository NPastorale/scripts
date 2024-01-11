# DroidCam Launcher Script <!-- omit from toc -->

This script facilitates the launch of DroidCam, a tool that enables Android devices to function as webcams for computers. It performs the necessary actions to start the DroidCam application on an Android device and connects it to the computer using the `droidcam-cli` utility.

- [Usage](#usage)
- [Steps Performed by the Script](#steps-performed-by-the-script)
- [Running the Script](#running-the-script)
- [Disclaimer](#disclaimer)

## Usage

Ensure that you have the following prerequisites before running the script:

- Android Debug Bridge (ADB) installed on your system.
- DroidCamX application installed on your Android device.

## Steps Performed by the Script

1. **Navigate to Home Screen**: Sends a key event to the Android device to return to the home screen.
2. **Force-Stop DroidCamX**: Stops the DroidCamX application if it is currently running.
3. **Start DroidCamX**: Launches the DroidCamX application.
4. **Wait for Initialization**: Waits for a short duration (1.5 seconds) to allow DroidCamX to initialize.
5. **Connect to Computer**: Uses `droidcam-cli` to connect to the Android device over ADB on port 4747.

## Running the Script

1. Connect your Android device to your computer using a USB cable.
2. Ensure that ADB is installed and properly configured.
3. Make the script executable: `chmod +x droidcam_activate.sh`
4. Run the script: `./droidcam_activate.sh`

**Note:** Adjustments to the script may be needed based on your specific environment and configurations.

## Disclaimer

This script is provided as-is, and you should review and understand each step before running it. Use at your own risk.
