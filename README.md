
<p align="center">
<img src="./distro/image.jpg">
</p>

<p align="center">
<img src="https://img.shields.io/badge/Version-3.0-blue?style=for-the-badge">
<img src="https://img.shields.io/badge/Written%20In-Bash-darkgreen?style=for-the-badge">
<img src="https://img.shields.io/badge/Open%20Source-Yes-darkviolet?style=for-the-badge">
</p>

<p align="center"><b>🚀 Professional Debian GUI Environment for Termux with AI-Powered Development Tools</b></p>

## ✨ Features

### 🎯 **Core Features**
- ✅ **Fixed Audio Output** - Crystal clear sound experience
- ⚡ **Lightweight Design** - Requires minimum 4GB storage
- 🖥️  **Professional Desktop** - Complete XFCE4 environment
- 🎨 **Custom Themes** - Beautiful and modern UI themes
- 🔧 **Configuration Tool** - GUI-based system management

### 🌐 **Web Browsers**
- 🦊 **Firefox** - Popular and secure browser
- 🌐 **Chromium** - Open-source Chrome alternative
- 🛡️  **Brave** - Privacy-focused browsing (optional)

### 💻 **Development Environment**
- 🤖 **Cursor AI** - AI-first code editor with smart assistance
- ⚡ **Void AI** - AI-enhanced development experience  
- 💻 **Visual Studio Code** - Microsoft's popular IDE
- 📝 **Sublime Text** - Lightweight and fast editor
- 🐍 **Python Development** - Complete Python environment
- ☕ **Java Development** - OpenJDK support
- 🟢 **Node.js** - JavaScript runtime environment

### 🎵 **Media & Entertainment**
- 🎥 **VLC Media Player** - Universal media player
- 🎬 **MPV Player** - Minimalist media experience
- 🎵 **Audio Support** - Multiple format support

### 📊 **System Tools**
- 📊 **Htop** - Interactive process monitor
- 💻 **Neofetch** - System information display
- 🔍 **Advanced Package Manager** - GUI software management
- 💾 **Backup & Restore** - Complete data protection

## 🚀 Installation Guide

### **Step 1: Install Termux**
- Download [Termux](https://f-droid.org/repo/com.termux_118.apk) from F-Droid
- Install and open Termux

### **Step 2: Setup Repository**
```
# Update packages
yes | pkg up

# Install requirements
pkg install git wget -y

# Clone repository
git clone --depth=1 https://github.com/Sandeepgaddam5432/modded-ubuntu.git

# Navigate to directory
cd modded-ubuntu

# Run setup
bash setup.sh
```

### **Step 3: Initial Configuration**
```
# Restart Termux, then run:
debian

# Setup user account
bash user.sh
```
- Enter your desired username (lowercase, no spaces)
- Set a secure password
- Wait for completion

### **Step 4: GUI Environment Setup**
```
# Restart Termux again, then run:
debian

# Install GUI environment with AI tools
sudo bash gui.sh
```
- Choose your preferred browsers
- Select development tools (including AI editors)
- Pick media players
- **Important: Note your VNC password!**

### **Step 5: VNC Connection**
```
# Start VNC server
vncstart

# Stop VNC server (when needed)
vncstop
```

**VNC Viewer Setup:**
1. Install [VNC Viewer](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android) from Play Store
2. Open VNC Viewer and tap the **+** button  
3. Enter address: `localhost:1`
4. Set picture quality to **High**
5. Connect and enter your VNC password
6. **Enjoy your professional development environment!** 🎉

## 🎯 Quick Commands

| Command | Description |
|---------|-------------|
| `debian` | Access Debian CLI environment |
| `vncstart` | Start VNC server for GUI |
| `vncstop` | Stop VNC server |
| `debian-config` | Open GUI configuration tool |
| `bash remove.sh` | Completely remove installation |

## 🤖 AI Development Tools

### **Cursor AI Code Editor**
- 🧠 **Natural Language Coding** - Write code with AI assistance
- 🚀 **Smart Autocompletion** - Context-aware suggestions  
- 🔄 **Code Refactoring** - AI-powered code improvements
- 📚 **GitHub Copilot Integration** - Enhanced AI features

### **Void AI Code Editor**  
- ⚡ **AI-Enhanced Development** - Intelligent code assistance
- 🎯 **Multi-language Support** - Works with all major languages
- 🔧 **Smart Debugging** - AI-powered error detection
- 📊 **Performance Optimization** - Automated code optimization

## 🛠️ System Requirements

- **Android Version:** 7.0+ recommended
- **RAM:** 3GB+ for optimal performance  
- **Storage:** Minimum 4GB free space
- **Architecture:** ARM64/ARMv8 recommended
- **Network:** Stable internet connection for setup

## 🎨 Customization Options

- **Themes:** Multiple desktop themes available
- **Icons:** Various icon packs included  
- **Wallpapers:** Professional wallpaper collection
- **Fonts:** Multiple font families supported
- **Colors:** Customizable color schemes

## 📊 What's New in v3.0

- 🤖 **AI Development Tools** - Cursor AI & Void AI integration
- 🎨 **Enhanced UI/UX** - Professional interface design
- 🔧 **Smart Installation** - Automatic error recovery
- 📱 **Better Mobile Support** - Optimized for Android devices
- 🚀 **Performance Improvements** - Faster boot and operation
- 🛡️  **Enhanced Security** - Better permission management

## 💡 Pro Tips

- **Use AI Tools:** Try Cursor AI for intelligent code completion
- **VNC Quality:** Set to High for best visual experience
- **Performance:** Close unnecessary Android apps while using
- **Backup:** Use the built-in backup tool regularly
- **Updates:** Run system updates periodically for security

## 🆘 Troubleshooting

### Common Issues:
- **VNC Connection Failed:** Check if vncstart was successful
- **Audio Issues:** Restart VNC server after configuration
- **Performance Slow:** Ensure sufficient RAM and storage
- **GUI Not Loading:** Try `bash fix-gui.sh` in user home directory

### Getting Help:
- Check the built-in configuration tool
- Review command logs for error messages
- Ensure all setup steps were completed
- Try restarting Termux completely

## 🌟 About

**Enhanced Debian GUI for Termux** - A professional development environment that brings the power of Linux desktop with AI-powered development tools to your Android device.

Created with ❤️ by **Sandeep Gaddam**

**Repository:** [Sandeepgaddam5432/modded-ubuntu](https://github.com/Sandeepgaddam5432/modded-ubuntu)
