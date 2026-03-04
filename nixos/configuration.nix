{ config, pkgs, inputs, ... }:

{
  # Bootloader setup (equivalent to EFISTUB but gives us rollback capability)
  boot.loader.systemd-boot.enable = true;
  # Fast boot: timeout 0 skips the menu but allows holding Space to show it.
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  # Support ZFS
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "c0defeca"; # Required by ZFS. Use `head -c 4 /dev/urandom | od -A none -t x4` to generate a real one if needed, but this works.

  # Kernel setup
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Hardware configuration
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # Networking
  networking.hostName = "XPS";
  networking.useNetworkd = true;
  networking.wireless.iwd.enable = true;

  systemd.network.networks."99-wired-wildcard" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
    dhcpV4Config.RouteMetric = 10;
  };
  systemd.network.networks."99-wireless-wildcard" = {
    matchConfig.Type = "wlan";
    networkConfig = {
      DHCP = "yes";
      IgnoreCarrierLoss = "3s";
    };
    dhcpV4Config.RouteMetric = 20;
  };

  # NTP is enabled by default in NixOS, but we define the timezone and locale
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  # Hardware Clock
  time.hardwareClockInLocalTime = false;

  # Touchpad configuration (libinput)
  # Disabling tap-to-click per user request, while keeping natural scrolling
  services.libinput = {
    enable = true;
    touchpad.tapping = false;
    touchpad.naturalScrolling = true;
    touchpad.accelSpeed = "0.5";
  };

  # User Configuration
  users.users.nahue = {
    isNormalUser = true;
    description = "Nahuel";
    extraGroups = [ "wheel" "audio" "video" "docker" "networkmanager" ];
    # Passwords should generally be set via `passwd nahue` post-installation
    # Or handled by an age/sops secret. We leave it normal so it can be set.
  };

  # ZFS Auto-Unlock at Login using PAM Exec
  # We read the password from PAM and pass it to zfs load-key.
  # The dataset is zroot/home.
  security.pam.services.login.text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
    auth optional pam_exec.so expose_authtok ${pkgs.writeShellScript "zfs-unlock" ''
      DATASET="zroot/home"
      # Only process for the user "nahue"
      if [ "$PAM_USER" = "nahue" ]; then
        STATUS=$(zfs get -H -o value keystatus $DATASET)
        if [ "$STATUS" = "unavailable" ]; then
          # Read auth token from expose_authtok pipeline and pipe to zfs load-key
          cat | zfs load-key $DATASET
          zfs mount $DATASET || true
        fi
      fi
    ''}
  '');

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Services
  services.auto-cpufreq.enable = true;
  services.syncthing = {
    enable = true;
    user = "nahue";
    dataDir = "/home/nahue";
    configDir = "/home/nahue/.config/syncthing";
  };
  virtualisation.docker.enable = true;

  # ZFS auto-trim is configured in Disko, but scrubbing is here
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";

  # Enable SSH (often useful)
  services.openssh.enable = true;

  # Wayland Display Manager (greetd with tuigreet)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Drops straight into Hyprland after login
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Wayland Window Manager (Hyprland)
  programs.hyprland.enable = true;

  # Set DPI globally for Wayland/Xwayland
  # Note: Hyprland configuration in home.nix handles scaling,
  # but we can set GDK/QT variables here.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint to electron apps to use Wayland
  };

  # System Packages (from the original paru list)
  environment.systemPackages = with pkgs; [
    acpilight
    alsa-utils
    auto-cpufreq
    bash-completion
    bluez
    bluez-tools
    btop
    dua
    efibootmgr
    feh
    git
    htop
    intel-gpu-tools
    keepassxc
    keychain
    kind
    kitty
    maim # Might want to replace with grim/slurp for Wayland
    man-db
    mpv
    ncdu
    playerctl
    steam
    stow
    syncthing
    vim
    wget
    curl
    wpa_supplicant
    xdg-user-dirs
    xdg-utils
    yt-dlp
  ];

  # Enables flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Do not change this unless you read the NixOS options!
  system.stateVersion = "24.05";
}
