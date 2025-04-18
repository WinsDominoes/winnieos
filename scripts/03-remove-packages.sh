#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "nano"
  "foot"
  "dmenu"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}
