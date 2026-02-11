sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
nix shell github:nix-community/home-manager
home-manager switch --flake ~/.config/home-manager