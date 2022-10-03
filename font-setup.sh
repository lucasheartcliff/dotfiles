source ./check_os.sh
if [ is_fedora ]; then
    sudo dnf makecache --refresh
    sudo dnf -y install fira-code-fonts
else
    sudo apt install fonts-firacode
fi