#!/bin/bash

# Check internet connection

wget -q --tries=10 --timeout=20 --spider http://google.com

if [ $? -ne 0 ]; then
    echo "Internet connection is required!"
    exit
fi

# Update system

echo "Updating the system..."
# sudo pacman-mirrors -f5
sudo pacman -Sy

# Get script path

script_path=$(dirname "$(readlink -f "$0")")

# Package installation

echo "Installing packages..."

open_source_packages="zsh yay flameshot kdialog kvantum-manjaro neovim optimus-manager tmux fakeroot glibc lib32-glibc nodejs"
closed_source_packages="google-chrome"

sudo pacman -S $open_source_packages --noconfirm --needed --quiet

yay -S $closed_source_packages --noconfirm --quiet

# Configure Neovim

echo "Configuring Neovim..."
mkdir -p "${HOME}/.config/nvim"
sh -c 'curl -fLo "${XDG_DATA_HOME:-${HOME}/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sudo rsync --protect-args -aqxP "${script_path}/neovim-config/" "${HOME}/.config/nvim/"
nvim +PlugInstall +qa!

# Configure Tmux

echo "Configuring Tmux..."
[[ ! -d "${HOME}/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
sudo rsync --protect-args -aqxP "${script_path}/tmux-config/" "${HOME}/"
"${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh"
tmux source "${HOME}/.tmux.conf"

# Configure Kvantum Manager

echo "Configuring Kvantum Manager..."

if [[ ! -d "${HOME}/.local/share/plasma/desktoptheme/ChromeOS" ]]; then
    git clone --quiet https://github.com/vinceliuice/chromeos-kde "/tmp/chromeos-kde"
    "/tmp/chromeos-kde/install.sh"
    sudo rm -rf "/tmp/chromeos-kde"
fi

if [[ ! -d "${HOME}/.local/share/icons/Tela-dark" ]]; then
    git clone --quiet https://github.com/vinceliuice/Tela-icon-theme "/tmp/Tela-icon-theme"
    "/tmp/Tela-icon-theme/install.sh"
    sudo rm -rf "/tmp/Tela-icon-theme"
fi

/usr/lib/plasma-changeicons Tela-dark

kvantummanager --set ChromeOS-dark

# Configure Plasma

echo "Configuring Plasma..."
sed "s/USER_NAME/${USER}/" "${script_path}/plasma-config/plasma-org.kde.plasma.desktop-appletsrc" > "${HOME}/.config/plasma-org.kde.plasma.desktop-appletsrc"
mv "${HOME}/.config/khotkeysrc" "${HOME}/.config/khotkeysrc.bak"
sudo rsync --protect-args -aqxP "${script_path}/plasma-config/" --exclude 'plasma' "${HOME}/.config"
sudo rsync --protect-args -aqxP "${script_path}/plasma-config/plasma" "${HOME}/.local/share/"

# Configure Nvidia drivers

if lspci | grep -iq NVIDIA; then
    echo "Installing Nvidia drivers..."
    sudo mhwd -a pci nonfree 0300

    echo "Configuring Optimus Manager..."
    if [[ -f /etc/sddm.conf ]]; then
        sed '/DisplayCommand/ s/^#*/#/' -i /etc/sddm.conf
        sed '/DisplayStopCommand/ s/^#*/#/' -i /etc/sddm.conf
    fi
    sudo systemctl disable bumblebeed.service

    echo "See https://github.com/Askannz/optimus-manager/wiki/A-guide--to-power-management-options to configure power management for Optimus Manager"
    # TODO: Add optimus-manager.conf file
fi

# Disable Baloo Indexer

echo "Disabling Baloo Indexer..."
balooctl disable

# Configure Konsole

echo "Configuring Konsole..."
sudo rsync --protect-args -aqxP "${script_path}/konsole-config/" "${HOME}/.config/"

# Configure ZSH

echo "Configuring ZShell..."
chsh -s /bin/zsh
# Install Oh-My-Zsh
[[ ! -d "/${HOME}/.oh-my-zsh" ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch 
# Install Powerlevel10K theme
[[ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]] && git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
# Install Fonts
wget -q -P "/usr/share/fonts/TTF/" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf 
wget -q -P "/usr/share/fonts/TTF/" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q -P "/usr/share/fonts/TTF/" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q -P "/usr/share/fonts/TTF/" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
# Copy configuration
sudo rsync --protect-args -aqxP "${script_path}/zsh-config/" "${HOME}/"
/bin/zsh -c "source ${HOME}/.zshrc"

# Uninstall Yakuake

echo "Uninstalling Yakuake..."
sudo pacman -Rs yakuake --noconfirm

echo "Successfully configured!"
echo "Please restart your computer for all changes to take effect!"
