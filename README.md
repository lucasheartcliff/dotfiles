# Dotfiles

Declarative Linux workstation setup built around Nix Home Manager, Fish, Neovim, Tmux, Kitty, and GNU Stow.

![setup screenshot](./assets/setup.png)

## What This Manages

- Nix/Home Manager packages and user-level programs.
- Fish shell, abbreviations, plugins, and command completions.
- Git, delta, lazygit, fzf, Starship, direnv, and Tmux.
- Stowed app configs for Neovim, Kitty, Terminator, and Tmux.
- Optional Codex and Claude Code CLI installation through a separate script.

## Install

Run from the repository root.

```bash
git clone https://github.com/lucasheartcliff/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./ubuntu.sh
```

`ubuntu.sh` installs base system dependencies and then calls `bootstrap.sh`.
Bootstrap installs Nix, installs Home Manager, links this repo's Home Manager config, runs `home-manager switch`, sets Fish as the default shell, and stows the app configs.

## Daily Workflow

Preview Home Manager changes:

```bash
home-manager switch --dry-run
```

Build without activating:

```bash
home-manager build
```

Apply changes:

```bash
home-manager switch
```

Restow app configs:

```bash
./stow-config.sh
```

Rollback Home Manager:

```bash
home-manager generations
home-manager switch --rollback
```

## Project Structure

```text
dotfiles/
├── bootstrap.sh
├── ubuntu.sh
├── stow-config.sh
├── scripts/
│   └── install-ai-clis.sh
├── home-manager/.config/home-manager/
│   ├── home.nix
│   └── modules/
├── neovim/.config/nvim/
├── kitty/.config/kitty/
├── terminator/.config/terminator/
├── tmux/
├── utils/
└── assets/
```

`home.nix` is the entrypoint. The modules directory keeps packages, Fish, Git, terminal tooling, direnv, and lazygit configuration separated.

## Fish Shell

Fish is configured through Home Manager with:

- abbreviations for Git, Docker, Kubernetes, GitHub CLI, Nix, Home Manager, Codex, and Claude Code;
- fzf-fish, done, autopair, git-abbr, fish-you-should-use, and foreign-env plugins;
- Starship and fzf integration;
- zoxide directory jumping and atuin history search;
- declarative completions for dev tools including `gh`, `kubectl`, `kubectx`, `kubens`, `helm`, `docker`, `docker-compose`, `home-manager`, `nix`, `npm`, `yarn`, and `asdf`.

Useful abbreviations:

```fish
g      # git
glg    # lazygit
k      # kubectl
kctx   # kubectx
kns    # kubens
ghpr   # gh pr
hmb    # home-manager build
hms    # home-manager switch
z      # jump to frequent directories with zoxide
atuin  # searchable shell history
cx     # codex
ccode  # claude
```

## Optional AI CLIs

Codex and Claude Code are not installed by bootstrap automatically. Install them when needed:

```bash
./scripts/install-ai-clis.sh
```

Upgrade or reinstall:

```bash
./scripts/install-ai-clis.sh --upgrade
```

The script uses npm global packages and does not run authentication flows or store secrets. After installation, authenticate manually:

```bash
codex login
claude
```

## Neovim

The Neovim config lives in `neovim/.config/nvim` and includes automated Kotlin/Android checks.

Run the local Neovim CI check:

```bash
neovim/.config/nvim/tests/ci/kotlin_android_ci.sh
```

## Verification

Run syntax checks:

```bash
bash -n bootstrap.sh stow-config.sh ubuntu.sh uninstall_nix.sh scripts/install-ai-clis.sh
```

Run ShellCheck:

```bash
shellcheck -e SC1091 bootstrap.sh
shellcheck stow-config.sh ubuntu.sh uninstall_nix.sh scripts/install-ai-clis.sh
```

Check Fish completions after applying Home Manager:

```bash
fish -c 'complete -C "gh pr "'
fish -c 'complete -C "kubectl get "'
fish -c 'complete -C "helm "'
fish -c 'complete -C "home-manager "'
fish -c 'complete -C "asdf "'
```

## Notes

- Fish becomes the default shell after bootstrap; log out and back in if the current shell does not change immediately.
- FiraCode Nerd Font is installed through Home Manager.
- Kitty is installed with the OS package manager in bootstrap to avoid Nix/OpenGL issues.
- Manual installer scripts and vendored font binaries are intentionally not part of the supported setup.
