#!/bin/bash
FOLDER_PATH="/tmp/$(uuidgen -r)/"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"

wget -P $FOLDER_PATH https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz

LSD_PATH=$HOME/.lsd/
tar -xzvf $FILE_PATH -C $LSD_PATH

rm -rf $FOLDER_PATH
rm -f $HOME/.local/bin/lsd

ln -s $LSD_PATH/lsd $HOME/.local/bin/lsd
