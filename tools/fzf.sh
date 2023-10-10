#!/bin/bash
rm -rf $HOME/.fzf/
cit clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
