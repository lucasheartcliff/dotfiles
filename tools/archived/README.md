# Archived Tool Installation Scripts

These scripts are kept for reference but are **no longer the recommended installation method**.

## Why Archived?

The dotfiles repository has migrated to using **Nix Home Manager** for package management, which provides:

- ✅ Declarative configuration
- ✅ Automatic dependency resolution
- ✅ Easy rollback capabilities
- ✅ Reproducible environments
- ✅ No manual version management

## Migration

Instead of running individual scripts from this directory, use the modern approach:

```bash
# From repository root
./ubuntu.sh  # or ./fedora.sh
```

This will:

1. Install system dependencies
2. Install Nix + Home Manager
3. Apply all configurations declaratively

## Contents

These scripts were previously used to manually install:

- `brave-config.sh` - Brave browser setup (now managed by Nix)
- `fzf.sh` - Fuzzy finder (now managed by Nix)
- `git-config.sh` - Git configuration (now in home.nix)
- `gnome.sh` - GNOME extensions
- `k8s.sh` - Kubernetes tools
- `lazygit.sh` - LazyGit TUI (now managed by Nix)
- `lsd.sh` - Modern ls replacement (now managed by Nix)
- `neovim.sh` - Neovim editor (now managed by Nix)
- `nix.sh` - Nix installation (now in bootstrap.sh)
- `nvm.sh` - Node version manager
- `pyenv.sh` - Python version manager (now managed by Nix)
- `sdkman.sh` - Java SDK manager
- `zap-zsh.sh` - ZSH plugin manager (replaced by Fish shell)
- `zsh-config.sh` - ZSH configuration (replaced by Fish shell)

## Using These Scripts (Not Recommended)

If you absolutely need to use these legacy scripts:

```bash
cd ~/.dotfiles/tools/archived
bash <script-name>.sh
```

**Warning**: These scripts:

- Are not maintained
- May have hardcoded versions
- Don't handle errors gracefully
- May conflict with Nix-managed packages
- Won't receive updates

## Recommended: Use Home Manager

Edit `~/.config/home-manager/home.nix` instead and run:

```bash
home-manager switch
```

This provides a much better experience with centralized configuration and automatic updates.
