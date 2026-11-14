# dotfiles

My macOS setup, managed with [chezmoi](https://chezmoi.io). Apps and CLI tools come from Homebrew, language runtimes from [mise](https://mise.jdx.dev), and config files from this repo.

This repo is public, so it never contains secrets, not even encrypted ones. Machine-specific values and tokens live in untracked files (see [After the first apply](#after-the-first-apply)).

## New machine

```sh
# 1. Install Homebrew (https://brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and apply this repo
/opt/homebrew/bin/brew install chezmoi
chezmoi init --apply edborsa/dotfiles
```

`chezmoi apply` runs these scripts in order:

1. **`brew bundle`** installs everything in the [Brewfile](Brewfile). It runs before the dotfiles are written.
2. **`mise install`** installs the global runtimes: Node 22, Python 3.13 and rebar3.
3. **macOS defaults**: key repeat, Dock, Finder and the screenshot location. It restarts Dock, Finder and SystemUIServer.
4. **launchd** loads the weekly `tidy-check` agent.

Each script runs again only when its input changes, for example when the Brewfile changes.

### After the first apply

These steps are manual, because they involve secrets or a login:

- **`~/.zshenv.local`** (untracked, sourced by `~/.zshenv` if present). Put tokens here, for example `JIRA_API_TOKEN` and optionally `GITHUB_TOKEN`, which lifts GitHub's API rate limit for mise.
- **GitHub CLI:** `gh auth login`.
- **Copilot:** `:Copilot auth` in Neovim.
- **GKE:** `gcloud auth login`, then `gcloud components install gke-gcloud-auth-plugin`.
- **Neovim:** the first launch installs plugins (lazy.nvim, pinned by `nvim/lazy-lock.json`) and elixir-ls (Mason).
- **Projects pinning an old Python** (for example 3.11.6): mise rejects builds older than GitHub's attestations, so install those once with `MISE_PYTHON_GITHUB_ATTESTATIONS=false mise install python`. The checksum is still verified.
- **Apps without a Homebrew package:** Tidewave, installed from its GitHub releases.

## Day to day

```sh
chezmoi cd            # open a shell in this repo
chezmoi diff          # preview what apply would change
chezmoi apply         # write changes to ~
chezmoi edit ~/.zshrc # edit a managed file's source
```

- **Add a package:** add it to the Brewfile, then run `chezmoi apply`. Packages are never removed automatically. To remove one, delete it from the Brewfile, then run `brew bundle cleanup --file=Brewfile` by hand (it only lists what it would remove until you add `--force`).
- **Neovim:** `~/.config/nvim` is a symlink into `nvim/` in this repo. Config edits and lazy.nvim's lock file updates show up in `git status` here right away, with no `chezmoi apply` needed.
- **Pinned downloads:** fzf-tab and the tmux plugins are pinned in [`.chezmoiexternal.toml`](.chezmoiexternal.toml). To update one, change its version or commit there.

## What's in here

| Path | Becomes | Notes |
|---|---|---|
| `Brewfile` | — | read by the brew script; never copied to `~` |
| `dot_zshenv`, `dot_zprofile`, `dot_zshrc` | `~/.zsh*` | PATH is set in `.zprofile`: mise first, then `~/.local/bin`, libpq, Homebrew, and gcloud components |
| `dot_config/git/` | `~/.config/git/` | git config with delta, and a global ignore file |
| `dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | prefix `C-s`; plugins load from `~/.config/tmux/plugins` |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | global runtimes; projects pin their own in `.tool-versions` |
| `dot_config/cspell/cspell.json` | `~/.config/cspell/cspell.json` | |
| `dot_config/symlink_nvim.tmpl` | `~/.config/nvim` → `nvim/` | |
| `dot_config/opencode/skills/symlink_elixir.tmpl` | link to `~/projects/companies/minnasoft/agents/skills/elixir` | |
| `dot_docker/modify_config.json` | `~/.docker/config.json` | adds Homebrew's CLI plugin folder (compose, buildx) and keeps everything else |
| `dot_local/bin/` | `~/.local/bin/` | `tat`, `tmux-sessionizer`, `ensure-tmux-is-running`, `tidy-check`, … |
| `Library/LaunchAgents/` | `~/Library/LaunchAgents/` | the `tidy-check` schedule |
| `Documents/…`, `Pictures/Screenshots`, `projects/scratch` | empty folders | the folder layout below |
| `run_*` | — | the setup scripts listed above |

Never managed here: `~/.zshenv.local`, `~/.config/gh`, `~/.config/gcloud`, `~/.config/github-copilot`, opencode's config, and the notes vault.

## Folder layout

| What | Where |
|---|---|
| Code | `~/projects/<org or language>/<name>` |
| Throwaway code | `~/projects/scratch/` |
| Notes (Obsidian vault, synced with Syncthing) | `~/Notes` |
| Books, manuals, reference material | `~/Documents/Library` |
| Ongoing responsibilities (admin, invoices, a job) | `~/Documents/Areas/<area>` |
| Non-code projects with an end | `~/Documents/Projects/<name>` |
| Finished things | `~/Documents/Archive` |
| Scripts | `~/.local/bin` (via this repo) |
| Screenshots | `~/Pictures/Screenshots` |
| Downloads | an inbox only: empty it weekly |

`tidy-check` only reports and never moves anything. It runs every Monday at 09:00 and sends a notification if something is out of place: loose files in `~` or `~/Documents`, unknown folders in `~`, or Downloads and Desktop items older than 14 days. Run `tidy-check` by hand to see the details.
