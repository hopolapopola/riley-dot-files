#!/bin/bash
#Install zsh (debian/ubuntu)
# sudo apt install zsh
#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#Grab the extension I like
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#Put the custom .zshrc into the home folder (IT ONLY WORKS FOR me, i.e. username=riley)
cp .zshrc ~/.zshrc 
