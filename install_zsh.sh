#!/bin/bash

# old method of testing distro & moving zshrcs 
# dist=$(cat /etc/issue | cut -c-4)
# if [ "$dist" = "Arch" ]; then
# 	sudo pacman -Syu zsh
# 	cp .zshrc ~/.zshrc
# elif [ "$dist" = "Ubun" ] || [ "$dist" = "Debi" ]; then
# 	sudo apt install zsh
# 	cp .zshrc_buntu ~/.zshrc
# fi

install_ohmyzsh() {
	#Install oh-my-zsh, now a function!
	git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
	echo "Change your shell to zsh"
	chsh -s $(which zsh)
}

zsh_goodies() {
	#Grab the extension I like
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	#Put the custom theme into the right folder :)
	cp candy_custom.zsh-theme ~/.oh-my-zsh/themes
	if [ "$distro" = "Arch" ]; then
		git clone https://aur.archlinux.org/find-the-command.git
		cd find-the-command
		makepkg -si 
		cd ..
	fi
}

other_goodies() {
	#WIP, can't use *yet*
	# case $distro in
	# 	Arch)
	# 		sudo pacman -Syu neofetch kitty
	# 		cp kitty.conf ~/.config/kitty/kitty.conf
	# 		cp neofetch_config.conf ~/.config/neofetch/config.conf
	# 		cp byleth_neofetch.png ~/.config/neofetch/byleth_neofetch.png
	# 	Ubun|Debi|iPhone)
	# 		sudo apt install neofetch
	# 		cp neofetch_config.conf ~/.config/neofetch/config.conf
	# 		cp byleth_neofetch.png ~/.config/neofetch/byleth_neofetch.png
	# 	macOS)
	# 		brew install neofetch
	# 		cp neofetch_config.conf ~/.config/neofetch/config.conf
	# 		cp byleth_neofetch.png ~/.config/neofetch/config.conf
	# 	*)
	# 		printf "Other goodies couldn't be installed :pensive:"
	# 		;;
	# esac

	printf "Well passing the arg worked?"
}

cache_uname() {
	# from neofetch
	IFS=" " read -ra uname <<< "$(uname -srm)"

    kernel_name="${uname[0]}"
    kernel_version="${uname[1]}"
    kernel_machine="${uname[2]}"

    if [[ "$kernel_name" == "Darwin" ]]; then
        # macOS can report incorrect versions unless this is 0.
        # https://github.com/dylanaraps/neofetch/issues/1607
        export SYSTEM_VERSION_COMPAT=0

        IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' \
                            "/System/Library/CoreServices/SystemVersion.plist")"
        for ((i=0;i<${#sw_vers[@]};i+=2)) {
            case ${sw_vers[i]} in
                ProductName)          darwin_name=${sw_vers[i+1]} ;;
                ProductVersion)       osx_version=${sw_vers[i+1]} ;;
                ProductBuildVersion)  osx_build=${sw_vers[i+1]}   ;;
            esac
        }
    fi
}

get_os() {
	case $kernel_name in
		Darwin)	
			os=$darwin_name 
		;;

		Linux|GNU*) 
			os=Linux 
		;;

		*)
			printf "get_os() Oops"
			exit 1
		;;
	esac
}
       
get_distro() {
	#this is so fucking jank but i'm doing it again lmao
	case $os in
		Linux) 
			distro=$(cat /etc/issue | cut -c-4)
			;;
		"Mac OS X"|"macOS")
			distro="macOS"
			;;
		"iPhone OS")
			distro="iPhone"
			;;
		*)
			printf "get_distro() Oops"
			exit 1
			;;
	esac
}

install_zsh() {
	case $distro in
		Arch)
			sudo pacman -Syu zsh
			;;
		Ubun|Debi)
			sudo apt install zsh
			;;
		"macOS"|"iPhone")
			printf "You already have zsh :)"
			;;
		*)
			printf "install_zsh Oops"
			exit 1
			;;
	esac
}

copy_zshrc() {
	case $distro in
		Arch)
			cp .zshrc_arch ~/.zshrc
			;;
		Ubun|Debi|macOS)
			cp .zshrc_buntu ~/.zshrc
			;;
		iPhone)
			cp .zshrc_ios ~/.zshrc
			;;
		*)
			printf "Realistically, you're never gonna see this because it would've errored out way before"
			exit 1
			;;
		esac
}

main() {
	cache_uname
	get_os
	get_distro
	install_zsh
	copy_zshrc
	zsh_goodies
	if [[ "$1" = "--extra" ]]; then
		other_goodies
	fi
	printf "We gaming :sunglasses:"
	return 0
}

main "$@"

