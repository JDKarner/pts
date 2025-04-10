#!/bin/bash
# **Check for dependencies and install if missing**
packages=(git php-cli php-xml php-gd php-bz2 php-sqlite3 php-curl php-zip openssh-server)
for package in "${packages[@]}"; do
    if ! dpkg -s "$package" &> /dev/null; then
        echo "Installing missing package: $package"
        sudo apt-get install -y "$package"
    fi
done

# **Clone the Phoronix Test Suite repository if not already cloned**
pts_dir="$HOME/phoronix-test-suite"
if [ ! -d "$pts_dir" ]; then
    echo "Cloning Phoronix Test Suite..."
    git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git "$pts_dir"
fi

# **Install Phoronix Test Suite**
echo "Installing Phoronix Test Suite..."
cd "$pts_dir" || exit
sudo ./install-sh

# **Create pts.sh script on Desktop**
desktopPTS="$HOME/Desktop/pts.sh"
if [ ! -f "$desktopPTS" ]; then
    echo "Creating pts.sh script on Desktop..."
    echo "#!/bin/bash" > "$desktopPTS"
    echo "phoronix-test-suite phoromatic.connect 192.168.50.26:17761/UNHLT0" >> "$desktopPTS"
    
    # Make the script executable
    chmod +x "$desktopPTS"
fi

# **Create alias in .bashrc if not already present**
alias_line='alias pts="./phoronix-test-suite/phoronix-test-suite"'
if ! grep -q "$alias_line" "$HOME/.bashrc"; then
    echo "Adding 'pts' alias to .bashrc"
    echo "$alias_line" >> "$HOME/.bashrc"
    # Source .bashrc to make the alias immediately available
    source "$HOME/.bashrc"
fi

# **Install and enable OpenSSH server**
echo "Installing and enabling OpenSSH server..."
sudo apt-get install -y openssh-server
sudo systemctl enable ssh

# **Set hostname based on user input**
read -p "Please enter your order or RMA number: " hostname_value
if [ -n "$hostname_value" ]; then
    echo "Setting hostname to $hostname_value..."
    sudo hostnamectl set-hostname "$hostname_value"
    
    # Update /etc/hosts file
    echo "Updating /etc/hosts..."
    sudo sed -i "s/^127.0.0.1.*$/127.0.0.1 localhost $hostname_value/" /etc/hosts
else
    echo "No hostname provided. Skipping hostname change."
fi

echo "Setup complete!"
