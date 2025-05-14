#!/bin/bash

set -ouex pipefail

systemctl enable docker.socket
systemctl enable slimbook-service.service
systemctl enable slimbook-settings.service
