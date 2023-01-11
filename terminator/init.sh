source ./check_os.sh

if [ is_fedora ]; then
    sudo dnf -y makecache --refresh
    sudo dnf -y install terminator
else
    sudo add-apt-repository ppa:gnome-terminator
    sudo apt-get install terminator
    sudo update-alternatives --config x-terminal-emulator
fi


rm -rf $HOME/.config/terminator/
mkdir $HOME/.config/terminator/
cp ./terminator-config $HOME/.config/terminator/config
