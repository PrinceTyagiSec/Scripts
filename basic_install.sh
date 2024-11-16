#!/bin/bash

# Enable logging
LOGFILE="/home/kali/Desktop/setup.log"
exec > >(tee -i $LOGFILE) 2>&1
exec 2>&1

echo "Starting setup process..."

# Check for Go installation
if ! command -v go &> /dev/null; then
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
echo "Installing haiti-hash gem..."
if ! gem list -i haiti-hash; then
    sudo gem install haiti-hash
else
    echo "haiti-hash gem is already installed."
fi

# Set up CTF tools directory
CTF_DIR="/home/kali/Desktop/Tools/CTF"
mkdir -p $CTF_DIR
cd $CTF_DIR

# Download CTF scripts
echo "Downloading CTF scripts..."
wget -q https://linpeas.sh -O linpeas.sh
wget -q https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32
wget -q https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/RCE.php
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/shell.aspx
wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/shell.php

# Install common.py
COMMON_PY="/usr/bin/common.py"
if [ ! -f $COMMON_PY ]; then
    echo "Installing common.py..."
    wget -q https://raw.githubusercontent.com/prince2313/Scripts/refs/heads/main/common.py
    sudo chmod +x common.py
    sudo mv common.py $COMMON_PY
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
if [ ! -f "$HOME/go/bin/gauplus" ]; then
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
if [ ! -f "$HOME/go/bin/httpx" ]; then
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

echo "Setup complete! Logs available at $LOGFILE."
