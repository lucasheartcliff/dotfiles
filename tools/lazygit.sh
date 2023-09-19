
FOLDER_PATH="/tmp/$(uuidgen -r)/"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/lazygit.taz.gz"

wget -P $FILE_PATH https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz


LAZTGIT_PATH=$HOME/.lazygit/
tar -xzvf $FILE_PATH -C $LAZTGIT_PATH

rm -rf $FOLDER_PATH
rm -f $HOME/.local/bin/lazygit

ln -s $LAZTGIT_PATH/lazygit $HOME/.local/bin/lazygit