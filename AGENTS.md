# Repository Guidelines

## Project Structure & Module Organization
This repository is a dotfiles setup centered on Nix Home Manager and GNU Stow. Core entry points live at the root: `bootstrap.sh` installs Nix and Home Manager, `ubuntu.sh` and `fedora.sh` prepare OS packages, and `stow-config.sh` links package directories into `$HOME`.

Main configuration lives in `home-manager/.config/home-manager/home.nix`. App-specific packages are organized by target path, for example `neovim/.config/nvim`, `kitty/.config/kitty`, `terminator/.config/terminator`, `tmux/.tmux.conf`, and `zsh/.config/zsh`. Tests and CI fixtures are under `neovim/.config/nvim/tests`. Archived manual installers remain in `tools/archived/`. Fonts and screenshots are in `font-unicode/` and `assets/`.

## Build, Test, and Development Commands
Use the repository root for all commands.

- `./ubuntu.sh` or `./fedora.sh`: install OS prerequisites, then delegate to `bootstrap.sh`.
- `./bootstrap.sh`: install Nix/Home Manager, link `home.nix`, run `home-manager switch`, and then run Stow.
- `./stow-config.sh`: restow package directories after editing dotfiles.
- `home-manager switch --dry-run`: preview Home Manager changes safely.
- `home-manager build`: build the generation without activating it.
- `home-manager switch`: apply updated Nix-managed configuration.
- `neovim/.config/nvim/tests/ci/kotlin_android_ci.sh`: run the Neovim Kotlin/Android checks locally.

## Coding Style & Naming Conventions
Shell scripts should use Bash with `set -euo pipefail` and clear helper logging, matching the existing setup scripts. Lua in Neovim uses `stylua`; the checked-in `stylua.toml` sets 2-space indentation and 120-column width. Keep module names lowercase and descriptive, and follow the existing patterns such as `lua/user/plugins/...` and `tests/spec/*_spec.lua`.

## Testing Guidelines
Automated coverage is concentrated in the Neovim config. Add Lua specs under `neovim/.config/nvim/tests/spec/` with `_spec.lua` suffixes, and keep reusable sample projects in `tests/fixtures/`. When changing Neovim behavior, run the CI shell script locally before opening a PR.

## Commit & Pull Request Guidelines
Recent history favors short, imperative subjects, sometimes with conventional prefixes like `feat:` or `refactor:`. Keep commit titles focused, for example `feat: add fish alias for lazygit` or `fix neovim jdtls setup`.

PRs should describe the affected area (`home-manager`, `neovim`, shell bootstrap, etc.), list manual verification steps, and include screenshots only for visible terminal or UI changes. Call out OS-specific impact when modifying `ubuntu.sh`, `fedora.sh`, or bootstrap logic.
