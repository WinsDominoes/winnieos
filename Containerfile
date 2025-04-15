ARG BASE_IMAGE

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

COPY build_files/ /scripts
COPY system_files 
FROM ${BASE_IMAGE}
 
RUN /scripts/00-preconfigure.sh && \
    /scripts/01-image-info.sh && \
    /scripts/02-install-packages.sh && \
    /scripts/03-remove-packages.sh && \
    /scripts/04-enable-services.sh && \
    /scripts/05-just.sh && \
    /scripts/06-cleanup.sh && \
    ostree container commit
