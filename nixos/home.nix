{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nahue";
  home.homeDirectory = "/home/nahue";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Wayland Replacements and other user utilities
    grim # replacement for maim
    slurp # replacement for maim selection
    wl-clipboard # replacement for xclip
    mako # notification daemon (replacement for dunst/rofi built-ins context)
    wofi # wayland application launcher (replacement for rofi)
    waybar # wayland bar (replacement for polybar)
    wlogout # logout menu

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    font-awesome

    # GUI Apps
    google-chrome
    slack
    vscode
  ];

  # Enable Home Manager to manage fonts
  fonts.fontconfig.enable = true;

  # Hyprland Configuration
  # This serves as the Wayland equivalent to your bspwm config.
  # Scaling of 2 handles the "Xft.dpi: 192" high DPI request.
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration. scale 2 is equivalent to DPI 192 (192/96 = 2.0)
      monitor = ",preferred,auto,2";

      # Autostart applications
      exec-once = [
        "waybar"
        "mako"
        "syncthing serve --no-browser"
      ];

      # Basic input settings
      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
          tap-to-click = false;
        };
      };

      # Keybindings (similar to sxhkd)
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, Space, exec, wofi --show drun"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"

        # Audio controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Brightness controls (using acpilight)
        ", XF86MonBrightnessUp, exec, xbacklight -inc 5"
        ", XF86MonBrightnessDown, exec, xbacklight -dec 5"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ] ++
        # Workspaces
        builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10);
    };
  };

  # Shell settings
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Nahuel";
    userEmail = ""; # User should fill this in or let existing dotfiles configure it
    # Aliases and other details can go here
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
