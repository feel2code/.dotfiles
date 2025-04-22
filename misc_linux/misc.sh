# install normal i3
sudo apt install git gcc i3 i3status tar zip unzip fakeroot\
 make automake patch python python3 npm curl wget\
 vim neovim ripgrep\
 nvidia-driver-560\
 xclip ncdu mc ranger htop rsync pavucontrol\
 bluez bluez-utils blueman pulseaudio-bluetooth\
 sqlite dunst noto-fonts-emoji\
 playerctl pkg-config\
 ffmpeg mpd mpv mpc feh grim slurp\
 awesome-terminal-fonts\
 qt5-wayland keepassxc\
 docker docker-compose\
 pyenv

# snap
sudo snap install slack
sudo snap install telegram-desktop

# zsh
sudo apt install zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# rgb fix
wget https://openrgb.org/releases/release_0.9/openrgb_0.9_amd64_bookworm_b5f46e3.deb
sudo dpkg -i openrgb_0.9_amd64_bookworm_b5f46e3.deb

# login screen fix
sudo cp ~/.config/monitors.xml ~gdm/.config/monitors.xml
sudo chown gdm:gdm ~gdm/.config/monitors.xml

# install vim key bindings
sudo apt install xautomation sxhkd

# installing fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip 
sudo mkdir -p /usr/share/fonts
sudo mkdir -p /usr/share/fonts/JetBrainsMono
mkdir JetBrainsMono && mv JetBrainsMono.zip JetBrainsMono/ && cd JetBrainsMono
unzip JetBrainsMono.zip && sudo cp *.ttf /usr/share/fonts/JetBrainsMono
cd .. && rm -rf JetBrainsMono
fc-cache
