# Dotfiles Cheat Sheet

Quick reference for this WezTerm + fish + tmux + chezmoi setup. Tokyo Night throughout.

---

## WezTerm (mods = `Ctrl+Shift`)

| Keys                             | Action                                       |
| -------------------------------- | -------------------------------------------- |
| `Ctrl+Shift+D`                   | Split pane **left/right**                    |
| `Ctrl+Shift+E`                   | Split pane **top/bottom**                    |
| `Ctrl+Shift+H` / `J` / `K` / `L` | Focus pane **left / down / up / right**      |
| `Ctrl+Shift+W`                   | Close current pane (confirms)                |
| `Ctrl+Shift+T`                   | New tab                                      |
| `Ctrl+Shift+Tab` / `Ctrl+Tab`    | Previous / next tab _(WezTerm default)_      |
| `Ctrl+Shift+C` / `V`             | Copy / paste _(WezTerm default)_             |
| `Ctrl+Shift+P`                   | Command palette _(WezTerm default)_          |
| `Ctrl+Shift+Space`               | Quick-select / copy mode _(WezTerm default)_ |

On Windows, WezTerm opens straight into the WSL fish session (`default_domain`).

---

## tmux (prefix = `Ctrl+A`)

Press the prefix, release, then the key.

| Keys                           | Action                                      |
| ------------------------------ | ------------------------------------------- |
| `Ctrl+A` `\|`                  | Split window **left/right** (keeps cwd)     |
| `Ctrl+A` `-`                   | Split window **top/bottom** (keeps cwd)     |
| `Ctrl+A` `c`                   | New window (keeps cwd)                      |
| `Ctrl+A` `h` / `j` / `k` / `l` | Select pane left / down / up / right        |
| `Ctrl+A` `Ctrl+A`              | Send literal `Ctrl+A` to the app            |
| `Ctrl+A` `d`                   | Detach session                              |
| `Ctrl+A` `[`                   | Copy mode (scroll/select; `q` to exit)      |
| mouse                          | Enabled — click panes, drag borders, scroll |

Windows/panes are 1-indexed and auto-renumber. CLI: `tmux new -s name`, `tmux ls`, `tmux a -t name`.

> WezTerm panes vs tmux panes: WezTerm panes are local to the Windows app; tmux panes survive across disconnects and live on the Linux side. Use tmux when you want sessions to persist.

---

## Fish aliases

### Git

| Alias | Expands to           |
| ----- | -------------------- |
| `g`   | `git`                |
| `gst` | `git status`         |
| `gaa` | `git add .`          |
| `gd`  | `git diff`           |
| `gp`  | `git push`           |
| `gl`  | `git pull`           |
| `lg`  | `lazygit` (full TUI) |

### Files / editor

| Alias              | Expands to                                                             |
| ------------------ | ---------------------------------------------------------------------- |
| `ll`               | `eza -l --icons --git --group-directories-first --time-style=long-iso` |
| `la`               | `eza -la …` (incl. hidden)                                             |
| `lt`               | `eza --tree --level=2 --icons`                                         |
| `cat`              | `bat --style=plain` (syntax-highlighted)                               |
| `v` / `vim` / `vi` | `nvim`                                                                 |

### Dotfiles

| Alias | Expands to                                          |
| ----- | --------------------------------------------------- |
| `dfu` | `dotfiles_update` → `chezmoi update` (pull + apply) |

---

## Fish functions (git worktrees)

| Command           | What it does                                                               |
| ----------------- | -------------------------------------------------------------------------- |
| `gwa <branch>`    | Create a worktree at `../<branch>` on a new branch `<branch>`              |
| `gwr <name>`      | Remove the worktree at `../<name>`; optionally delete the branch (prompts) |
| `dotfiles_update` | `chezmoi update` — pull latest dotfiles and re-apply                       |

---

## chezmoi workflow

| Command                                   | What it does                                     |
| ----------------------------------------- | ------------------------------------------------ |
| `chezmoi diff`                            | Preview pending changes (empty = in sync)        |
| `chezmoi apply`                           | Apply source → home                              |
| `chezmoi apply --exclude scripts`         | Apply config files only, skip run scripts        |
| `chezmoi update`                          | `git pull` in source, then apply (this is `dfu`) |
| `chezmoi edit ~/.config/fish/config.fish` | Edit the **source** of a managed file            |
| `chezmoi cd`                              | Drop into the source repo (`~/repos/dotfiles`)   |
| `chezmoi managed`                         | List files chezmoi controls                      |
| `chezmoi re-add`                          | Pull home-side edits back into the source        |

Source tree lives at `~/repos/dotfiles`. Per-machine data: `isWSL`, `os` (auto-detected at init).

### New machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <username>
```

---

## Navigation & search tools

| Command      | What it does                         |
| ------------ | ------------------------------------ |
| `z <dir>`    | Jump to a frecent directory (zoxide) |
| `zi`         | Interactive zoxide picker            |
| `fd <pat>`   | Fast file find (respects .gitignore) |
| `rg <pat>`   | ripgrep — fast content search        |
| `bat <file>` | Pager with syntax highlighting       |
| `eza`        | Modern `ls` (see `ll`/`la`/`lt`)     |

### fzf.fish keybindings _(plugin defaults)_

| Keys         | Search              |
| ------------ | ------------------- |
| `Ctrl+R`     | Command history     |
| `Ctrl+Alt+F` | Files / directories |
| `Ctrl+Alt+L` | Git log             |
| `Ctrl+Alt+S` | Git status (files)  |
| `Ctrl+Alt+P` | Processes           |
| `Ctrl+V`     | Shell variables     |

---

## Runtimes

| Command                               | What it does                                                   |
| ------------------------------------- | -------------------------------------------------------------- |
| `fnm use <ver>` / `fnm default <ver>` | Switch / set default Node (auto-switches on `cd` via `.nvmrc`) |
| `ruby` / `gem` / `bundle`             | Lazy-init rbenv on first call (no startup cost)                |
| `uv …`                                | Python package/venv manager (completions loaded)               |

---

## Maintenance

- **Update everything:** `dfu`
- **Retheme colors:** edit `.chezmoidata/colors.toml` (single Tokyo Night Moon palette), then `chezmoi apply` — updates WezTerm, starship, tmux, and fzf together
- **Edit a config so it's tracked:** `chezmoi edit <target>` then commit in `~/repos/dotfiles`
- **Update fish plugins:** edit `dot_config/fish/fish_plugins`, then `chezmoi apply` (the `run_onchange` hook runs `fisher update`)
