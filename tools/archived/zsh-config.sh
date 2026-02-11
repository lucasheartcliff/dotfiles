#!/bin/bash
wget --no-check-certificate http://install.ohmyz.sh -O - | bash
chsh -s $(which zsh)

echo "You should restart to take effect"
