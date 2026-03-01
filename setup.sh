sudo apt update
sudo apt upgrade -y

# Font update (for Nerd font)
fc-cache -fv


# Installation for util (snapd -> nvim,)
sudo apt install zsh tmux snapd flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.google.Chrome
sudo snap install neovim

# Installation for Latex
sudo apt install texlive-lang-japanese texlive-science texlive-pictures texlive-luatex texlive-latex-extra texlive-fonts-recommended latexmk

# Installation for docker container
sudo apt install podman podman-compose

# Installation for VSCode (https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
rm -f microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https &&
sudo apt update &&
sudo apt install code -y # or code-insiders
