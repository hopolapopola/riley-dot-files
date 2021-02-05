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
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
chsh -s $(which zsh)
#Grab the extension I like
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#Put the custom theme into the right folder :)
cp candy_custom.zsh-theme ~/.oh-my-zsh/themes
