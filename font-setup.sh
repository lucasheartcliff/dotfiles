source ./check_os.sh
if [ is_fedora ]; then
    sudo dnf makecache --refresh
    sudo dnf -y install fira-code-fonts

else
    sudo apt install fonts-firacode
fi

git clone https://github.com/terroo/fonts.git
mkdir $HOME/.local/share/fonts/
cd fonts/fonts && cp *.ttf *.otf $HOME/.local/share/fonts/

fc-cache -fv
