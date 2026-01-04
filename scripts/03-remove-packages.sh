#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "nano"
  "foot"
  "dmenu"
  "gnome-software*"
  "gnome-extension-app"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}
