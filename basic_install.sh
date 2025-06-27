#!/bin/bash
set -euo pipefail

# Enable logging
LOGFILE="/home/kali/Desktop/setup.log"
exec > >(tee -i "$LOGFILE") 2>&1

echo "Starting setup process..."

# Ensure ~/go/bin is in PATH
if ! echo $PATH | grep -q "$HOME/go/bin"; then
    echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/go/bin:$PATH"
fi

# Fix PostgreSQL collation version issues
echo "Fixing PostgreSQL collation version issues..."
sudo -u postgres psql -c "ALTER DATABASE template1 REFRESH COLLATION VERSION;" 2>/dev/null || true
sudo -u postgres psql -c "ALTER DATABASE postgres REFRESH COLLATION VERSION;" 2>/dev/null || true

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

# Install common.py
COMMON_PY="/usr/bin/common.py"
if [ ! -f "$COMMON_PY" ]; then
    echo "Installing common.py..."
    wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/common.py
    sudo chmod +x common.py
    sudo mv common.py "$COMMON_PY"
else
    echo "common.py is already installed."
fi

# Set up Bug Bounty tools directory
BUG_BOUNTY_DIR="/home/kali/Desktop/Tools/Bug Bounty"
mkdir -p "$BUG_BOUNTY_DIR"
cd "$BUG_BOUNTY_DIR"

# Install Nuclei
if [ ! -f "/usr/local/bin/nuclei" ]; then
    echo "Installing Nuclei..."
    git clone https://github.com/projectdiscovery/nuclei.git
    cd nuclei/cmd/nuclei
    go build
    sudo mv nuclei /usr/local/bin/
    nuclei -version
    cd "$BUG_BOUNTY_DIR"
else
    echo "Nuclei is already installed."
fi

# Install Subfinder
if [ ! -f "/usr/local/bin/subfinder" ]; then
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
if [ ! -f "/usr/local/bin/kerbrute" ]; then
    echo "Installing Kerbrute..."
    cd /tmp
    wget -q https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute
    chmod +x kerbrute
    sudo mv kerbrute /usr/local/bin/
    echo "Kerbrute installed successfully."
else
    echo "Kerbrute is already installed."
fi

# Install BloodHound
if ! command -v bloodhound &>/dev/null; then
    echo "Installing BloodHound and Neo4j..."
    sudo apt install -y bloodhound
    echo "Running bloodhound-setup..."
    sudo bloodhound-setup
else
    echo "BloodHound is already installed."
fi

# Final reminder for BloodHound password setup
echo ""
echo "📌 BloodHound Setup Reminder:"
echo "  ➤ Visit http://localhost:7474 in your browser."
echo "  ➤ Login with 'neo4j' / 'neo4j', then set a new password."
echo "  ➤ Update the password in /etc/bhapi/bhapi.json accordingly."
echo ""

echo "✅ Setup complete! Logs saved at $LOGFILE."
