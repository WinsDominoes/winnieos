#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "nano"
  "foot"
  "dmenu"
  "gnome-software*"
  "gnome-extensions-app"
  "malcontent-control"
  "gnome-tour"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}
