FROM ghcr.io/ublue-os/bluefin-dx:stable AS winnieos

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
    
COPY system_files /
COPY scripts /scripts

RUN /scripts/preconfigure.sh && \
    /scripts/install_1password.sh && \
    /scripts/install_warp.sh && \
    /scripts/install_packages.sh && \
    /scripts/configure_kde.sh && \
    /scripts/enable_services.sh && \
    /scripts/just.sh && \
    /scripts/cleanup.sh && \
    ostree container commit