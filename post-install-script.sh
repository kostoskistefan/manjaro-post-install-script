#!/bin/bash

# Get script path

script_path=$(dirname $(readlink -f "$0"))

# Package installation

echo "Installing packages..."

declare -a packages=("zsh" "flameshot" "google-chrome" "kdialog" "kvantum-manjaro" "neovim" "optimus-manager" "tmux" "xclip")

for package in "${packages[@]}"
do
    if sudo pacman -Qs $package > /dev/null; then
        echo "Package ${package}" already installed. Skipping...
    else
        echo "Installing ${package}..."
        sudo pacman -S $package --noconfirm
    fi
done

# Configure Neovim

echo "Configuring Neovim..."
mkdir -p $HOME/.config/nvim
rsync -aq ${script_path}/neovim-config/* $HOME/.config/nvim
nvim +PlugInstall +qa!

# Configure Tmux

echo "Configuring Tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rsync -aq ${script_path}/tmux-config/* $HOME/
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux source $HOME/.tmux.conf

# Configure Kvantum Manager

echo "Configuring Kvantum Manager..."

git clone --quiet https://github.com/vinceliuice/chromeos-kde $HOME
$HOME/chromeos-kde/install.sh
rm -r $HOME/chromeos-kde

git clone --quiet https://github.com/vinceliuice/Tela-icon-theme $HOME
$HOME/Tela-icon-theme/install.sh
rm -r $HOME/Tela-icon-theme

/usr/lib/plasma-changeicons Tela-dark

kvantummanager --set ChromeOS-dark

# Configure Plasma

echo "Configuring Plasma..."
sed "s/USER_NAME/$USER/" ${script_path}/plasma-config/plasma-org.kde.plasma.desktop-appletsrc > $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc

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

# Configure ZSH

echo "Configuring ZShell..."
chsh -s /bin/zsh
rsync -aq $script_path/zsh-config/* $HOME/
# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install Powerlevel10K theme
git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
source $HOME/.zshrc

echo "Successfully configured!"
echo "Please select the ChromeOS theme in KDE Settings > Appearance."
echo "Restart your computer for all changes to take effect!"
