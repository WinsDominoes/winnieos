#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "nano"
  "foot"
  "dmenu"
  "gnome-software*"
  "malcontent-control"
  "gnome-tour"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}

rm -rf /usr/bin/gnome-extensions-app
rm -rf /usr/lib64/gnome-extensions-app/
rm -rf /usr/share/applications/org.gnome.Extensions.desktop


