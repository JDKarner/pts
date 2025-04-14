# PTS
Automating the adding of systems to a phoromatic server
Pre-installing some test dependencies.

This is intended for a specific workflow that may not be suited towards your usecase.

# Editing
If you would like to use this for your own phoromatic server there are a few edits you may need.
In the first section `php-cli php-xml php-gd php-bz2 php-sqlite3 php-curl php-zip` is for pts, I suggest you do not remove these.
Any packages you need for your test suite can be added after them.

This script sets up easy syntax for SSH, if you don't plan on using ssh, I suggest removing `openssh-server` from the packages list, as well as commenting out or removing this section

```
### -------Cut or comment for no ssh-------
# **Create alias in .bashrc if not already present**
alias_line='alias pts="./phoronix-test-suite/phoronix-test-suite"'
if ! grep -q "$alias_line" "$HOME/.bashrc"; then
    echo "Adding 'pts' alias to .bashrc"
    echo "$alias_line" >> "$HOME/.bashrc"
    # Source .bashrc to make the alias immediately available
    source "$HOME/.bashrc"
fi

# **Install and enable OpenSSH server**
echo "Enabling OpenSSH server..."
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
### -------Cut or comment for no ssh-------
```




