#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

sudo() {
    echo -e "\n${R} [${W}-${R}]${C} Installing Sudo..."${W}
    apt update -y
    apt install sudo -y
    apt install wget apt-utils locales-all dialog tzdata curl -y
    echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed !"${W}
}

download_file() {
    local file=$1
    local url=$2
    local dest=$3
    local max_retries=3
    local retry=0
    local success=false

    echo -e "\n${R} [${W}-${R}]${C} Downloading ${file}..."${W}

    while [ $retry -lt $max_retries ] && [ "$success" = false ]; do
        if curl -s --fail --retry 3 --retry-delay 2 --connect-timeout 10 --max-time 60 -L -o "$dest" "$url"; then
            success=true
            echo -e "\n${R} [${W}-${R}]${G} Successfully downloaded ${file}!"${W}
        else
            retry=$((retry + 1))
            if [ $retry -lt $max_retries ]; then
                echo -e "\n${R} [${W}-${R}]${Y} Download failed. Retrying... (Attempt $retry of $max_retries)"${W}
                sleep 2
            else
                echo -e "\n${R} [${W}-${R}]${R} Failed to download ${file} after $max_retries attempts."${W}
                return 1
            fi
        fi
    done

    # Verify file exists and is not empty
    if [ -s "$dest" ]; then
        chmod +x "$dest"
        return 0
    else
        echo -e "\n${R} [${W}-${R}]${R} Downloaded file is empty or doesn't exist."${W}
        return 1
    fi
}

setup_gui_files() {
    local user=$1
    local gui_path="/home/$user/gui.sh"
    
    echo -e "\n${R} [${W}-${R}]${C} Setting up GUI files..."${W}

    # First check the source from the modded-ubuntu repository
    if [ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh' ]; then
        echo -e "\n${R} [${W}-${R}]${G} Found gui.sh in local repository"${W}
        cp '/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh' "$gui_path"
        if [ $? -eq 0 ] && [ -s "$gui_path" ]; then
            chmod +x "$gui_path"
            echo -e "\n${R} [${W}-${R}]${G} Successfully copied gui.sh from local repository!"${W}
            return 0
        else
            echo -e "\n${R} [${W}-${R}]${Y} Error copying from local repository. Will try downloading..."${W}
        fi
    fi

    # If not in repository or copy failed, download from GitHub
    if download_file "gui.sh" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh" "$gui_path"; then
        echo -e "\n${R} [${W}-${R}]${G} GUI file setup complete!"${W}
        return 0
    else
        # Try alternative download method as fallback
        echo -e "\n${R} [${W}-${R}]${Y} Trying alternative download method..."${W}
        if wget -q --show-progress -O "$gui_path.tmp" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh"; then
            if [ -s "$gui_path.tmp" ]; then
                mv "$gui_path.tmp" "$gui_path"
                chmod +x "$gui_path"
                echo -e "\n${R} [${W}-${R}]${G} Successfully downloaded gui.sh using wget!"${W}
                return 0
            else
                echo -e "\n${R} [${W}-${R}]${R} Downloaded file is empty."${W}
                rm -f "$gui_path.tmp"
            fi
        fi
        
        echo -e "\n${R} [${W}-${R}]${R} Failed to set up GUI files. Please download manually."${W}
        return 1
    fi
}

login() {
    banner
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\en' pass
    echo -e "${W}"
    useradd -m -s $(which bash) ${user}
    usermod -aG sudo ${user}
    echo "${user}:${pass}" | chpasswd
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
    
    # Set up GUI files
    setup_gui_files "$user"
    gui_setup_status=$?
    
    # Create a script to help manually download if needed
    cat > "/home/$user/fix-gui.sh" << EOF
#!/bin/bash
echo "Downloading gui.sh file..."
if command -v curl &> /dev/null; then
    curl -L -o ~/gui.sh https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh
elif command -v wget &> /dev/null; then
    wget -O ~/gui.sh https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh
else
    echo "Error: Neither curl nor wget is installed. Please install one of them first."
    exit 1
fi

if [ -s ~/gui.sh ]; then
    chmod +x ~/gui.sh
    echo "gui.sh has been successfully downloaded!"
else
    echo "Failed to download gui.sh. Please check your internet connection."
fi
EOF
    chmod +x "/home/$user/fix-gui.sh"

    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu"${W}
    
    if [ $gui_setup_status -eq 0 ]; then
        echo -e "\n${R} [${W}-${R}]${G} Then Type ${C}sudo bash gui.sh"${W}
    else
        echo -e "\n${R} [${W}-${R}]${Y} GUI file setup had issues. After logging in, type: ${C}bash fix-gui.sh${W}"
        echo -e "\n${R} [${W}-${R}]${Y} Then type: ${C}sudo bash gui.sh"${W}
    fi
    echo
}

banner
sudo
login
