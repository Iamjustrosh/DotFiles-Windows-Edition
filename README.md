# Windows Zsh Setup

A minimal, reproducible Windows terminal setup using **MSYS2 UCRT64 + Zsh**.

This repository is the source of truth for rebuilding the shell on a new Windows device.

## Stack

```text
Windows Terminal / VS Code / WezTerm
                ↓
          MSYS2 UCRT64
                ↓
               Zsh
        ┌───────┴────────┐
   Oh My Zsh          Zinit
   arch_end theme      plugins
        │
        ├── fzf
        ├── zoxide
        ├── eza
        ├── bat
        ├── fd
        ├── ripgrep
        ├── fastfetch
        └── Bun / Node
```

> This is not WSL. Linux can be learned/setup separately later.

## Repository

```text
.
├── README.md
├── docs/
│   ├── TOOLS.md
│   ├── CONFIG.md
│   └── TROUBLESHOOTING.md
├── .zshrc
├── arch_end.zsh-theme
├── fastfetch/
│   ├── config.jsonc
│   └── images/
│       └── logo.png
├── starship.toml
└── vsc export/
    └── vsc-extensions.txt
```

## Fresh Device Setup

### 1. Install MSYS2

Install MSYS2, open **UCRT64**, then update it:

```bash
pacman -Syu
```

Reopen MSYS2 and repeat if the update asks you to close the terminal.

Install the packages needed by this setup. Package names can change over time, so search with `pacman -Ss <tool>` if one is unavailable.

```bash
pacman -S --needed   git zsh   mingw-w64-ucrt-x86_64-fzf   mingw-w64-ucrt-x86_64-zoxide   mingw-w64-ucrt-x86_64-eza   mingw-w64-ucrt-x86_64-bat   mingw-w64-ucrt-x86_64-fd   mingw-w64-ucrt-x86_64-ripgrep   mingw-w64-ucrt-x86_64-fastfetch
```

Verify:

```bash
echo $MSYSTEM
```

Expected:

```text
UCRT64
```

### 2. Install Oh My Zsh

Install Oh My Zsh into:

```text
~/.oh-my-zsh
```

The active prompt is the custom `arch_end` theme.

Copy:

```text
repo/arch_end.zsh-theme
```

to:

```text
~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
```

The Arch icon in the prompt requires a **Nerd Font** in the terminal.

### 3. Install Zinit

Install Zinit into:

```text
~/.local/share/zinit/zinit.git
```

The `.zshrc` loads it automatically. Zinit then installs/loads:

```text
zsh-completions
zsh-autosuggestions
zsh-history-substring-search
fzf-tab
```

Do not enable `zsh-syntax-highlighting` in this setup; it caused severe typing lag under MSYS2.

### 4. Restore the Repository Config

Copy the repository `.zshrc`:

```bash
cp /path/to/repo/.zshrc ~/.zshrc
```

Copy Fastfetch:

```bash
mkdir -p ~/.config/fastfetch/images

cp /path/to/repo/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp /path/to/repo/fastfetch/images/logo.png ~/.config/fastfetch/images/logo.png
```

Optional Starship config:

```bash
cp /path/to/repo/starship.toml ~/.config/starship.toml
```

Starship is currently kept as an alternative; `arch_end` is the active prompt.

### 5. Configure Windows Terminal

Use MSYS2's launcher so the shell starts inside **UCRT64**, instead of launching `zsh.exe` directly.

```json
{
    "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64 -use-full-path -shell zsh",
    "name": "Zsh (MSYS2 UCRT64)",
    "startingDirectory": "%USERPROFILE%"
}
```

### 6. Configure VS Code Terminal

In `settings.json`:

```json
"terminal.integrated.profiles.windows": {
    "MSYS2 Zsh": {
        "path": "C:\\msys64\\msys2_shell.cmd",
        "args": [
            "-defterm",
            "-here",
            "-no-start",
            "-ucrt64",
            "-use-full-path",
            "-shell",
            "zsh"
        ]
    }
},
"terminal.integrated.defaultProfile.windows": "MSYS2 Zsh",
"terminal.integrated.enableImages": true
```

Open a new terminal and verify:

```bash
echo $MSYSTEM
echo $TERM_PROGRAM
```

### 7. Restore VS Code Extensions

The repository contains:

```text
vsc export/vsc-extensions.txt
```

Export on the current machine:

```powershell
code --list-extensions > vsc-extensions.txt
```

Restore on a new machine:

```powershell
Get-Content .\vsc-extensions.txt | ForEach-Object { code --install-extension $_ }
```

### 8. Node and Bun

Install Node.js normally for Windows if it is not already installed.

Bun is also used and can coexist with Node/npm. No Node version manager is part of this setup yet.

Verify:

```bash
node --version
npm --version
bun --version
```

### 9. Validate Everything

```bash
echo $MSYSTEM
zsh --version
git --version
zinit version
fzf --version
zoxide --version
eza --version
bat --version
fd --version
rg --version
fastfetch --version
node --version
bun --version
```

Then validate and reload Zsh:

```bash
zsh -n ~/.zshrc
exec zsh
```

## Tools — Quick Reference

| Tool | Why it is here | Basic use |
|---|---|---|
| **Zsh** | Main interactive shell; better completion/customization than the default shell for this workflow. | `zsh`, `exec zsh` |
| **Oh My Zsh** | Organizes Zsh themes/plugins and provides Git helpers. | Configured through `.zshrc` |
| **Zinit** | Lightweight plugin manager; avoids manually cloning/sourcing every Zsh plugin. | `zinit status`, `zinit update` |
| **FZF** | Fuzzy search instead of manually scrolling/searching lists. | `Ctrl+R`, `fzf` |
| **Zoxide** | Learns visited directories and provides faster navigation than repeated long `cd` paths. | `z project`, `zi` |
| **eza** | More readable modern `ls` with tree/metadata support. | `ll`, `la`, `lt` |
| **bat** | Better file viewer than plain `cat`, with formatting and syntax highlighting. | `bat file.js` |
| **fd** | Simpler everyday file search than traditional `find`. | `fd README` |
| **ripgrep** | Very fast project text search and cleaner replacement for common `grep -R` usage. | `rg "useState"` |
| **Fastfetch** | Quick system/environment overview and custom terminal logo. | `ff` |
| **Bun** | Fast JS/TS runtime/package tooling where projects support it. | `bi`, `brd`, `bunx` |
| **Git** | Version control and repository workflow. | `git status` |

Useful modern replacements:

```text
ls       → eza
cat      → bat
find     → fd
grep -R  → rg
long cd  → zoxide
history  → fzf / Ctrl+R
```

## Navigation

Two different features are available:

**AUTO_CD** handles real paths/directories:

```bash
Documents
../
~/Downloads
```

It does not learn anything.

**Zoxide** learns directories you visit and can jump to them from elsewhere:

```bash
z meena
z project
zi
```

Use `cd` normally at first; Zoxide automatically learns those visits.

## Fastfetch

The logo is stored at:

```text
~/.config/fastfetch/images/logo.png
```

Current rendering:

```text
VS Code          → iTerm image protocol
WezTerm          → iTerm image protocol
Windows Terminal → Sixel
```

The `.zshrc` handles terminal detection. Do not replace the terminal-aware `ff()` function with an `ff='fastfetch'` alias.

## Everyday Commands

```bash
ll              # detailed files
la              # include hidden files
lt              # directory tree

z project       # smart directory jump
zi              # interactive directory picker
Ctrl+R          # fuzzy history

rg "text"       # search project contents
fd filename     # search files
bat file        # view file

zshrc           # open .zshrc
zshcheck        # validate .zshrc
reload          # restart Zsh

bi              # bun install
brd             # bun run dev
brb             # bun run build
```

## Maintenance

After changing `.zshrc`:

```bash
zshcheck
reload
```

Before pushing changes, test:

```bash
zinit status
z Documents
zi
ll
ff
```

Also test Fastfetch in each terminal you use.

Keep secrets and machine-specific private values out of this repository.

## More Documentation

- [`docs/TOOLS.md`](docs/TOOLS.md) — what each tool/plugin does and how to use it.
- [`docs/CONFIG.md`](docs/CONFIG.md) — file locations, aliases, functions, history, prompts and Fastfetch behavior.
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) — fixes for the MSYS2/Zoxide/Zinit/Fastfetch issues encountered while building this setup.
