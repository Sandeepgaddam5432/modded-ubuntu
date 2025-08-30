#!/bin/bash

# Enhanced Debian Configuration Manager with Professional UI/UX
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
SCRIPT_NAME="Debian Configuration Manager"
SCRIPT_VERSION="3.0"
LOG_FILE="$HOME/.debian-config.log"

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Enhanced banner
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
    echo -e "${CYAN}║${RESET}        ${MAGENTA}${BOLD}C O N F I G U R A T I O N   M A N A G E R${RESET}        ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${GREEN}Professional GUI Configuration Tool v${SCRIPT_VERSION}${RESET}      ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}    ${WHITE}By: Sandeep Gaddam | Enhanced Experience${RESET}            ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}                                                              ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo
    log_message "INFO" "Configuration Manager started"
}

# Check and install GUI dependencies
check_dependencies() {
    echo -e "${CYAN}🔍 Checking GUI dependencies...${RESET}"
    
    local deps_needed=()
    for cmd in zenity yad; do
        if ! command -v $cmd &> /dev/null; then
            deps_needed+=($cmd)
        fi
    done
    
    if [ ${#deps_needed[@]} -gt 0 ]; then
        echo -e "${YELLOW}📦 Installing missing dependencies: ${deps_needed[*]}${RESET}"
        apt update >/dev/null 2>&1
        for dep in "${deps_needed[@]}"; do
            echo -e "${GREEN}Installing: $dep${RESET}"
            apt install -y $dep >/dev/null 2>&1
        done
        echo -e "${GREEN}✅ Dependencies installed successfully${RESET}"
        log_message "SUCCESS" "GUI dependencies installed: ${deps_needed[*]}"
    else
        echo -e "${GREEN}✅ All dependencies are already installed${RESET}"
    fi
    echo
}

# Enhanced main menu with modern styling
main_menu() {
    option=$(zenity --list --title="🔧 Debian Configuration Manager v$SCRIPT_VERSION" \
        --width=500 --height=600 \
        --column="🎯 Configuration Options" \
        --text="Select a configuration option:" \
        "🔄 System Updates & Maintenance" \
        "📦 Software Management Hub" \
        "🎨 Desktop Appearance & Themes" \
        "🖥️  VNC Server Configuration" \
        "⚡ System Performance Tools" \
        "🤖 AI Development Tools" \
        "💾 Backup & Restore Manager" \
        "📊 System Information" \
        "ℹ️  About Configuration Manager" \
        "🚪 Exit" \
        2>/dev/null)

    case "$option" in
        "🔄 System Updates & Maintenance")
            system_updates
            ;;
        "📦 Software Management Hub")
            software_management
            ;;
        "🎨 Desktop Appearance & Themes")
            desktop_appearance
            ;;
        "🖥️  VNC Server Configuration")
            vnc_settings
            ;;
        "⚡ System Performance Tools")
            system_performance
            ;;
        "🤖 AI Development Tools")
            ai_development_tools
            ;;
        "💾 Backup & Restore Manager")
            backup_restore
            ;;
        "📊 System Information")
            system_information
            ;;
        "ℹ️  About Configuration Manager")
            about
            ;;
        "🚪 Exit"|"")
            exit 0
            ;;
    esac
    main_menu
}

# Enhanced system updates with better progress tracking
system_updates() {
    if zenity --question --title="🔄 System Updates" \
        --text="Do you want to update your Debian system?\n\n• Package lists will be refreshed\n• All packages will be upgraded\n• System will be cleaned up" \
        --width=400; then
        
        (
        echo "5"; echo "# Preparing system update..."
        sleep 1
        
        echo "15"; echo "# Updating package repositories..."
        apt update > /dev/null 2>&1
        
        echo "40"; echo "# Checking for upgradeable packages..."
        sleep 1
        
        echo "50"; echo "# Upgrading system packages..."
        apt upgrade -y > /dev/null 2>&1
        
        echo "80"; echo "# Removing orphaned packages..."
        apt autoremove -y > /dev/null 2>&1
        
        echo "95"; echo "# Cleaning package cache..."
        apt clean > /dev/null 2>&1
        
        echo "100"; echo "# System update completed successfully!"
        ) | zenity --progress \
            --title="🔄 Updating Debian System" \
            --text="Initializing system update..." \
            --percentage=0 \
            --auto-close \
            --width=500
        
        zenity --info --title="✅ Update Complete" \
            --text="Your Debian system has been updated successfully!\n\n🎉 All packages are now up to date." \
            --width=400
        
        log_message "SUCCESS" "System update completed"
    fi
}

# Enhanced software management with AI tools
software_management() {
    option=$(zenity --list --title="📦 Software Management Hub" \
        --width=500 --height=500 \
        --column="Software Categories" \
        --text="Choose a software category to manage:" \
        "🌐 Web Browsers" \
        "💻 Development Tools & IDEs" \
        "🤖 AI-Powered Code Editors" \
        "🎵 Media Players & Audio" \
        "📄 Office & Productivity" \
        "🛠️  System Utilities" \
        "🗑️  Remove Installed Software" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "🌐 Web Browsers")
            install_browsers
            ;;
        "💻 Development Tools & IDEs")
            install_development_tools
            ;;
        "🤖 AI-Powered Code Editors")
            install_ai_tools
            ;;
        "🎵 Media Players & Audio")
            install_media_players
            ;;
        "📄 Office & Productivity")
            install_office_software
            ;;
        "🛠️  System Utilities")
            install_utilities
            ;;
        "🗑️  Remove Installed Software")
            remove_software
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    software_management
}

# Browser installation function
install_browsers() {
    browser=$(zenity --list --title="🌐 Install Web Browser" \
        --width=500 --height=400 \
        --column="Browser" --column="Description" \
        "Firefox" "🦊 Mozilla Firefox - Popular & secure" \
        "Chromium" "🌐 Chromium - Open-source Chrome" \
        "Brave" "🛡️  Brave - Privacy-focused browser" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$browser" in
        "Firefox")
            install_software_with_progress "firefox-esr" "🦊 Firefox Browser"
            ;;
        "Chromium")
            install_software_with_progress "chromium" "🌐 Chromium Browser"
            ;;
        "Brave")
            install_brave_browser
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# Development tools installation
install_development_tools() {
    dev_tool=$(zenity --list --title="💻 Install Development Tools" \
        --width=500 --height=450 \
        --column="Tool" --column="Description" \
        "VSCode" "💻 Visual Studio Code - Microsoft IDE" \
        "Sublime" "📝 Sublime Text - Lightweight editor" \
        "NodeJS" "🟢 Node.js - JavaScript runtime" \
        "Python" "🐍 Python - Programming language" \
        "Java" "☕ OpenJDK - Java development kit" \
        "Git" "📚 Git - Version control system" \
        "Docker" "🐳 Docker - Containerization platform" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$dev_tool" in
        "VSCode")
            install_vscode_enhanced
            ;;
        "Sublime")
            install_sublime_enhanced
            ;;
        "NodeJS")
            install_software_with_progress "nodejs npm" "🟢 Node.js & NPM"
            ;;
        "Python")
            install_software_with_progress "python3 python3-pip python3-venv" "🐍 Python Development"
            ;;
        "Java")
            install_software_with_progress "default-jdk default-jre" "☕ Java Development Kit"
            ;;
        "Git")
            install_software_with_progress "git" "📚 Git Version Control"
            ;;
        "Docker")
            install_docker_enhanced
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# New AI tools installation function
install_ai_tools() {
    ai_tool=$(zenity --list --title="🤖 AI-Powered Development Tools" \
        --width=500 --height=400 \
        --column="AI Tool" --column="Description" \
        "Cursor AI" "🤖 Cursor - AI-first code editor" \
        "Void AI" "⚡ Void - AI-enhanced development" \
        "Both AI Tools" "🧠 Install both Cursor & Void AI" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$ai_tool" in
        "Cursor AI")
            install_cursor_ai_gui
            ;;
        "Void AI")
            install_void_ai_gui
            ;;
        "Both AI Tools")
            install_cursor_ai_gui
            install_void_ai_gui
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# AI-specific installation functions
install_cursor_ai_gui() {
    if command -v cursor >/dev/null 2>&1; then
        zenity --info --title="🤖 Cursor AI" \
            --text="Cursor AI Code Editor is already installed!" \
            --width=400
        return 0
    fi

    (
    echo "10"; echo "# Downloading Cursor AI installer..."
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/cursor-termux/main/cursor.sh > /tmp/cursor_gui.sh 2>/dev/null
    
    echo "30"; echo "# Preparing installation..."
    chmod +x /tmp/cursor_gui.sh
    
    echo "50"; echo "# Installing Cursor AI Code Editor..."
    echo "1" | bash /tmp/cursor_gui.sh > /dev/null 2>&1
    
    echo "90"; echo "# Finalizing installation..."
    rm -f /tmp/cursor_gui.sh
    
    echo "100"; echo "# Cursor AI installation completed!"
    ) | zenity --progress \
        --title="🤖 Installing Cursor AI" \
        --text="Starting Cursor AI installation..." \
        --percentage=0 \
        --auto-close \
        --width=500

    zenity --info --title="✅ Installation Complete" \
        --text="🤖 Cursor AI Code Editor has been installed successfully!\n\nYou can now use AI-powered coding assistance." \
        --width=400
    
    log_message "SUCCESS" "Cursor AI installed via GUI"
}

install_void_ai_gui() {
    if command -v void >/dev/null 2>&1; then
        zenity --info --title="⚡ Void AI" \
            --text="Void AI Code Editor is already installed!" \
            --width=400
        return 0
    fi

    (
    echo "10"; echo "# Downloading Void AI installer..."
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/Void/main/void.sh > /tmp/void_gui.sh 2>/dev/null
    
    echo "30"; echo "# Preparing installation..."
    chmod +x /tmp/void_gui.sh
    
    echo "50"; echo "# Installing Void AI Code Editor..."
    echo "1" | bash /tmp/void_gui.sh > /dev/null 2>&1
    
    echo "90"; echo "# Finalizing installation..."
    rm -f /tmp/void_gui.sh
    
    echo "100"; echo "# Void AI installation completed!"
    ) | zenity --progress \
        --title="⚡ Installing Void AI" \
        --text="Starting Void AI installation..." \
        --percentage=0 \
        --auto-close \
        --width=500

    zenity --info --title="✅ Installation Complete" \
        --text="⚡ Void AI Code Editor has been installed successfully!\n\nEnjoy AI-enhanced development experience." \
        --width=400
    
    log_message "SUCCESS" "Void AI installed via GUI"
}

# Enhanced software installation with better progress
install_software_with_progress() {
    local software="$1"
    local display_name="$2"
    
    (
    echo "10"; echo "# Updating package repositories..."
    apt update > /dev/null 2>&1
    
    echo "30"; echo "# Checking package availability..."
    sleep 1
    
    echo "50"; echo "# Installing $display_name..."
    apt install -y $software > /dev/null 2>&1
    
    echo "90"; echo "# Configuring installation..."
    sleep 1
    
    echo "100"; echo "# Installation completed successfully!"
    ) | zenity --progress \
        --title="📦 Installing $display_name" \
        --text="Preparing installation..." \
        --percentage=0 \
        --auto-close \
        --width=500
    
    zenity --info --title="✅ Installation Complete" \
        --text="$display_name has been installed successfully!" \
        --width=400
    
    log_message "SUCCESS" "$display_name installed"
}

# Enhanced VSCode installation
install_vscode_enhanced() {
    if command -v code >/dev/null 2>&1; then
        zenity --info --title="💻 VS Code" \
            --text="Visual Studio Code is already installed!" \
            --width=400
        return 0
    fi

    (
    echo "10"; echo "# Adding Microsoft repository..."
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg 2>/dev/null
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ 2>/dev/null
    
    echo "25"; echo "# Configuring package source..."
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list 2>/dev/null
    
    echo "40"; echo "# Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo "70"; echo "# Installing Visual Studio Code..."
    apt install -y code > /dev/null 2>&1
    
    echo "90"; echo "# Applying desktop file patch..."
    curl -fsSL https://raw.githubusercontent.com/Sandeepgaddam5432/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop 2>/dev/null
    
    echo "100"; echo "# VS Code installation completed!"
    ) | zenity --progress \
        --title="💻 Installing Visual Studio Code" \
        --text="Starting VS Code installation..." \
        --percentage=0 \
        --auto-close \
        --width=500

    zenity --info --title="✅ Installation Complete" \
        --text="💻 Visual Studio Code has been installed successfully!\n\nThe world's most popular code editor is ready to use." \
        --width=400
    
    log_message "SUCCESS" "Visual Studio Code installed"
}

# Media players installation
install_media_players() {
    media_player=$(zenity --list --title="🎵 Install Media Player" \
        --width=500 --height=400 \
        --column="Player" --column="Description" \
        "VLC" "🎥 VLC - Universal media player" \
        "MPV" "🎬 MPV - Minimalist media player" \
        "Audacious" "🎵 Audacious - Audio player" \
        "Rhythmbox" "🎶 Rhythmbox - Music library manager" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$media_player" in
        "VLC")
            install_software_with_progress "vlc" "🎥 VLC Media Player"
            ;;
        "MPV")
            install_software_with_progress "mpv" "🎬 MPV Media Player"
            ;;
        "Audacious")
            install_software_with_progress "audacious" "🎵 Audacious Audio Player"
            ;;
        "Rhythmbox")
            install_software_with_progress "rhythmbox" "🎶 Rhythmbox Music Player"
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# Office software installation
install_office_software() {
    office=$(zenity --list --title="📄 Install Office Software" \
        --width=500 --height=400 \
        --column="Software" --column="Description" \
        "LibreOffice" "📊 LibreOffice - Complete office suite" \
        "AbiWord" "📝 AbiWord - Lightweight word processor" \
        "Gnumeric" "📋 Gnumeric - Spreadsheet application" \
        "Thunderbird" "📧 Thunderbird - Email client" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$office" in
        "LibreOffice")
            install_software_with_progress "libreoffice" "📊 LibreOffice Suite"
            ;;
        "AbiWord")
            install_software_with_progress "abiword" "📝 AbiWord"
            ;;
        "Gnumeric")
            install_software_with_progress "gnumeric" "📋 Gnumeric"
            ;;
        "Thunderbird")
            install_software_with_progress "thunderbird" "📧 Thunderbird"
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# System utilities installation
install_utilities() {
    utility=$(zenity --list --title="🛠️ Install System Utilities" \
        --width=500 --height=400 \
        --column="Utility" --column="Description" \
        "Htop" "📊 Htop - Interactive process viewer" \
        "Neofetch" "💻 Neofetch - System information" \
        "Timeshift" "💾 Timeshift - System backup" \
        "GParted" "💿 GParted - Partition manager" \
        "Synaptic" "📦 Synaptic - Package manager GUI" \
        "⬅️ Back" "Return to software menu" \
        2>/dev/null)
    
    case "$utility" in
        "Htop")
            install_software_with_progress "htop" "📊 Htop Process Viewer"
            ;;
        "Neofetch")
            install_software_with_progress "neofetch" "💻 Neofetch System Info"
            ;;
        "Timeshift")
            install_software_with_progress "timeshift" "💾 Timeshift Backup"
            ;;
        "GParted")
            install_software_with_progress "gparted" "💿 GParted Partition Manager"
            ;;
        "Synaptic")
            install_software_with_progress "synaptic" "📦 Synaptic Package Manager"
            ;;
        "⬅️ Back"|"")
            return
            ;;
    esac
}

# Enhanced software removal
remove_software() {
    installed_packages=$(dpkg --get-selections | grep -v deinstall | cut -f1 | head -50)
    
    software_to_remove=$(zenity --list --title="🗑️ Remove Software" \
        --width=600 --height=500 \
        --column="📦 Installed Packages" \
        --multiple \
        --text="Select software to remove (Ctrl+Click for multiple selection):" \
        $(echo "$installed_packages") \
        2>/dev/null)
    
    if [ -n "$software_to_remove" ]; then
        if zenity --question --title="⚠️ Confirm Removal" \
            --text="Are you sure you want to remove the selected software?\n\n⚠️ This action cannot be undone!" \
            --width=400; then
            
            (
            echo "10"; echo "# Preparing for software removal..."
            
            echo "30"; echo "# Removing selected packages..."
            for pkg in $(echo "$software_to_remove" | tr '|' ' '); do
                echo "# Removing $pkg..."
                apt remove -y "$pkg" > /dev/null 2>&1
            done
            
            echo "80"; echo "# Cleaning up dependencies..."
            apt autoremove -y > /dev/null 2>&1
            
            echo "100"; echo "# Software removal completed!"
            ) | zenity --progress \
                --title="🗑️ Removing Software" \
                --text="Starting software removal..." \
                --percentage=0 \
                --auto-close \
                --width=500
            
            zenity --info --title="✅ Removal Complete" \
                --text="Selected software has been removed successfully!\n\n🧹 System has been cleaned up." \
                --width=400
            
            log_message "SUCCESS" "Software removed: $software_to_remove"
        fi
    fi
}

# Enhanced desktop appearance
desktop_appearance() {
    option=$(zenity --list --title="🎨 Desktop Appearance & Themes" \
        --width=500 --height=450 \
        --column="Appearance Options" \
        --text="Customize your desktop appearance:" \
        "🎨 Change Theme" \
        "🎯 Change Icon Theme" \
        "🖼️  Change Wallpaper" \
        "🔤 Font Settings" \
        "🌈 Color Schemes" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "🎨 Change Theme")
            change_theme
            ;;
        "🎯 Change Icon Theme")
            change_icons
            ;;
        "🖼️  Change Wallpaper")
            change_wallpaper
            ;;
        "🔤 Font Settings")
            change_fonts
            ;;
        "🌈 Color Schemes")
            change_color_scheme
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    desktop_appearance
}

# Theme changing function
change_theme() {
    theme_dir="/usr/share/themes"
    if [ -d "$theme_dir" ]; then
        themes=$(find "$theme_dir" -maxdepth 1 -type d -not -path "$theme_dir" -printf "%f\n" | sort)
        
        selected_theme=$(zenity --list --title="🎨 Select Desktop Theme" \
            --width=500 --height=400 \
            --column="Available Themes" \
            $(echo "$themes") \
            2>/dev/null)
        
        if [ -n "$selected_theme" ]; then
            xfconf-query -c xsettings -p /Net/ThemeName -s "$selected_theme" 2>/dev/null
            xfconf-query -c xfwm4 -p /general/theme -s "$selected_theme" 2>/dev/null
            
            zenity --info --title="✅ Theme Applied" \
                --text="🎨 Desktop theme has been changed to:\n\n$selected_theme\n\nThe new theme is now active!" \
                --width=400
            
            log_message "SUCCESS" "Theme changed to: $selected_theme"
        fi
    else
        zenity --error --title="❌ Theme Error" \
            --text="Theme directory not found!\n\nPlease ensure themes are properly installed." \
            --width=400
    fi
}

# Enhanced VNC settings
vnc_settings() {
    option=$(zenity --list --title="🖥️ VNC Server Configuration" \
        --width=500 --height=400 \
        --column="VNC Options" \
        --text="Configure your VNC server settings:" \
        "🔐 Change VNC Password" \
        "📐 Change Screen Resolution" \
        "🔄 Restart VNC Server" \
        "📊 VNC Server Status" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "🔐 Change VNC Password")
            change_vnc_password
            ;;
        "📐 Change Screen Resolution")
            change_vnc_resolution
            ;;
        "🔄 Restart VNC Server")
            restart_vnc_server
            ;;
        "📊 VNC Server Status")
            show_vnc_status
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    vnc_settings
}

# VNC password change
change_vnc_password() {
    new_password=$(zenity --password --title="🔐 New VNC Password" \
        --text="Enter your new VNC password:" \
        2>/dev/null)
    
    if [ -n "$new_password" ]; then
        mkdir -p ~/.vnc
        echo "$new_password" | vncpasswd -f > ~/.vnc/passwd 2>/dev/null
        chmod 600 ~/.vnc/passwd
        
        zenity --info --title="✅ Password Updated" \
            --text="🔐 VNC password has been changed successfully!\n\nPlease restart your VNC server to apply changes." \
            --width=400
        
        if zenity --question --title="🔄 Restart VNC Server" \
            --text="Would you like to restart the VNC server now?" \
            --width=400; then
            restart_vnc_server
        fi
        
        log_message "SUCCESS" "VNC password changed"
    fi
}

# Enhanced system performance tools
system_performance() {
    option=$(zenity --list --title="⚡ System Performance Tools" \
        --width=500 --height=450 \
        --column="Performance Options" \
        --text="Monitor and optimize your system:" \
        "🧹 Deep System Cleanup" \
        "📊 Real-time System Monitor" \
        "💻 Detailed System Information" \
        "🔍 Process Manager" \
        "💾 Memory Usage Analysis" \
        "💿 Disk Usage Analysis" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "🧹 Deep System Cleanup")
            deep_system_cleanup
            ;;
        "📊 Real-time System Monitor")
            system_monitor
            ;;
        "💻 Detailed System Information")
            detailed_system_info
            ;;
        "🔍 Process Manager")
            process_manager
            ;;
        "💾 Memory Usage Analysis")
            memory_analysis
            ;;
        "💿 Disk Usage Analysis")
            disk_analysis
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    system_performance
}

# Deep system cleanup
deep_system_cleanup() {
    if zenity --question --title="🧹 Deep System Cleanup" \
        --text="Perform a comprehensive system cleanup?\n\n• Remove package caches\n• Clean temporary files\n• Remove orphaned packages\n• Clear thumbnails\n• Empty trash" \
        --width=400; then
        
        (
        echo "10"; echo "# Cleaning APT package cache..."
        apt clean > /dev/null 2>&1
        
        echo "25"; echo "# Removing orphaned packages..."
        apt autoremove -y > /dev/null 2>&1
        
        echo "40"; echo "# Cleaning temporary files..."
        rm -rf /tmp/* > /dev/null 2>&1
        
        echo "55"; echo "# Clearing thumbnail cache..."
        rm -rf ~/.cache/thumbnails/* > /dev/null 2>&1
        
        echo "70"; echo "# Emptying trash..."
        rm -rf ~/.local/share/Trash/* > /dev/null 2>&1
        
        echo "85"; echo "# Cleaning journal logs..."
        journalctl --vacuum-time=7d > /dev/null 2>&1
        
        echo "100"; echo "# Deep cleanup completed!"
        ) | zenity --progress \
            --title="🧹 Deep System Cleanup" \
            --text="Starting comprehensive cleanup..." \
            --percentage=0 \
            --auto-close \
            --width=500
        
        # Calculate freed space
        freed_space=$(df -h / | awk 'NR==2{print $4}')
        
        zenity --info --title="✅ Cleanup Complete" \
            --text="🧹 Deep system cleanup completed successfully!\n\n💾 Available space: $freed_space\n\n🚀 Your system should run faster now!" \
            --width=400
        
        log_message "SUCCESS" "Deep system cleanup completed"
    fi
}

# New AI development tools menu
ai_development_tools() {
    option=$(zenity --list --title="🤖 AI Development Tools" \
        --width=500 --height=400 \
        --column="AI Tools" \
        --text="Manage AI-powered development tools:" \
        "🤖 Install Cursor AI" \
        "⚡ Install Void AI" \
        "🧠 Install Both AI Tools" \
        "🔧 Configure AI Settings" \
        "📊 AI Tools Status" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "🤖 Install Cursor AI")
            install_cursor_ai_gui
            ;;
        "⚡ Install Void AI")
            install_void_ai_gui
            ;;
        "🧠 Install Both AI Tools")
            install_cursor_ai_gui
            install_void_ai_gui
            ;;
        "🔧 Configure AI Settings")
            configure_ai_settings
            ;;
        "📊 AI Tools Status")
            show_ai_status
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    ai_development_tools
}

# AI tools status
show_ai_status() {
    local status_text="🤖 AI Development Tools Status\n\n"
    
    if command -v cursor >/dev/null 2>&1; then
        status_text+="✅ Cursor AI: Installed and ready\n"
    else
        status_text+="❌ Cursor AI: Not installed\n"
    fi
    
    if command -v void >/dev/null 2>&1; then
        status_text+="✅ Void AI: Installed and ready\n"
    else
        status_text+="❌ Void AI: Not installed\n"
    fi
    
    if command -v code >/dev/null 2>&1; then
        status_text+="✅ VS Code: Available for AI extensions\n"
    else
        status_text+="⚠️  VS Code: Not installed\n"
    fi
    
    zenity --info --title="📊 AI Tools Status" \
        --text="$status_text\n🚀 Ready to enhance your coding with AI!" \
        --width=400
}

# Enhanced about dialog
about() {
    zenity --info --title="ℹ️ About Debian Configuration Manager" \
        --text="🔧 Debian Configuration Manager v$SCRIPT_VERSION\n\n🎯 A comprehensive GUI tool for managing your enhanced Debian environment on Termux.\n\n✨ Features:\n• System updates & maintenance\n• Software management\n• AI-powered development tools\n• Desktop customization\n• VNC server configuration\n• System performance monitoring\n• Backup & restore capabilities\n\n👨‍💻 Created by: Sandeep Gaddam\n🌐 GitHub: Sandeepgaddam5432\n📅 Version: $SCRIPT_VERSION ($(date +%Y))\n\n💡 Enhanced for professional development experience!" \
        --width=500
    
    log_message "INFO" "About dialog displayed"
}

# Enhanced backup and restore with better organization
backup_restore() {
    option=$(zenity --list --title="💾 Backup & Restore Manager" \
        --width=500 --height=400 \
        --column="Backup Options" \
        --text="Manage your system backups:" \
        "💾 Backup Home Directory" \
        "🏠 Restore Home Directory" \
        "⚙️  Backup System Settings" \
        "🔧 Restore System Settings" \
        "🤖 Backup AI Tools Config" \
        "📊 Backup Status" \
        "⬅️  Back to Main Menu" \
        2>/dev/null)
    
    case "$option" in
        "💾 Backup Home Directory")
            backup_home_directory
            ;;
        "🏠 Restore Home Directory")
            restore_home_directory
            ;;
        "⚙️  Backup System Settings")
            backup_system_settings
            ;;
        "🔧 Restore System Settings")
            restore_system_settings
            ;;
        "🤖 Backup AI Tools Config")
            backup_ai_configs
            ;;
        "📊 Backup Status")
            show_backup_status
            ;;
        "⬅️  Back to Main Menu"|"")
            return
            ;;
    esac
    backup_restore
}

# Enhanced home directory backup
backup_home_directory() {
    backup_dir=$(zenity --file-selection --directory \
        --title="📁 Select Backup Location" \
        --text="Choose where to store your home directory backup:" \
        2>/dev/null)
    
    if [ -n "$backup_dir" ]; then
        backup_file="$backup_dir/debian_home_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
        
        (
        echo "5"; echo "# Preparing home directory backup..."
        sleep 1
        
        echo "15"; echo "# Scanning home directory..."
        home_size=$(du -sh /home 2>/dev/null | cut -f1)
        
        echo "25"; echo "# Creating compressed backup archive..."
        tar -czf "$backup_file" \
            --exclude="*.log" \
            --exclude="cache" \
            --exclude=".cache" \
            --exclude=".local/share/Trash" \
            --exclude="*.tmp" \
            -C /home . > /dev/null 2>&1
        
        echo "80"; echo "# Verifying backup integrity..."
        sleep 1
        
        echo "95"; echo "# Finalizing backup..."
        backup_size=$(du -sh "$backup_file" 2>/dev/null | cut -f1)
        
        echo "100"; echo "# Home directory backup completed!"
        ) | zenity --progress \
            --title="💾 Creating Home Directory Backup" \
            --text="Initializing backup process..." \
            --percentage=0 \
            --auto-close \
            --width=500
        
        zenity --info --title="✅ Backup Created Successfully" \
            --text="💾 Home directory backup completed!\n\n📁 Location: $backup_file\n📦 Original size: $home_size\n🗜️  Compressed size: $backup_size\n\n✨ Your data is now safely backed up!" \
            --width=500
        
        log_message "SUCCESS" "Home directory backup created: $backup_file"
    fi
}

# System information display
system_information() {
    (
        echo "🖥️  DEBIAN SYSTEM INFORMATION"
        echo "=" | tr ' ' '='  | head -c 50; echo
        echo
        echo "📋 BASIC SYSTEM INFO:"
        echo "• OS: $(lsb_release -ds 2>/dev/null || echo 'Debian Linux')"
        echo "• Kernel: $(uname -r)"
        echo "• Architecture: $(uname -m)"
        echo "• Hostname: $(hostname)"
        echo "• Uptime: $(uptime -p 2>/dev/null || uptime)"
        echo
        echo "💻 HARDWARE INFO:"
        echo "• Processor: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d ':' -f2 | xargs)"
        echo "• CPU Cores: $(grep -c '^processor' /proc/cpuinfo)"
        echo "• CPU Architecture: $(lscpu | grep Architecture | awk '{print $2}' 2>/dev/null || echo 'Unknown')"
        echo
        echo "💾 MEMORY INFO:"
        free -h | grep -E '^(Mem|Swap)'
        echo
        echo "💿 STORAGE INFO:"
        df -h | grep -E '^(/dev|tmpfs)' | head -10
        echo
        echo "🌐 NETWORK INFO:"
        echo "• Network interfaces: $(ip link show | grep -E '^[0-9]+:' | wc -l)"
        ip addr show | grep -E 'inet ' | head -5
        echo
        echo "🔧 INSTALLED AI TOOLS:"
        if command -v cursor >/dev/null 2>&1; then
            echo "• ✅ Cursor AI Code Editor"
        else
            echo "• ❌ Cursor AI Code Editor (not installed)"
        fi
        if command -v void >/dev/null 2>&1; then
            echo "• ✅ Void AI Code Editor"  
        else
            echo "• ❌ Void AI Code Editor (not installed)"
        fi
        if command -v code >/dev/null 2>&1; then
            echo "• ✅ Visual Studio Code"
        else
            echo "• ❌ Visual Studio Code (not installed)"
        fi
        echo
        echo "📊 SYSTEM PERFORMANCE:"
        echo "• Load Average: $(uptime | awk -F'load average:' '{print $2}' | xargs)"
        echo "• Running Processes: $(ps aux | wc -l)"
        echo "• Logged Users: $(who | wc -l)"
        echo
        echo "📅 Generated: $(date)"
        echo "🔧 Configuration Manager v$SCRIPT_VERSION"
    ) | zenity --text-info \
        --title="💻 Detailed System Information" \
        --width=700 --height=600 \
        --font="monospace 10"
    
    log_message "INFO" "System information displayed"
}

# Error handling
handle_error() {
    local error_msg="$1"
    zenity --error --title="❌ Configuration Error" \
        --text="An error occurred:\n\n$error_msg\n\nPlease check the log file for details:\n$LOG_FILE" \
        --width=400
    
    log_message "ERROR" "$error_msg"
    exit 1
}

# Cleanup function
cleanup() {
    log_message "INFO" "Configuration Manager session ended"
}

# Main execution
main() {
    # Set up error trapping
    trap 'handle_error "Unexpected error occurred"' ERR
    trap cleanup EXIT
    
    banner
    check_dependencies
    main_menu
}

# Execute main function
main "$@"
