#!/bin/bash

# Enhanced Debian GUI Setup with Professional UI/UX and AI Tools
# Author: Sandeep Gaddam
# Version: 3.0 - Professional Experience

# Color definitions
declare -r RED='\033[1;31m'
declare -r GREEN='\033[1;32m'
declare -r YELLOW='\033[1;33m'
declare -r BLUE='\033[1;34m'
declare -r CYAN='\033[1;36m'
declare -r WHITE='\033[1;37m'
declare -r MAGENTA='\033[1;35m'
declare -r RESET='\033[0m'
declare -r BOLD='\033[1m'

# Script configuration
SCRIPT_NAME="Debian GUI Professional Setup"
SCRIPT_VERSION="3.0"
LOG_FILE="$HOME/.debian-gui-setup.log"
arch=$(uname -m)
username=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
TEMP_DIR="/tmp/debian-gui-setup-$(date +%Y%m%d_%H%M%S)"

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced animated banner
banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}G U I   S E T U P   T O O L   v${SCRIPT_VERSION}${RESET}          ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Professional Debian GUI with AI-Powered IDEs${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${WHITE}By: Sandeep Gaddam | Enhanced Experience${RESET}            ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local percentage=$((current * 100 / total))
    local filled=$((percentage / 2))
    local empty=$((50 - filled))
    
    printf "\r${CYAN}[${RESET}"
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "${CYAN}]${RESET} ${YELLOW}%3d%%${RESET} ${WHITE}%s${RESET}" "$percentage" "$message"
}

# Spinner animation
show_spinner() {
    local message="$1"
    local pid="$2"
    local delay=0.1
    local spinstr='🔄🔃🔁⚙️'
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${CYAN}%s${RESET} ${WHITE}%s${RESET}" "${spinstr:0:2}" "$message"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r${GREEN}✅${RESET} ${WHITE}%s - Complete${RESET}\n" "$message"
}

# Root check with enhanced message
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
        echo -e "${RED}║${RESET}                        ${BOLD}❌ ERROR ❌${RESET}                        ${RED}║${RESET}"
        echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
        echo -e "${RED}║${RESET}  ${WHITE}This script requires root privileges to install${RESET}         ${RED}║${RESET}"
        echo -e "${RED}║${RESET}  ${WHITE}system packages and configure the GUI environment.${RESET}      ${RED}║${RESET}"
        echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
        echo -e "${RED}║${RESET}  ${YELLOW}Please run: ${CYAN}sudo bash gui.sh${RESET}                        ${RED}║${RESET}"
        echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
        echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
        log_message "ERROR" "Script not run as root"
        exit 1
    fi
}

# Enhanced package installation
package() {
    banner
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                 ${BOLD}SYSTEM PACKAGES SETUP${RESET}                   ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    local steps=8
    local current=0

    # Step 1: Update package lists
    ((current++))
    show_progress $current $steps "Updating package repositories..."
    sleep 1
    
    echo -e "\n${CYAN}🔄 Updating package repositories...${RESET}"
    apt-get update -y >/dev/null 2>&1 &
    show_spinner "Updating repositories" $!

    # Step 2: Handle udisks2 package
    ((current++))
    show_progress $current $steps "Configuring system packages..."
    sleep 1
    
    if apt-cache show udisks2 > /dev/null 2>&1; then
        echo -e "\n${CYAN}⚙️  Configuring udisks2...${RESET}"
        apt install udisks2 -y >/dev/null 2>&1 || true
        if [ -f /var/lib/dpkg/info/udisks2.postinst ]; then
            rm /var/lib/dpkg/info/udisks2.postinst
            echo "" > /var/lib/dpkg/info/udisks2.postinst
            dpkg --configure -a >/dev/null 2>&1
            apt-mark hold udisks2 >/dev/null 2>&1
        fi
        echo -e "${GREEN}✅ udisks2 configured${RESET}"
    fi

    # Step 3: Setup repositories
    ((current++))
    show_progress $current $steps "Configuring repositories..."
    sleep 1
    
    if ! grep -q "contrib" /etc/apt/sources.list; then
        echo -e "\n${CYAN}📦 Configuring Debian repositories...${RESET}"
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
        
        debian_version=$(cat /etc/debian_version | cut -d. -f1)
        case "$debian_version" in
            "10") codename="buster" ;;
            "11") codename="bullseye" ;;
            "12") codename="bookworm" ;;
            *) codename="stable" ;;
        esac
        
        cat > /etc/apt/sources.list << EOF
deb http://deb.debian.org/debian $codename main contrib non-free
deb http://deb.debian.org/debian $codename-updates main contrib non-free
deb http://security.debian.org/debian-security $codename-security main contrib non-free
EOF
        
        apt-get update -y >/dev/null 2>&1
        echo -e "${GREEN}✅ Repositories configured for $codename${RESET}"
        log_message "SUCCESS" "Repositories configured for $codename"
    fi

    # Step 4-6: Install core packages
    ((current++))
    show_progress $current $steps "Installing core system packages..."
    sleep 1

    echo -e "\n${CYAN}📦 Installing core packages...${RESET}"
    local core_packs=(sudo gnupg2 curl nano git xz-utils wget jq)
    for pack in "${core_packs[@]}"; do
        if ! command -v "$pack" >/dev/null 2>&1; then
            echo -e "${YELLOW}Installing: $pack${RESET}"
            apt-get install "$pack" -y --no-install-recommends >/dev/null 2>&1
        fi
    done

    ((current++))
    show_progress $current $steps "Installing GUI packages..."
    sleep 1

    echo -e "\n${CYAN}🖥️  Installing GUI environment...${RESET}"
    local gui_packs=(xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu dialog tigervnc-standalone-server tigervnc-common dbus-x11)
    for pack in "${gui_packs[@]}"; do
        if ! dpkg -l | grep -q "^ii  $pack "; then
            echo -e "${YELLOW}Installing: $pack${RESET}"
            apt-get install "$pack" -y --no-install-recommends >/dev/null 2>&1 &
            show_spinner "Installing $pack" $!
        fi
    done

    ((current++))
    show_progress $current $steps "Installing fonts and themes..."
    sleep 1

    echo -e "\n${CYAN}🎨 Installing fonts and themes...${RESET}"
    local theme_packs=(fonts-noto fonts-noto-cjk fonts-noto-color-emoji gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
    for pack in "${theme_packs[@]}"; do
        if ! dpkg -l | grep -q "^ii  $pack "; then
            apt-get install "$pack" -y --no-install-recommends >/dev/null 2>&1
        fi
    done

    ((current++))
    show_progress $current $steps "Upgrading system..."
    sleep 1

    echo -e "\n${CYAN}⬆️  Upgrading system packages...${RESET}"
    apt-get upgrade -y >/dev/null 2>&1 &
    show_spinner "Upgrading system" $!

    ((current++))
    show_progress $current $steps "Package installation completed!"
    sleep 1

    echo -e "\n${GREEN}✅ All packages installed successfully!${RESET}"
    log_message "SUCCESS" "Core packages installation completed"
    echo
}

# Enhanced software installation function
install_apt() {
    for apt in "$@"; do
        if command -v "$apt" >/dev/null 2>&1; then
            echo -e "${YELLOW}$apt is already installed!${RESET}"
        else
            echo -e "${GREEN}Installing ${YELLOW}${apt}${RESET}"
            apt install -y "${apt}" >/dev/null 2>&1 &
            show_spinner "Installing $apt" $!
        fi
    done
}

# Professional VSCode installation
install_vscode() {
    if command -v code >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ VSCode is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}🔄 Installing ${YELLOW}Visual Studio Code${RESET}"
    
    # Add Microsoft GPG key
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg 2>/dev/null
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    
    # Add repository based on architecture
    local current_arch=$(dpkg --print-architecture)
    echo "deb [arch=$current_arch signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
    
    apt update -y >/dev/null 2>&1
    apt install code -y >/dev/null 2>&1 &
    show_spinner "Installing Visual Studio Code" $!
    
    # Apply desktop file patch
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop 2>/dev/null
    
    echo -e "${GREEN}✅ Visual Studio Code installed successfully${RESET}"
    log_message "SUCCESS" "VSCode installed"
}

# Sublime Text installation
install_sublime() {
    if command -v subl >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ Sublime Text is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}🔄 Installing ${YELLOW}Sublime Text${RESET}"
    
    apt install gnupg2 software-properties-common --no-install-recommends -y >/dev/null 2>&1
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list >/dev/null
    curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2>/dev/null
    
    apt update -y >/dev/null 2>&1
    apt install sublime-text -y >/dev/null 2>&1 &
    show_spinner "Installing Sublime Text" $!
    
    echo -e "${GREEN}✅ Sublime Text installed successfully${RESET}"
    log_message "SUCCESS" "Sublime Text installed"
}

# Cursor AI installation
install_cursor_ai() {
    if command -v cursor >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ Cursor AI is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}🤖 Installing ${YELLOW}Cursor AI Code Editor${RESET}"
    
    # Download and run Cursor installer
    local cursor_script="/tmp/cursor_installer.sh"
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/cursor-termux/main/cursor.sh > "$cursor_script" 2>/dev/null
    chmod +x "$cursor_script"
    
    # Run installer with option 1 automatically
    echo "1" | bash "$cursor_script" >/dev/null 2>&1 &
    show_spinner "Installing Cursor AI" $!
    
    rm -f "$cursor_script"
    echo -e "${GREEN}✅ Cursor AI Code Editor installed successfully${RESET}"
    log_message "SUCCESS" "Cursor AI installed"
}

# Void AI installation
install_void_ai() {
    if command -v void >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ Void AI is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}⚡ Installing ${YELLOW}Void AI Code Editor${RESET}"
    
    # Download and run Void installer
    local void_script="/tmp/void_installer.sh"
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/Void/main/void.sh > "$void_script" 2>/dev/null
    chmod +x "$void_script"
    
    # Run installer with option 1 automatically
    echo "1" | bash "$void_script" >/dev/null 2>&1 &
    show_spinner "Installing Void AI" $!
    
    rm -f "$void_script"
    echo -e "${GREEN}✅ Void AI Code Editor installed successfully${RESET}"
    log_message "SUCCESS" "Void AI installed"
}

# Enhanced Chromium installation
install_chromium() {
    if command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ Chromium is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}🌐 Installing ${YELLOW}Chromium Browser${RESET}"
    
    apt update >/dev/null 2>&1
    
    if apt-cache show chromium-browser > /dev/null 2>&1; then
        apt install chromium-browser -y >/dev/null 2>&1 &
        show_spinner "Installing Chromium" $!
    elif apt-cache show chromium > /dev/null 2>&1; then
        apt install chromium -y >/dev/null 2>&1 &
        show_spinner "Installing Chromium" $!
    else
        echo -e "${YELLOW}Adding external Chromium repository...${RESET}"
        apt install gnupg2 software-properties-common --no-install-recommends -y >/dev/null 2>&1
        echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list.d/chromium.list
        
        local keys=("DCC9EFBF77E11517" "648ACFD622F3D138" "AA8E81B4331F7F50" "112695A0E562B32A" "3B4FE6ACC0B21F32")
        for key in "${keys[@]}"; do
            apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$key" >/dev/null 2>&1
        done
        
        apt update -y >/dev/null 2>&1
        apt install chromium -y >/dev/null 2>&1 &
        show_spinner "Installing Chromium" $!
    fi
    
    # Add no-sandbox flag to desktop files
    for file in /usr/share/applications/chromium*.desktop; do
        if [ -f "$file" ]; then
            sed -i 's/chromium %U/chromium --no-sandbox %U/g' "$file" 2>/dev/null
            sed -i 's/chromium-browser %U/chromium-browser --no-sandbox %U/g' "$file" 2>/dev/null
        fi
    done
    
    echo -e "${GREEN}✅ Chromium Browser installed successfully${RESET}"
    log_message "SUCCESS" "Chromium installed"
}

# Enhanced Firefox installation
install_firefox() {
    if command -v firefox >/dev/null 2>&1 || command -v firefox-esr >/dev/null 2>&1; then
        echo -e "${YELLOW}✅ Firefox is already installed!${RESET}"
        return 0
    fi

    echo -e "${GREEN}🦊 Installing ${YELLOW}Firefox Browser${RESET}"
    
    if apt-cache show firefox-esr > /dev/null 2>&1; then
        apt install firefox-esr -y >/dev/null 2>&1 &
        show_spinner "Installing Firefox ESR" $!
        echo -e "${GREEN}✅ Firefox ESR installed successfully${RESET}"
    elif apt-cache show firefox > /dev/null 2>&1; then
        apt install firefox -y >/dev/null 2>&1 &
        show_spinner "Installing Firefox" $!
        echo -e "${GREEN}✅ Firefox installed successfully${RESET}"
    else
        echo -e "${YELLOW}Using custom Firefox installer...${RESET}"
        curl -fsSL "https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master/distro/firefox.sh" > /tmp/firefox.sh 2>/dev/null
        sed -i 's/Ubuntu/Debian/g' /tmp/firefox.sh
        sed -i 's/ubuntu/debian/g' /tmp/firefox.sh
        bash /tmp/firefox.sh >/dev/null 2>&1 &
        show_spinner "Installing Firefox" $!
        rm /tmp/firefox.sh
        echo -e "${GREEN}✅ Firefox installed successfully${RESET}"
    fi
    
    log_message "SUCCESS" "Firefox installed"
}

# Enhanced software selection menu
install_softwares() {
    banner
    
    # Browser Selection
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                    ${BOLD}🌐 BROWSER SELECTION${RESET}                    ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${CYAN} [${WHITE}1${CYAN}] 🦊 Firefox (Default & Recommended)${RESET}"
    echo -e "${CYAN} [${WHITE}2${CYAN}] 🌐 Chromium (Lightweight)${RESET}"
    echo -e "${CYAN} [${WHITE}3${CYAN}] 🚀 Both Browsers (Firefox + Chromium)${RESET}"
    echo
    read -n1 -p "$(echo -e "${YELLOW}Choose Browser Option [1-3]: ${GREEN}")" BROWSER_OPTION
    echo -e "${RESET}"
    banner

    # IDE Selection (Enhanced with AI tools)
    if [[ "$arch" != 'armhf' && "$arch" != *'armv7'* ]]; then
        echo -e "${MAGENTA}╔══════════════════════════════════════════════════════════════╗${RESET}"
        echo -e "${MAGENTA}║${RESET}                    ${BOLD}💻 IDE SELECTION${RESET}                        ${MAGENTA}║${RESET}"
        echo -e "${MAGENTA}╚══════════════════════════════════════════════════════════════╝${RESET}"
        echo
        echo -e "${CYAN} [${WHITE}1${CYAN}] 📝 Sublime Text (Lightweight & Fast)${RESET}"
        echo -e "${CYAN} [${WHITE}2${CYAN}] 💻 Visual Studio Code (Microsoft)${RESET}"
        echo -e "${CYAN} [${WHITE}3${CYAN}] 🤖 Cursor AI Code Editor (AI-Powered)${RESET}"
        echo -e "${CYAN} [${WHITE}4${CYAN}] ⚡ Void AI Code Editor (AI-Enhanced)${RESET}"
        echo -e "${CYAN} [${WHITE}5${CYAN}] 🧠 AI Combo (Cursor + Void)${RESET}"
        echo -e "${CYAN} [${WHITE}6${CYAN}] 🔧 Classic Combo (Sublime + VSCode)${RESET}"
        echo -e "${CYAN} [${WHITE}7${CYAN}] 🎯 Everything (All 4 IDEs)${RESET}"
        echo -e "${CYAN} [${WHITE}8${CYAN}] ⏭️  Skip IDE Installation${RESET}"
        echo
        read -n1 -p "$(echo -e "${YELLOW}Choose IDE Option [1-8]: ${GREEN}")" IDE_OPTION
        echo -e "${RESET}"
        banner
    fi
    
    # Media Player Selection
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                 ${BOLD}🎵 MEDIA PLAYER SELECTION${RESET}                ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${CYAN} [${WHITE}1${CYAN}] 🎬 MPV Media Player (Recommended)${RESET}"
    echo -e "${CYAN} [${WHITE}2${CYAN}] 🎥 VLC Media Player (Popular)${RESET}"
    echo -e "${CYAN} [${WHITE}3${CYAN}] 🎭 Both Players (MPV + VLC)${RESET}"
    echo -e "${CYAN} [${WHITE}4${CYAN}] ⏭️  Skip Media Player Installation${RESET}"
    echo
    read -n1 -p "$(echo -e "${YELLOW}Choose Media Player Option [1-4]: ${GREEN}")" PLAYER_OPTION
    echo -e "${RESET}"
    { banner; sleep 1; }

    # Install selected software
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                ${BOLD}🚀 SOFTWARE INSTALLATION${RESET}                 ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    # Browser Installation
    case $BROWSER_OPTION in
        2) install_chromium ;;
        3) install_firefox; install_chromium ;;
        *) install_firefox ;;
    esac

    # IDE Installation (with AI tools)
    if [[ "$arch" != 'armhf' && "$arch" != *'armv7'* ]]; then
        case $IDE_OPTION in
            1) install_sublime ;;
            2) install_vscode ;;
            3) install_cursor_ai ;;
            4) install_void_ai ;;
            5) install_cursor_ai; install_void_ai ;;
            6) install_sublime; install_vscode ;;
            7) install_sublime; install_vscode; install_cursor_ai; install_void_ai ;;
            8) echo -e "${YELLOW}⏭️  Skipping IDE installation${RESET}"; sleep 1 ;;
            *) install_sublime ;;
        esac
    else
        echo -e "${YELLOW}⚠️  ARM architecture detected - IDEs may have limited functionality${RESET}"
        sleep 2
    fi

    # Media Player Installation
    case $PLAYER_OPTION in
        1) install_apt "mpv" ;;
        2) install_apt "vlc" ;;
        3) install_apt "mpv" "vlc" ;;
        4) echo -e "${YELLOW}⏭️  Skipping media player installation${RESET}"; sleep 1 ;;
        *) install_apt "mpv" ;;
    esac

    echo -e "${GREEN}✅ Software installation completed!${RESET}"
    log_message "SUCCESS" "Software installation completed"
}

# Enhanced downloader with progress
downloader() {
    local path="$1"
    local url="$2"
    local max_retries=3
    local retry_count=0
    
    [ -e "$path" ] && rm -rf "$path"
    
    while [ $retry_count -lt $max_retries ]; do
        echo -e "${CYAN}📥 Downloading $(basename "$path")... (Attempt $((retry_count + 1))/${max_retries})${RESET}"
        
        if curl --progress-bar --insecure --fail --retry-connrefused --retry 3 --retry-delay 2 --location --output "$path" "$url" 2>/dev/null; then
            log_message "SUCCESS" "Downloaded: $(basename "$path")"
            return 0
        else
            ((retry_count++))
            log_message "WARNING" "Download attempt $retry_count failed for $(basename "$path")"
            sleep 2
        fi
    done
    
    log_message "ERROR" "Failed to download $(basename "$path") after $max_retries attempts"
    return 1
}

# Enhanced sound configuration
sound_fix() {
    echo -e "${CYAN}🔊 Configuring audio system...${RESET}"
    
    # Modify debian command to include sound
    if [ -f "/data/data/com.termux/files/usr/bin/debian" ]; then
        echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/debian)" > /data/data/com.termux/files/usr/bin/debian
    fi
    
    # Add environment variables
    {
        echo 'export DISPLAY=":1"'
        echo 'export PULSE_SERVER=127.0.0.1'
    } >> /etc/profile
    
    source /etc/profile 2>/dev/null || true
    echo -e "${GREEN}✅ Audio configuration completed${RESET}"
    log_message "SUCCESS" "Audio system configured"
}

# Theme cleanup functions
rem_theme() {
    local theme=(Bright Daloa Emacs Moheli Retro Smoke)
    for rmi in "${theme[@]}"; do
        if [ -d "/usr/share/themes/$rmi" ]; then
            rm -rf "/usr/share/themes/$rmi"
        fi
    done
}

rem_icon() {
    local fonts=(hicolor LoginIcons)
    for rmf in "${fonts[@]}"; do
        if [ -d "/usr/share/icons/$rmf" ]; then
            rm -rf "/usr/share/icons/$rmf"
        fi
    done
}

# Enhanced configuration function
config() {
    banner
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}                ${BOLD}🎨 THEME & CONFIGURATION${RESET}                 ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    local steps=10
    local current=0

    # Step 1: Sound configuration
    ((current++))
    show_progress $current $steps "Configuring audio system..."
    sleep 1
    sound_fix

    # Step 2: System updates
    ((current++))
    show_progress $current $steps "Updating system keys..."
    sleep 1
    
    if command -v apt-key &> /dev/null; then
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 >/dev/null 2>&1 || true
    fi

    # Step 3: Install theme packages
    ((current++))
    show_progress $current $steps "Installing theme packages..."
    sleep 1
    
    echo -e "\n${CYAN}🎨 Installing theme packages...${RESET}"
    yes | apt upgrade >/dev/null 2>&1
    yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin >/dev/null 2>&1 || true

    # Step 4: Prepare directories
    ((current++))
    show_progress $current $steps "Preparing directories..."
    sleep 1
    
    if [ -d "/usr/share/backgrounds/xfce" ]; then
        if [ -f "/usr/share/backgrounds/xfce/xfce-verticals.png" ]; then
            mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png 2>/dev/null
        fi
    else
        mkdir -p /usr/share/backgrounds/xfce
    fi

    # Step 5: Create temp folder and download themes
    ((current++))
    show_progress $current $steps "Downloading theme files..."
    sleep 1
    
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    echo -e "\n${CYAN}📦 Downloading theme and configuration files...${RESET}"

    # Download files with progress
    local files=(
        "fonts.tar.gz::https://github.com/Sandeepgaddam5432/modded-ubuntu/releases/download/config/fonts.tar.gz"
        "icons.tar.gz::https://github.com/Sandeepgaddam5432/modded-ubuntu/releases/download/config/icons.tar.gz"
        "wallpaper.tar.gz::https://github.com/Sandeepgaddam5432/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
        "gtk-themes.tar.gz::https://github.com/Sandeepgaddam5432/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
        "ubuntu-settings.tar.gz::https://github.com/Sandeepgaddam5432/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"
    )

    for file_info in "${files[@]}"; do
        local filename="${file_info%%::*}"
        local url="${file_info##*::}"
        downloader "$filename" "$url" || {
            echo -e "${YELLOW}⚠️  Failed to download $filename, continuing...${RESET}"
            continue
        }
    done

    # Steps 6-8: Extract and install files
    ((current++))
    show_progress $current $steps "Extracting fonts..."
    sleep 1

    echo -e "\n${CYAN}📁 Extracting and installing files...${RESET}"
    mkdir -p /usr/local/share/fonts/
    mkdir -p /usr/share/icons/
    mkdir -p /usr/share/themes/
    mkdir -p "$TEMP_DIR/debian-settings"

    ((current++))
    show_progress $current $steps "Installing themes and icons..."
    sleep 1

    # Process ubuntu-settings and rename to debian-settings
    if [ -f "ubuntu-settings.tar.gz" ]; then
        tar -xzf ubuntu-settings.tar.gz -C "$TEMP_DIR/" 2>/dev/null || true
        if [ -d "$TEMP_DIR/ubuntu-settings" ]; then
            find "$TEMP_DIR/ubuntu-settings" -type f -exec sed -i 's/Ubuntu/Debian/g' {} \; 2>/dev/null || true
            find "$TEMP_DIR/ubuntu-settings" -type f -exec sed -i 's/ubuntu/debian/g' {} \; 2>/dev/null || true
            cp -r "$TEMP_DIR/ubuntu-settings/"* "$TEMP_DIR/debian-settings/" 2>/dev/null || true
        fi
    fi

    # Extract other files
    [ -f "fonts.tar.gz" ] && tar -xzf fonts.tar.gz -C "/usr/local/share/fonts/" 2>/dev/null || true
    [ -f "icons.tar.gz" ] && tar -xzf icons.tar.gz -C "/usr/share/icons/" 2>/dev/null || true
    [ -f "wallpaper.tar.gz" ] && tar -xzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/" 2>/dev/null || true
    [ -f "gtk-themes.tar.gz" ] && tar -xzf gtk-themes.tar.gz -C "/usr/share/themes/" 2>/dev/null || true

    ((current++))
    show_progress $current $steps "Configuring user settings..."
    sleep 1

    # Copy debian settings to user home
    if [ -d "$TEMP_DIR/debian-settings" ] && [ -n "$username" ]; then
        cp -r "$TEMP_DIR/debian-settings/"* "/home/$username/" 2>/dev/null || true
        chown -R "$username:$username" "/home/$username/" 2>/dev/null || true
    fi

    # Step 9: Cleanup and font cache
    ((current++))
    show_progress $current $steps "Cleaning up and rebuilding cache..."
    sleep 1

    echo -e "\n${CYAN}🧹 Cleaning up unnecessary files...${RESET}"
    rem_theme
    rem_icon
    
    echo -e "${CYAN}🔤 Rebuilding font cache...${RESET}"
    fc-cache -fv >/dev/null 2>&1 &
    show_spinner "Rebuilding font cache" $!

    # Create desktop entry for configuration tool
    echo -e "${CYAN}🖥️  Creating desktop entries...${RESET}"
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

    # Step 10: Final system update
    ((current++))
    show_progress $current $steps "Final system optimization..."
    sleep 1

    echo -e "\n${CYAN}⚡ Performing final system optimization...${RESET}"
    apt update >/dev/null 2>&1
    yes | apt upgrade >/dev/null 2>&1 &
    show_spinner "System upgrade" $!
    
    apt clean >/dev/null 2>&1
    yes | apt autoremove >/dev/null 2>&1

    # Cleanup temp directory
    cd /
    rm -rf "$TEMP_DIR"

    echo -e "\n${GREEN}✅ Theme and configuration setup completed!${RESET}"
    log_message "SUCCESS" "Configuration and theming completed"
}

# Enhanced completion message
note() {
    banner
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                 ${BOLD}🎉 INSTALLATION COMPLETE! 🎉${RESET}               ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}Debian GUI with AI-Powered IDEs Successfully Installed!${RESET} ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}🚀 QUICK START COMMANDS:${RESET}                             ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}• ${WHITE}vncstart${CYAN} - Start VNC server${RESET}                         ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}• ${WHITE}vncstop${CYAN} - Stop VNC server${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}• ${WHITE}debian-config${CYAN} - Open configuration tool${RESET}            ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}📱 VNC SETUP INSTRUCTIONS:${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}1. Install VNC Viewer app from Play Store${RESET}           ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}2. Open VNC Viewer & click + button${RESET}                  ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}3. Enter address: ${CYAN}localhost:1${RESET}                         ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}4. Set picture quality to High${RESET}                       ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}5. Connect and enter your VNC password${RESET}               ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${MAGENTA}🤖 INSTALLED AI TOOLS:${RESET}                               ${GREEN}║${RESET}"
    
    # Show installed IDEs
    if command -v cursor >/dev/null 2>&1; then
        echo -e "${GREEN}║${RESET}    ${WHITE}✅ Cursor AI - Advanced AI code editor${RESET}              ${GREEN}║${RESET}"
    fi
    if command -v void >/dev/null 2>&1; then
        echo -e "${GREEN}║${RESET}    ${WHITE}✅ Void AI - AI-enhanced development${RESET}                ${GREEN}║${RESET}"
    fi
    if command -v code >/dev/null 2>&1; then
        echo -e "${GREEN}║${RESET}    ${WHITE}✅ VS Code - Microsoft's popular editor${RESET}            ${GREEN}║${RESET}"
    fi
    if command -v subl >/dev/null 2>&1; then
        echo -e "${GREEN}║${RESET}    ${WHITE}✅ Sublime Text - Lightweight & fast${RESET}               ${GREEN}║${RESET}"
    fi
    
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}💡 Pro Tip: Type 'vncstart' and enjoy coding with AI!${RESET}   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}Created by: Sandeep Gaddam | Enhanced Experience${RESET}     ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "SUCCESS" "GUI setup completed successfully"
}

# Error handling function
handle_error() {
    local error_msg="$1"
    echo -e "\n${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║${RESET}                        ${BOLD}❌ ERROR ❌${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}Setup failed:${RESET}                                           ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${YELLOW}$error_msg${RESET}"
    printf "${RED}║${RESET}%*s${RED}║${RESET}\n" $((62 - ${#error_msg})) ""
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${CYAN}💡 Troubleshooting:${RESET}                                     ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Check internet connection${RESET}                             ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Ensure sufficient storage space${RESET}                       ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Run with root privileges: sudo bash gui.sh${RESET}           ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Check log: $LOG_FILE${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "ERROR" "$error_msg"
    exit 1
}

# Cleanup function
cleanup() {
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
    log_message "INFO" "Cleanup completed"
}

# Main execution
main() {
    # Initialize logging
    log_message "INFO" "Starting Debian GUI setup v$SCRIPT_VERSION"
    
    # Set up error trapping
    trap 'handle_error "Unexpected error occurred during setup"' ERR
    trap cleanup EXIT
    
    banner
    check_root
    package
    install_softwares
    config
    note
    
    # Clean up log file on success
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
}

# Execute main function
main "$@"
