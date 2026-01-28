#!/bin/bash

set -ouex pipefail

systemctl enable docker.socket
systemctl enable slimbook-service.service
systemctl enable slimbook-settings.service
systemctl enable gdm.service
systemctl enable --global gnome-keyring-daemon.service
systemctl enable --global gnome-keyring-daemon.socket
systemctl enable flatpak-preinstall.service
systemctl enable rechunker-group-fix.service
systemctl enable --global bazaar.service
systemctl enable hardinfo2