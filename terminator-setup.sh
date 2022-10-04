source ./check_os.sh

if [ is_fedora ]; then
    sudo dnf -y makecache --refresh
    sudo dnf -y install terminator
else
    sudo add-apt-repository ppa:gnome-terminator
    sudo apt-get install terminator
    sudo update-alternatives --config x-terminal-emulator
fi

mkdir $HOME/.config/terminator/
cp ./configs/terminator/terminator-config $HOME/.config/terminator/config
