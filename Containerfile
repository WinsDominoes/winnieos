
COPY --from=ghcr.io/blue-build/nushell-image:default /nu/nu /usr/libexec/bluebuild/nu/nu

FROM quay.io/fedora/fedora-bootc:43

# Copy Homebrew files from the brew image
# And enable
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /usr/bin/systemctl preset brew-setup.service && \
    /usr/bin/systemctl preset brew-update.timer && \
    /usr/bin/systemctl preset brew-upgrade.timer

COPY --from=ghcr.io/projectbluefin/common:latest /system_files/shared /

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
ARG FEDORA_MAJOR_VERSION="43"
ARG UBLUE_IMAGE_TAG="43"
ARG VERSION=""

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10
# `yq` be used to pass BlueBuild modules configuration written in yaml

RUN /scripts/00-preconfigure.sh && \
    /scripts/01-image-info.sh && \
    /scripts/02-install-packages.sh && \
    /scripts/03-remove-packages.sh && \
    /scripts/04-enable-services.sh && \
    /scripts/05-just.sh && \
    /scripts/build-extensions.sh && \
    /scripts/06-selinux.sh

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
    - Caffeine # https://extensions.gnome.org/extension/517/caffeine/ \n\
    - Battery Health Charging # https://extensions.gnome.org/extension/5724/battery-health-charging/ \n\
    - Immich Wallpaper # https://extensions.gnome.org/extension/8701/immich-wallpaper/ \n\
    - Blur my Shell # https://extensions.gnome.org/extension/3193/blur-my-shell/ \n\
    - AppIndicator and KStatusNotifierItem Support # https://extensions.gnome.org/extension/615/appindicator-support/ \n\
' && \
/tmp/scripts/run_module.sh "$(echo "$config" | yq eval '.type')" "$(echo "$config" | yq eval -o=j -I=0)"

RUN dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

COPY --from=ghcr.io/ublue-os/akmods:main-43 / /tmp/akmods-common
RUN find /tmp/akmods-common
## optionally install remove old and install new kernel
# dnf -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra
## install ublue support package and desired kmod(s)
RUN dnf5 install -y /tmp/akmods-common/rpms/ublue-os/ublue-os-akmods*.rpm --skip-broken
RUN dnf5 install -y /tmp/akmods-common/rpms/kmods/kmod-v4l2loopback*.rpm --skip-broken
RUN dnf5 install -y /tmp/akmods-common/rpms/kmods/kmod-xone*.rpm --skip-broken
RUN dnf5 install -y /tmp/akmods-common/rpms/kmods/kmod-framework-laptop*.rpm --skip-broken
RUN dnf5 install -y /tmp/akmods-common/rpms/kmods/kmod-openrazer*.rpm --skip-broken

RUN /scripts/07-cleanup.sh && \
    ostree container commit
