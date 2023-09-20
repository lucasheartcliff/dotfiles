#!/bin/bash

DIR_PATH="/tmp/$(uuidgen -r)/"

git clone git@github.com:vinceliuice/Orchis-theme.git $DIR_PATH
$DIR_PATH/install.sh -l
rm -rf $DIR_PATH

git clone git@github.com:TaylanTatli/Sevi.git $DIR_PATH
$DIR_PATH/install.sh -a
rm -rf $DIR_PATH

