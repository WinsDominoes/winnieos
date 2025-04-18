#!/bin/bash

set -ouex pipefail

# Packages
dnf5 copr enable -y derenderkeks/proxmox-backup-client
sysadmin_packages=(
  "proxmox-backup-client"
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
  "sway"
)

dnf_packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
)

# install rpms
dnf5 install -y ${dnf_packages[@]} --skip-unavailable
dnf5 install -y @cosmic-desktop-environment

# install fzf-tab-completion
# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion
dnf5 copr disable -y derenderkeks/proxmox-backup-client
# brew_packages=(
#   "btop"
#   "dysk"
#   "dust"
#   "ffmpeg"
#   "fzf"
#   "broot"
# )
# 
# brew install ${brew_packages[@]}
