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
	git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
	echo "Change your shell to zsh"
	chsh -s $(which zsh)
}

zsh_goodies() {
	install_ohmyzsh
	#Grab the extension I like
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	#Put the custom theme into the right folder :)
	cp theming/candy_custom.zsh-theme $HOME/.oh-my-zsh/themes
	if [ "$distro" = "Arch" ]; then
		git clone https://aur.archlinux.org/find-the-command.git
		cd find-the-command
		makepkg -si 
		cd ..
	fi
}

other_goodies() {
	case $distro in
		Arch)
			sudo pacman -Syu neofetch kitty
			cp theming/kitty.conf $HOME/.config/kitty/kitty.conf
			cp neofetch/neofetch_arch.conf $HOME/.config/neofetch/config.conf
			cp neofetch/byleth_neofetch.png $HOME/.config/neofetch/byleth_neofetch.png
			printf "Extras v1-arch done"
			;;
		Ubun|Debi|iPhone)
			sudo apt install neofetch
			cp neofetch/neofetch_noimage.conf $HOME/.config/neofetch/config.conf
			printf "Extras v1 done" 
			;;
		macOS)
			brew install neofetch
			cp neofetch/neofetch_macos.conf $HOME/.config/neofetch/config.conf
			cp neofetch/byleth_neofetch.png $HOME/.config/neofetch/config.conf
			printf "Extras v1 done"
			;;
		*)
			printf "Extras couldn't be installed :pensive:"
			;;
	esac
}
red_arch() {
    if [[ "$distro" == "Arch" ]]; then
        sudo pacman -Syu neofetch kitty
        cp arch-owo-v2/kitty.conf $HOME/.config/kitty/kitty.conf
        cp arch-owo-v2/neofetch.conf $HOME/.config/neofetch/config.conf
        cp neofetch/byleth_neofetch.png $HOME/.config/neofetch/byleth_neofetch.png
        printf "Extras v2-arch done"
        printf "https://www.youtube.com/watch?v=-AuQZrUHjhg"
    fi
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
			cp zshrc/.zshrc_arch $HOME/.zshrc
			;;
		Ubun|Debi|macOS)
			cp zshrc/.zshrc_buntu $HOME/.zshrc
			;;
		iPhone)
			cp zshrc/.zshrc_ios $HOME/.zshrc
			;;
		*)
			printf "Realistically, you're never gonna see this because it would've errored out way before"
			exit 1
			;;
		esac
}

help_info() {
    printf "Available options:"
    printf "\n"
    printf "These work like any other arg lmao just pass them as SEPARATE ARGS"
    printf "\n"
    printf " -i or --install does what you'd think it does"
    printf "\n"
    printf " -e or --extras installs the extra stuff too" 
    printf "\n"
    printf " -r or --red installs the red version of the extra stuff, but only on arch"
    printf "\n"
    printf " -h or --help or just anything not listed here gets you this :)"
    printf "\n"
}

main() {
	cache_uname
	get_os
	get_distro
	install_zsh
	copy_zshrc
	zsh_goodies
	printf "Finished the main things"
	return 0
}

while [ ! -z "$1" ]; do
    case $1 in
        --install|-i)
            shift
            main
            ;;
        --extra|-e)
            shift
            other_goodies
            ;;
        --red|-r)
            shift   
            red_arch
            ;;
        --help|-h)
            shift
            help_info
            ;;
        *)
            shift
            help_info
            ;;
    esac
shift
done

