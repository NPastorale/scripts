#!/bin/env bash
###########################################################################
# Check if running as root
###########################################################################
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

###########################################################################
# Enable passwordless sudo
###########################################################################
cat <<EOF >/etc/sudoers.d/$SUDO_USER
$SUDO_USER ALL=(ALL) NOPASSWD:ALL
EOF

###########################################################################
# Install dependenies
###########################################################################
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y \
        curl \
        git \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        gpg

###########################################################################
# Download deb packages
###########################################################################
curl -L "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" --output /tmp/chrome.deb
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" --output /tmp/vscode.deb
curl -L "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" --output /tmp/bitwarden.deb
curl -L "https://cdn.akamai.steamstatic.com/client/installer/steam.deb" --output /tmp/steam.deb

###########################################################################
# Add gpg keys
###########################################################################
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://syncthing.net/release-key.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/syncthing-archive-keyring.gpg >/dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg >/dev/null
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/hashicorp-archive-keyring.gpg >/dev/null
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-archive-keyring.gpg >/dev/null
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

###########################################################################
# Add sources
###########################################################################
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo add-apt-repository -y ppa:phoerious/keepassxc

###########################################################################
# Kind installation
###########################################################################
curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest |
        grep "kind-linux-amd64" |
        head -2 | cut -d : -f 2,3 |
        tr -d \" |
        wget -qi - -O kind
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

###########################################################################
# Apt installations
###########################################################################
sudo apt update
sudo apt install -y \
        /tmp/chrome.deb \
        /tmp/vscode.deb \
        /tmp/bitwarden.deb \
        /tmp/steam.deb \
        syncthing \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin \
        kubectl \
        gh \
        terraform

###########################################################################
# Docker final steps
###########################################################################
sudo groupadd docker
sudo usermod -aG docker $SUDO_USER

###########################################################################
# Autocompletion
###########################################################################
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null
gh completion -s bash | sudo tee /etc/bash_completion.d/gh >/dev/null
kind completion bash | sudo tee /etc/bash_completion.d/kind >/dev/null
terraform -install-autocomplete

###########################################################################
# Cleanup
###########################################################################
rm /tmp/*.deb
sudo apt autoremove --purge -y
