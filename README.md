# My Dotfiles Workspace

A [chezmoi](https://www.chezmoi.io/)-managed configuration around Fish, Starship, Tmux, WezTerm, and LazyVim using a Tokyo Night theme. Targets WSL2/Arch, native Linux, and macOS from a single source tree.

## Install on a new machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <username>
```

chezmoi clones this repo, detects the machine (`isWSL`, `os`), then installs packages and applies configs via the `run_once_`/`run_onchange_` scripts in `.chezmoiscripts/`. On WSL the Windows username is auto-detected (`wslvar`) to bridge WezTerm + the Lilex Nerd Font to the Windows host.

## Maintenance updates

Run **`dfu`** in any shell to pull the latest dotfiles and re-apply them — it's an alias for `chezmoi update` (pull + apply).
