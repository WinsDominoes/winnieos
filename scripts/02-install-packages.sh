#!/bin/bash

CHROOT="fedora-43-x86_64"

set -ouex pipefail

dnf config-manager addrepo --from-repofile=https://repo.secureblue.dev/secureblue.repo
dnf config-manager setopt secureblue.enabled=0
dnf -y install --enablerepo='secureblue' trivalent

dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:/Slimbook/Fedora_43/home:Slimbook.repo
dnf config-manager setopt home_Slimbook.enabled=0
dnf -y install --enablerepo='home_Slimbook' slimbook-meta-gnome slimbook-service

dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf config-manager setopt tailscale-stable.enabled=0
dnf -y install --enablerepo='tailscale-stable' tailscale

systemctl enable tailscaled
# Packages 
dnf5 copr enable -y derenderkeks/proxmox-backup-client ${CHROOT}
dnf5 copr enable -y swayfx/swayfx ${CHROOT}
dnf5 copr enable -y secureblue/trivalent ${CHROOT}
dnf5 copr enable -y secureblue/run0edit ${CHROOT}
dnf5 copr enable -y amyiscoolz/komnenos-logos ${CHROOT}

sysadmin_packages=(
  "proxmox-backup-client"
  "osbuild-selinux"
  "komnenos-logos"
  "xprop"
  "gnome-shell-extension-pop-shell"
)

programming_packages=(
  "i3blocks"
  "gparted"
)

utility_packages=(
  "trivalent-subresource-filter"
  "keyd"
  "run0edit"
  "swayfx"
  "fuzzel"
  "adw-gtk3-theme"
  "just"
  "nautilus"
  "ptyxis"
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
)

# install rpms
dnf5 install -y ${dnf_packages[@]} --skip-unavailable 

# install fzf-tab-completion

# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion
dnf5 copr disable -y derenderkeks/proxmox-backup-client
dnf5 copr disable -y swayfx/swayfx
dnf5 copr disable -y secureblue/trivalent
dnf5 copr disable -y secureblue/run0edit
dnf5 copr disable -y amyiscoolz/komnenos-logos

SOURCE_DIR="/usr/lib/opt"
TARGET_DIR="/var/opt"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Loop through directories in the source directory
for dir in "$SOURCE_DIR/"*/; do
  if [ -d "$dir" ]; then
    # Get the base name of the directory
    dir_name=$(basename "$dir")
    
    # Check if the symlink already exists in the target directory
    if [ -L "$TARGET_DIR/$dir_name" ]; then
      echo "Symlink already exists for $dir_name, skipping."
      continue
    fi
    
    # Create the symlink
    ln -s "$dir" "$TARGET_DIR/$dir_name"
    echo "Created symlink for $dir_name"
  fi
done

dnf5 config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
# Mullvad VPN
#canon_dest=/var/opt/'Mullvad VPN'
#dest=/usr/share/factory/${canon_dest##/}

dnf5 install -y mullvad-vpn

#ls /var/opt/

mv -T "$SOURCE_DIR" "$TARGET_DIR" 

cat >/usr/lib/tmpfiles.d/mullvad-vpn.conf <<EOF
Type  Path         Mode  User  Group  Age  Argument…
C+     $SOURCE_DIR  -     -     -      -    $TARGET_DIR
EOF

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/mullvad.repo

# CrossOver
#canon_dest=/var/opt/'cxoffice'
#dest=/usr/share/factory/${canon_dest##/}

#dnf5 install -y http://crossover.codeweavers.com/redirect/crossover.rpm

#cp -r "$canon_dest" "$dest"

#cat >/usr/lib/tmpfiles.d/crossover.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
#C+     $canon_dest  -     -     -      -    $dest
#EOF

#sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/mullvad.repo


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

# Build Extensions
