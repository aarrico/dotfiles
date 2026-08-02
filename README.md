# My Dotfiles Workspace

A [chezmoi](https://www.chezmoi.io/)-managed configuration around Fish, Starship, Tmux, Ghostty/WezTerm, and LazyVim using the [City Lights](https://citylights.xyz/) theme. Targets WSL2/Arch, native Linux, and macOS from a single source tree.

## Where things live

Filenames follow chezmoi's naming contract — `dot_` becomes `.`, `symlink_` becomes a symlink, `executable_` sets `+x`, and `.chezmoi*` are special directories. Don't rename them.

| I want to change…            | Edit this                              |
| ---------------------------- | -------------------------------------- |
| **Colors (everything)**      | `.chezmoidata/colors.toml`             |
| Terminal — native Linux/mac  | `dot_config/ghostty/config.tmpl`       |
| Terminal — Windows/WSL2      | `dot_config/wezterm/wezterm.lua.tmpl`  |
| Prompt                       | `dot_config/starship.toml.tmpl`        |
| Shell config / aliases       | `dot_config/fish/config.fish.tmpl`     |
| Shell functions (`dfu`, `gwa`) | `dot_config/fish/functions/`         |
| Tmux                         | `dot_config/tmux/tmux.conf.tmpl`       |
| Neovim                       | `dot_config/nvim/`                     |
| Packages & bootstrap         | `.chezmoiscripts/`                     |
| Claude settings / hooks      | `dot_claude/`                          |
| Claude memory facts          | `.chezmoitemplates/claude-memory/`     |
| Which terminal a machine gets | `.chezmoiignore`                      |

Every terminal, prompt, and tmux config templates its colors off `colors.toml`. Change a hex there, run `chezmoi apply`, and the whole setup follows.

## Install on a new machine

Install chezmoi via your package manager if available, or download the executable and initialize the setup.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <username>
```

chezmoi clones this repo, detects the machine (`isWSL`, `os`), then installs packages and applies configs via the `run_once_`/`run_onchange_` scripts in `.chezmoiscripts/`. On WSL the Windows username is auto-detected (`wslvar`) to bridge WezTerm + the Lilex Nerd Font to the Windows host.

## Maintenance updates

Run **`dfu`** in any shell to pull the latest dotfiles and re-apply them — it's an alias for `chezmoi update` (pull + apply).
