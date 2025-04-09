#!/bin/bash

# Check for dependencies and install if missing
packages=(git php-cli php-xml php-gd php-bz2 php-sqlite3 php-curl php-zip)
for package in "${packages[@]}"; do
    if ! dpkg -s "$package" &> /dev/null; then
        echo "Installing missing package: $package"
        sudo apt-get install -y "$package"
    fi
done

# Clone the Phoronix Test Suite repository if not already cloned
pts_dir="$HOME/phoronix-test-suite"
if [ ! -d "$pts_dir" ]; then
    echo "Cloning Phoronix Test Suite..."
    git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git "$pts_dir"
fi

# Create alias in .bashrc if not already present
alias_line='alias pts="./phoronix-test-suite/phoronix-test-suite"'
if ! grep -q "$alias_line" "$HOME/.bashrc"; then
    echo "Adding 'pts' alias to .bashrc"
    echo "$alias_line" >> "$HOME/.bashrc"
    # Source .bashrc to make the alias immediately available
    source "$HOME/.bashrc"
fi

echo "Setup complete!"

