#!/usr/bin/bash

set -eoux pipefail

echo "::group:: ===$(basename "$0")==="

# Install tooling
dnf5 -y install glib2-devel meson sassc cmake dbus-devel git

# Build Extensions
# HACKY WORKAROUND
rm -rf /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
rm -rf /usr/share/gnome-shell/extensions/tmp/caffeine@patapon.info
rm -rf /usr/share/gnome-shell/extensions/logomenu@aryan_k
rm -rf /usr/share/gnome-shell/extensions/blur-my-shell@aunetx

git clone https://github.com/ublue-os/Logomenu /usr/share/gnome-shell/extensions/logomenu@aryan_k


# Logo Menu
# xdg-terminal-exec is required for this extension as it opens up terminals using that script
install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/distroshelf-helper
install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/missioncenter-helper
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/logomenu@aryan_k/schemas

# Cleanup
dnf5 -y remove glib2-devel meson sassc cmake dbus-devel

echo "::endgroup::"
