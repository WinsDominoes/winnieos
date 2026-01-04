# Connect home using WireGuard
connect-home:
    #!/bin/bash
    echo "Connecting to home"
    sudo tailscale up --exit-node fw --accept-routes

# Disconnect from home using WireGuard
disconnect-home:
    #!/bin/bash
    echo "Disconnecting from home"
    tailscale down

# Setting up Mullvad
mullvad-vpn:
    #!/bin/bash
    sudo cp -r /usr/lib/var/opt/'Mullvad VPN' /var/opt

# Install system flatpaks
_install-winnie-flatpaks:
    #!/bin/bash
    BAZZITE_FLATPAK_LIST="$(curl https://raw.githubusercontent.com/ublue-os/bazzite/main/scripts/kde_flatpaks/flatpaks | tr '\n' ' ')"
    WINNIEOS_FLATPAK_LIST="$(curl https://raw.githubusercontent.com/winsdominoes/winnieos/main/flatpaks/winnie_flatpaks | tr '\n' ' ')"
    echo "Installing Bazzite Flatpaks.."
    flatpak --system -y install ${BAZZITE_FLATPAK_LIST}
    echo "Installing WinnieOS Flatpaks.."
    flatpak --system -y install ${WINNIEOS_FLATPAK_LIST}

# Install brew things
install_brew_things:
    #!/bin/bash
    brew tap ublue-os/tap
    brew install --cask visual-studio-code-linux
    brew install --cask vscodium-linux
    brew install --cask jetbrains-toolbox-linux
    brew install --cask android-platform-tools
    brew install pmbootstrap
    brew install scrcpy
    brew install --cask font-jetbrains-mono-nerd-font
    brew install --cask font-inter
