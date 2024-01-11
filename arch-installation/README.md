# Arch Linux Installation Script <!-- omit from toc -->

This script automates the installation process of Arch Linux with a specific configuration tailored to my preferences. It covers essential steps such as disk partitioning, system configuration, user creation, and the installation of additional packages.

- [Usage](#usage)
- [Steps Performed by the Script](#steps-performed-by-the-script)
- [Running the Script](#running-the-script)
- [Disclaimer](#disclaimer)

## Usage

Before running the script, make sure to review and customize the following variables at the beginning of the script according to your preferences:

- `disk`: The target disk for the installation.
- `hostname`: The desired hostname for the system.
- `domain`: The domain name associated with the hostname.
- `username`: The username for the primary user account.
- `name`: The full name of the user.

## Steps Performed by the Script

1. **Unmount and Close**: Unmounts partitions and closes LUKS container, useful for rerunning the script.
2. **Internet Connectivity Check**: Ensures there is an internet connection before proceeding.
3. **EFI Cleanup**: Eliminates Arch Linux entries in EFI.
4. **Password Setup**: Prompts for and sets the password for the user.
5. **NTP Configuration**: Enables NTP for time synchronization.
6. **Disk Partitioning**: Creates EFI, root, and home partitions on the specified disk.
7. **Home Partition Encryption**: Encrypts the home partition using LUKS.
8. **Partition Formatting**: Formats EFI, root, and home partitions.
9. **Mounting Partitions**: Mounts the formatted partitions.
10. **Package Installation**: Installs essential packages for the base system.
11. **Locale and Timezone Configuration**: Configures locale, generates locale, and sets timezone.
12. **Hostname and Network Configuration**: Sets hostname and configures network settings.
13. **User and Home Directory Setup**: Creates the user, sets passwords, and configures home directory.
14. **Pacaur Installation**: Clones and installs Pacaur (AUR helper) for managing AUR packages.
15. **Additional Package Installation**: Installs a set of additional packages using Pacaur.
16. **EFI Boot Entry Creation**: Adds an EFI entry for Arch Linux to allow EFISTUB boot.
17. **Post-Installation Cleanup**: Removes unnecessary files and configurations.
18. **Service Enablement**: Enables various services such as systemd, LightDM, and others.

## Running the Script

1. Boot the Arch Linux live environment.
2. Ensure you have an internet connection.
3. Make the script executable: `chmod +x arch_install.sh`
4. Run the script: `./arch_install.sh`

**Note:** After installation, the system will automatically reboot into the configured Arch Linux environment. Review any error messages during the process and address them accordingly.

## Disclaimer

This script is provided as-is, and you should review and understand each step before running it. Use at your own risk.

  <!--
  TODO: remmina                                  remote desktop client
  TODO: thunar, nemo, nautilus                   file managers
  TODO: TMUX
  TODO: WATERFALL fonts preview
  TODO: timeshift backup
  TODO: ROFI
  TODO: LOGOUT UI
  TODO: UNDERVOLT
  TODO: PLYMOUTH  BOOT SPLASH SCREEN
  TODO: IMPROVING PERFORMANCE WIKI
  TODO: SOLID STATE DRIVE WIKI
  TODO: SYSTEM MAINTENANCE WIKI
  TODO: SECURITY WIKI
  TODO: zsh and oh my zsh
  -->
