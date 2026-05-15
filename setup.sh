#! /bin/bash

#     /$$   /$$ /$$    /$$$$$$$$ /$$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$ /$$       /$$                    /$$$$$$   /$$$$$$
#    | $$  | $$| $$   |__  $$__/| $$__  $$ /$$__  $$| $$  /$$/|_  $$_/| $$      | $$                   /$$__  $$ /$$__  $$
#    | $$  | $$| $$      | $$   | $$  \ $$| $$  \ $$| $$ /$$/   | $$  | $$      | $$                  | $$  \ $$| $$  \__/
#    | $$  | $$| $$      | $$   | $$$$$$$/| $$$$$$$$| $$$$$/    | $$  | $$      | $$                  | $$  | $$|  $$$$$$
#    | $$  | $$| $$      | $$   | $$__  $$| $$__  $$| $$  $$    | $$  | $$      | $$                  | $$  | $$ \____  $$
#    | $$  | $$| $$      | $$   | $$  \ $$| $$  | $$| $$\  $$   | $$  | $$      | $$                  | $$  | $$ /$$  \ $$
#    |  $$$$$$/| $$$$$$$$| $$   | $$  | $$| $$  | $$| $$ \  $$ /$$$$$$| $$$$$$$$| $$$$$$$$            |  $$$$$$/|  $$$$$$/
#     \______/ |________/|__/   |__/  |__/|__/  |__/|__/  \__/|______/|________/|________/             \______/  \______/
#
#    Written by SodiumIceCream

# Credits:

# ASCII Art: https://fsymbols.com/generators/carty/
# ULTRAKILL GRUB Theme: https://github.com/AdrienZianne/ultrakill-grub-theme
# ULTRAKILL Docs: https://github.com/NotDarkn/ultradocs

start_time=$(date +%s%N)

set -euo pipefail
mkdir ~/UltrakillOS-Setup


# █▀█ ▄▀█ █▀▀ █▄▀ ▄▀█ █▀▀ █▀▀   █▀▀ █▀█ █▄░█ █▀▀ █ █▀▀
# █▀▀ █▀█ █▄▄ █░█ █▀█ █▄█ ██▄   █▄▄ █▄█ █░▀█ █▀░ █ █▄█

echo "==> Reading package config \n"

packages_pacman=(
"curl" # REQUIRED
"git" # REQUIRED
"base-devel" # REQUIRED
"zsh"
"cockpit"
"cockpit-storaged"
"cockpit-networkd"
"go" # REQUIRED (for yay)
"flatpak"
"steam"
"mangohud"
"discord"
)
echo "==> Pacman done!"


packages_flatpak=(
"net.davidotek.pupgui2"
"com.heroicgameslauncher.hgl"
"io.github.rfrench3.scopebuddy-gui"
"org.freedesktop.Platform.VulkanLayer.gamescope"
"com.github.tchx84.Flatseal"
)
echo "==> Flatpak done!"


packages_aur(
"stoat-desktop-bin"
)
echo "==> AUR done!"



# █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀ █▀
# ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█ ▄█

development=1
cockpit=1
chaotic=1
echo "==> \nSettings are valid"


# █ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░   █▀ █▀█ █▀▀ ▀█▀ █░█░█ ▄▀█ █▀█ █▀▀
# █ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄   ▄█ █▄█ █▀░ ░█░ ▀▄▀▄▀ █▀█ █▀▄ ██▄

echo "==> \nInstalling Pacman packages..."
sudo pacman -S --noconfirm $packages_pacman
echo "==> Success!"


echo "==> \nInstalling YAY AUR helper..."
git clone https://aur.archlinux.org/yay-bin.git ~/UltrakillOS-Setup/
cd ~/UltrakillOS-Setup/yay-bin
makepkg -si
echo "==> Success!"

echo "==> \nInstalling flatpaks..."
flatpak install -y flathub $packages_flatpak
echo "==> Success!"

echo "==> \nInstalling AUR packages..."
yay -S --noconfirm $packages_aur
echo "==> Success!"


# █▀ █▀▀ ▀█▀ █░█ █▀█   █▀█ █▀▀ █▀█ █▀█ █▀
# ▄█ ██▄ ░█░ █▄█ █▀▀   █▀▄ ██▄ █▀▀ █▄█ ▄█

# Chaotic AUR

echo "==> Fetching primary Chaotic-AUR signing key..."
# Fetch and locally sign the signing key
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036

echo "==> Downloading and installing keyring and mirrorlist binaries..."
# Install the keyring
sudo pacman --noconfirm -U \
  'https://chaotic.cx' \
  'https://chaotic.cx'


echo "==> Appending Chaotic-AUR repository to /etc/pacman.conf..."
# Add the chaotic AUR repo to pacman conf file and ensure this only happens once
if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
  sudo tee -a /etc/pacman.conf << 'EOF'

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
else
  echo "--> Repository block already exists in pacman.conf. Skipping configuration entry."
fi

echo "==> Refreshing package databases and synchronising system mirrors..."
# Force a database refresh to make Pacman aware of the new package database
sudo pacman -Sy --noconfirm

echo "==> \nSuccess! Chaotic-AUR is fully automated and ready for use."



# █▀█ █▀█ █░░   █▀▀ █▀▀ ▄▀█ ▀█▀ █░█ █▀█ █▀▀ █▀
# ▀▀█ █▄█ █▄▄   █▀░ ██▄ █▀█ ░█░ █▄█ █▀▄ ██▄ ▄█

echo "==> Setting up QOL Features..."

sudo systemctl enable cockpit.socket
curl https://raw.githubusercontent.com/galenguyer/nano-syntax-highlighting/master/install.sh | bash
echo "==> Success!"



# █░█ █░░ ▀█▀ █▀█ ▄▀█ █▄▀ █ █░░ █░░   █▀▀ █▀▀ ▄▀█ ▀█▀ █░█ █▀█ █▀▀ █▀
# █▄█ █▄▄ ░█░ █▀▄ █▀█ █░█ █ █▄▄ █▄▄   █▀░ ██▄ █▀█ ░█░ █▄█ █▀▄ ██▄ ▄█

wget -O- https://github.com/Youstones/ultrakill-grub-theme/raw/main/install.sh | bash -s -- --lang English

git clone https://github.com/NotDarkn/ultradocs.git ~/UltrakillOS-Setup/UltrakillDocs
mv ~/UltrakillOS-Setup/UltrakillDocs/docs ~/Documents/ULTRAKILL

end_time=$(date +%s%N)
elapsed=$(( (end_time - start_time) / 1000000 ))

echo "==> Done! ($elapsed ms)"
echo "==> It is recommended to reboot your system now. Run `sudo reboot` to reboot your system."
