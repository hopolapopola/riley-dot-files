#!/bin/bash
# Install zsh and move custom zshrc
dist=$(cat /etc/issue | cut -c-4)
if [ "$dist" = "Arch" ]; then
	sudo pacman -Syu zsh
	cp .zshrc ~/.zshrc
elif [ "$dist" = "Ubun" ] || [ "$dist" = "Debi" ]; then
	sudo apt install zsh
	cp .zshrc_buntu ~/.zshrc
fi
#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#Grab the extension I like
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#Put the custom .zshrc into the home folder and the theme too :)
cp candy_custom.zsh-theme ~/.oh-my-zsh/themes
