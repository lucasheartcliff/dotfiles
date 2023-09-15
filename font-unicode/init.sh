FOLDER_PATH="/tmp/$(uuidgen -r)/"

mkdir $FOLDER_PATH

git clone https://github.com/lucasheartcliff/fonts.git $FOLDER_PATH

mkdir $HOME/.local/share/fonts/

echo "Copying fonts in folder"
cp ./nerd-fonts/**/*.ttf  $HOME/.local/share/fonts/


echo "Copying nerd-fonts"
cd $FOLDER_PATH/fonts && cp *.ttf *.otf $HOME/.local/share/fonts/

fc-cache -fv

rm -rf $FOLDER_PATH
