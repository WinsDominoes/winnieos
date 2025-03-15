#!/bin/bash

set -ouex pipefail

# Packages

sysadmin_packages=(
  "subscription-manager"
  "cockpit-navigator"
  "cockpit-bridge"
  "cockpit-system"
  "cockpit-selinux"
  "cockpit-networkmanager"
  "cockpit-storaged"
  "cockpit-podman"
  "cockpit-machines"
  "cockpit-kdump"
  "libguestfs-tools"
  "NetworkManager-tui"
  "virt-install"
  "virt-manager"
  "virt-viewer"
)

programming_packages=(
  "codium"
  "gh"
  "insync"
)

utility_packages=(
  "trivalent"
  "keyd"
  "micro"
  "syncthing"
  "stow"
)

dnf_packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
)

# install rpms
dnf5 install -y ${packages[@]}

# install fzf-tab-completion
# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion

brew_packages=(
  "btop"
  "dysk"
  "dust"
  "ffmpeg"
  "fzf"
  "broot"
)