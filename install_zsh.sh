#!/bin/bash
# Test for distro
dist=$(cat /etc/issue | cut -c-4)
if [ "$dist" = "Arch"]; then
	sudo pacman -Syu zsh
elif [ "$dist" = "Ubun" || "$dist" = "Debi" ]; then
	sudo apt install zsh
fi
#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#Grab the extension I like
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#Put the custom .zshrc into the home folder :)
cp .zshrc ~/.zshrc 
