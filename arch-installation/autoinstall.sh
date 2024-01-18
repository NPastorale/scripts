#!/usr/bin/env bash

readonly disk="/dev/nvme0n1"
readonly hostname='XPS'
readonly domain='nahue.ar'
readonly username='nahue'
readonly name='Nahuel'

# ===================================================
# ==Do not change variables from this point onwards==
# ===================================================

blue='\033[0;34m'
green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m' # No Color

echo -e "${blue}=============================================================="
echo -e "${blue}============= Welcome to the Nahue Arch Installer ============"
echo -e "${blue}==============================================================${nc}"

# Unmount partitions and close LUKS container, useful when rerunning the script
umount -R /mnt &>/dev/null
cryptsetup close home-$username &>/dev/null

# Check internet connectivity
curl -ILs --fail --output /dev/null https://www.google.com || {
	echo "${red}No internet connection. Exiting..."
	exit 1
}

# Eliminate Arch Linuux entries in EFI
for i in $(efibootmgr | cut -d" " -f1 | cut -c5-8); do
	efibootmgr -Bb $i
done &>/dev/null

# Set the password for the user
echo -n "Set password: "
IFS= read -rs password
echo

echo -n "Confirm password: "
IFS= read -rs password2
echo

[[ "$password" == "$password2" ]] || {
	echo "Passwords do not match. Exiting..."
	exit 1
}

# Enable NTP
echo -e "${green}Enabling NTP${nc}"
timedatectl set-ntp true

# Destroy the GPT data structures and create new partitions. 500MiB for EFI, 50GiB for root and the rest for the home partition.
echo -e "${green}Partitioning disk${nc}"
sgdisk -Z $disk
sgdisk -n 0:0:+500M -t 0:ef00 -c 0:"EFI" $disk
sgdisk -n 0:0:+50G -t 0:8300 -c 0:"root" $disk
sgdisk -n 0:0:0 -t 0:8300 -c 0:"home" $disk

# Encrypt the home partition
echo -e "${green}Encrypting home partition${nc}"
echo -n $password | cryptsetup luksFormat "$disk"p3 --key-file -
echo -n $password | cryptsetup open "$disk"p3 --key-file - home-$username

# Format the partitions
echo -e "${green}Formatting partitions${nc}"
yes | mkfs.fat -F32 "$disk"p1
yes | mkfs.ext4 "$disk"p2
yes | mkfs.ext4 /dev/mapper/home-$username

# Mount the partitions
echo -e "${green}Mounting partitions${nc}"
mount "$disk"p2 /mnt
mkdir /mnt/boot
mount "$disk"p1 /mnt/boot

# Set my mirror as the server for Arch packages
echo "Server = https://mirrors.nahue.ar/\$repo/os/\$arch" >/etc/pacman.d/mirrorlist

# Configure pacman to color the output
sed -i "s/^#Color*/Color/" /etc/pacman.conf

# Set pacman parallel downloads to 5
sed -i "/^#ParallelDownloads =/c\ParallelDownloads = 5" /etc/pacman.conf

# Install the essential packages
pacstrap /mnt \
	base \
	base-devel \
	linux \
	linux-firmware

# Configure pacman to color the output
sed -i "s/^#Color*/Color/" /mnt/etc/pacman.conf

# Set pacman parallel downloads to 5
sed -i "/^#ParallelDownloads =/c\ParallelDownloads = 5" /mnt/etc/pacman.conf

# Enable multilib
awk -i inplace '$0=="#[multilib]"{c=2} c&&c--{sub(/#/,"")} 1' /mnt/etc/pacman.conf

# Refresh the package database
arch-chroot /mnt pacman -Syy

# Generate the fstab for the current partitions
genfstab -U /mnt >>/mnt/etc/fstab

# Configure the generation of locale for en_US.UTF-8
sed -i "s/^#en_US.UTF-8 UTF-8*/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen

# Set the locale to en_US.UTF-8
echo "LANG=en_US.UTF-8" >/mnt/etc/locale.conf

# Generate the locale
arch-chroot /mnt locale-gen

# Set the timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

# Set the Hardware Clock to the current System Time
arch-chroot /mnt hwclock --systohc

# Set the hostmane
echo $hostname >/mnt/etc/hostname

# Create the hosts file and configure it with the variables defined at the start
cat <<-EOF >/mnt/etc/hosts
	127.0.0.1  localhost
	::1        localhost
	127.0.1.1  $hostname.$domain  $hostname
EOF

# Configure sytemd-networkd wired network
cat <<-EOF >/mnt/etc/systemd/network/99-wired-wildcard.network
	[Match]
	Type=ether
	Name=en*

	[Network]
	DHCP=yes

	[DHCP]
	RouteMetric=10
EOF

# Configure sytemd-networkd wireless network
cat <<-EOF >/mnt/etc/systemd/network/99-wireless-wildcard.network
	[Match]
	Type=wlan

	[Network]
	DHCP=yes
	IgnoreCarrierLoss=3s

	[DHCP]
	RouteMetric=20
EOF

# Create the home directory
mkdir /mnt/home/$username

# Mount the encrypted home partition
mount /dev/mapper/home-$username /mnt/home/$username

# Create the user
useradd -R /mnt -m -G audio,video $username

# Change ownership of the home directory to the created user
arch-chroot /mnt chown -R $username:$username /home/$username

# Sets the password for the created user
echo $username:$password | chpasswd -R /mnt

# Set a skeleton home
arch-chroot /mnt cp -r /etc/skel/. /home/$username

# Set the root password
echo root:$password | chpasswd -R /mnt

# Create a link for vim to vi
arch-chroot /mnt ln -sf /usr/bin/vim /usr/bin/vi

# Change finger information
arch-chroot /mnt chfn -f $name $username

# Clone paru repository
curl -o /mnt/home/$username/paru-bin.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/paru-bin.tar.gz

# Untar the paru files
tar -xf /mnt/home/$username/paru-bin.tar.gz -C /mnt/home/$username

# Grant all permissions to the paru directory
chmod 777 -R /mnt/home/$username/paru-bin

# Add the created user as a passwordless sudoer
cat <<-EOF >/mnt/etc/sudoers.d/$username
	$username ALL=(ALL) NOPASSWD:ALL
EOF

# Create a workaround script to install paru and additional packages
cat <<-EOF >/mnt/home/$username/paru.sh
	#!/bin/bash

	cd /home/$username/paru-bin
	sudo -u $username makepkg -sri --noconfirm
	sudo -u $username paru --noconfirm --batchinstall -Syyu \
		acpilight \
		alsa-utils \
		apple-fonts \
		auto-cpufreq \
		bash-completion \
		blueman \
		bluez \
		bluez-utils \
		bspwm \
		btop \
		docker \
		droidcam \
		dua-cli \
		efibootmgr \
		feh \
		git \
		gnome-keyring \
		google-chrome \
		htop \
		intel-gpu-tools \
		intel-media-driver \
		intel-ucode \
		iwd \
		keepassxc \
		keychain \
		kind-bin \
		kitty \
		leafpad \
		light-locker \
		lightdm-mini-greeter \
		maim \
		man-db \
		mpv \
		ncdu \
		oh-my-zsh-git \
		openssh \
		picom \
		playerctl \
		polybar \
		pulseaudio \
		pulseaudio-alsa \
		pulseaudio-bluetooth \
		rofi \
		slack-desktop \
		sof-firmware \
		steam \
		stow \
		sxhkd \
		syncthing \
		ttf-font-awesome \
		vim \
		visual-studio-code-bin \
		wpa_supplicant \
		xcape \
		xdg-user-dirs \
		xdg-utils \
		xf86-input-libinput \
		xorg-server \
		xorg-xsetroot \
		yt-dlp

	sudo -u $username git clone https://github.com/NPastorale/.dotfiles.git /home/$username/.dotfiles
	sudo -u $username /home/$username/.dotfiles/setup.sh
	exit
EOF

# Grant execution permission to the script
chmod +x /mnt/home/$username/paru.sh

# Execute the script
arch-chroot /mnt /home/$username/paru.sh

# Remove the script
rm /mnt/home/$username/paru.sh

# Remove the paru repository
rm -rf /mnt/home/$username/paru-bin
rm -rf /mnt/home/$username/paru-bin.tar.gz

# Change the DPI to 192. TEMPORARY while I find a dynamyc solution
cat <<-EOF >/mnt/home/$username/.Xresources
	Xft.dpi: 192
EOF

# Create an EFI entry to allow EFISTUB boot
arch-chroot /mnt efibootmgr --disk $disk --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=PARTUUID='$(blkid "$disk"p2 -s PARTUUID | cut -d'"' -f 2)' rw initrd=\initramfs-linux.img' --verbose

# Add user to the docker group
usermod -R /mnt -aG docker $username

# Change the created user to still be a sudoer but requiring a password
cat <<-EOF >/mnt/etc/sudoers.d/$username
	$username ALL=(ALL) ALL
EOF

#  Configure lightdm
sed -i "/^#greeter-session=/c\greeter-session=lightdm-mini-greeter" /mnt/etc/lightdm/lightdm.conf
sed -i "/^#user-session=/c\user-session=bspwm" /mnt/etc/lightdm/lightdm.conf
sed -i "/^user = CHANGE_ME/c\user = ${username}" /mnt/etc/lightdm/lightdm-mini-greeter.conf
cp /mnt/home/$username/.dotfiles/lightdm/lightdm-mini-greeter.conf /mnt/etc/lightdm/lightdm-mini-greeter.conf

# Configure the home partition to be mounted and decrypted at login
# https://wiki.archlinux.org/title/Dm-crypt/Mounting_at_login
echo "auth       optional   pam_exec.so expose_authtok /etc/pam_cryptsetup.sh" >>/mnt/etc/pam.d/system-login

cat <<-EOF >/mnt/etc/pam_cryptsetup.sh
	#!/usr/bin/env bash

	CRYPT_USER="$username"
	PARTITION="${disk}p3"
	NAME="home-\$CRYPT_USER"

	[[ "\$PAM_USER" == "\$CRYPT_USER" && ! -e "/dev/mapper/\$NAME" ]] && /usr/bin/cryptsetup open "\$PARTITION" "\$NAME"
EOF

cat <<-EOF >/mnt/etc/systemd/system/home-$username.mount
	[Unit]
	Requires=user@1000.service
	Before=user@1000.service

	[Mount]
	Where=/home/$username
	What=/dev/mapper/home-$username

	[Install]
	RequiredBy=user@1000.service
EOF

chmod +x /mnt/etc/pam_cryptsetup.sh

# Configure touchpad
cat <<-EOF >/mnt/etc/X11/xorg.conf.d/30-touchpad.conf
	Section "InputClass"
		Identifier "libinput touchpad catchall"
		MatchIsTouchpad "on"
		MatchDevicePath "/dev/input/event*"
		Option "Tapping" "on"
		Option "NaturalScrolling" "true"
		Option "AccelSpeed" "0.5"
		Driver "libinput
	EndSection
EOF

# Enable services
arch-chroot /mnt systemctl enable home-nahue.mount
arch-chroot /mnt systemctl enable systemd-networkd.service
arch-chroot /mnt systemctl enable systemd-resolved.service
arch-chroot /mnt systemctl enable lightdm.service
arch-chroot /mnt systemctl enable fstrim.timer
arch-chroot /mnt systemctl enable auto-cpufreq
arch-chroot /mnt systemctl enable syncthing@nahue.service
arch-chroot /mnt systemctl enable docker.service
arch-chroot /mnt systemctl enable iwd
