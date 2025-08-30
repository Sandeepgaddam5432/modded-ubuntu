#!/bin/bash

# Enhanced Debian Remover with Professional UI/UX
# Author: Sandeep Gaddam
# Version: 2.0

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
SCRIPT_NAME="Debian Remover"
SCRIPT_VERSION="2.0"
LOG_FILE="$HOME/.debian-remover.log"

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced banner with animation
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
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}R E M O V A L   T O O L   v${SCRIPT_VERSION}${RESET}              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Professional Debian Environment Cleanup Utility${RESET}     ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${WHITE}By: Sandeep Gaddam | Termux-Debian Project${RESET}          ${CYAN}║${RESET}"
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

# Confirmation dialog with enhanced styling
confirm_removal() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}                    ${RED}${BOLD}⚠️  WARNING  ⚠️${RESET}                      ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}                                                              ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}  ${WHITE}This will completely remove the Debian environment${RESET}      ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}  ${WHITE}including all installed packages and user data.${RESET}         ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}                                                              ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}  ${RED}This action cannot be undone!${RESET}                           ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}                                                              ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    while true; do
        echo -ne "${CYAN}${BOLD}Do you want to continue? ${RESET}${WHITE}[${GREEN}y${WHITE}/${RED}N${WHITE}]${RESET}: "
        read -r choice
        case $choice in
            [Yy]|[Yy][Ee][Ss])
                log_message "INFO" "User confirmed removal"
                return 0
                ;;
            [Nn]|[Nn][Oo]|"")
                echo -e "${GREEN}Operation cancelled by user.${RESET}"
                log_message "INFO" "User cancelled removal"
                exit 0
                ;;
            *)
                echo -e "${RED}Please enter 'y' for yes or 'n' for no.${RESET}"
                ;;
        esac
    done
}

# Enhanced removal function with progress tracking
perform_removal() {
    local steps=5
    local current=0
    
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}                    ${BOLD}REMOVAL IN PROGRESS${RESET}                    ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    # Step 1: Check if Debian is installed
    ((current++))
    show_progress $current $steps "Checking Debian installation..."
    sleep 1
    
    if ! command -v proot-distro >/dev/null 2>&1; then
        echo -e "\n${RED}❌ proot-distro not found. Nothing to remove.${RESET}"
        log_message "ERROR" "proot-distro not found"
        exit 1
    fi
    
    # Step 2: Remove Debian distribution
    ((current++))
    show_progress $current $steps "Removing Debian distribution..."
    sleep 1
    
    if proot-distro list --installed | grep -q "debian"; then
        proot-distro remove debian 2>/dev/null
        log_message "INFO" "Debian distribution removed"
    fi
    
    # Step 3: Clear cache
    ((current++))
    show_progress $current $steps "Clearing distribution cache..."
    sleep 1
    
    proot-distro clear-cache 2>/dev/null
    log_message "INFO" "Distribution cache cleared"
    
    # Step 4: Remove binaries and shortcuts
    ((current++))
    show_progress $current $steps "Removing shortcuts and binaries..."
    sleep 1
    
    [ -f "$PREFIX/bin/debian" ] && rm -rf "$PREFIX/bin/debian"
    log_message "INFO" "Debian shortcuts removed"
    
    # Step 5: Clean audio configuration
    ((current++))
    show_progress $current $steps "Cleaning audio configuration..."
    sleep 1
    
    if [ -f "$HOME/.sound" ]; then
        sed -i '/pulseaudio --start --exit-idle-time=-1/d' "$HOME/.sound" 2>/dev/null
        sed -i '/pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1/d' "$HOME/.sound" 2>/dev/null
        sed -i '/pacmd load-module module-aaudio-sink/d' "$HOME/.sound" 2>/dev/null
    fi
    log_message "INFO" "Audio configuration cleaned"
    
    echo -e "\n"
}

# Success message with enhanced styling
show_success() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                       ${BOLD}✅ SUCCESS! ✅${RESET}                       ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${WHITE}Debian environment has been completely removed!${RESET}          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${YELLOW}📋 What was removed:${RESET}                                   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Debian root filesystem${RESET}                             ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• All installed packages${RESET}                             ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Audio configuration${RESET}                                ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Command shortcuts${RESET}                                  ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Distribution cache${RESET}                                 ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}  ${CYAN}💡 Tip: Run setup.sh to reinstall Debian${RESET}               ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "SUCCESS" "Debian removal completed successfully"
}

# Error handling function
handle_error() {
    local error_msg="$1"
    echo -e "\n${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║${RESET}                        ${BOLD}❌ ERROR ❌${RESET}                        ${RED}║${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${WHITE}An error occurred during removal:${RESET}                       ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${YELLOW}$error_msg${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}║${RESET}  ${CYAN}Check log file: $LOG_FILE${RESET}"
    echo -e "${RED}║${RESET}                                                              ${RED}║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "ERROR" "$error_msg"
    exit 1
}

# Main execution
main() {
    # Initialize log
    log_message "INFO" "Starting Debian removal process"
    
    show_banner
    confirm_removal
    
    echo
    perform_removal
    
    show_success
    
    # Cleanup log if successful
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
}

# Error trap
trap 'handle_error "Unexpected error occurred"' ERR

# Execute main function
main "$@"
