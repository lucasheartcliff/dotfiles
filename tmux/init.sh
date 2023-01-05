source ../check_os.sh

if [ is_fedora ]; then
    sudo dnf -y install tmux

else
    sudo apt install tmux
fi

rm -rf ~/.tmux/
rm -f ~/.tmux.conf
rm -f ~/.tmux.conf.local

cp ./config/.tmux.conf.local ~/.tmux.conf.local
cp ./config/.tmux.conf ~/.tmux.conf