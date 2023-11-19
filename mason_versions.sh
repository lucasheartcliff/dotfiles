#!/bin/bash
FILE=~/.local/share/nvim/mason/registries/github/mason-org/mason-registry/registry.json
rm -f $FILE
cp ./mason_config.json $FILE
