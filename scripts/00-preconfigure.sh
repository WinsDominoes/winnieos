#!/bin/bash

set -ouex pipefail

# Apply IP Forwarding before installing Docker to prevent messing with LXC networking
sysctl -p
rm -rf /usr/share/plymouth
rm -rf /usr/share/pixmaps
rm -rf usr/share/icons/hicolor/scalable/places

