# Ubuntu Developer Environment Setup Script <!-- omit from toc -->

This script is designed to automate the setup of a development environment on an Ubuntu system.

- [Passwordless Sudo](#passwordless-sudo)
- [Dependency Installation](#dependency-installation)
- [GPG Keys and Sources](#gpg-keys-and-sources)
- [Kind (Kubernetes in Docker) Installation](#kind-kubernetes-in-docker-installation)
- [Apt Installations](#apt-installations)
- [Docker Configuration](#docker-configuration)
- [Autocompletion](#autocompletion)
- [Cleanup](#cleanup)
- [Usage](#usage)
- [Disclaimer](#disclaimer)

## Passwordless Sudo

The script enables passwordless sudo for the executing user to streamline administrative tasks.

## Dependency Installation

Installs essential dependencies and tools for development, including:

- Google Chrome
- Visual Studio Code
- Bitwarden
- Steam
- Syncthing
- Docker and Docker Compose
- Kubernetes tools (kubectl, kind)
- GitHub CLI (gh)
- Terraform

## GPG Keys and Sources

Adds GPG keys and package sources for various tools and repositories, ensuring secure and verified installations.

## Kind (Kubernetes in Docker) Installation

Downloads and installs `kind`, a tool for running local Kubernetes clusters using Docker container nodes.

## Apt Installations

Installs packages using the Advanced Package Tool (apt), including the previously downloaded deb packages and various development tools.

## Docker Configuration

Creates a docker group and adds the user to it, ensuring that Docker commands can be executed without sudo.

## Autocompletion

Configures command autocompletion for `kubectl`, `gh` (GitHub CLI), `kind`, and `terraform`.

## Cleanup

Removes temporary deb packages and performs system cleanup by removing unnecessary packages.

## Usage

Ensure that you run the script with root privileges.

```bash
sudo ./ubuntu-prep.sh
```

## Disclaimer

This script is provided as-is, and you should review and understand each step before running it. Use at your own risk.
