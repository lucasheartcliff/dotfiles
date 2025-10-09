sudo rm -rf /nix
sudo rm -rf /etc/nix
sudo rm -rf /usr/local/bin/nix*
sudo rm -rf /etc/systemd/system/nix-daemon.service 
sudo rm -rf /etc/systemd/system/nix-daemon.socket 

sudo mv /etc/zsh/zshrc.backup-before-nix /etc/zsh/zshrc
sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc                    
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
sudo mv /etc/profile.d/nix.sh.backup-before-nix /etc/profile.d/nix.sh
sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
sudo mv /etc/zsh/zshrc.backup-before-nix /etc/zsh/zshrc