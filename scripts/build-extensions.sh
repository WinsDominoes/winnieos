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

git clone https://github.com/ubuntu/gnome-shell-extension-appindicator /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
git clone https://github.com/eonpatapon/gnome-shell-extension-caffeine /usr/share/gnome-shell/extensions/tmp/caffeine@patapon.info
git clone https://github.com/ublue-os/Logomenu /usr/share/gnome-shell/extensions/logomenu@aryan_k
git clone https://github.com/aunetx/blur-my-shell /usr/share/gnome-shell/extensions/blur-my-shell@aunetx

# AppIndicator Support
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/schemas

# Blur My Shell
make -C /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
unzip -o /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/build/blur-my-shell@aunetx.shell-extension.zip -d /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas
rm -rf /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/build

# Caffeine
# The Caffeine extension is built/packaged into a temporary subdirectory (tmp/caffeine/caffeine@patapon.info).
# Unlike other extensions, it must be moved to the standard extensions directory so GNOME Shell can detect it.
mv /usr/share/gnome-shell/extensions/tmp/caffeine/caffeine@patapon.info /usr/share/gnome-shell/extensions/caffeine@patapon.info
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/caffeine@patapon.info/schemas

# Logo Menu
# xdg-terminal-exec is required for this extension as it opens up terminals using that script
install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/distroshelf-helper
install -Dpm0755 -t /usr/bin /usr/share/gnome-shell/extensions/logomenu@aryan_k/missioncenter-helper
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/logomenu@aryan_k/schemas

# Cleanup
dnf5 -y remove glib2-devel meson sassc cmake dbus-devel
rm -rf /usr/share/gnome-shell/extensions/tmp

echo "::endgroup::"