# Windows Zsh Development Environment

A reference and backup for my Windows terminal setup using **MSYS2 UCRT64 + Zsh**.

This repository exists so I can restore the environment on another machine, remember why each tool is installed, and maintain my terminal configuration without having to reconstruct the setup from scratch.

---

## 1. Final Stack

```text
Windows
├── Windows Terminal
├── WezTerm
└── VS Code Integrated Terminal
        │
        ▼
   MSYS2 UCRT64
        │
        ▼
       Zsh
        │
        ├── Oh My Zsh
        │   ├── Git plugin
        │   └── arch_end theme
        │
        ├── Zinit
        │   ├── zsh-autosuggestions
        │   ├── zsh-history-substring-search
        │   ├── zsh-completions
        │   └── fzf-tab
        │
        ├── FZF
        ├── Zoxide
        ├── eza
        ├── bat
        ├── fd
        ├── ripgrep
        ├── Bun
        └── Fastfetch
```

This is **not WSL**. Zsh runs through MSYS2's UCRT64 environment on Windows.

---

## 2. Repository Structure

Current repository:

```text
.
├── arch_end.zsh-theme
├── fastfetch/
│   └── config.jsonc
├── starship.toml
└── vsc export/
    └── vsc-extensions.txt
```

Recommended addition:

```text
.
├── README.md
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

Do not commit secrets, API keys, tokens, passwords, or machine-specific private values.

---

## 3. What Each File Is

### `.zshrc`

Main Zsh configuration.

It controls:

- environment variables
- Zsh options
- command history
- Zinit
- Oh My Zsh
- plugins
- aliases
- functions
- FZF
- Zoxide
- prompt selection
- Fastfetch startup and terminal detection

Runtime location:

```text
~/.zshrc
```

After editing it:

```bash
zsh -n ~/.zshrc
exec zsh
```

Aliases configured for this:

```bash
zshrc      # open ~/.zshrc in VS Code
zshcheck   # syntax-check ~/.zshrc
reload     # restart Zsh
```

---

### `arch_end.zsh-theme`

Current Oh My Zsh prompt theme.

```zsh
# Simple Arch End Theme
# %n = user, %~ = directory, %f = reset color
PROMPT='%{$fg[green]%}%n%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%} %{$fg[cyan]%}%{$reset_color%} \$ '
```

It produces approximately:

```text
rosha:~/Documents  $
```

Install/copy it to:

```text
~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
```

Then enable it in `.zshrc`:

```zsh
ZSH_THEME="arch_end"
```

The Arch glyph requires a Nerd Font.

---

### `starship.toml`

Alternative prompt configuration.

Current config:

```toml
add_newline = true

[directory]
truncation_length = 3

[git_branch]
symbol = " "

[git_status]
disabled = false

[cmd_duration]
min_time = 2000
show_milliseconds = false
```

Runtime location:

```text
~/.config/starship.toml
```

Starship is currently **not the active prompt**.

To switch from `arch_end` to Starship:

```zsh
ZSH_THEME=""
```

Then enable:

```zsh
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
```

Do not intentionally run both prompt systems at the same time.

---

### `fastfetch/config.jsonc`

Controls the Fastfetch information layout and default logo.

Runtime location:

```text
~/.config/fastfetch/config.jsonc
```

Logo runtime location:

```text
~/.config/fastfetch/images/logo.png
```

The current default logo protocol is **iTerm**.

The `.zshrc` overrides the protocol when required by the terminal.

---

### `vsc export/vsc-extensions.txt`

Backup of installed VS Code extensions.

Export extensions with:

```powershell
code --list-extensions > vsc-extensions.txt
```

Restore them from PowerShell:

```powershell
Get-Content .\vsc-extensions.txt | ForEach-Object { code --install-extension $_ }
```

---

## 4. Install MSYS2

Install MSYS2 and use the **UCRT64 environment**, not the plain MSYS environment, for the development shell.

The important distinction is:

```text
MSYS
└── Unix compatibility environment

UCRT64
└── Native Windows development environment using UCRT
```

Our Zsh setup uses UCRT64 so native development tools from `/ucrt64/bin` are available.

Update packages:

```bash
pacman -Syu
```

If MSYS2 asks to close the terminal during a core update, reopen it and run the update again.

---

## 5. Launch Zsh Through UCRT64

Do not launch `zsh.exe` in isolation.

The intended startup chain is:

```text
Terminal
   ↓
msys2_shell.cmd
   ↓
UCRT64 environment
   ↓
Zsh
```

Example Windows Terminal profile:

```json
{
    "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64 -use-full-path -shell zsh",
    "name": "Zsh (MSYS2 UCRT64)",
    "startingDirectory": "%USERPROFILE%"
}
```

The important flag is:

```text
-ucrt64
```

not:

```text
-msys
```

Verify after opening Zsh:

```bash
echo $MSYSTEM
```

Expected:

```text
UCRT64
```

---

## 6. VS Code Integrated Terminal

VS Code should also launch the complete MSYS2 UCRT64 environment rather than calling Zsh directly.

Example `settings.json`:

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

After changing the profile, kill old integrated terminals and create a new one.

Verify:

```bash
echo $MSYSTEM
echo $TERM_PROGRAM
```

Expected:

```text
UCRT64
vscode
```

Launching Zsh directly without MSYS2 initialization can cause commands from the UCRT64 environment to appear missing.

---

## 7. WezTerm

WezTerm can use the same MSYS2 UCRT64 → Zsh chain.

Example `.wezterm.lua`:

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = {
  'C:\\msys64\\msys2_shell.cmd',
  '-defterm',
  '-here',
  '-no-start',
  '-ucrt64',
  '-use-full-path',
  '-shell',
  'zsh',
}

config.font_size = 11.0

config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

config.window_background_opacity = 0.94

return config
```

The Zsh configuration remains the same regardless of whether the host is WezTerm, Windows Terminal, or VS Code.

---

## 8. Oh My Zsh

Oh My Zsh is the Zsh framework used by this setup.

Runtime directory:

```text
~/.oh-my-zsh
```

Configured in `.zshrc`:

```zsh
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
)

ZSH_THEME="arch_end"

source "$ZSH/oh-my-zsh.sh"
```

The `git` plugin provides Git aliases and helper functionality.

Only source Oh My Zsh **once** in `.zshrc`.

---

## 9. Zinit

Zinit is the plugin manager.

Runtime location:

```text
~/.local/share/zinit/zinit.git
```

The `.zshrc` loads it with:

```zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
else
    echo "Zinit not found at: $ZINIT_HOME"
fi
```

Useful checks:

```bash
type zinit
zinit version
zinit status
```

Plugins currently used:

```zsh
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab
```

`zsh-completions` is loaded before Oh My Zsh initializes its completion system.

---

## 10. Zsh Plugins

### Autosuggestions

```text
zsh-users/zsh-autosuggestions
```

Shows suggestions from command history while typing.

Example:

```text
git sta...
    ↓
git status
```

---

### History Substring Search

```text
zsh-users/zsh-history-substring-search
```

Type part of an old command and use Up/Down to search matching history.

Configured keys:

```zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
```

---

### zsh-completions

```text
zsh-users/zsh-completions
```

Adds completion definitions beyond Zsh's built-in completion set.

---

### fzf-tab

```text
Aloxaf/fzf-tab
```

Turns many normal TAB completion lists into an interactive fuzzy selector.

Examples:

```text
cd <TAB>
git switch <TAB>
```

---

### Syntax Highlighting — Disabled

`zsh-syntax-highlighting` was tested but caused severe per-keystroke input lag under this MSYS2 Zsh environment.

Keep it disabled:

```zsh
# zinit light zsh-users/zsh-syntax-highlighting
```

Responsiveness is more important than command coloring.

---

### Auto Notify — Optional/Disabled

`zsh-auto-notify` can notify when long-running commands finish.

It is not currently part of the active setup:

```zsh
# zinit light MichaelAquilina/zsh-auto-notify
```

It should only be enabled after verifying Windows/MSYS2 notification behavior.

---

## 11. History

Persistent history lives at:

```text
~/.config/zsh/history
```

Current configuration keeps up to 50,000 commands:

```zsh
HISTFILE="$HOME/.config/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
```

Important options:

```zsh
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
```

This gives persistent, shared, cleaner history across terminals.

---

## 12. FZF

FZF is the fuzzy finder.

Zsh integration:

```zsh
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
```

Most useful shortcut:

```text
Ctrl + R
```

This opens fuzzy command-history search.

FZF is also used by `fzf-tab` and Zoxide's interactive selector.

---

## 13. Zoxide

Zoxide is a smarter directory jumper that learns frequently visited directories.

Examples:

```bash
z Documents
z project
```

List its database:

```bash
zoxide query -l
```

Interactive selector:

```bash
zi
```

### MSYS2 Fix

The native UCRT64 Zoxide initialization generated an incorrect path conversion involving Zsh's builtin `pwd`.

The working override is:

```zsh
__zoxide_pwd() {
    builtin pwd -L
}
```

### `zi` Conflict

Zinit also defines `zi` as an alias.

We want:

```text
zinit → plugin manager
z     → Zoxide jump
zi    → Zoxide interactive selector
```

Therefore:

```zsh
unalias zi 2>/dev/null

function zi {
    __zoxide_zi "$@"
}
```

This collision is important to remember if the setup is rebuilt.

---

## 14. Modern CLI Tools

The environment uses modern CLI utilities including:

```text
eza       modern ls
bat       modern cat/file viewer
fd        simpler/faster file finder
ripgrep   fast recursive text search (rg)
fzf       fuzzy finder
zoxide    smart directory navigation
fastfetch system information
```

Useful checks:

```bash
which eza
which bat
which fd
which rg
which fzf
which zoxide
which fastfetch
```

---

## 15. Aliases

### Navigation

```bash
..          # cd ..
...         # cd ../..
....        # cd ../../..
home        # cd ~
desktop     # ~/Desktop
downloads   # ~/Downloads
documents   # ~/Documents
```

### eza

```bash
ll          # eza -lah
la          # eza -a
lt          # tree, two levels
lta         # tree including hidden files
```

### Zsh

```bash
zshrc       # open ~/.zshrc
zshcheck    # validate .zshrc syntax
reload      # exec zsh
```

### Development

```bash
c.          # code .
npmi        # npm install
nerd        # npm run dev
```

### Bun

Bun is already installed.

Aliases:

```bash
bi          # bun install
br          # bun run
brd         # bun run dev
brb         # bun run build
bx          # bunx
```

### Utilities

```bash
c           # clear
duh         # du -h
path        # print PATH one entry per line
copy        # Windows clipboard input
```

Example:

```bash
pwd | copy
```

---

## 16. Custom Functions

### `mkcd`

Create and enter a directory:

```bash
mkcd new-project
```

Equivalent to:

```bash
mkdir -p new-project
cd new-project
```

### `open`

Open Explorer:

```bash
open
open .
open ~/Downloads
```

### `paste`

Print Windows clipboard contents:

```bash
paste
```

### `winpath`

Convert an MSYS path to Windows:

```bash
winpath /c/Users/rosha/Documents
```

Example result:

```text
C:\Users\rosha\Documents
```

With no argument it converts `$PWD`.

### `unixpath`

Convert Windows path syntax to MSYS:

```bash
unixpath 'C:\Users\rosha\Documents'
```

Result:

```text
/c/Users/rosha/Documents
```

### `extract`

Single function for common archives:

```bash
extract file.zip
extract file.tar.gz
extract file.tar.xz
```

---

## 17. Fastfetch

Fastfetch runs automatically when Zsh starts.

The logo file is:

```text
~/.config/fastfetch/images/logo.png
```

The source image can be high resolution; the important part is the rendering protocol used by the terminal.

### Why Chafa Was Not Used

Chafa was tested first.

It converts images into colored terminal character cells, which made the logo visibly pixelated/character-based.

For a smooth image, use an actual terminal image protocol instead.

### Terminal Protocols

The working setup is:

```text
WezTerm          → iTerm
VS Code          → iTerm
Windows Terminal → Sixel
```

The Fastfetch config defaults to iTerm.

The `.zshrc` detects the current host and overrides Windows Terminal to Sixel.

Detection order matters because VS Code may inherit `WT_SESSION` when launched from Windows Terminal.

Therefore detect:

```text
1. VS Code
2. WezTerm
3. Windows Terminal
4. fallback
```

Example logic:

```zsh
unalias ff 2>/dev/null

FASTFETCH_LOGO="C:/msys64/home/rosha/.config/fastfetch/images/logo.png"

ff() {
    if ! command -v fastfetch >/dev/null 2>&1; then
        echo "fastfetch is not installed"
        return 1
    fi

    if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        fastfetch \
            --logo-type iterm \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    elif [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
        fastfetch \
            --logo-type iterm \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    elif [[ -n "$WT_SESSION" ]]; then
        fastfetch \
            --logo-type sixel \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    else
        fastfetch
    fi
}
```

### `ff` Alias Collision

An earlier `ff='fastfetch'` alias caused:

```text
defining function based on alias `ff'
parse error near `()'
```

Before declaring the `ff()` function:

```zsh
unalias ff 2>/dev/null
```

Do not keep a later `alias ff='fastfetch'` if `ff()` is being used as the terminal-aware function.

---

## 18. Fastfetch Config

Current configuration:

```jsonc
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",

    "logo": {
        "type": "iterm",
        "source": "C:/msys64/home/rosha/.config/fastfetch/images/logo.png",
        "width": 30,
        "height": 15,
        "preserveAspectRatio": true,
        "padding": {
            "right": 3
        }
    },

    "display": {
        "separator": "  "
    },

    "modules": [
        "title",
        "separator",
        { "type": "os", "key": "OS" },
        { "type": "host", "key": "Host" },
        { "type": "kernel", "key": "Kernel" },
        { "type": "uptime", "key": "Uptime" },
        { "type": "shell", "key": "Shell" },
        { "type": "terminal", "key": "Terminal" },
        { "type": "cpu", "key": "CPU" },
        { "type": "gpu", "key": "GPU" },
        { "type": "memory", "key": "Memory" },
        { "type": "disk", "key": "Disk" },

        {
            "type": "command",
            "key": "Node",
            "text": "node --version"
        },

        {
            "type": "command",
            "key": "Git",
            "text": "git --version"
        },

        "break",
        "colors"
    ]
}
```

---

## 19. `.zshrc.local`

Optional machine-specific configuration can live in:

```text
~/.zshrc.local
```

Load it from `.zshrc`:

```zsh
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi
```

Use it for machine-specific aliases, PATH additions, and local settings.

Do **not** commit secrets to the public dotfiles repository.

---

## 20. Bun

Bun is already installed and can coexist with Node/npm.

Check:

```bash
bun --version
which bun
```

Current shortcuts:

```bash
bi
br
brd
brb
bx
```

No additional shell framework is required just to use Bun.

---

## 21. Node Version Management

NVM was intentionally **not added yet**.

The reason is that this environment combines:

```text
Windows + MSYS2 UCRT64 + Zsh
```

and there are different Node version-management approaches for native Windows and POSIX environments.

The current Node/npm installation works, so do not introduce a version manager until a project actually requires switching Node versions.

When needed, investigate the Windows/MSYS2 implications before changing the existing Node PATH.

---

## 22. `remaining_days`

Not installed.

This is simply a custom convenience function for calculating the number of days between today and a target date.

Conceptually:

```text
target date
   -
today
   ↓
difference in seconds
   ↓
divide by 86400
   ↓
days remaining
```

Example interface:

```bash
remaining_days 2026-12-31
```

It is unrelated to Zsh functionality itself and was intentionally omitted.

---

## 23. Useful Diagnostics

### What shell am I using?

```bash
echo $0
echo $SHELL
```

### Am I in UCRT64?

```bash
echo $MSYSTEM
echo $MINGW_PREFIX
```

Expected:

```text
UCRT64
/ucrt64
```

### Where is a command coming from?

```bash
which zsh
which node
which npm
which bun
which fastfetch
```

For aliases/functions/builtins, use:

```bash
type ff
type zi
type zinit
```

### Show every definition/location

```bash
type -a <command>
```

### Inspect PATH

```bash
path
```

### Check Zinit

```bash
zinit version
zinit status
```

### Check `.zshrc`

```bash
zshcheck
```

### Restart cleanly

```bash
reload
```

---

## 24. Common Problems We Encountered

### `zinit light` succeeds but plugin appears unloaded

Verify Zinit itself:

```bash
type zinit
zinit version
zinit status
```

Do not rely on only checking plugin directories manually.

---

### Syntax highlighting makes every keystroke slow

Disable:

```zsh
zsh-users/zsh-syntax-highlighting
```

It caused unacceptable interactive latency in this MSYS2 environment.

---

### Zoxide prints a broken path such as `C:\builtin pwd -L`

Use the custom:

```zsh
__zoxide_pwd() {
    builtin pwd -L
}
```

---

### `zi` launches Zinit instead of Zoxide

Zinit owns an alias named `zi`.

Fix:

```zsh
unalias zi 2>/dev/null
```

then define the Zoxide `zi` function.

---

### `defining function based on alias 'zi'` / `'ff'`

Zsh cannot safely define the intended function while an alias with the same name is active.

Use:

```zsh
unalias zi 2>/dev/null
unalias ff 2>/dev/null
```

before the corresponding function declarations.

---

### VS Code says commands are missing

Ensure VS Code launches:

```text
msys2_shell.cmd → -ucrt64 → zsh
```

instead of launching Zsh directly.

Then verify:

```bash
echo $MSYSTEM
echo $PATH
```

---

### Fastfetch shows Windows ASCII logo instead of the PNG

Run:

```bash
fastfetch --show-errors
```

During setup this exposed missing image dependencies and rendering problems.

---

### Fastfetch PNG looks pixelated

If using Chafa, this is expected: Chafa converts the image to character cells.

Use terminal image protocols instead:

```text
iTerm → WezTerm / VS Code
Sixel → Windows Terminal
```

---

### VS Code accidentally gets Sixel

VS Code may inherit `WT_SESSION`.

Check `TERM_PROGRAM=vscode` **before** testing `WT_SESSION` in the Fastfetch function.

---

## 25. Restore Checklist

When rebuilding this environment:

```text
[ ] Install MSYS2
[ ] Update MSYS2 packages
[ ] Use UCRT64 environment
[ ] Install Zsh
[ ] Install Git/base CLI tools
[ ] Install Oh My Zsh
[ ] Install Zinit
[ ] Install FZF
[ ] Install Zoxide
[ ] Install eza
[ ] Install bat
[ ] Install fd
[ ] Install ripgrep
[ ] Install Fastfetch
[ ] Install image/runtime dependencies if required
[ ] Install/copy arch_end theme
[ ] Copy .zshrc
[ ] Copy Fastfetch config
[ ] Copy Fastfetch logo
[ ] Configure Windows Terminal profile
[ ] Configure VS Code MSYS2 Zsh profile
[ ] Enable VS Code terminal images
[ ] Configure WezTerm if used
[ ] Restore VS Code extensions
[ ] Validate with zshcheck
[ ] Restart Zsh
```

Then verify:

```bash
echo $MSYSTEM
zsh --version
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

---

## 26. Maintenance

Before committing configuration changes:

```bash
zshcheck
reload
```

Then test:

```bash
zinit status
z Documents
zi
ll
ff
```

Test Fastfetch in:

```text
Windows Terminal
VS Code
WezTerm
```

because each terminal can expose different capabilities/environment variables.

Keep the Git repository as the source of truth, but copy files to their expected runtime locations when restoring the environment.

---

## 27. Current Decisions

These choices are intentional:

```text
MSYS2 UCRT64            YES
Zsh                     YES
Oh My Zsh               YES
Zinit                   YES
arch_end                 ACTIVE PROMPT
Starship                 AVAILABLE / NOT ACTIVE
Autosuggestions          YES
History substring search YES
zsh-completions          YES
fzf-tab                  YES
FZF                      YES
Zoxide                   YES
Syntax highlighting      NO — caused lag
Auto-notify              NO — not required/tested
Bun                      YES
NVM                      NO — add only when needed
remaining_days           NO — unnecessary
Fastfetch PNG            YES
WezTerm logo protocol    iTerm
VS Code logo protocol    iTerm
Windows Terminal logo    Sixel
```

The goal is a **fast, understandable, maintainable Windows Zsh environment**, not the largest possible collection of plugins.
