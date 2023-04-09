sudo dnf -y install terminator


rm -rf $HOME/.config/terminator/
mkdir $HOME/.config/terminator/
cp ./terminator-config $HOME/.config/terminator/config
