#!/bin/bash

set -ouex pipefail

# Packages 
dnf5 copr enable -y derenderkeks/proxmox-backup-client
dnf5 copr enable -y swayfx/swayfx

sysadmin_packages=(
  "proxmox-backup-client"
  "slimbook-meta-gnome"
  "slimbook-service"
)

programming_packages=(
  "i3blocks"
  "gparted"
  "codium"
)

utility_packages=(
  "trivalent"
  "keyd"
  "micro"
  "swayfx"
  "fuzzel"
)

dnf_packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
)

# install rpms
dnf5 install -y ${dnf_packages[@]} --skip-unavailable

# install fzf-tab-completion

# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion
dnf5 copr disable -y derenderkeks/proxmox-backup-client
dnf5 copr disable -y swayfx/swayfx
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/secureblue.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/Slimbook.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/vscodium.repo

# Mullvad VPN
canon_dest=/var/opt/'Mullvad VPN'
dest=/usr/share/factory/${canon_dest##/}

mkdir -p /var/opt /usr/share/factory/var/opt
dnf5 install -y mullvad-vpn

ls /var/opt/

mv -T "$canon_dest" "$dest" 

cat >/usr/lib/tmpfiles.d/mullvad-vpn.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
C+     $canon_dest  -     -     -      -    $dest
EOF

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/mullvad.repo

# CrossOver
canon_dest=/var/opt/'cxoffice'
dest=/usr/share/factory/${canon_dest##/}

dnf5 install -y http://crossover.codeweavers.com/redirect/crossover.rpm

cp -r "$canon_dest" "$dest"

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
