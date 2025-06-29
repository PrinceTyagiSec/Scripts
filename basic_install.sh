#!/bin/bash
set -euo pipefail

# Enable logging
LOGFILE="/home/kali/Desktop/setup.log"
exec > >(tee -i "$LOGFILE") 2>&1

SCRIPT_PATH=$(realpath "$0")
echo "Starting setup process..."

# Ensure ~/go/bin is in PATH
if ! echo $PATH | grep -q "$HOME/go/bin"; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/go/bin:$PATH"
fi

# Check for Go installation
if ! command -v go &>/dev/null; then
    echo "Go not found. Installing Go..."
    sudo apt install -y golang
else
    echo "Go is already installed."
fi

# Install CTF Tools
echo "Installing CTF tools..."
sudo apt update
sudo apt install -y seclists steghide pspy enum4linux zaproxy stegcracker peass rubygems amass openvpn

# Install RubyGem Tool
echo "Installing hashid gem..."
if ! gem list -i hashid; then
    sudo gem install hashid
else
    echo "hashid gem is already installed."
fi

# Set up CTF tools directory
CTF_DIR="/home/kali/Desktop/Tools/CTF"
mkdir -p "$CTF_DIR"
cd "$CTF_DIR"

# Download CTF scripts
echo "Downloading CTF scripts..."
wget -q https://github.com/peass-ng/PEASS-ng/releases/download/20250601-88c7a0f6/linpeas.sh -O linpeas.sh
wget -q https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32
wget -q https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/RCE.php
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/shell.aspx
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/shell.php

# Install help
COMMON_PY="/usr/bin/help"
if [ ! -f "$COMMON_PY" ]; then
    echo "Installing help..."
    wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/help
    sudo chmod +x help
    dos2unix help
    sudo mv help "$COMMON_PY"
else
    echo "help is already installed."
fi

# Set up Bug Bounty tools directory
BUG_BOUNTY_DIR="/home/kali/Desktop/Tools/Bug Bounty"
mkdir -p "$BUG_BOUNTY_DIR"
cd "$BUG_BOUNTY_DIR"

# Install Nuclei via apt
if ! command -v nuclei &>/dev/null; then
    echo "Installing Nuclei via apt..."
    sudo apt install -y nuclei
else
    echo "Nuclei is already installed."
fi

# Install Subfinder
if ! command -v subfinder &>/dev/null; then
    echo "Installing Subfinder..."
    git clone https://github.com/projectdiscovery/subfinder.git
    cd subfinder/v2/cmd/subfinder
    go build
    sudo mv subfinder /usr/local/bin/
    subfinder -version
    cd "$BUG_BOUNTY_DIR"
else
    echo "Subfinder is already installed."
fi

# Install gauplus
if ! command -v gauplus &>/dev/null; then
    echo "Installing gauplus..."
    go install github.com/bp0lr/gauplus@latest
else
    echo "gauplus is already installed."
fi

# Install ParamSpider
if [ ! -d "ParamSpider" ]; then
    echo "Installing ParamSpider..."
    git clone https://github.com/0xKayala/ParamSpider
    cd ParamSpider
    pip3 install -r requirements.txt
    cd "$BUG_BOUNTY_DIR"
else
    echo "ParamSpider is already installed."
fi

# Install httpx
if ! command -v httpx &>/dev/null; then
    echo "Installing httpx..."
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
else
    echo "httpx is already installed."
fi

# Install Nuclei Templates
TEMPLATE_DIR="$BUG_BOUNTY_DIR/nuclei-templates"
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Installing Nuclei templates..."
    git clone --depth 1 https://github.com/projectdiscovery/nuclei-templates.git
else
    echo "Updating Nuclei templates..."
    cd "$TEMPLATE_DIR"
    git pull
    cd "$BUG_BOUNTY_DIR"
fi

# Install NucleiScanner
if [ ! -d "NucleiScanner" ]; then
    echo "Installing NucleiScanner..."
    git clone https://github.com/0xKayala/NucleiScanner.git
    cd NucleiScanner
    sudo chmod +x install.sh
    ./install.sh
    ns -h
    cd "$BUG_BOUNTY_DIR"
else
    echo "NucleiScanner is already installed."
fi

# Install Kerbrute
if ! command -v kerbrute &>/dev/null; then
    echo "Installing Kerbrute..."
    cd /tmp
    wget -q https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute
    chmod +x kerbrute
    echo "Kerbrute installed successfully."
else
    echo "Kerbrute is already installed."
fi


# Self-delete script after execution
if [ -f "$SCRIPT_PATH" ]; then
    echo "Cleaning up: Deleting script $SCRIPT_PATH..."
    rm -- "$SCRIPT_PATH"
fi

echo "Setup complete! Logs saved at $LOGFILE."
