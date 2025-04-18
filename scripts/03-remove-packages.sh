#!/bin/bash

set -ouex pipefail

# Packages

programming_packages=(
  "code"
)

packages=(
  ${programming_packages[@]}
)

# install rpms
dnf5 remove -y ${packages[@]}