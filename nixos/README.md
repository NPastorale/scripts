# NixOS Installation Translation

This directory contains the declarative NixOS translation of your previous Arch Linux installation script. This setup provides a fully reproducible deployment utilizing modern Nix conventions.

## Features Included
- **Flakes & Disko:** Completely declarative definitions of the OS and the disk layouts.
- **ZFS & Encryption:** Uses ZFS as the root and home filesystem layout. The `/home` dataset has native ZFS encryption (`aes-256-gcm`) configured.
- **Auto-unlocking Home:** Instead of requiring a password at boot, you will boot directly to the `greetd` login screen. When you log in with your password, a PAM script automatically leverages `zfs load-key` and unlocks your `/home` dataset dynamically.
- **Wayland & Hyprland:** Completely replaced the X11 stack (bspwm, sxhkd, rofi, picom) with modern Wayland equivalents (Hyprland, wofi, mako, waybar), managed through **Home Manager**.
- **Systemd-boot:** Replaces EFISTUB. Provides instantaneous boot (`timeout = 0`) exactly like EFISTUB, but allows you to hold `Space` during boot to select previous NixOS generations—a crucial safety and best practice feature in NixOS.

## How to Install from Scratch

If you are on a blank computer, follow these steps to deploy this exact system in minutes.

### 1. Boot the Live ISO
1. Flash the [latest NixOS Minimal ISO (x86_64)](https://nixos.org/download.html) onto a USB stick.
2. Boot from the USB stick into the live system.

### 2. Connect to the Internet
Since this requires pulling packages from the internet:

If you are on WiFi, configure it using `wpa_cli` or `nmtui`:
```bash
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "YOUR_WIFI_NAME"
> set_network 0 psk "YOUR_WIFI_PASSWORD"
> enable_network 0
> quit
```

Ensure you have a connection with `curl -I https://google.com`.

### 3. Run the Installer
Run the automated installation script directly from GitHub. This script will prompt you for a password, download the configuration, run Disko (which will prompt you to confirm the ZFS encryption password), install the system, and set your root/user passwords automatically without further intervention!

```bash
sudo bash <(curl -s https://raw.githubusercontent.com/NPastorale/scripts/main/nixos/install.sh)
```

Remove the USB stick and boot. The system will boot almost instantly into `greetd`. Entering the custom password you set will organically unlock the decrypt `/home` dataset and launch Hyprland!

<details>
<summary>Manual Installation Steps (Alternative)</summary>

If you prefer applying the steps manually instead of using the fully automated script:

1. Clone the repository:
   ```bash
   nix-shell -p git
   git clone https://github.com/NPastorale/scripts.git
   cd scripts/nixos
   ```

2. Partition the disk with Disko:
   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko-config.nix
   ```

3. Install the system:
   ```bash
   sudo nixos-install --flake .#XPS
   ```

4. Set passwords:
   ```bash
   sudo nixos-enter
   passwd root
   passwd nahue
   exit
   ```
</details>

## Post-Installation
Your `.dotfiles` configuration script (`setup.sh`) and related repositories have been left as a manual step, considering Home Manager natively handles ZSH and Hyprland config logic. You can easily pull down your old dotfiles repository in `~/` and apply whatever manual modifications remain.
