#!/bin/bash

set -ouex pipefail


# Packages
dnf5 copr enable -y derenderkeks/proxmox-backup-client
dnf5 copr enable -y swayfx/swayfx

sysadmin_packages=(
  "proxmox-backup-client"
)

programming_packages=(
  "i3blocks"
  "gparted"
)

utility_packages=(
  "trivalent"
  "keyd"
  "micro"
  "swayfx"
  "fuzzel"
  "mullvad-vpn"
)

dnf_packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
)

# install rpms
dnf5 install -y ${dnf_packages[@]} --skip-unavailable
# install fzf-tab-completion
mkdir -p /usr/share/factory/var/opt
mv -Tv /var/opt /usr/lib/opt
mkdir -p /var/opt # Recreate an empty dir, just in case
echo "C+ /var/opt - - - - /usr/share/factory/var/opt" >>/usr/lib/tmpfiles.d/bazzite-factory-opt.conf
# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion
dnf5 copr disable -y derenderkeks/proxmox-backup-client
dnf5 copr disable -y swayfx/swayfx
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/secureblue.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/mullvad.repo


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
