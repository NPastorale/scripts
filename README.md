# Scripts Repository <!-- omit from toc -->

This collection houses a variety of useful scripts to simplify and enhance my workflow. You'll find a diverse set of scripts here to automate tasks.

- [Introduction](#introduction)
- [Scripts Overview](#scripts-overview)
  - [Arch Linux Installation](#arch-linux-installation)
  - [DroidCam Launcher](#droidcam-launcher)
  - [macOS Developer Environment Setup](#macos-developer-environment-setup)
  - [Ubuntu Developer Environment Setup](#ubuntu-developer-environment-setup)
- [Ansible Playbooks](#ansible-playbooks)
  - [Network UPS Tools](#network-ups-tools)
  - [Raspberry Pi Kubernetes Cluster](#raspberry-pi-kubernetes-cluster)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository is a curated collection of scripts designed to make my life easier by automating common tasks and providing solutions to various challenges.

## Scripts Overview

### Arch Linux Installation

- Automates the installation of Arch Linux. It handles disk partitioning, encryption, user creation, package installation, and system configuration. The script also sets up networking, installs an AUR helper (paru), configures services, and optimizes the environment.

### DroidCam Launcher

- Checks and configures the environment for DroidCam. It initializes the app on a connected Android device and uses `droidcam-cli` to use it.

### macOS Developer Environment Setup

- Automates the setup of a macOS development environment. It checks and installs Command Line Tools for Xcode, Homebrew, Git, and Oh My Zsh. Additionally, it installs essential apps like Google Chrome, Kitty, Docker, and Visual Studio Code using Homebrew.

### Ubuntu Developer Environment Setup

- Streamline Debian-based system setup. This script automates installation of key development tools, enabling passwordless sudo, and configuring essential packages.

## Ansible Playbooks

A collection of playbooks catering to different needs

### Network UPS Tools

- Automates the initial setup for a Raspberry Pi. Focuses on setting up Network UPS Tools (NUT) for monitoring connected devices. It installs NUT packages, gathers UPS information, configures global and device-specific UPS settings, and sets up monitoring and network configurations.

### Raspberry Pi Kubernetes Cluster

- Automates the setup of a Kubernetes cluster running on several Raspberry Pis using `kubeadm` and resulting in a fully functional cluster. In my infrastructure, the necessity for this playbook has been superseded by [Talos](https://www.talos.dev/)

## Getting Started

To get started with the scripts in this repository, follow these simple steps:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/NPastorale/scripts.git
   ```

2. **Navigate to the Repository:**

   ```bash
   cd scripts
   ```

## Usage

> **⚠️ Warning ⚠️**
>
> **_Caution and Review Required_**
>
> The scripts in this repository are tailored to my needs. Before executing any of them, it is crucial to thoroughly review its content and understand its functionality. These scripts are provided as-is, and their execution may have varying effects on your system or environment.

Detailed instructions on how to use each script can be found in their respective _README_.

## Contributing

Contributions are welcome! If you have a script you'd like to add or if you find a bug, feel free to open an issue or submit a pull request.

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. You are free to use, modify, and distribute the scripts, but I encourage giving credit where credit is due.
