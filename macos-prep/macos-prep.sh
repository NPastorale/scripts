#!/bin/bash

echo "Checking Command Line Tools for Xcode"
# Only run if the tools are not installed yet
# To check that try to print the SDK path
xcode-select -p &>/dev/null
if [ $? -ne 0 ]; then
    echo "Command Line Tools for Xcode not found. Installing from softwareupdate..."
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
    softwareupdate -i "$PROD" --verbose
else
    echo "Command Line Tools for Xcode are already installed"
fi

echo "Checking Homebrew"
which brew &>/dev/null
if [ $? -ne 0 ]; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Adding brew to PATH"
    (
        echo
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed"
fi

echo "Updating Homebrew..."
brew update

echo "Installing git..."
brew install --no-quarantine git

# TODO: Get dotfiles

echo "Checking Oh My ZSH..."

if [ -d ~/.oh-my-zsh ]; then
    echo "Oh My Zsh is already installed"
else
    echo "Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# TODO: Get omz themes and plugins

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

# Apps
apps=(
    google-chrome
    kitty
    docker
    visual-studio-code
)

# Install apps to /Applications instead of /Users/$user/Applications
echo "Installing apps with cask..."
brew install --no-quarantine --cask --appdir="/Applications" ${apps[@]}

brew cleanup

echo "Setting some mac defaults..."

# TODO: Mac settings

killall Finder

echo "Done"
