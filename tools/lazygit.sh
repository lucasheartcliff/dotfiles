
#!/bin/bash
FOLDER_PATH="/tmp/$(uuidgen -r)/"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/lazygit_0.40.2_Linux_x86_64.tar.gz"

wget -P $FOLDER_PATH https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz

LAZTGIT_PATH=$HOME/.lazygit
rm -rf $LAZTGIT_PATH
mkdir $LAZTGIT_PATH

tar -xvzf $FILE_PATH -C $FOLDER_PATH
cp $FOLDER_PATH/lazygit_0.40.2_Linux_x86_64/* $LAZTGIT_PATH

rm -rf $FOLDER_PATH
rm -f $HOME/.local/bin/lazygit

ln -s $LAZTGIT_PATH/lazygit $HOME/.local/bin/lazygit
