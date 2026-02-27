#!/usr/bin/env bash

# Exit on error
set -e

# Display welcome message
green='\033[0;32m'
nc='\033[0m'

echo -e "${green}=============================================================="
echo -e "============= Welcome to the Nahue NixOS Installer ==========="
echo -e "==============================================================${nc}"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (or use sudo)."
  exit 1
fi

# 1. Check internet connectivity
echo -e "\n${green}[1/5] Checking internet connection...${nc}"
curl -ILs --fail --output /dev/null https://www.google.com || {
	echo "No internet connection. Please connect to Wi-Fi first."
	exit 1
}

# 2. Get passwords upfront to automate the rest
echo -e "\n${green}[2/5] System setup...${nc}"
echo -n "Set system password (used for user login and ZFS home decryption): "
read -rs PASSWORD
echo
echo -n "Confirm password: "
read -rs PASSWORD2
echo

if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
	echo "Passwords do not match. Exiting..."
	exit 1
fi

# 3. Fetch configuration
echo -e "\n${green}[3/5] Fetching configuration from GitHub...${nc}"
rm -rf /tmp/nixos-install
nix-shell -p git --run "git clone https://github.com/NPastorale/scripts.git /tmp/nixos-install"
cd /tmp/nixos-install/nixos

# 4. Partition disk
echo -e "\n${green}[4/5] Partitioning disk with Disko...${nc}"
echo -e "NOTE: You will be prompted by ZFS to enter a passphrase. Please use the password you just typed above."
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko-config.nix

# 5. Install NixOS
echo -e "\n${green}[5/5] Installing NixOS...${nc}"
nixos-install --flake .#XPS --no-root-passwd

# 6. Set passwords automatically
echo -e "\n${green}Setting user and root passwords automatically...${nc}"
nixos-enter --root /mnt --command "echo 'root:$PASSWORD' | chpasswd"
nixos-enter --root /mnt --command "echo 'nahue:$PASSWORD' | chpasswd"

# 7. Done
echo -e "\n${green}Installation complete! You can now remove the USB and 'reboot'.${nc}"
