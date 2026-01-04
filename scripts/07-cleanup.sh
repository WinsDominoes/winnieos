#!/bin/bash

set -ouex pipefail

rm -vr /scripts

# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Saves a space
rm -rf /usr/share/doc
rm -rf /usr/bin/chsh # footgun


