# dotfiles

My macOS setup, managed with [chezmoi](https://chezmoi.io). Apps and CLI tools come from Homebrew, language runtimes from [mise](https://mise.jdx.dev), and config files from this repo.

This repo is public, so it never contains secrets, not even encrypted ones. Machine-specific values and tokens live in untracked files (see [After the first apply](#after-the-first-apply)).

## New machine

```sh
# 1. Install Homebrew (https://brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and apply this repo
/opt/homebrew/bin/brew install chezmoi
/opt/homebrew/bin/brew tap xoshbin/asyar && /opt/homebrew/bin/brew trust --tap xoshbin/asyar   # third-party tap in the Brewfile; Homebrew 6+ requires trusting it
chezmoi init --apply edborsa/dotfiles
```

`chezmoi apply` runs these scripts in order:

1. **`brew bundle`** installs everything in the [Brewfile](Brewfile). It runs before the dotfiles are written.
2. **`mise install`** installs the global runtimes: Erlang 29.1.2, Elixir 1.20.5, Go 1.27.4, Lua 5.5.1, Node 26.13.1, Python 3.15.2, Ruby 4.0.10, Rust (latest) and rebar3.
3. **macOS defaults**: key repeat, Dock, Finder and the screenshot location. It restarts Dock, Finder and SystemUIServer.
4. **launchd** loads every `com.edborsa.*` agent: the weekly `tidy-check`, and login launchers for Rex, Asyar, Vorssaint and Tailscale.

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
- **Pinned downloads:** fzf-tab is pinned in [`.chezmoiexternal.toml`](.chezmoiexternal.toml). To update it, change its version there.

## What's in here

| Path | Becomes | Notes |
|---|---|---|
| `Brewfile` | — | read by the brew script; never copied to `~` |
| `dot_zshenv`, `dot_zprofile`, `dot_zshrc` | `~/.zsh*` | PATH is set in `.zprofile`: mise first, then `~/.local/bin`, libpq, Homebrew, and gcloud components |
| `dot_config/git/` | `~/.config/git/` | git config with delta, and a global ignore file |
| `dot_config/rex/init.lua` | `~/.config/rex/init.lua` | Rex terminal multiplexer (replaces tmux); prefix `ctrl+s` |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | global runtimes; projects pin their own in `.tool-versions` |
| `dot_config/cspell/cspell.json` | `~/.config/cspell/cspell.json` | |
| `dot_config/symlink_nvim.tmpl` | `~/.config/nvim` → `nvim/` | |
| `dot_config/opencode/skills/symlink_elixir.tmpl` | link to the Minnasoft agents repo's Elixir skill | |
| `dot_docker/modify_config.json` | `~/.docker/config.json` | adds Homebrew's CLI plugin folder (compose, buildx) and keeps everything else |
| `dot_local/bin/` | `~/.local/bin/` | `tidy-check`, `clean-zsh-history`, `fzf-history-call`, … |
| `Library/LaunchAgents/` | `~/Library/LaunchAgents/` | the `tidy-check` schedule; Rex, Asyar, Vorssaint and Tailscale start at login |
| `Documents/…`, `Pictures/Screenshots` | empty folders | the Johnny.Decimal skeleton below |
| `run_*` | — | the setup scripts listed above |

Never managed here: `~/.zshenv.local`, `~/.config/gh`, `~/.config/gcloud`, `~/.config/github-copilot`, opencode's config, and the notes vault.

## Folder layout

Everything I file by hand, code included, lives in a [Johnny.Decimal](https://johnnydecimal.com) system in `~/Documents`. It has up to 10 areas, each with up to 10 categories, and IDs inside those. Names use underscores, never spaces, so code paths stay safe for tools.

```
~/Documents/
├── 00-09_System/
│   ├── 01_Inbox/        # things to file
│   ├── 02_Home/         # the home repo: agent instructions, skills, and the index of IDs (jdex.md)
│   └── 03_Scratch/      # throwaway code
├── 10-19_Work/
│   └── 11_<Company>/
│       ├── 11.01_<Topic>/   # documents get IDs
│       └── <repo>/          # git repos keep their own name (Docker Compose names volumes after it)
├── 20-29_Personal/      # 21_Finance, 22_Health, 23_Home, …
└── 30-39_Learning/      # 31_Books, 32_Courses, 33_Reference, …
```

Outside the system:

| What | Where | Why |
|---|---|---|
| Notes (Obsidian vault, synced with Syncthing) | `~/Notes` | Syncthing and Obsidian rely on this path |
| Screenshots, photos, recordings | `~/Pictures`, `~/Movies` | macOS apps write there |
| Scripts | `~/.local/bin` (via this repo) | |
| This repo | `~/.local/share/chezmoi` | chezmoi's default |
| Downloads | `~/Downloads` | an inbox only: empty it weekly |

`tidy-check` only reports and never moves anything. It runs every Monday at 09:00 and sends a notification if something is out of place:

- loose files in `~` or `~/Documents`;
- unknown folders in `~`;
- anything at the top of `~/Documents` that isn't an `NN-NN_Name` area;
- Downloads and Desktop items older than 14 days.

Run `tidy-check` by hand to see the details.
