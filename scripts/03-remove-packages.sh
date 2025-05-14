#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "nano"
  "foot"
  "dmenu"
  "gnome-shell-extension-gsconnect"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}
