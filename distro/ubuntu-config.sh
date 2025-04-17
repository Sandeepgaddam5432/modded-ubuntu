#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')" 

banner() {
    echo -e "${Y}    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  ${W}"
    echo -e "${C}    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ ${W}"
    echo -e "${G}    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ ${W}"
    echo -e "\n${G}     Configuration Manager for Modded Ubuntu${W}\n"
}

check_dependencies() {
    for cmd in zenity yad; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${R}Installing ${cmd}...${W}"
            apt update
            apt install -y $cmd
        fi
    done
}

main_menu() {
    option=$(zenity --list --title="Ubuntu Configuration Manager" \
        --width=400 --height=500 \
        --column="Options" \
        "System Updates" \
        "Software Management" \
        "Desktop Appearance" \
        "VNC Settings" \
        "System Performance" \
        "Backup & Restore" \
        "About" \
        "Exit")

    case "$option" in
        "System Updates")
            system_updates
            ;;
        "Software Management")
            software_management
            ;;
        "Desktop Appearance")
            desktop_appearance
            ;;
        "VNC Settings")
            vnc_settings
            ;;
        "System Performance")
            system_performance
            ;;
        "Backup & Restore")
            backup_restore
            ;;
        "About")
            about
            ;;
        "Exit"|"")
            exit 0
            ;;
    esac
    main_menu
}

system_updates() {
    zenity --question --title="System Updates" \
        --text="Do you want to update your system?" \
        --width=300
    
    if [ $? -eq 0 ]; then
        (
        echo "10"; echo "# Updating package lists..."
        apt update > /dev/null 2>&1
        
        echo "50"; echo "# Upgrading packages..."
        apt upgrade -y > /dev/null 2>&1
        
        echo "90"; echo "# Cleaning up..."
        apt autoremove -y > /dev/null 2>&1
        apt clean > /dev/null 2>&1
        
        echo "100"; echo "# Update completed!"
        ) | zenity --progress \
            --title="Updating System" \
            --text="Starting update..." \
            --percentage=0 \
            --auto-close \
            --width=400
        
        zenity --info --title="System Updates" \
            --text="System has been updated successfully!" \
            --width=300
    fi
}

software_management() {
    option=$(zenity --list --title="Software Management" \
        --width=400 --height=400 \
        --column="Options" \
        "Install Browsers" \
        "Install Development Tools" \
        "Install Media Players" \
        "Install Office Software" \
        "Install System Utilities" \
        "Remove Software" \
        "Back")
    
    case "$option" in
        "Install Browsers")
            browser=$(zenity --list --title="Install Browser" \
                --width=400 --height=300 \
                --column="Browser" --column="Description" \
                "Firefox" "Mozilla Firefox web browser" \
                "Chromium" "Open-source version of Chrome" \
                "Brave" "Privacy-focused browser" \
                "Back" "Return to software menu")
            
            case "$browser" in
                "Firefox")
                    install_software "firefox"
                    ;;
                "Chromium")
                    install_software "chromium-browser"
                    ;;
                "Brave")
                    install_brave
                    ;;
            esac
            ;;
        "Install Development Tools")
            dev_tool=$(zenity --list --title="Install Development Tools" \
                --width=400 --height=400 \
                --column="Tool" --column="Description" \
                "VSCode" "Visual Studio Code" \
                "Sublime" "Sublime Text Editor" \
                "NodeJS" "JavaScript runtime" \
                "Python" "Python programming language" \
                "Java" "OpenJDK Development Kit" \
                "Git" "Version control system" \
                "Back" "Return to software menu")
            
            case "$dev_tool" in
                "VSCode")
                    install_vscode
                    ;;
                "Sublime")
                    install_sublime
                    ;;
                "NodeJS")
                    install_software "nodejs npm"
                    ;;
                "Python")
                    install_software "python3 python3-pip"
                    ;;
                "Java")
                    install_software "default-jdk"
                    ;;
                "Git")
                    install_software "git"
                    ;;
            esac
            ;;
        "Install Media Players")
            media_player=$(zenity --list --title="Install Media Players" \
                --width=400 --height=300 \
                --column="Player" --column="Description" \
                "VLC" "VLC media player" \
                "MPV" "Minimalist media player" \
                "Audacious" "Audio player" \
                "Back" "Return to software menu")
            
            case "$media_player" in
                "VLC")
                    install_software "vlc"
                    ;;
                "MPV")
                    install_software "mpv"
                    ;;
                "Audacious")
                    install_software "audacious"
                    ;;
            esac
            ;;
        "Install Office Software")
            office=$(zenity --list --title="Install Office Software" \
                --width=400 --height=300 \
                --column="Software" --column="Description" \
                "LibreOffice" "Full office suite" \
                "AbiWord" "Lightweight word processor" \
                "Gnumeric" "Spreadsheet application" \
                "Back" "Return to software menu")
            
            case "$office" in
                "LibreOffice")
                    install_software "libreoffice"
                    ;;
                "AbiWord")
                    install_software "abiword"
                    ;;
                "Gnumeric")
                    install_software "gnumeric"
                    ;;
            esac
            ;;
        "Install System Utilities")
            utility=$(zenity --list --title="Install System Utilities" \
                --width=400 --height=300 \
                --column="Utility" --column="Description" \
                "Htop" "Interactive process viewer" \
                "Neofetch" "System information tool" \
                "Timeshift" "System backup tool" \
                "Back" "Return to software menu")
            
            case "$utility" in
                "Htop")
                    install_software "htop"
                    ;;
                "Neofetch")
                    install_software "neofetch"
                    ;;
                "Timeshift")
                    install_software "timeshift"
                    ;;
            esac
            ;;
        "Remove Software")
            remove_software
            ;;
        "Back"|"")
            return
            ;;
    esac
    software_management
}

install_software() {
    software=$1
    
    (
    echo "10"; echo "# Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo "40"; echo "# Installing $software..."
    apt install -y $software > /dev/null 2>&1
    
    echo "100"; echo "# Installation completed!"
    ) | zenity --progress \
        --title="Installing $software" \
        --text="Starting installation..." \
        --percentage=0 \
        --auto-close \
        --width=400
    
    zenity --info --title="Software Installation" \
        --text="$software has been installed successfully!" \
        --width=300
}

install_vscode() {
    (
    echo "10"; echo "# Adding VSCode repository..."
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg 2>/dev/null
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ 2>/dev/null
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list 2>/dev/null
    
    echo "40"; echo "# Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo "70"; echo "# Installing Visual Studio Code..."
    apt install -y code > /dev/null 2>&1
    
    echo "90"; echo "# Patching desktop file..."
    curl -fsSL https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop 2>/dev/null
    
    echo "100"; echo "# Installation completed!"
    ) | zenity --progress \
        --title="Installing Visual Studio Code" \
        --text="Starting installation..." \
        --percentage=0 \
        --auto-close \
        --width=400
    
    zenity --info --title="Software Installation" \
        --text="Visual Studio Code has been installed successfully!" \
        --width=300
}

install_sublime() {
    (
    echo "10"; echo "# Adding Sublime Text repository..."
    apt install -y gnupg2 software-properties-common --no-install-recommends > /dev/null 2>&1
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list > /dev/null 2>&1
    curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2> /dev/null
    
    echo "40"; echo "# Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo "70"; echo "# Installing Sublime Text..."
    apt install -y sublime-text > /dev/null 2>&1
    
    echo "100"; echo "# Installation completed!"
    ) | zenity --progress \
        --title="Installing Sublime Text" \
        --text="Starting installation..." \
        --percentage=0 \
        --auto-close \
        --width=400
    
    zenity --info --title="Software Installation" \
        --text="Sublime Text has been installed successfully!" \
        --width=300
}

install_brave() {
    (
    echo "10"; echo "# Adding Brave browser repository..."
    apt install -y apt-transport-https curl > /dev/null 2>&1
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 2>/dev/null
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null 2>&1
    
    echo "40"; echo "# Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo "70"; echo "# Installing Brave browser..."
    apt install -y brave-browser > /dev/null 2>&1
    
    echo "100"; echo "# Installation completed!"
    ) | zenity --progress \
        --title="Installing Brave Browser" \
        --text="Starting installation..." \
        --percentage=0 \
        --auto-close \
        --width=400
    
    zenity --info --title="Software Installation" \
        --text="Brave Browser has been installed successfully!" \
        --width=300
}

remove_software() {
    installed_packages=$(dpkg --get-selections | grep -v deinstall | cut -f1)
    
    software_to_remove=$(zenity --list --title="Remove Software" \
        --width=500 --height=500 \
        --column="Package" \
        --multiple \
        --text="Select software to remove:" \
        $(echo "$installed_packages") \
        2>/dev/null)
    
    if [ -n "$software_to_remove" ]; then
        zenity --question --title="Confirm Removal" \
            --text="Are you sure you want to remove the selected software?" \
            --width=300
        
        if [ $? -eq 0 ]; then
            (
            echo "10"; echo "# Preparing for removal..."
            
            echo "50"; echo "# Removing selected software..."
            for pkg in $(echo "$software_to_remove" | tr '|' ' '); do
                apt remove -y "$pkg" > /dev/null 2>&1
            done
            
            echo "90"; echo "# Cleaning up..."
            apt autoremove -y > /dev/null 2>&1
            
            echo "100"; echo "# Removal completed!"
            ) | zenity --progress \
                --title="Removing Software" \
                --text="Starting removal..." \
                --percentage=0 \
                --auto-close \
                --width=400
            
            zenity --info --title="Software Removal" \
                --text="Selected software has been removed successfully!" \
                --width=300
        fi
    fi
}

desktop_appearance() {
    option=$(zenity --list --title="Desktop Appearance" \
        --width=400 --height=300 \
        --column="Options" \
        "Change Theme" \
        "Change Icons" \
        "Change Wallpaper" \
        "Font Settings" \
        "Back")
    
    case "$option" in
        "Change Theme")
            theme_dir="/usr/share/themes"
            themes=$(find "$theme_dir" -maxdepth 1 -type d -not -path "$theme_dir" -printf "%f\n" | sort)
            
            selected_theme=$(zenity --list --title="Select Theme" \
                --width=400 --height=400 \
                --column="Theme" \
                $(echo "$themes") \
                2>/dev/null)
            
            if [ -n "$selected_theme" ]; then
                xfconf-query -c xsettings -p /Net/ThemeName -s "$selected_theme"
                xfconf-query -c xfwm4 -p /general/theme -s "$selected_theme"
                zenity --info --title="Theme Changed" \
                    --text="Theme has been changed to $selected_theme" \
                    --width=300
            fi
            ;;
        "Change Icons")
            icon_dir="/usr/share/icons"
            icons=$(find "$icon_dir" -maxdepth 1 -type d -not -path "$icon_dir" -printf "%f\n" | sort)
            
            selected_icon=$(zenity --list --title="Select Icon Theme" \
                --width=400 --height=400 \
                --column="Icon Theme" \
                $(echo "$icons") \
                2>/dev/null)
            
            if [ -n "$selected_icon" ]; then
                xfconf-query -c xsettings -p /Net/IconThemeName -s "$selected_icon"
                zenity --info --title="Icon Theme Changed" \
                    --text="Icon theme has been changed to $selected_icon" \
                    --width=300
            fi
            ;;
        "Change Wallpaper")
            wallpaper_dir="/usr/share/backgrounds/xfce"
            wallpaper=$(zenity --file-selection \
                --title="Select Wallpaper" \
                --filename="$wallpaper_dir/" \
                --file-filter="Images | *.jpg *.jpeg *.png *.gif *.bmp" \
                2>/dev/null)
            
            if [ -n "$wallpaper" ]; then
                xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$wallpaper"
                zenity --info --title="Wallpaper Changed" \
                    --text="Wallpaper has been changed" \
                    --width=300
            fi
            ;;
        "Font Settings")
            font=$(zenity --font-selection \
                --title="Select Font" \
                2>/dev/null)
            
            if [ -n "$font" ]; then
                xfconf-query -c xsettings -p /Gtk/FontName -s "$font"
                zenity --info --title="Font Changed" \
                    --text="System font has been changed" \
                    --width=300
            fi
            ;;
        "Back"|"")
            return
            ;;
    esac
    desktop_appearance
}

vnc_settings() {
    option=$(zenity --list --title="VNC Settings" \
        --width=400 --height=300 \
        --column="Options" \
        "Change VNC Password" \
        "Change VNC Resolution" \
        "Restart VNC Server" \
        "Back")
    
    case "$option" in
        "Change VNC Password")
            new_password=$(zenity --password --title="New VNC Password" 2>/dev/null)
            
            if [ -n "$new_password" ]; then
                echo "$new_password" | vncpasswd -f > ~/.vnc/passwd
                chmod 600 ~/.vnc/passwd
                
                zenity --info --title="VNC Password" \
                    --text="VNC password has been changed" \
                    --width=300
                
                zenity --question --title="Restart VNC Server" \
                    --text="Do you want to restart the VNC server to apply changes?" \
                    --width=300
                
                if [ $? -eq 0 ]; then
                    vncstop
                    vncstart
                    zenity --info --title="VNC Server" \
                        --text="VNC server has been restarted" \
                        --width=300
                fi
            fi
            ;;
        "Change VNC Resolution")
            current_resolution=$(grep -oP "geometry=\K[0-9]+x[0-9]+" ~/.vnc/config 2>/dev/null || echo "1024x768")
            
            new_resolution=$(zenity --list --title="Select VNC Resolution" \
                --width=300 --height=300 \
                --column="Resolution" \
                "800x600" \
                "1024x768" \
                "1280x720" \
                "1366x768" \
                "1920x1080" \
                --text="Current resolution: $current_resolution" \
                2>/dev/null)
            
            if [ -n "$new_resolution" ]; then
                if [ -f ~/.vnc/config ]; then
                    sed -i "s/geometry=[0-9]*x[0-9]*/geometry=$new_resolution/" ~/.vnc/config
                else
                    mkdir -p ~/.vnc
                    echo "geometry=$new_resolution" > ~/.vnc/config
                fi
                
                zenity --info --title="VNC Resolution" \
                    --text="VNC resolution has been changed to $new_resolution" \
                    --width=300
                
                zenity --question --title="Restart VNC Server" \
                    --text="Do you want to restart the VNC server to apply changes?" \
                    --width=300
                
                if [ $? -eq 0 ]; then
                    vncstop
                    vncstart
                    zenity --info --title="VNC Server" \
                        --text="VNC server has been restarted" \
                        --width=300
                fi
            fi
            ;;
        "Restart VNC Server")
            zenity --question --title="Restart VNC Server" \
                --text="Do you want to restart the VNC server?" \
                --width=300
            
            if [ $? -eq 0 ]; then
                vncstop
                vncstart
                zenity --info --title="VNC Server" \
                    --text="VNC server has been restarted" \
                    --width=300
            fi
            ;;
        "Back"|"")
            return
            ;;
    esac
    vnc_settings
}

system_performance() {
    option=$(zenity --list --title="System Performance" \
        --width=400 --height=300 \
        --column="Options" \
        "Clean System" \
        "View System Info" \
        "Process Manager" \
        "Disk Usage" \
        "Back")
    
    case "$option" in
        "Clean System")
            zenity --question --title="Clean System" \
                --text="Do you want to clean your system?\nThis will remove package caches and unused packages." \
                --width=300
            
            if [ $? -eq 0 ]; then
                (
                echo "10"; echo "# Cleaning apt cache..."
                apt clean > /dev/null 2>&1
                
                echo "30"; echo "# Removing downloaded package files..."
                apt autoclean > /dev/null 2>&1
                
                echo "50"; echo "# Removing unused packages..."
                apt autoremove -y > /dev/null 2>&1
                
                echo "70"; echo "# Cleaning thumbnails..."
                rm -rf ~/.cache/thumbnails/* > /dev/null 2>&1
                
                echo "90"; echo "# Final cleanup..."
                rm -rf ~/.local/share/Trash/* > /dev/null 2>&1
                
                echo "100"; echo "# Cleanup completed!"
                ) | zenity --progress \
                    --title="Cleaning System" \
                    --text="Starting cleanup..." \
                    --percentage=0 \
                    --auto-close \
                    --width=400
                
                zenity --info --title="System Cleanup" \
                    --text="System has been cleaned successfully!" \
                    --width=300
            fi
            ;;
        "View System Info")
            (
                echo "Gathering system information..."
                echo
                echo "=== SYSTEM INFO ==="
                echo "OS: $(lsb_release -ds)"
                echo "Kernel: $(uname -r)"
                echo "Architecture: $(uname -m)"
                echo
                echo "=== CPU INFO ==="
                echo "Processor: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d ':' -f2 | tr -s ' ')"
                echo "CPU Cores: $(grep -c '^processor' /proc/cpuinfo)"
                echo
                echo "=== MEMORY INFO ==="
                free -h
                echo
                echo "=== DISK USAGE ==="
                df -h
            ) | zenity --text-info \
                --title="System Information" \
                --width=600 --height=500
            ;;
        "Process Manager")
            ps_output=$(ps aux --sort=-%cpu | head -21)
            (
                echo "$ps_output"
            ) | zenity --text-info \
                --title="Process Manager" \
                --width=800 --height=500
            ;;
        "Disk Usage")
            disk_usage=$(du -sh /* 2>/dev/null | sort -hr)
            (
                echo "$disk_usage"
            ) | zenity --text-info \
                --title="Disk Usage" \
                --width=500 --height=500
            ;;
        "Back"|"")
            return
            ;;
    esac
    system_performance
}

backup_restore() {
    option=$(zenity --list --title="Backup & Restore" \
        --width=400 --height=300 \
        --column="Options" \
        "Backup Home Directory" \
        "Restore from Backup" \
        "Backup System Settings" \
        "Restore System Settings" \
        "Back")
    
    case "$option" in
        "Backup Home Directory")
            backup_dir=$(zenity --file-selection --directory \
                --title="Select Backup Location" \
                2>/dev/null)
            
            if [ -n "$backup_dir" ]; then
                backup_file="$backup_dir/home_backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
                
                (
                echo "10"; echo "# Preparing backup..."
                
                echo "30"; echo "# Creating backup of home directory..."
                tar -czf "$backup_file" --exclude="*.log" --exclude="cache" --exclude=".cache" --exclude=".local/share/Trash" -C /home . > /dev/null 2>&1
                
                echo "90"; echo "# Finalizing backup..."
                
                echo "100"; echo "# Backup completed!"
                ) | zenity --progress \
                    --title="Creating Backup" \
                    --text="Starting backup..." \
                    --percentage=0 \
                    --auto-close \
                    --width=400
                
                zenity --info --title="Backup Created" \
                    --text="Backup has been created at:\n$backup_file" \
                    --width=400
            fi
            ;;
        "Restore from Backup")
            backup_file=$(zenity --file-selection \
                --title="Select Backup File" \
                --file-filter="Backup files | *.tar.gz" \
                2>/dev/null)
            
            if [ -n "$backup_file" ]; then
                zenity --question --title="Confirm Restore" \
                    --text="Are you sure you want to restore from this backup?\nExisting files may be overwritten." \
                    --width=300
                
                if [ $? -eq 0 ]; then
                    (
                    echo "10"; echo "# Preparing to restore..."
                    
                    echo "30"; echo "# Extracting backup..."
                    tar -xzf "$backup_file" -C /home > /dev/null 2>&1
                    
                    echo "90"; echo "# Finalizing restore..."
                    
                    echo "100"; echo "# Restore completed!"
                    ) | zenity --progress \
                        --title="Restoring Backup" \
                        --text="Starting restore..." \
                        --percentage=0 \
                        --auto-close \
                        --width=400
                    
                    zenity --info --title="Restore Completed" \
                        --text="Backup has been restored successfully!" \
                        --width=300
                fi
            fi
            ;;
        "Backup System Settings")
            backup_dir=$(zenity --file-selection --directory \
                --title="Select Backup Location" \
                2>/dev/null)
            
            if [ -n "$backup_dir" ]; then
                backup_file="$backup_dir/system_settings_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
                
                (
                echo "10"; echo "# Preparing backup..."
                
                echo "30"; echo "# Creating backup of system settings..."
                tar -czf "$backup_file" -C /etc . > /dev/null 2>&1
                
                echo "90"; echo "# Finalizing backup..."
                
                echo "100"; echo "# Backup completed!"
                ) | zenity --progress \
                    --title="Creating System Settings Backup" \
                    --text="Starting backup..." \
                    --percentage=0 \
                    --auto-close \
                    --width=400
                
                zenity --info --title="Backup Created" \
                    --text="System settings backup has been created at:\n$backup_file" \
                    --width=400
            fi
            ;;
        "Restore System Settings")
            backup_file=$(zenity --file-selection \
                --title="Select System Settings Backup File" \
                --file-filter="Backup files | *.tar.gz" \
                2>/dev/null)
            
            if [ -n "$backup_file" ]; then
                zenity --question --title="Confirm Restore" \
                    --text="Are you sure you want to restore system settings from this backup?\nThis is potentially dangerous and may break your system." \
                    --width=400
                
                if [ $? -eq 0 ]; then
                    (
                    echo "10"; echo "# Preparing to restore..."
                    
                    echo "30"; echo "# Extracting system settings..."
                    tar -xzf "$backup_file" -C /etc > /dev/null 2>&1
                    
                    echo "90"; echo "# Finalizing restore..."
                    
                    echo "100"; echo "# Restore completed!"
                    ) | zenity --progress \
                        --title="Restoring System Settings" \
                        --text="Starting restore..." \
                        --percentage=0 \
                        --auto-close \
                        --width=400
                    
                    zenity --info --title="Restore Completed" \
                        --text="System settings have been restored successfully!\nYou may need to restart your system." \
                        --width=400
                fi
            fi
            ;;
        "Back"|"")
            return
            ;;
    esac
    backup_restore
}

about() {
    zenity --info --title="About Ubuntu Configuration Manager" \
        --text="Ubuntu Configuration Manager v1.0\n\nA simple GUI tool for managing your modded Ubuntu environment on Termux.\n\nCreated for the modded-ubuntu project.\n\nVisit: https://github.com/modded-ubuntu/modded-ubuntu" \
        --width=400
}

# Main execution
banner
check_dependencies
main_menu 