#!/bin/bash
FOLDER_PATH="/tmp/$(uuidgen -r)"

FILE_PATH="$FOLDER_PATH/NoiseTorch_x64_v0.12.2.tgz"

wget -P $FOLDER_PATH https://github.com/noisetorch/NoiseTorch/releases/download/v0.12.2/NoiseTorch_x64_v0.12.2.tgz

tar -C $HOME -h -xzf $FILE_PATH
gtk-update-icon-cache
sudo setcap 'CAP_SYS_RESOURCE=+ep' ~/.local/bin/noisetorch
