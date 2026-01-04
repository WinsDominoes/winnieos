#!/bin/bash

set -ouex pipefail

systemctl enable docker.socket
systemctl enable slimbook-service.service
systemctl enable slimbook-settings.service
systemctl enable --global gdm.service
systemctl enable --global gnome-keyring-daemon.service
systemctl enable --global gnome-keyring-daemon.socket
systemctl enable brew-setup.service
systemctl enable flatpak-preinstall.service
systemctl enable rechunker-group-fix.service
systemctl enable --global bazaar.service