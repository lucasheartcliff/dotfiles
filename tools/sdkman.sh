#!/bin/bash
curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
source $HOME/.zshrc

sdk version

sdk install java 8.0.362-amzn
sdk install java 11.0.18-amzn
sdk install java 17.0.6-amzn

sdk install maven
