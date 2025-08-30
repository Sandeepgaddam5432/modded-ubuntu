#!/bin/bash

# Enhanced Debian Setup with Professional UI/UX
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
SCRIPT_NAME="Debian GUI Setup"
SCRIPT_VERSION="3.0"
LOG_FILE="$HOME/.debian-setup.log"
CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")

# Fix PREFIX variable if not set
if [ -z "$PREFIX" ]; then
    if [ -d "/data/data/com.termux/files/usr" ]; then
        export PREFIX="/data/data/com.termux/files/usr"
    else
        export PREFIX="/usr"
    fi
fi

DEBIAN_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/debian"
REPO_BASE="https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master"

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced animated banner
show_banner() {
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
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}S E T U P   T O O L   v${SCRIPT_VERSION}${RESET}              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Professional Debian GUI Environment for Termux${RESET}      ${CYAN}║${RESET}"
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

# Spinner animation for longer operations
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

# Enhanced system requirements check
check_system_requirements() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                 ${BOLD}SYSTEM REQUIREMENTS CHECK${RESET}                ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Enhanced Termux detection
    local is_termux=false
    
    # Method 1: Check for Termux package directory
    if [ -d "/data/data/com.termux" ]; then
        is_termux=true
    # Method 2: Check for Termux environment variables
    elif [ -n "$TERMUX_VERSION" ] || [ -n "$PREFIX" ]; then
        is_termux=true
    # Method 3: Check for Termux-specific paths
    elif [ -f "/data/data/com.termux/files/usr/bin/termux-info" ]; then
        is_termux=true
    # Method 4: Check if we can access Termux directories
    elif [ -w "/data/data/com.termux/files/home" ] 2>/dev/null; then
        is_termux=true
    # Method 5: Check for pkg command (Termux package manager)
    elif command -v pkg >/dev/null 2>&1; then
        is_termux=true
    fi
    
    if [ "$is_termux" = true ]; then
        echo -e "${GREEN}✅ Termux environment detected${RESET}"
        
        # Additional Termux info
        if command -v termux-info >/dev/null 2>&1; then
            local termux_version=$(termux-info 2>/dev/null | grep "Termux version" | cut -d: -f2 | xargs || echo "Unknown")
            echo -e "${WHITE}   Termux version: ${CYAN}$termux_version${RESET}"
        fi
        
        log_message "SUCCESS" "Termux environment verified"
    else
        echo -e "${RED}❌ This script must be run in Termux!${RESET}"
        echo -e "${WHITE}   Please install and run this script from the Termux app.${RESET}"
        log_message "ERROR" "Not running in Termux environment"
        exit 1
    fi
    
    # Check storage space
    local available_space=$(df "$HOME" 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")
    local required_space=4194304  # 4GB in KB
    
    if [ "$available_space" -gt 0 ] && [ "$available_space" -lt "$required_space" ]; then
        echo -e "${RED}❌ Insufficient storage space!${RESET}"
        echo -e "${WHITE}   Required: 4GB, Available: $((available_space/1024/1024))GB${RESET}"
        log_message "ERROR" "Insufficient storage space"
        exit 1
    else
        local available_gb=$((available_space/1024/1024))
        if [ "$available_gb" -gt 0 ]; then
            echo -e "${GREEN}✅ Storage check passed${RESET} (${available_gb}GB available)"
        else
            echo -e "${YELLOW}⚠️  Could not determine storage space${RESET}"
        fi
    fi
    
    echo
}

# Enhanced package installation with progress
install_packages() {
    local steps=4
    local current=0
    
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}                   ${BOLD}PACKAGE INSTALLATION${RESET}                   ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Step 1: Setup storage
    ((current++))
    show_progress $current $steps "Setting up storage access..."
    sleep 1
    
    if [ ! -d '/data/data/com.termux/files/home/storage' ]; then
        echo -e "\n${CYAN}📁 Setting up storage access...${RESET}"
        termux-setup-storage 2>/dev/null || true
        log_message "INFO" "Storage access configured"
    fi
    
    # Step 2: Update packages
    ((current++))
    show_progress $current $steps "Updating package repositories..."
    sleep 1
    
    echo -e "\n${CYAN}🔄 Updating package repositories...${RESET}"
    yes | pkg upgrade >/dev/null 2>&1 &
    show_spinner "Updating packages" $!
    
    # Step 3: Check existing packages
    ((current++))
    show_progress $current $steps "Checking required packages..."
    sleep 1
    
    local missing_packages=()
    local required_packages=("pulseaudio" "proot-distro")
    
    for pkg in "${required_packages[@]}"; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            missing_packages+=("$pkg")
        fi
    done
    
    # Step 4: Install missing packages
    ((current++))
    if [ ${#missing_packages[@]} -eq 0 ]; then
        show_progress $current $steps "All packages already installed"
        echo -e "\n${GREEN}✅ All required packages are already installed${RESET}"
    else
        show_progress $current $steps "Installing missing packages..."
        echo
        
        for pkg in "${missing_packages[@]}"; do
            echo -e "${CYAN}Installing: ${YELLOW}$pkg${RESET}"
            yes | pkg install "$pkg" >/dev/null 2>&1 &
            show_spinner "Installing $pkg" $!
            log_message "INFO" "Installed package: $pkg"
        done
    fi
    
    echo
}

# Enhanced distribution installation
install_distribution() {
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║${RESET}                ${BOLD}DEBIAN DISTRIBUTION SETUP${RESET}                ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    termux-reload-settings 2>/dev/null || true
    
    if [ -d "$DEBIAN_DIR" ]; then
        echo -e "${YELLOW}⚠️  Debian distribution already exists${RESET}"
        echo -e "${WHITE}Skipping installation...${RESET}"
        log_message "INFO" "Debian distribution already exists"
        return 0
    fi
    
    echo -e "${CYAN}📥 Downloading and installing Debian distribution...${RESET}"
    echo -e "${WHITE}This may take several minutes depending on your connection.${RESET}"
    echo
    
    proot-distro install debian >/dev/null 2>&1 &
    show_spinner "Installing Debian distribution" $!
    
    termux-reload-settings 2>/dev/null || true
    
    if [ -d "$DEBIAN_DIR" ]; then
        echo -e "${GREEN}✅ Debian distribution installed successfully${RESET}"
        log_message "SUCCESS" "Debian distribution installed"
    else
        echo -e "${RED}❌ Failed to install Debian distribution${RESET}"
        log_message "ERROR" "Failed to install Debian distribution"
        exit 1
    fi
    
    echo
}

# Smart file downloader with retry logic
smart_download() {
    local file_path="$1"
    local url="$2"
    local max_retries=3
    local retry_count=0
    
    [ -e "$file_path" ] && rm -rf "$file_path"
    
    while [ $retry_count -lt $max_retries ]; do
        echo -e "${CYAN}📥 Downloading $(basename "$file_path")... (Attempt $((retry_count + 1))/${max_retries})${RESET}"
        
        if curl --progress-bar --insecure --fail --retry-connrefused --retry 3 --retry-delay 2 --location --output "$file_path" "$url" 2>/dev/null; then
            log_message "SUCCESS" "Downloaded: $(basename "$file_path")"
            return 0
        else
            ((retry_count++))
            log_message "WARNING" "Download attempt $retry_count failed for $(basename "$file_path")"
            sleep 2
        fi
    done
    
    log_message "ERROR" "Failed to download $(basename "$file_path") after $max_retries attempts"
    return 1
}

# Audio configuration with enhanced feedback
configure_audio() {
    echo -e "${GREEN}🔊 Configuring audio system...${RESET}"
    
    [ ! -e "$HOME/.sound" ] && touch "$HOME/.sound"
    
    # Remove existing entries to prevent duplicates
    if [ -f "$HOME/.sound" ]; then
        sed -i '/pacmd load-module module-aaudio-sink/d' "$HOME/.sound" 2>/dev/null
        sed -i '/pulseaudio --start --exit-idle-time=-1/d' "$HOME/.sound" 2>/dev/null
        sed -i '/pacmd load-module module-native-protocol-tcp/d' "$HOME/.sound" 2>/dev/null
    fi
    
    # Add new configuration
    {
        echo "pacmd load-module module-aaudio-sink"
        echo "pulseaudio --start --exit-idle-time=-1"
        echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"
    } >> "$HOME/.sound"
    
    echo -e "${GREEN}✅ Audio configuration completed${RESET}"
    log_message "SUCCESS" "Audio system configured"
}

# VNC setup with error handling
setup_vnc_tools() {
    echo -e "${BLUE}🖥️  Setting up VNC tools...${RESET}"
    
    local vnc_files=("vncstart" "vncstop")
    
    for file in "${vnc_files[@]}"; do
        local local_path="$CURR_DIR/distro/$file"
        local target_path="$DEBIAN_DIR/usr/local/bin/$file"
        local download_url="$REPO_BASE/distro/$file"
        
        if [ -e "$local_path" ]; then
            cp -f "$local_path" "$target_path"
            echo -e "${GREEN}✅ Copied local $file${RESET}"
        else
            if smart_download "$CURR_DIR/$file" "$download_url"; then
                mv -f "$CURR_DIR/$file" "$target_path"
                echo -e "${GREEN}✅ Downloaded and installed $file${RESET}"
            else
                echo -e "${RED}❌ Failed to setup $file${RESET}"
                return 1
            fi
        fi
        
        chmod +x "$target_path"
    done
    
    log_message "SUCCESS" "VNC tools configured"
}

# Configuration tool setup
setup_config_tool() {
    echo -e "${CYAN}⚙️  Setting up configuration tool...${RESET}"
    
    local config_file="debian-config.sh"
    local local_config="$CURR_DIR/distro/$config_file"
    local target_config="$DEBIAN_DIR/usr/local/bin/debian-config"
    
    if [ -e "$local_config" ]; then
        cp -f "$local_config" "$target_config"
        echo -e "${GREEN}✅ Used local configuration tool${RESET}"
    else
        local ubuntu_config="$CURR_DIR/distro/ubuntu-config.sh"
        if [ -e "$ubuntu_config" ]; then
            cp -f "$ubuntu_config" "$CURR_DIR/$config_file"
            sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/$config_file"
            sed -i 's/ubuntu/debian/g' "$CURR_DIR/$config_file"
            mv -f "$CURR_DIR/$config_file" "$target_config"
            echo -e "${GREEN}✅ Converted Ubuntu config to Debian${RESET}"
        else
            local config_url="$REPO_BASE/distro/ubuntu-config.sh"
            if smart_download "$CURR_DIR/$config_file" "$config_url"; then
                sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/$config_file"
                sed -i 's/ubuntu/debian/g' "$CURR_DIR/$config_file"
                mv -f "$CURR_DIR/$config_file" "$target_config"
                echo -e "${GREEN}✅ Downloaded and configured tool${RESET}"
            else
                echo -e "${YELLOW}⚠️  Configuration tool setup failed${RESET}"
                return 1
            fi
        fi
    fi
    
    chmod +x "$target_config"
    log_message "SUCCESS" "Configuration tool setup completed"
}

# User setup script configuration
setup_user_script() {
    echo -e "${MAGENTA}👤 Setting up user management...${RESET}"
    
    local user_script="user.sh"
    local local_user="$CURR_DIR/distro/$user_script"
    local target_user="$DEBIAN_DIR/root/$user_script"
    
    if [ -e "$local_user" ]; then
        cp -f "$local_user" "$target_user"
        sed -i 's/Ubuntu/Debian/g' "$target_user"
        sed -i 's/ubuntu/debian/g' "$target_user"
        echo -e "${GREEN}✅ Used local user script${RESET}"
    else
        local user_url="$REPO_BASE/distro/user.sh"
        if smart_download "$CURR_DIR/$user_script" "$user_url"; then
            sed -i 's/Ubuntu/Debian/g' "$CURR_DIR/$user_script"
            sed -i 's/ubuntu/debian/g' "$CURR_DIR/$user_script"
            mv -f "$CURR_DIR/$user_script" "$target_user"
            echo -e "${GREEN}✅ Downloaded user management script${RESET}"
        else
            echo -e "${RED}❌ Failed to setup user script${RESET}"
            return 1
        fi
    fi
    
    chmod +x "$target_user"
    log_message "SUCCESS" "User script configured"
}

# Final environment setup
finalize_setup() {
    echo -e "${YELLOW}🔧 Finalizing environment setup...${RESET}"
    
    # Set timezone
    if [ -d "$DEBIAN_DIR/etc" ]; then
        echo "$(getprop persist.sys.timezone 2>/dev/null || echo 'UTC')" > "$DEBIAN_DIR/etc/timezone"
        echo -e "${GREEN}✅ Timezone configured${RESET}"
    fi
    
    # Create debian command
    echo "proot-distro login debian" > "$PREFIX/bin/debian"
    chmod +x "$PREFIX/bin/debian"
    echo -e "${GREEN}✅ Debian command created${RESET}"
    
    # Reload settings
    termux-reload-settings 2>/dev/null || true
    echo -e "${GREEN}✅ Termux settings reloaded${RESET}"
    
    log_message "SUCCESS" "Environment setup finalized"
}

# Success display with next steps
show_success_message() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                    ${BOLD}🎉 INSTALLATION COMPLETE! 🎉${RESET}               ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${WHITE}Debian GUI environment has been successfully installed!${RESET}  ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${YELLOW}📋 NEXT STEPS:${RESET}                                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}1.${RESET} ${WHITE}Restart Termux to prevent any issues${RESET}                 ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}2.${RESET} ${WHITE}Type ${YELLOW}'debian'${WHITE} to enter CLI mode${RESET}                      ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}3.${RESET} ${WHITE}Run ${YELLOW}'bash user.sh'${WHITE} to setup GUI user${RESET}                 ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}4.${RESET} ${WHITE}Restart Termux again after user setup${RESET}                ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}5.${RESET} ${WHITE}Type ${YELLOW}'debian'${WHITE} then ${YELLOW}'sudo bash gui.sh'${WHITE} for GUI${RESET}          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${YELLOW}🎮 USEFUL COMMANDS:${RESET}                                     ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${WHITE}• ${CYAN}vncstart${WHITE} - Start VNC server${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${WHITE}• ${CYAN}vncstop${WHITE} - Stop VNC server${RESET}                           ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${WHITE}• ${CYAN}debian-config${WHITE} - Open configuration tool (GUI mode)${RESET}  ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${MAGENTA}💡 Install VNC Viewer from Play Store for GUI access${RESET}    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${MAGENTA}🔗 Connect to: localhost:1${RESET}                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}Created by: Sandeep Gaddam | Enhanced Experience${RESET}        ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "SUCCESS" "Installation completed successfully"
}

# Error handling with detailed feedback
handle_error() {
    local error_msg="$1"
    echo -e "\n${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║${RESET}                        ${BOLD}❌ ERROR ❌${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}An error occurred during installation:${RESET}                  ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${YELLOW}$error_msg${RESET}"
    printf "${RED}║${RESET}%*s${RED}║${RESET}\n" $((62 - ${#error_msg})) ""
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${CYAN}💡 Troubleshooting:${RESET}                                     ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Check your internet connection${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Ensure sufficient storage space (4GB+)${RESET}                ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Try running the script again${RESET}                          ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}• Check log file: $LOG_FILE${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "ERROR" "$error_msg"
    exit 1
}

# Cleanup function
cleanup() {
    [ -f "$LOG_FILE.tmp" ] && rm -f "$LOG_FILE.tmp"
    log_message "INFO" "Setup cleanup completed"
}

# Main execution function
main() {
    # Initialize logging
    log_message "INFO" "Starting Debian GUI setup v$SCRIPT_VERSION"
    
    # Set up error trapping
    trap 'handle_error "Unexpected error occurred during setup"' ERR
    trap cleanup EXIT
    
    show_banner
    check_system_requirements
    install_packages
    install_distribution
    configure_audio
    
    echo -e "${BLUE}🔧 Setting up GUI components...${RESET}"
    setup_vnc_tools || handle_error "Failed to setup VNC tools"
    setup_config_tool || handle_error "Failed to setup configuration tool"
    setup_user_script || handle_error "Failed to setup user script"
    
    finalize_setup
    show_success_message
    
    # Clean up log file on success
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
}

# Execute main function
main "$@"
