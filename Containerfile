FROM ghcr.io/ublue-os/bluefin-dx:stable-daily

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

ARG BASE_IMAGE_NAME="bluefin-dx"
ARG FEDORA_MAJOR-VERSION="42"
ARG IMAGE_NAME="winnieos"
ARG IMAGE_VENDOR="winsdominoes"
ARG FEDORA_MAJOR_VERSION="42"
ARG UBLUE_IMAGE_TAG="42"
ARG VERSION=""
FROM ghcr.io/blue-build/nushell-image:default as nushell
COPY --from=ghcr.io/blue-build/nushell-image:default /nu/nu /usr/libexec/bluebuild/nu/nu


# `yq` be used to pass BlueBuild modules configuration written in yaml
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN \
  # add in the module source code
  --mount=type=bind,from=ghcr.io/blue-build/modules:latest,src=/modules,dst=/tmp/modules,rw \
  # add in the script that sets up the module run environment
  --mount=type=bind,from=ghcr.io/blue-build/cli/build-scripts:latest,src=/scripts/,dst=/tmp/scripts/ \
# run the module
config=$'\
type: gnome-extensions \n\
install: \n\
    - Wiggle # https://extensions.gnome.org/extension/6784/wiggle/ \n\
' && \
/tmp/scripts/run_module.sh "$(echo "$config" | yq eval '.type')" "$(echo "$config" | yq eval -o=j -I=0)"


RUN /scripts/00-preconfigure.sh && \
    /scripts/01-image-info.sh && \
    /scripts/02-install-packages.sh && \
    /scripts/03-remove-packages.sh && \
    /scripts/04-enable-services.sh && \
    /scripts/05-just.sh && \
    /scripts/06-selinux.sh

COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN \
  # add in the module source code
  --mount=type=bind,from=ghcr.io/blue-build/modules:latest,src=/modules,dst=/tmp/modules,rw \
  # add in the script that sets up the module run environment
  --mount=type=bind,from=ghcr.io/blue-build/cli/build-scripts:latest,src=/scripts/,dst=/tmp/scripts/ \
# run the module
config=$'\
type: dnf \n\
repos:\n\
  cleanup: true \n\
  files: \n\
    - https://repository.mullvad.net/rpm/stable/mullvad.repo \n\
  optfix: \n\
    - Mullvad VPN \n\
    - cxoffice \n\
  install: \n\
    skip-unavailable: true \n\
    packages: \n\
      - mullvad-vpn \n\
      - http://crossover.codeweavers.com/redirect/crossover.rpm \n\
' && \
/tmp/scripts/run_module.sh "$(echo "$config" | yq eval '.type')" "$(echo "$config" | yq eval -o=j -I=0)"


RUN /scripts/07-cleanup.sh && \
    ostree container commit
