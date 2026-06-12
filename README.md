# My Dotfiles Workspace

A [chezmoi](https://www.chezmoi.io/)-managed configuration around Fish, Starship, Tmux, WezTerm, and LazyVim using a Tokyo Night theme. Targets WSL2/Arch, native Linux, and macOS from a single source tree.

## Install on a new machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <username>
```

chezmoi clones this repo, detects the machine (`isWSL`, `os`), then installs packages and applies configs via the `run_once_`/`run_onchange_` scripts in `.chezmoiscripts/`. On WSL the Windows username is auto-detected (`wslvar`) to bridge WezTerm + the Lilex Nerd Font to the Windows host.

## Claude Code setup

Captured: `~/.claude/{settings.json,CLAUDE.md,statusline.sh,hooks/git-guard.sh}`, the `~/.claude/skills` symlinks, `~/.agents/.skill-lock.json`, the 4 vendored skills (`use-railway`, `docker-best-practices`, `graphify`, `notebooklm`), and global memory.

On a new machine, `chezmoi apply` also runs:

- `run_once_after_60-claude-skills` — reinstalls the 23 lock-tracked skills via `npx skills`.
- `run_once_after_70-claude-plugins` — re-adds 3 marketplaces + installs 4 plugins via `claude plugin`.
- `run_onchange_after_55-claude-memory` — places memory at the per-OS project path (`/home` vs `/Users`).

**Manual post-steps (not automated):**

- `claude` login (re-auth per machine).
- `uv tool install graphifyy` — runtime for the `graphify` skill.
- `uv tool install "notebooklm-py[browser]"` then `notebooklm login` (+ optional `notebooklm mcp install claude-code`) — runtime for `notebooklm`.
- Obsidian + its Python deps for the `claude-obsidian` plugin.

**Never committed:** `~/.claude/.credentials.json` and any MCP/Google auth — re-auth per machine.

### Capturing Claude changes back into chezmoi

The Claude setup is edited live on this (source) machine, so changes must be re-captured with `chezmoi add` or they won't propagate — and may be **reverted** on the next `dfu`.

> ⚠️ **Gotcha:** Claude Code rewrites `~/.claude/settings.json` itself when you enable/disable plugins. That drifts from the source, so a later `chezmoi apply`/`dfu` would revert your plugin change. Always re-capture settings after touching plugins.

| You changed… | Capture step |
| ------------ | ------------ |
| Added a manifest skill (`npx skills add …`) | `chezmoi add ~/.agents/.skill-lock.json ~/.claude/skills/<name>` |
| Vendored a skill manually | `chezmoi add ~/.agents/skills/<name> ~/.claude/skills/<name>` |
| Enabled/disabled a plugin | `chezmoi add ~/.claude/settings.json` |
| Edited `CLAUDE.md` / a hook / statusline | `chezmoi add <that file>` |
| Updated a memory fact | re-copy into `.chezmoitemplates/claude-memory/` |
| `npx skills update` (refresh manifest skills) | then `chezmoi add ~/.agents/.skill-lock.json` |

After capturing, review and commit in `~/repos/dotfiles`. Verify nothing drifted with `chezmoi diff`.

## Maintenance updates

Run **`dfu`** in any shell to pull the latest dotfiles and re-apply them — it's an alias for `chezmoi update` (pull + apply).
