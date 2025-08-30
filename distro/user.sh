#!/bin/bash

# Enhanced Debian User Setup with Professional UI/UX
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
SCRIPT_NAME="Debian User Setup"
SCRIPT_VERSION="3.0"
LOG_FILE="/tmp/debian-user-setup.log"
REPO_BASE="https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master"

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
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}U S E R   S E T U P   T O O L   v${SCRIPT_VERSION}${RESET}          ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Professional Debian User Management System${RESET}          ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${WHITE}By: Sandeep Gaddam | Enhanced Experience${RESET}            ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    log_message "INFO" "User setup tool started v$SCRIPT_VERSION"
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

# Enhanced sudo installation with progress
install_sudo() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}                 ${BOLD}SYSTEM DEPENDENCIES SETUP${RESET}                ${BLUE}║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    local steps=4
    local current=0

    # Step 1: Update package lists
    ((current++))
    show_progress $current $steps "Updating package repositories..."
    sleep 1
    
    echo -e "\n${CYAN}🔄 Updating package repositories...${RESET}"
    apt update -y >/dev/null 2>&1 &
    show_spinner "Updating package lists" $!

    # Step 2: Install sudo
    ((current++))
    show_progress $current $steps "Installing sudo package..."
    sleep 1
    
    echo -e "\n${CYAN}🔐 Installing sudo package...${RESET}"
    apt install sudo -y >/dev/null 2>&1 &
    show_spinner "Installing sudo" $!

    # Step 3: Install essential packages
    ((current++))
    show_progress $current $steps "Installing essential packages..."
    sleep 1
    
    echo -e "\n${CYAN}📦 Installing essential packages...${RESET}"
    local essential_packages=(wget apt-utils locales-all dialog tzdata curl)
    for package in "${essential_packages[@]}"; do
        echo -e "${WHITE}Installing: $package${RESET}"
        apt install "$package" -y >/dev/null 2>&1
    done

    # Step 4: Verification
    ((current++))
    show_progress $current $steps "Verifying installation..."
    sleep 1

    if command -v sudo >/dev/null 2>&1; then
        echo -e "\n${GREEN}✅ Sudo and essential packages installed successfully!${RESET}"
        log_message "SUCCESS" "Sudo and essential packages installed"
    else
        echo -e "\n${RED}❌ Failed to install sudo package${RESET}"
        log_message "ERROR" "Failed to install sudo"
        exit 1
    fi
    
    echo
}

# Enhanced file download with retry logic and progress
download_file() {
    local file="$1"
    local url="$2"
    local dest="$3"
    local max_retries=3
    local retry=0
    local success=false
    
    echo -e "${CYAN}📥 Downloading $file...${RESET}"
    
    while [ $retry -lt $max_retries ] && [ "$success" = false ]; do
        if curl -s --fail --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 120 -L -o "$dest" "$url" 2>/dev/null; then
            success=true
            echo -e "${GREEN}✅ Successfully downloaded $file!${RESET}"
            log_message "SUCCESS" "Downloaded: $file"
        else
            retry=$((retry + 1))
            if [ $retry -lt $max_retries ]; then
                echo -e "${YELLOW}⚠️  Download failed. Retrying... (Attempt $retry of $max_retries)${RESET}"
                log_message "WARNING" "Download retry $retry for $file"
                sleep 2
            else
                echo -e "${RED}❌ Failed to download $file after $max_retries attempts${RESET}"
                log_message "ERROR" "Failed to download $file after $max_retries attempts"
                return 1
            fi
        fi
    done
    
    # Verify file exists and is not empty
    if [ -s "$dest" ]; then
        chmod +x "$dest"
        local file_size=$(du -h "$dest" | cut -f1)
        echo -e "${WHITE}   File size: $file_size${RESET}"
        return 0
    else
        echo -e "${RED}❌ Downloaded file is empty or corrupted${RESET}"
        log_message "ERROR" "Downloaded file is empty: $file"
        return 1
    fi
}

# Enhanced GUI files setup
setup_gui_files() {
    local user="$1"
    local gui_path="/home/$user/gui.sh"
    
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║${RESET}                  ${BOLD}GUI FILES SETUP${RESET}                         ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    
    echo -e "${CYAN}🔧 Setting up GUI files for user: ${YELLOW}$user${RESET}"
    
    # Method 1: Check local repository first
    local local_gui_path='/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh'
    if [ -e "$local_gui_path" ]; then
        echo -e "${CYAN}📁 Found gui.sh in local repository${RESET}"
        
        if cp "$local_gui_path" "$gui_path" 2>/dev/null && [ -s "$gui_path" ]; then
            # Only replace Ubuntu/ubuntu references since it's already our repo
            sed -i 's/Ubuntu/Debian/g' "$gui_path"
            sed -i 's/ubuntu/debian/g' "$gui_path"
            
            chmod +x "$gui_path"
            chown "$user:$user" "$gui_path"
            
            echo -e "${GREEN}✅ Successfully copied and configured gui.sh from local repository!${RESET}"
            log_message "SUCCESS" "GUI file copied from local repository for user: $user"
            return 0
        else
            echo -e "${YELLOW}⚠️  Error copying from local repository. Trying download...${RESET}"
        fi
    fi
    
    # Method 2: Download from GitHub repository
    local download_url="$REPO_BASE/distro/gui.sh"
    echo -e "${CYAN}🌐 Downloading from repository: Sandeepgaddam5432/modded-ubuntu${RESET}"
    
    if download_file "gui.sh" "$download_url" "$gui_path.tmp"; then
        # Only replace Ubuntu/ubuntu references since it's already our repo
        sed -i 's/Ubuntu/Debian/g' "$gui_path.tmp"
        sed -i 's/ubuntu/debian/g' "$gui_path.tmp"
        
        mv "$gui_path.tmp" "$gui_path"
        chmod +x "$gui_path"
        chown "$user:$user" "$gui_path"
        
        echo -e "${GREEN}✅ GUI file downloaded and configured successfully!${RESET}"
        log_message "SUCCESS" "GUI file downloaded for user: $user"
        return 0
    else
        # Method 3: Try alternative download with wget
        echo -e "${YELLOW}🔄 Trying alternative download method...${RESET}"
        
        if command -v wget >/dev/null 2>&1; then
            if wget -q --show-progress --timeout=30 --tries=3 -O "$gui_path.tmp" "$download_url" 2>/dev/null; then
                if [ -s "$gui_path.tmp" ]; then
                    # Only replace Ubuntu/ubuntu references since it's already our repo
                    sed -i 's/Ubuntu/Debian/g' "$gui_path.tmp"
                    sed -i 's/ubuntu/debian/g' "$gui_path.tmp"
                    
                    mv "$gui_path.tmp" "$gui_path"
                    chmod +x "$gui_path"
                    chown "$user:$user" "$gui_path"
                    
                    echo -e "${GREEN}✅ Successfully downloaded using wget!${RESET}"
                    log_message "SUCCESS" "GUI file downloaded via wget for user: $user"
                    return 0
                else
                    echo -e "${RED}❌ Downloaded file is empty${RESET}"
                    rm -f "$gui_path.tmp"
                fi
            fi
        fi
        
        echo -e "${RED}❌ Failed to setup GUI files${RESET}"
        log_message "ERROR" "Failed to setup GUI files for user: $user"
        return 1
    fi
}

# Enhanced recovery script creation
create_recovery_script() {
    local user="$1"
    local fix_script="/home/$user/fix-gui.sh"
    
    echo -e "${CYAN}🛠️  Creating recovery script...${RESET}"
    
    cat > "$fix_script" << EOF
#!/bin/bash

# GUI Recovery Script for Debian Setup
# Author: Sandeep Gaddam
# This script helps recover missing GUI files

echo -e "\033[1;36m🔧 Debian GUI Recovery Tool\033[0m"
echo -e "\033[1;32m================================\033[0m"
echo

# Try downloading with curl first
if command -v curl &> /dev/null; then
    echo -e "\033[1;33m📥 Downloading gui.sh using curl...\033[0m"
    if curl -L --retry 3 --retry-delay 2 --connect-timeout 15 --max-time 120 -o ~/gui.sh.tmp "$REPO_BASE/distro/gui.sh" 2>/dev/null; then
        if [ -s ~/gui.sh.tmp ]; then
            # Only replace Ubuntu/ubuntu references since it's already our repo
            sed -i 's/Ubuntu/Debian/g' ~/gui.sh.tmp
            sed -i 's/ubuntu/debian/g' ~/gui.sh.tmp
            
            mv ~/gui.sh.tmp ~/gui.sh
            chmod +x ~/gui.sh
            echo -e "\033[1;32m✅ gui.sh has been successfully downloaded and configured!\033[0m"
            echo -e "\033[1;36m🚀 Now run: sudo bash gui.sh\033[0m"
            exit 0
        else
            echo -e "\033[1;31m❌ Downloaded file is empty\033[0m"
            rm -f ~/gui.sh.tmp
        fi
    fi
fi

# Try downloading with wget as fallback
if command -v wget &> /dev/null; then
    echo -e "\033[1;33m📥 Downloading gui.sh using wget...\033[0m"
    if wget -q --show-progress --timeout=30 --tries=3 -O ~/gui.sh.tmp "$REPO_BASE/distro/gui.sh" 2>/dev/null; then
        if [ -s ~/gui.sh.tmp ]; then
            # Only replace Ubuntu/ubuntu references since it's already our repo
            sed -i 's/Ubuntu/Debian/g' ~/gui.sh.tmp
            sed -i 's/ubuntu/debian/g' ~/gui.sh.tmp
            
            mv ~/gui.sh.tmp ~/gui.sh
            chmod +x ~/gui.sh
            echo -e "\033[1;32m✅ gui.sh has been successfully downloaded and configured!\033[0m"
            echo -e "\033[1;36m🚀 Now run: sudo bash gui.sh\033[0m"
            exit 0
        else
            echo -e "\033[1;31m❌ Downloaded file is empty\033[0m"
            rm -f ~/gui.sh.tmp
        fi
    fi
fi

echo -e "\033[1;31m❌ Error: Neither curl nor wget worked properly\033[0m"
echo -e "\033[1;33m💡 Please check your internet connection and try again\033[0m"
echo
echo -e "\033[1;36m🌐 Manual download URL: $REPO_BASE/distro/gui.sh\033[0m"
exit 1
EOF

    chmod +x "$fix_script"
    chown "$user:$user" "$fix_script"
    
    echo -e "${GREEN}✅ Recovery script created: ${CYAN}fix-gui.sh${RESET}"
    log_message "SUCCESS" "Recovery script created for user: $user"
}

# Enhanced user input with validation
get_user_input() {
    local username=""
    local password=""
    local confirm_password=""
    
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}                    ${BOLD}USER ACCOUNT SETUP${RESET}                      ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    # Username input with validation
    while true; do
        echo -ne "${CYAN}👤 Enter username ${WHITE}[${GREEN}lowercase, no spaces${WHITE}]${CYAN}: ${RESET}"
        read -r username
        
        if [[ -z "$username" ]]; then
            echo -e "${RED}❌ Username cannot be empty${RESET}"
            continue
        elif [[ "$username" =~ [A-Z] ]]; then
            echo -e "${RED}❌ Username must be lowercase${RESET}"
            continue
        elif [[ "$username" =~ [[:space:]] ]]; then
            echo -e "${RED}❌ Username cannot contain spaces${RESET}"
            continue
        elif [[ ${#username} -lt 3 ]]; then
            echo -e "${RED}❌ Username must be at least 3 characters${RESET}"
            continue
        elif id "$username" &>/dev/null; then
            echo -e "${RED}❌ Username already exists${RESET}"
            continue
        else
            echo -e "${GREEN}✅ Username validated: ${CYAN}$username${RESET}"
            break
        fi
    done

    # Password input with confirmation
    while true; do
        echo -ne "${CYAN}🔐 Enter password: ${RESET}"
        read -rs password
        echo
        
        if [[ -z "$password" ]]; then
            echo -e "${RED}❌ Password cannot be empty${RESET}"
            continue
        elif [[ ${#password} -lt 4 ]]; then
            echo -e "${RED}❌ Password must be at least 4 characters${RESET}"
            continue
        fi
        
        echo -ne "${CYAN}🔐 Confirm password: ${RESET}"
        read -rs confirm_password
        echo
        
        if [[ "$password" != "$confirm_password" ]]; then
            echo -e "${RED}❌ Passwords do not match${RESET}"
            continue
        else
            echo -e "${GREEN}✅ Password confirmed${RESET}"
            break
        fi
    done
    
    echo
    echo -e "${WHITE}📋 Account Summary:${RESET}"
    echo -e "${WHITE}   Username: ${CYAN}$username${RESET}"
    echo -e "${WHITE}   Password: ${GREEN}[Hidden for security]${RESET}"
    echo

    # Store in global variables
    USER_NAME="$username"
    USER_PASS="$password"
}

# Enhanced user account creation
create_user_account() {
    local user="$1"
    local pass="$2"
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                 ${BOLD}USER ACCOUNT CREATION${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo

    local steps=5
    local current=0

    # Step 1: Create user
    ((current++))
    show_progress $current $steps "Creating user account..."
    sleep 1
    
    echo -e "\n${CYAN}👤 Creating user: ${YELLOW}$user${RESET}"
    useradd -m -s $(which bash) "$user" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ User account created${RESET}"
    else
        echo -e "${RED}❌ Failed to create user account${RESET}"
        log_message "ERROR" "Failed to create user: $user"
        exit 1
    fi

    # Step 2: Add to sudo group
    ((current++))
    show_progress $current $steps "Configuring sudo permissions..."
    sleep 1
    
    echo -e "\n${CYAN}🔐 Adding user to sudo group...${RESET}"
    usermod -aG sudo "$user" 2>/dev/null
    echo -e "${GREEN}✅ Sudo permissions granted${RESET}"

    # Step 3: Set password
    ((current++))
    show_progress $current $steps "Setting user password..."
    sleep 1
    
    echo -e "\n${CYAN}🔑 Setting password...${RESET}"
    echo "$user:$pass" | chpasswd 2>/dev/null
    echo -e "${GREEN}✅ Password configured${RESET}"

    # Step 4: Configure passwordless sudo
    ((current++))
    show_progress $current $steps "Configuring passwordless sudo..."
    sleep 1
    
    echo -e "\n${CYAN}⚙️  Configuring passwordless sudo...${RESET}"
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo -e "${GREEN}✅ Passwordless sudo configured${RESET}"

    # Step 5: Create login script
    ((current++))
    show_progress $current $steps "Creating login script..."
    sleep 1
    
    echo -e "\n${CYAN}📜 Creating optimized login script...${RESET}"
    cat > /data/data/com.termux/files/usr/bin/debian << EOF
#!/bin/bash
# Enhanced Debian Login Script
# Author: Sandeep Gaddam
proot-distro login --user $user debian --bind /dev/null:/proc/sys/kernel/cap_last_cap --shared-tmp --fix-low-ports
EOF
    chmod +x /data/data/com.termux/files/usr/bin/debian
    echo -e "${GREEN}✅ Login script configured${RESET}"

    log_message "SUCCESS" "User account created successfully: $user"
    echo
}

# Enhanced completion message
show_completion_message() {
    local user="$1"
    local gui_setup_status="$2"
    
    banner
    
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}                 ${BOLD}🎉 SETUP COMPLETED! 🎉${RESET}                   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}Debian user account has been created successfully!${RESET}   ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}📋 ACCOUNT DETAILS:${RESET}                                 ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Username: ${CYAN}$user${RESET}                                    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Home Directory: ${CYAN}/home/$user${RESET}                       ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Sudo Access: ${CYAN}Enabled (passwordless)${RESET}              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${YELLOW}🚀 NEXT STEPS:${RESET}                                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}1.${WHITE} Restart Termux completely${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}2.${WHITE} Type: ${YELLOW}debian${WHITE} to login${RESET}                            ${GREEN}║${RESET}"
    
    if [ "$gui_setup_status" -eq 0 ]; then
        echo -e "${GREEN}║${RESET}    ${CYAN}3.${WHITE} Type: ${YELLOW}sudo bash gui.sh${WHITE} for GUI setup${RESET}              ${GREEN}║${RESET}"
        echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
        echo -e "${GREEN}║${RESET}    ${MAGENTA}✅ GUI files are ready to use!${RESET}                        ${GREEN}║${RESET}"
    else
        echo -e "${GREEN}║${RESET}    ${CYAN}3.${WHITE} Type: ${YELLOW}bash fix-gui.sh${WHITE} to recover GUI files${RESET}       ${GREEN}║${RESET}"
        echo -e "${GREEN}║${RESET}    ${CYAN}4.${WHITE} Then: ${YELLOW}sudo bash gui.sh${WHITE} for GUI setup${RESET}             ${GREEN}║${RESET}"
        echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
        echo -e "${GREEN}║${RESET}    ${YELLOW}⚠️  GUI files need recovery (fix-gui.sh available)${RESET}    ${GREEN}║${RESET}"
    fi
    
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${MAGENTA}💡 Pro Tip: After GUI setup, you'll have access to:${RESET}     ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• AI-powered development tools${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• Professional desktop environment${RESET}                      ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${WHITE}• VNC server for remote access${RESET}                          ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}    ${CYAN}Created by: Sandeep Gaddam | Enhanced Experience${RESET}        ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}                                                              ${GREEN}║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    
    log_message "SUCCESS" "User setup completed successfully for: $user"
}

# Enhanced main execution
main() {
    # Initialize logging
    log_message "INFO" "Starting Debian User Setup v$SCRIPT_VERSION"
    
    # Display banner
    banner
    
    # Install sudo and dependencies
    install_sudo
    
    # Get user input
    get_user_input
    
    # Create user account
    create_user_account "$USER_NAME" "$USER_PASS"
    
    # Setup GUI files
    setup_gui_files "$USER_NAME"
    gui_setup_status=$?
    
    # Create recovery script
    create_recovery_script "$USER_NAME"
    
    # Show completion message
    show_completion_message "$USER_NAME" "$gui_setup_status"
    
    # Clean up
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
}

# Execute main function
main "$@"
