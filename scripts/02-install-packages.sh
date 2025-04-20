#!/bin/bash

set -ouex pipefail

get_yaml_array OPTFIX '.optfix[]' "$1"
if [[ ${#OPTFIX[@]} -gt 0 ]]; then
    echo "Creating symlinks to fix packages that install to /opt"
    # Create symlink for /opt to /var/opt since it is not created in the image yet
    mkdir -p "/var/opt"
    ln -s "/var/opt"  "/opt"
    # Create symlinks for each directory specified in recipe.yml
    for OPTPKG in "${OPTFIX[@]}"; do
        OPTPKG="${OPTPKG%\"}"
        OPTPKG="${OPTPKG#\"}"
        OPTPKG=$(printf "$OPTPKG")
        mkdir -p "/usr/lib/opt/${OPTPKG}"
        ln -s "../../usr/lib/opt/${OPTPKG}" "/var/opt/${OPTPKG}"
        echo "Created symlinks for ${OPTPKG}"
    done
fi

get_yaml_array INSTALL '.install[]' "$1"
get_yaml_array REMOVE '.remove[]' "$1"

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
