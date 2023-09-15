FOLDER_PATH="/tmp/$(uuidgen -r)/"
mkdir $FOLDER_PATH

FILE_PATH="$FOLDER_PATH/lsd.taz.gz"

wget -P $FILE_PATH https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz

tar -xzvf $FILE_PATH -C $HOME/.lsd/

rm -rf $FOLDER_PATH

