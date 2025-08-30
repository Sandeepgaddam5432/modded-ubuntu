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

# Root check
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}❌ Run with sudo: sudo bash gui.sh${RESET}"
        exit 1
    fi
}

# Basic package installation
install_packages() {
    echo -e "${CYAN}📦 Installing packages...${RESET}"
    apt-get update -y
    apt-get install -y xfce4 xfce4-goodies tigervnc-standalone-server firefox-esr
    echo -e "${GREEN}✅ Packages installed${RESET}"
}

# VNC setup
setup_vnc() {
    echo -e "${CYAN}🖥️  Setting up VNC...${RESET}"
    
    cat > /usr/local/bin/vncstart << 'EOF'
#!/bin/bash
export DISPLAY=:1
vncserver :1 -geometry 1280x720 -depth 24
EOF
    
    cat > /usr/local/bin/vncstop << 'EOF'  
#!/bin/bash
vncserver -kill :1
EOF
    
    chmod +x /usr/local/bin/vncstart /usr/local/bin/vncstop
    echo -e "${GREEN}✅ VNC configured${RESET}"
}

# Main execution
main() {
    check_root
    install_packages
    setup_vnc
    
    echo -e "${GREEN}🎉 GUI setup completed!${RESET}"
    echo -e "${YELLOW}Commands: vncstart, vncstop${RESET}"
    echo -e "${CYAN}Connect to localhost:1${RESET}"
}

main "$@"
