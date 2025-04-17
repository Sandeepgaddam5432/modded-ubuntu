#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')" 

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
DEBIAN_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/debian"

banner() {
	clear
	cat <<- EOF
		${Y}    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  
		${C}    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ 
		${G}    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ 

	EOF
	echo -e "${G}     A modded gui version of Debian for Termux\n\n"${W}
}

package() {
	banner
	echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
	
	[ ! -d '/data/data/com.termux/files/home/storage' ] && echo -e "${R} [${W}-${R}]${C} Setting up Storage.."${W} && termux-setup-storage

	if [[ $(command -v pulseaudio) && $(command -v proot-distro) ]]; then
		echo -e "\n${R} [${W}-${R}]${G} Packages already installed."${W}
	else
		yes | pkg upgrade
		packs=(pulseaudio proot-distro)
		for x in "${packs[@]}"; do
			type -p "$x" &>/dev/null || {
				echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$x${C}"${W}
				yes | pkg install "$x"
			}
		done
	fi
}

distro() {
	echo -e "\n${R} [${W}-${R}]${C} Checking for Distro..."${W}
	termux-reload-settings
	
	if [[ -d "$DEBIAN_DIR" ]]; then
		echo -e "\n${R} [${W}-${R}]${G} Distro already installed."${W}
		exit 0
	else
		proot-distro install debian
		termux-reload-settings
	fi
	
	if [[ -d "$DEBIAN_DIR" ]]; then
		echo -e "\n${R} [${W}-${R}]${G} Installed Successfully !!"${W}
	else
		echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n"${W}
		exit 0
	fi
}

sound() {
	echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem..."${W}
	[ ! -e "$HOME/.sound" ] && touch "$HOME/.sound"
	echo "pacmd load-module module-aaudio-sink" >> "$HOME/.sound"
        echo "pulseaudio --start --exit-idle-time=-1" >> "$HOME/.sound"
	echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> "$HOME/.sound"
}

downloader(){
	path="$1"
	[ -e "$path" ] && rm -rf "$path"
	echo "Downloading $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
	echo
}

setup_vnc() {
	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstart" ]]; then
		cp -f "$CURR_DIR/distro/vncstart" "$DEBIAN_DIR/usr/local/bin/vncstart"
	else
		downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/distro/vncstart"
		mv -f "$CURR_DIR/vncstart" "$DEBIAN_DIR/usr/local/bin/vncstart"
	fi

	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstop" ]]; then
		cp -f "$CURR_DIR/distro/vncstop" "$DEBIAN_DIR/usr/local/bin/vncstop"
	else
		downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/distro/vncstop"
		mv -f "$CURR_DIR/vncstop" "$DEBIAN_DIR/usr/local/bin/vncstop"
	fi
	chmod +x "$DEBIAN_DIR/usr/local/bin/vncstart"
	chmod +x "$DEBIAN_DIR/usr/local/bin/vncstop"
}

setup_config_tool() {
	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/debian-config.sh" ]]; then
		cp -f "$CURR_DIR/distro/debian-config.sh" "$DEBIAN_DIR/usr/local/bin/debian-config"
	else
		# Convert ubuntu-config.sh to debian-config.sh
		if [[ -e "$CURR_DIR/distro/ubuntu-config.sh" ]]; then
			cp -f "$CURR_DIR/distro/ubuntu-config.sh" "$CURR_DIR/distro/debian-config.sh"
			sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/distro/debian-config.sh"
			sed -i 's/ubuntu/debian/g' "$CURR_DIR/distro/debian-config.sh"
			cp -f "$CURR_DIR/distro/debian-config.sh" "$DEBIAN_DIR/usr/local/bin/debian-config"
		else
			downloader "$CURR_DIR/debian-config.sh" "https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/distro/ubuntu-config.sh"
			sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/debian-config.sh" 
			sed -i 's/ubuntu/debian/g' "$CURR_DIR/debian-config.sh"
			mv -f "$CURR_DIR/debian-config.sh" "$DEBIAN_DIR/usr/local/bin/debian-config"
		fi
	fi
	chmod +x "$DEBIAN_DIR/usr/local/bin/debian-config"
}

permission() {
	banner
	echo -e "${R} [${W}-${R}]${C} Setting up Environment..."${W}

	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/user.sh" ]]; then
		cp -f "$CURR_DIR/distro/user.sh" "$DEBIAN_DIR/root/user.sh"
		sed -i 's/Ubuntu/Debian/g' "$DEBIAN_DIR/root/user.sh"
		sed -i 's/ubuntu/debian/g' "$DEBIAN_DIR/root/user.sh"
	else
		downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/distro/user.sh"
		sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/user.sh"
		sed -i 's/ubuntu/debian/g' "$CURR_DIR/user.sh"
		mv -f "$CURR_DIR/user.sh" "$DEBIAN_DIR/root/user.sh"
	fi
	chmod +x $DEBIAN_DIR/root/user.sh

	setup_vnc
	setup_config_tool
	echo "$(getprop persist.sys.timezone)" > $DEBIAN_DIR/etc/timezone
	echo "proot-distro login debian" > $PREFIX/bin/debian
	chmod +x "$PREFIX/bin/debian"
	termux-reload-settings

	if [[ -e "$PREFIX/bin/debian" ]]; then
		banner
		cat <<- EOF
			${R} [${W}-${R}]${G} Debian (CLI) is now Installed on your Termux
			${R} [${W}-${R}]${G} Restart your Termux to Prevent Some Issues.
			${R} [${W}-${R}]${G} Type ${C}debian${G} to run Debian CLI.
			${R} [${W}-${R}]${G} If you Want to Use Debian in GUI MODE then ,
			${R} [${W}-${R}]${G} Run ${C}debian${G} first & then type ${C}bash user.sh${W}
			${R} [${W}-${R}]${G} To use the configuration tool, run ${C}debian-config${G} in GUI mode${W}
		EOF
		{ echo; sleep 2; exit 1; }
	else
		echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !"${W}
		exit 0
	fi

}

package
distro
sound
permission
