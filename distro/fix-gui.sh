#!/bin/bash

# Enhanced GUI Recovery Script for Debian Setup  
# Author: Sandeep Gaddam
# This script helps recover missing GUI files with proper error checking

# Color definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

echo -e "${CYAN}🔧 Debian GUI Recovery Tool v2.0${RESET}"
echo -e "${GREEN}====================================${RESET}"
echo

# Enhanced download function with HTTP status checking
download_with_status_check() {
    local url="$1"
    local dest="$2"
    local max_retries=3
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        echo -e "${YELLOW}📥 Downloading from: $url (Attempt $((retry + 1))/$max_retries)${RESET}"
        
        # Use curl with status code checking
        if command -v curl >/dev/null 2>&1; then
            local http_code=$(curl -s -w "%{http_code}" -o "$dest" "$url")
            
            if [ "$http_code" = "200" ] && [ -s "$dest" ]; then
                # Check if file starts with HTML (404 page)
                if head -n1 "$dest" | grep -q -i "<!DOCTYPE\|<html\|404"; then
                    echo -e "${RED}❌ Downloaded HTML error page instead of script${RESET}"
                    rm -f "$dest"
                    ((retry++))
                    continue
                fi
                
                echo -e "${GREEN}✅ Successfully downloaded valid script${RESET}"
                return 0
            else
                echo -e "${RED}❌ HTTP Error: $http_code${RESET}"
                rm -f "$dest"
            fi
        fi
        
        ((retry++))
        sleep 2
    done
    
    return 1
}

# Try downloading gui.sh with multiple methods and URLs
echo -e "${CYAN}🔄 Attempting to download gui.sh...${RESET}"

# Method 1: Try from your main repository
if download_with_status_check "https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master/distro/gui.sh" "gui.sh.tmp"; then
    mv gui.sh.tmp gui.sh
    chmod +x gui.sh
    echo -e "${GREEN}✅ GUI script downloaded from primary repository${RESET}"
elif download_with_status_check "https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/main/distro/gui.sh" "gui.sh.tmp"; then
    mv gui.sh.tmp gui.sh  
    chmod +x gui.sh
    echo -e "${GREEN}✅ GUI script downloaded from main branch${RESET}"
else
    # If download fails, create the script locally
    echo -e "${YELLOW}⚠️  Download failed. Creating gui.sh locally...${RESET}"
    
    cat > gui.sh << 'SCRIPT_END'
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

# Show simple installation message
show_basic_setup() {
    banner
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                    ${BOLD}🎉 BASIC GUI SETUP${RESET}                      ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}This is a basic GUI setup. For full features:${RESET}           ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}1. Update package repositories${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}2. Install basic GUI packages${RESET}                           ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}3. Setup VNC server${RESET}                                     ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}For enhanced setup with AI tools, download the${RESET}          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}complete script from the repository.${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
}

# Check root privileges
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}❌ This script requires root privileges${RESET}"
        echo -e "${WHITE}Please run: ${YELLOW}sudo bash gui.sh${RESET}"
        exit 1
    fi
}

# Basic package installation
install_basic_packages() {
    echo -e "${CYAN}📦 Installing basic GUI packages...${RESET}"
    
    apt-get update -y
    apt-get install -y xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common
    apt-get install -y firefox-esr chromium fonts-noto dbus-x11
    
    echo -e "${GREEN}✅ Basic packages installed${RESET}"
}

# Basic VNC setup
setup_basic_vnc() {
    echo -e "${CYAN}🖥️  Setting up VNC server...${RESET}"
    
    # Create basic vncstart script
    cat > /usr/local/bin/vncstart << 'VNC_START'
#!/bin/bash
export DISPLAY=:1
vncserver :1 -geometry 1280x720 -depth 24
VNC_START
    
    # Create basic vncstop script  
    cat > /usr/local/bin/vncstop << 'VNC_STOP'
#!/bin/bash
vncserver -kill :1
VNC_STOP
    
    chmod +x /usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstop
    
    echo -e "${GREEN}✅ VNC server configured${RESET}"
}

# Main execution
main() {
    check_root
    show_basic_setup
    
    echo -e "${CYAN}🚀 Starting basic GUI setup...${RESET}"
    install_basic_packages
    setup_basic_vnc
    
    echo -e "${GREEN}🎉 Basic GUI setup completed!${RESET}"
    echo -e "${WHITE}Commands available:${RESET}"
    echo -e "${YELLOW}• vncstart - Start VNC server${RESET}"  
    echo -e "${YELLOW}• vncstop - Stop VNC server${RESET}"
    echo -e "${CYAN}Connect to localhost:1 with VNC Viewer${RESET}"
}

# Execute main function
main "$@"
SCRIPT_END
    
    chmod +x gui.sh
    echo -e "${GREEN}✅ Basic gui.sh script created locally${RESET}"
fi

echo
echo -e "${GREEN}🚀 gui.sh is ready! Now run: ${YELLOW}sudo bash gui.sh${RESET}"
