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

# Mostly CrossOver dependencies
dependency_packages=(
  "perl-File-Copy"
  "fontconfig.i686"
  "fontconfig.x86_64"
  "gstreamer1-plugins-bad-free.i686"
  "gstreamer1-plugins-bad-free.x86_64"
  "gstreamer1-plugins-base.i686"
  "gstreamer1-plugins-base.x86_64"
  "gstreamer1-plugins-good.i686"
  "gstreamer1-plugins-good.x86_64"
  "gstreamer1.i686"
  "gstreamer1.x86_64"
  "libXcomposite.i686"
  "libXcomposite.x86_64"
  "libXinerama.i686"
  "libXinerama.x86_64"
  "nss-mdns.i686"
  "nss-mdns.x86_64"
  "pcsc-lite-libs.i686"
  "pcsc-lite-libs.x86_64"
  "pulseaudio-libs.i686"
  "pulseaudio-libs.x86_64"
  "sane-backends-libs.i686"
  "sane-backends-libs.x86_64"
  "vulkan-loader.i686"
  "vulkan-loader.x86_64"
)

dnf_packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
  ${dependency_packages[@]}
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

cat >/usr/lib/tmpfiles.d/crossover.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
C+     $canon_dest  -     -     -      -    $dest
EOF

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
