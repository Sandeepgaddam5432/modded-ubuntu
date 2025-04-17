#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
username=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)

check_root(){
	if [ "$(id -u)" -ne 0 ]; then
		echo -ne " ${R}Run this program as root!\n\n"${W}
		exit 1
	fi
}

banner() {
	clear
	cat <<- EOF
		${Y}    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  
		${C}    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ 
		${G}    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ 

	EOF
	echo -e "${G}     A modded gui version of Debian for Termux\n"
}

note() {
	banner
	echo -e " ${G} [-] Successfully Installed !\n"${W}
	sleep 1
	cat <<- EOF
		 ${G}[-] Type ${C}vncstart${G} to run Vncserver.
		 ${G}[-] Type ${C}vncstop${G} to stop Vncserver.

		 ${C}Install VNC VIEWER Apk on your Device.

		 ${C}Open VNC VIEWER & Click on + Button.

		 ${C}Enter the Address localhost:1 & Name anything you like.

		 ${C}Set the Picture Quality to High for better Quality.

		 ${C}Click on Connect & Input the Password.

		 ${C}Enjoy :D${W}
	EOF
}

package() {
	banner
	echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
	apt-get update -y
	
	# Debian doesn't use udisks2 by default, but we'll handle it differently
	if apt-cache show udisks2 > /dev/null 2>&1; then
		apt install udisks2 -y || true
		if [ -f /var/lib/dpkg/info/udisks2.postinst ]; then
			rm /var/lib/dpkg/info/udisks2.postinst
			echo "" > /var/lib/dpkg/info/udisks2.postinst
			dpkg --configure -a
			apt-mark hold udisks2
		fi
	fi
	
	# Add non-free and contrib repositories for broader package availability
	if ! grep -q "contrib" /etc/apt/sources.list; then
		# Backup the original sources.list
		cp /etc/apt/sources.list /etc/apt/sources.list.bak
		
		# Get current Debian version
		debian_version=$(cat /etc/debian_version | cut -d. -f1)
		case "$debian_version" in
			"10") codename="buster" ;;
			"11") codename="bullseye" ;;
			"12") codename="bookworm" ;;
			*) codename="stable" ;;
		esac
		
		# Add contrib and non-free components
		echo "deb http://deb.debian.org/debian $codename main contrib non-free" > /etc/apt/sources.list
		echo "deb http://deb.debian.org/debian $codename-updates main contrib non-free" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/debian-security $codename-security main contrib non-free" >> /etc/apt/sources.list
		
		apt-get update -y
	fi
	
	packs=(sudo gnupg2 curl nano git xz-utils xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu dialog tigervnc-standalone-server tigervnc-common dbus-x11 fonts-noto fonts-noto-cjk fonts-noto-color-emoji gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
}

install_apt() {
	for apt in "$@"; do
		[[ `command -v $apt` ]] && echo "${Y}${apt} is already Installed!${W}" || {
			echo -e "${G}Installing ${Y}${apt}${W}"
			apt install -y ${apt}
		}
	done
}

install_vscode() {
	[[ $(command -v code) ]] && echo "${Y}VSCode is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}VSCode${W}"
		curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		# Use architecture-specific repository
		if [ "$(dpkg --print-architecture)" = "amd64" ]; then
			echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		elif [ "$(dpkg --print-architecture)" = "arm64" ]; then
			echo "deb [arch=arm64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		elif [[ "$(dpkg --print-architecture)" = "armhf" || "$(dpkg --print-architecture)" = "armel" ]]; then
			echo "deb [arch=armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		fi
		apt update -y
		apt install code -y
		echo "Patching.."
		curl -fsSL https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop
		echo -e "${C} Visual Studio Code Installed Successfully\n${W}"
	}
}

install_sublime() {
	[[ $(command -v subl) ]] && echo "${Y}Sublime is already Installed!${W}" || {
		apt install gnupg2 software-properties-common --no-install-recommends -y
		echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
		curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2> /dev/null
		apt update -y
		apt install sublime-text -y 
		echo -e "${C} Sublime Text Editor Installed Successfully\n${W}"
	}
}

install_chromium() {
	[[ $(command -v chromium) ]] && echo "${Y}Chromium is already Installed!${W}\n" || {
		echo -e "${G}Installing ${Y}Chromium${W}"
		# Debian provides chromium in the main repositories
		apt update
		
		# Get correct chromium package name for the current Debian
		if apt-cache show chromium-browser > /dev/null 2>&1; then
			apt install chromium-browser -y
		elif apt-cache show chromium > /dev/null 2>&1; then
			apt install chromium -y
		else
			echo "Unable to find chromium package. Adding external repository."
			apt install gnupg2 software-properties-common --no-install-recommends -y
			echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list.d/chromium.list
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
			apt update -y
			apt install chromium -y
		fi
		
		# Add the no-sandbox option to the chromium desktop file
		for file in /usr/share/applications/chromium*.desktop; do
			if [ -f "$file" ]; then
				sed -i 's/chromium %U/chromium --no-sandbox %U/g' "$file"
				sed -i 's/chromium-browser %U/chromium-browser --no-sandbox %U/g' "$file"
			fi
		done
		
		echo -e "${G} Chromium Installed Successfully\n${W}"
	}
}

install_firefox() {
	[[ $(command -v firefox) ]] && echo "${Y}Firefox is already Installed!${W}\n" || {
		echo -e "${G}Installing ${Y}Firefox${W}"
		# For Debian, we'll use the packaged Firefox-ESR first
		if apt-cache show firefox-esr > /dev/null 2>&1; then
			apt install firefox-esr -y
			echo -e "${G} Firefox ESR Installed Successfully\n${W}"
		else
			# If Firefox ESR isn't available, we'll try to install the regular Firefox
			if apt-cache show firefox > /dev/null 2>&1; then
				apt install firefox -y
				echo -e "${G} Firefox Installed Successfully\n${W}"
			else
				# If neither is available through APT, use the script
				echo "Firefox not found in repositories. Using custom installer..."
				# Modify the Firefox script URL for compatibility with Debian
				curl -fsSL "https://raw.githubusercontent.com/MaheshTechnicals/modded-ubuntu/master/distro/firefox.sh" > /tmp/firefox.sh
				sed -i 's/Ubuntu/Debian/g' /tmp/firefox.sh
				sed -i 's/ubuntu/debian/g' /tmp/firefox.sh
				bash /tmp/firefox.sh
				rm /tmp/firefox.sh
				echo -e "${G} Firefox Installed Successfully\n${W}"
			fi
		fi
	}
}

install_softwares() {
	banner
	cat <<- EOF
		${Y} ---${G} Select Browser ${Y}---

		${C} [${W}1${C}] Firefox (Default)
		${C} [${W}2${C}] Chromium
		${C} [${W}3${C}] Both (Firefox + Chromium)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" BROWSER_OPTION
	banner

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		cat <<- EOF
			${Y} ---${G} Select IDE ${Y}---

			${C} [${W}1${C}] Sublime Text Editor (Recommended)
			${C} [${W}2${C}] Visual Studio Code
			${C} [${W}3${C}] Both (Sublime + VSCode)
			${C} [${W}4${C}] Skip! (Default)

		EOF
		read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" IDE_OPTION
		banner
	}
	
	cat <<- EOF
		${Y} ---${G} Media Player ${Y}---

		${C} [${W}1${C}] MPV Media Player (Recommended)
		${C} [${W}2${C}] VLC Media Player
		${C} [${W}3${C}] Both (MPV + VLC)
		${C} [${W}4${C}] Skip! (Default)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" PLAYER_OPTION
	{ banner; sleep 1; }

	if [[ ${BROWSER_OPTION} == 2 ]]; then
		install_chromium
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		install_firefox
		install_chromium
	else
		install_firefox
	fi

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		if [[ ${IDE_OPTION} == 1 ]]; then
			install_sublime
		elif [[ ${IDE_OPTION} == 2 ]]; then
			install_vscode
		elif [[ ${IDE_OPTION} == 3 ]]; then
			install_sublime
			install_vscode
		else
			echo -e "${Y} [!] Skipping IDE Installation\n"
			sleep 1
		fi
	}

	if [[ ${PLAYER_OPTION} == 1 ]]; then
		install_apt "mpv"
	elif [[ ${PLAYER_OPTION} == 2 ]]; then
		install_apt "vlc"
	elif [[ ${PLAYER_OPTION} == 3 ]]; then
		install_apt "mpv" "vlc"
	else
		echo -e "${Y} [!] Skipping Media Player Installation\n"
		sleep 1
	fi

}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	echo "Downloading $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

sound_fix() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/debian)" > /data/data/com.termux/files/usr/bin/debian
	echo "export DISPLAY=":1"" >> /etc/profile
	echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
	source /etc/profile
}

rem_theme() {
	theme=(Bright Daloa Emacs Moheli Retro Smoke)
	for rmi in "${theme[@]}"; do
		type -p "$rmi" &>/dev/null || {
			rm -rf /usr/share/themes/"$rmi"
		}
	done
}

rem_icon() {
	fonts=(hicolor LoginIcons)
	for rmf in "${fonts[@]}"; do
		type -p "$rmf" &>/dev/null || {
			rm -rf /usr/share/icons/"$rmf"
		}
	done
}

config() {
	banner
	sound_fix

	# Debian might not have apt-key in newer versions
	if command -v apt-key &> /dev/null; then
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 || true
	fi
	
	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin || true
	
	# Check if xfce backgrounds directory exists before attempting to modify
	if [ -d "/usr/share/backgrounds/xfce" ]; then
		if [ -f "/usr/share/backgrounds/xfce/xfce-verticals.png" ]; then
			mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png
		fi
	else
		mkdir -p /usr/share/backgrounds/xfce
	fi
	
	temp_folder=$(mktemp -d -p "$HOME")
	{ banner; sleep 1; cd $temp_folder; }

	echo -e "${R} [${W}-${R}]${C} Downloading Required Files..\n"${W}
	downloader "fonts.tar.gz" "https://github.com/MaheshTechnicals/modded-ubuntu/releases/download/config/fonts.tar.gz"
	downloader "icons.tar.gz" "https://github.com/MaheshTechnicals/modded-ubuntu/releases/download/config/icons.tar.gz"
	downloader "wallpaper.tar.gz" "https://github.com/MaheshTechnicals/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
	downloader "gtk-themes.tar.gz" "https://github.com/MaheshTechnicals/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
	downloader "ubuntu-settings.tar.gz" "https://github.com/MaheshTechnicals/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"

	echo -e "${R} [${W}-${R}]${C} Unpacking Files..\n"${W}
	mkdir -p /usr/local/share/fonts/
	mkdir -p /usr/share/icons/
	mkdir -p /usr/share/themes/
	
	# Create a settings directory with a debian name
	mkdir -p "$temp_folder/debian-settings"
	tar -xzf ubuntu-settings.tar.gz -C "$temp_folder/ubuntu-settings/"
	
	# Replace Ubuntu with Debian in settings
	find "$temp_folder/ubuntu-settings" -type f -exec sed -i 's/Ubuntu/Debian/g' {} \;
	find "$temp_folder/ubuntu-settings" -type f -exec sed -i 's/ubuntu/debian/g' {} \;
	
	# Copy modified settings
	cp -r "$temp_folder/ubuntu-settings/"* "$temp_folder/debian-settings/"
	
	tar -xvzf fonts.tar.gz -C "/usr/local/share/fonts/" || true
	tar -xvzf icons.tar.gz -C "/usr/share/icons/" || true
	tar -xvzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/" || true
	tar -xvzf gtk-themes.tar.gz -C "/usr/share/themes/" || true
	cp -r "$temp_folder/debian-settings/"* "/home/$username/" || true
	rm -fr $temp_folder

	echo -e "${R} [${W}-${R}]${C} Purging Unnecessary Files.."${W}
	rem_theme
	rem_icon

	echo -e "${R} [${W}-${R}]${C} Rebuilding Font Cache..\n"${W}
	fc-cache -fv

	# Create desktop entry for Debian Configuration Tool
	echo -e "${R} [${W}-${R}]${C} Creating desktop entry for Debian Configuration Tool..\n"${W}
	cat > /usr/share/applications/debian-config.desktop << EOF
[Desktop Entry]
Name=Debian Configuration Tool
Comment=Configure and manage your Debian installation
Exec=debian-config
Icon=preferences-system
Terminal=false
Type=Application
Categories=GTK;Settings;System;
StartupNotify=true
EOF

	echo -e "${R} [${W}-${R}]${C} Upgrading the System..\n"${W}
	apt update
	yes | apt upgrade
	apt clean
	yes | apt autoremove
}

# ----------------------------

check_root
package
install_softwares
config
note

