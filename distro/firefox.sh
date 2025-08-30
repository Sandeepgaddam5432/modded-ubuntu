#!/bin/bash

# Enhanced Firefox Latest Version Installer with Professional UI/UX
# Author: Sandeep Gaddam
# Version: 2.0 - Always Latest

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
SCRIPT_NAME="Firefox Latest Installer"
SCRIPT_VERSION="2.0"
LOG_FILE="$HOME/.firefox-installer.log"
PREFFILE="/etc/apt/preferences.d/mozilla-firefox"
BACKUP_DIR="/tmp/firefox-backup-$(date +%Y%m%d_%H%M%S)"

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced banner with Firefox branding
show_banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}███████╗██╗██████╗ ███████╗███████╗ ██████╗ ██╗  ██╗${RESET}    ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██╔════╝██║██╔══██╗██╔════╝██╔════╝██╔═══██╗╚██╗██╔╝${RESET}    ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}█████╗  ██║██████╔╝█████╗  █████╗  ██║   ██║ ╚███╔╝${RESET}     ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██╔══╝  ██║██╔══██╗██╔══╝  ██╔══╝  ██║   ██║ ██╔██╗${RESET}     ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}██║     ██║██║  ██║███████╗██║     ╚██████╔╝██╔╝ ██╗${RESET}    ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${YELLOW}╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝${RESET}    ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}L A T E S T   I N S T A L L E R   v${SCRIPT_VERSION}${RESET}         ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Always Install Latest Firefox from Mozilla PPA${RESET}          ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${WHITE}By: Sandeep Gaddam | Professional Experience${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

# Progress bar with enhanced animation
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

# Spinner for longer operations
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

# System requirements and root check
check_prerequisites() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                 ${BOLD}SYSTEM REQUIREMENTS CHECK${RESET}                ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Root check
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}❌ This script must be run as root (sudo)${RESET}"
        echo -e "${WHITE}   Please run: ${YELLOW}sudo bash firefox.sh${RESET}"
        log_message "ERROR" "Script not run as root"
        exit 1
    else
        echo -e "${GREEN}✅ Root privileges confirmed${RESET}"
    fi
    
    # Check if we're on a Debian/Ubuntu system
    if [ -f /etc/debian_version ]; then
        echo -e "${GREEN}✅ Debian/Ubuntu system detected${RESET}"
        local distro=$(lsb_release -cs 2>/dev/null || echo "unknown")
        echo -e "${WHITE}   Distribution: ${CYAN}$distro${RESET}"
    else
        echo -e "${RED}❌ This script is designed for Debian/Ubuntu systems${RESET}"
        log_message "ERROR" "Not a Debian/Ubuntu system"
        exit 1
    fi
    
    # Check internet connectivity
    if ping -c 1 google.com >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Internet connection available${RESET}"
    else
        echo -e "${RED}❌ No internet connection detected${RESET}"
        log_message "ERROR" "No internet connection"
        exit 1
    fi
    
    echo
}

# Get current and available Firefox versions
check_firefox_versions() {
    echo -e "${CYAN}🔍 Checking Firefox versions...${RESET}"
    
    local current_version=""
    if command -v firefox >/dev/null 2>&1; then
        current_version=$(firefox --version 2>/dev/null | grep -oP 'Firefox \K[0-9.]+' || echo "Unknown")
        echo -e "${WHITE}   Current installed version: ${YELLOW}$current_version${RESET}"
    else
        echo -e "${WHITE}   Firefox not currently installed${RESET}"
    fi
    
    # Update package list silently for version check
    apt-get update >/dev/null 2>&1
    
    local available_version=$(apt-cache policy firefox 2>/dev/null | grep -A1 "Candidate:" | tail -1 | awk '{print $1}' || echo "Unknown")
    echo -e "${WHITE}   Latest available version: ${GREEN}$available_version${RESET}"
    
    echo
    log_message "INFO" "Current: $current_version, Available: $available_version"
}

# Create backup if Firefox exists
create_backup() {
    if command -v firefox >/dev/null 2>&1; then
        echo -e "${YELLOW}📦 Creating backup of current Firefox...${RESET}"
        mkdir -p "$BACKUP_DIR"
        
        # Backup Firefox profiles if they exist
        if [ -d "$HOME/.mozilla" ]; then
            cp -r "$HOME/.mozilla" "$BACKUP_DIR/" 2>/dev/null
            echo -e "${GREEN}✅ Firefox profiles backed up${RESET}"
        fi
        
        log_message "INFO" "Backup created at $BACKUP_DIR"
        echo -e "${WHITE}   Backup location: ${CYAN}$BACKUP_DIR${RESET}"
        echo
    fi
}

# Remove existing Firefox installations
remove_existing_firefox() {
    local steps=3
    local current=0
    
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}                 ${BOLD}REMOVING EXISTING FIREFOX${RESET}                ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Remove snap Firefox if exists
    ((current++))
    show_progress $current $steps "Checking for snap Firefox..."
    sleep 1
    
    if command -v snap >/dev/null 2>&1 && snap list | grep -q firefox 2>/dev/null; then
        echo -e "\n${CYAN}🔄 Removing snap Firefox...${RESET}"
        snap remove firefox >/dev/null 2>&1 &
        show_spinner "Removing snap Firefox" $!
        log_message "INFO" "Snap Firefox removed"
    else
        echo -e "\n${WHITE}   No snap Firefox found${RESET}"
    fi
    
    # Remove APT Firefox
    ((current++))
    show_progress $current $steps "Removing APT Firefox packages..."
    sleep 1
    
    if dpkg -l | grep -q firefox 2>/dev/null; then
        echo -e "\n${CYAN}🔄 Removing existing Firefox packages...${RESET}"
        apt-get remove --purge firefox* -y >/dev/null 2>&1 &
        show_spinner "Removing Firefox packages" $!
        log_message "INFO" "APT Firefox packages removed"
    else
        echo -e "\n${WHITE}   No APT Firefox packages found${RESET}"
    fi
    
    # Clean up
    ((current++))
    show_progress $current $steps "Cleaning up package cache..."
    sleep 1
    
    apt-get autoremove -y >/dev/null 2>&1
    apt-get autoclean >/dev/null 2>&1
    
    echo -e "\n${GREEN}✅ Existing Firefox installations removed${RESET}"
    echo
}

# Enhanced PGP key setup function
print_key() {
    cat <<-EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----

PASTE YOUR PGP KEY HERE MANUALLY
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
o5I=
=T8PE

-----END PGP PUBLIC KEY BLOCK-----
EOF
}

# Setup Mozilla repository with enhanced error handling
setup_mozilla_repository() {
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║${RESET}                ${BOLD}MOZILLA REPOSITORY SETUP${RESET}                 ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Detect distribution
    local distro_codename=$(lsb_release -cs 2>/dev/null)
    if [ -z "$distro_codename" ]; then
        distro_codename="jammy"  # Default fallback
        echo -e "${YELLOW}⚠️  Could not detect distribution, using default: $distro_codename${RESET}"
    fi
    
    echo -e "${CYAN}🔧 Setting up Mozilla PPA repository...${RESET}"
    
    # Add repository
    local repo_file="/etc/apt/sources.list.d/mozillateam-ubuntu-ppa-${distro_codename}.list"
    echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $distro_codename main" | tee "$repo_file" >/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Repository added successfully${RESET}"
    else
        echo -e "${RED}❌ Failed to add repository${RESET}"
        log_message "ERROR" "Failed to add Mozilla repository"
        exit 1
    fi
    
    # Setup GPG key
    echo -e "${CYAN}🔑 Setting up GPG key...${RESET}"
    print_key | gpg --dearmor > /etc/apt/trusted.gpg.d/firefox.gpg 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ GPG key installed successfully${RESET}"
    else
        echo -e "${RED}❌ Failed to install GPG key${RESET}"
        log_message "ERROR" "Failed to install GPG key"
        exit 1
    fi
    
    # Setup package preferences
    echo -e "${CYAN}⚙️  Configuring package preferences...${RESET}"
    
    if [ ! -f "$PREFFILE" ]; then
        mkdir -p /etc/apt/preferences.d/
        cat > "$PREFFILE" <<EOF
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
        echo -e "${GREEN}✅ Package preferences configured${RESET}"
    else
        echo -e "${YELLOW}⚠️  Preferences file already exists, updating...${RESET}"
        # Update existing preferences
        sed -i 's/Pin-Priority:.*/Pin-Priority: 1001/' "$PREFFILE"
    fi
    
    # Setup unattended upgrades
    echo -e "${CYAN}🔄 Configuring automatic updates...${RESET}"
    echo "Unattended-Upgrade::Allowed-Origins:: \"LP-PPA-mozillateam:\${distro_codename}\";" | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox >/dev/null
    
    echo -e "${GREEN}✅ Mozilla repository setup complete${RESET}"
    log_message "SUCCESS" "Mozilla repository configured"
    echo
}

# Install Firefox with progress tracking
install_firefox() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                  ${BOLD}FIREFOX INSTALLATION${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    local steps=3
    local current=0
    
    # Update package list
    ((current++))
    show_progress $current $steps "Updating package repositories..."
    sleep 1
    
    echo -e "\n${CYAN}🔄 Updating package repositories...${RESET}"
    apt-get update >/dev/null 2>&1 &
    show_spinner "Updating repositories" $!
    
    # Install Firefox
    ((current++))
    show_progress $current $steps "Installing latest Firefox..."
    sleep 1
    
    echo -e "\n${CYAN}🔥 Installing Firefox...${RESET}"
    echo -e "${WHITE}   This may take a few minutes...${RESET}"
    
    apt install firefox -y >/dev/null 2>&1 &
    show_spinner "Installing Firefox" $!
    
    # Verify installation
    ((current++))
    show_progress $current $steps "Verifying installation..."
    sleep 2
    
    if command -v firefox >/dev/null 2>&1; then
        local installed_version=$(firefox --version 2>/dev/null | grep -oP 'Firefox \K[0-9.]+' || echo "Unknown")
        echo -e "\n${GREEN}🎉 Firefox successfully installed!${RESET}"
        echo -e "${WHITE}   Installed version: ${BOLD}${GREEN}$installed_version${RESET}"
        log_message "SUCCESS" "Firefox installed successfully - version $installed_version"
    else
        echo -e "\n${RED}❌ Firefox installation failed${RESET}"
        log_message "ERROR" "Firefox installation failed"
        exit 1
    fi
    
    echo
}

# Post-installation configuration
post_installation_setup() {
    echo -e "${CYAN}⚙️  Performing post-installation setup...${RESET}"
    
    # Create desktop entry if needed
    if [ ! -f "/usr/share/applications/firefox.desktop" ]; then
        echo -e "${YELLOW}📋 Creating desktop entry...${RESET}"
        # Firefox package should create this, but just in case
        update-desktop-database >/dev/null 2>&1
    fi
    
    # Set Firefox as default browser (optional)
    echo -e "${CYAN}🌐 Configuring default browser settings...${RESET}"
    update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 200 >/dev/null 2>&1
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 200 >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Post-installation setup complete${RESET}"
    log_message "SUCCESS" "Post-installation setup completed"
}

# Success message with usage instructions
show_success_message() {
    local final_version=$(firefox --version 2>/dev/null | grep -oP 'Firefox \K[0-9.]+' || echo "Unknown")
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                    ${BOLD}🎉 SUCCESS! 🎉${RESET}                         ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}Firefox Latest Version Successfully Installed!${RESET}       ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}📊 INSTALLATION SUMMARY:${RESET}                            ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Version: ${BOLD}${CYAN}$final_version${RESET}                                ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Source: Mozilla PPA (Official)${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Auto-updates: Enabled${RESET}                             ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Priority: Highest (1001)${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}🚀 QUICK START:${RESET}                                     ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Launch: ${CYAN}firefox${WHITE} or click desktop icon${RESET}              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Check version: ${CYAN}firefox --version${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Run this script again to force latest update${RESET}      ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    if [ -d "$BACKUP_DIR" ]; then
    echo -e "${GREEN}║${RESET}    ${MAGENTA}💾 BACKUP LOCATION:${RESET}                                 ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}$BACKUP_DIR${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    fi
    echo -e "${GREEN}║${RESET}    ${CYAN}💡 Pro Tip: This script always installs the latest${RESET}   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}    version, even if Firefox is already installed!${RESET}   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "SUCCESS" "Installation completed - Firefox $final_version"
}

# Error handling function
handle_error() {
    local error_msg="$1"
    echo -e "\n${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║${RESET}                        ${BOLD}❌ ERROR ❌${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}Installation failed:${RESET}                                    ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${YELLOW}$error_msg${RESET}"
    printf "${RED}║${RESET}%*s${RED}║${RESET}\n" $((62 - ${#error_msg})) ""
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${CYAN}💡 Troubleshooting Steps:${RESET}                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}1. Check internet connection${RESET}                           ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}2. Ensure you have root privileges${RESET}                     ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}3. Update system: apt update && apt upgrade${RESET}            ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}4. Check log: $LOG_FILE${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}5. Try running the script again${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "ERROR" "$error_msg"
    exit 1
}

# Cleanup function
cleanup() {
    # Remove temporary files if any
    [ -f "$LOG_FILE.tmp" ] && rm -f "$LOG_FILE.tmp"
    log_message "INFO" "Cleanup completed"
}

# Main execution function
main() {
    # Initialize logging
    log_message "INFO" "Starting Firefox Latest Installer v$SCRIPT_VERSION"
    
    # Set up error trapping
    trap 'handle_error "Unexpected error occurred during installation"' ERR
    trap cleanup EXIT
    
    show_banner
    check_prerequisites
    check_firefox_versions
    create_backup
    remove_existing_firefox
    setup_mozilla_repository
    install_firefox
    post_installation_setup
    show_success_message
    
    # Clean up log file on success
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
    
    echo -e "${WHITE}Firefox installation completed successfully! 🎉${RESET}"
}

# Execute main function
main "$@"
