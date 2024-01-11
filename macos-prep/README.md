# macOS Developer Environment Setup Script <!-- omit from toc -->

This script automates the setup of a development environment on a macOS system. It performs the following tasks:

- [Command Line Tools for Xcode Installation](#command-line-tools-for-xcode-installation)
- [Homebrew Installation](#homebrew-installation)
- [Adding Brew to PATH](#adding-brew-to-path)
- [Homebrew Update](#homebrew-update)
- [Git Installation](#git-installation)
- [Homebrew Cleanup](#homebrew-cleanup)
- [Oh My Zsh Installation](#oh-my-zsh-installation)
- [Zsh Syntax Highlighting Plugin](#zsh-syntax-highlighting-plugin)
- [App Installation](#app-installation)
- [macOS System Settings](#macos-system-settings)
- [Usage](#usage)
- [Disclaimer](#disclaimer)

## Command Line Tools for Xcode Installation

Checks for and installs the Command Line Tools for Xcode if not already installed.

## Homebrew Installation

Installs the Homebrew package manager for macOS.

## Adding Brew to PATH

Updates the user's profile (`~/.zprofile`) to include Homebrew in the system's PATH.

## Homebrew Update

Updates Homebrew and its formulas.

## Git Installation

Installs Git using Homebrew.

## Homebrew Cleanup

Cleans up Homebrew by removing outdated versions.

## Oh My Zsh Installation

Installs Oh My Zsh, a delightful community-driven framework for managing Zsh configurations.

## Zsh Syntax Highlighting Plugin

Installs the Zsh Syntax Highlighting plugin.

## App Installation

Installs various applications using Homebrew Cask:

- Google Chrome
- Kitty
- Docker
- Visual Studio Code

## macOS System Settings

Configures certain macOS system settings for developer-friendly behavior:

- Disables OS X Gatekeeper to install apps from sources other than the Mac App Store.
- Checks for software updates daily.
- Adjusts trackpad and mouse speed.
- Shows all filename extensions in Finder.
- Sets Dock to auto-hide with no delay.
- Enables UTF-8 in Terminal.app and sets the Pro theme.

## Usage

1. Ensure that the script has execute permissions:

```bash
chmod +x setup_dev_environment_mac.sh
```

2. Run the script:

```bash
./setup_dev_environment_mac.sh
```

## Disclaimer

This script is provided as-is. Review its content to ensure it meets your requirements and aligns with best practices for your environment. Use it responsibly, and customize it based on your specific needs.

---

**Note:** The script assumes a macOS environment and installs developer tools and applications accordingly. Customize it as needed for your specific requirements and preferences.
