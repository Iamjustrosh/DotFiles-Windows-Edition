# Windows Zsh Setup

A simple, reproducible Windows terminal setup using **MSYS2 UCRT64 + Zsh**.

This repository is the **source of truth** for the shell. If you move to another Windows PC, follow this README in order instead of rebuilding the setup from memory.

> **Important:** This is **MSYS2**, not WSL. The shell runs from `C:\msys64`.

---

## 1. What This Setup Contains

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
        ├── btop4win → btop
        └── Bun / Node
```

The goal is simple:

1. Install MSYS2 UCRT64.
2. Install the tools.
3. Put the repository configuration files in the correct MSYS2 home locations.
4. Configure the terminals to start UCRT64 + Zsh.
5. Check the shell.
6. Use the same edit → check → copy → reload → verify workflow whenever you make changes.

---

## 2. Repository Structure

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

### What each important file does

| File                            | Purpose                                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------------------ |
| `.zshrc`                        | Main Zsh configuration: plugins, aliases, functions, history, Zoxide, FZF, Fastfetch, etc. |
| `arch_end.zsh-theme`            | Active Oh My Zsh prompt theme.                                                             |
| `fastfetch/config.jsonc`        | Fastfetch layout and logo configuration.                                                   |
| `fastfetch/images/logo.png`     | Custom Fastfetch logo.                                                                     |
| `starship.toml`                 | Alternative prompt configuration; not currently active.                                    |
| `vsc export/vsc-extensions.txt` | VS Code extension list for restoring a machine.                                            |
| `docs/`                         | Detailed reference and troubleshooting notes.                                              |

Do not commit passwords, API keys, tokens, or other private machine-specific values.

---

## 3. Repository Files vs Live MSYS2 Files

This is one of the most important things to understand.

The **repository copy** is your backup and source of truth.

The **live copy** is what Zsh actually loads.

On this machine, the live MSYS2 home is:

```text
C:\msys64\home\rosha
```

Inside Zsh, the same folder is:

```text
/home/rosha
```

So the important live files are:

```text
C:\msys64\home\rosha\.zshrc
C:\msys64\home\rosha\.oh-my-zsh\custom\themes\arch_end.zsh-theme
C:\msys64\home\rosha\.config\fastfetch\config.jsonc
C:\msys64\home\rosha\.config\fastfetch\images\logo.png
C:\msys64\home\rosha\.config\starship.toml
C:\msys64\home\rosha\.local\share\zinit\zinit.git
```

> If your Windows username is different, replace `rosha` with your MSYS2 username. The important structure is `C:\msys64\home\<username>`.

Check your actual location instead of guessing:

```bash
echo $HOME
cygpath -w "$HOME"
```

Expected on the current machine:

```text
/home/rosha/
C:\msys64\home\rosha
```

### Rule to remember

**Edit the repository → validate → copy the changed file to the live location → reload → verify → commit.**

Do not assume editing a repository file automatically changes the running shell.

---

# 4. Fresh Windows Device Setup

Follow these steps in order.

## Step 1 — Install MSYS2

Install MSYS2 and open the **UCRT64** terminal.

Update MSYS2:

```bash
pacman -Syu
```

If MSYS2 asks you to close the terminal, close it, reopen UCRT64, and run the update again until it completes.

Now install the tools used by this setup:

```bash
pacman -S --needed git zsh mingw-w64-ucrt-x86_64-fzf mingw-w64-ucrt-x86_64-zoxide mingw-w64-ucrt-x86_64-eza mingw-w64-ucrt-x86_64-bat mingw-w64-ucrt-x86_64-fd mingw-w64-ucrt-x86_64-ripgrep mingw-w64-ucrt-x86_64-fastfetch
```

If a package is not found, search for its current package name:

```bash
pacman -Ss <tool-name>
```

Check that you are actually inside UCRT64:

```bash
echo $MSYSTEM
```

Expected:

```text
UCRT64
```

**Why this matters:** the setup is built for the UCRT64 environment. Do not continue with a plain MSYS shell if the result is not `UCRT64`.

---

## Step 2 — Install Oh My Zsh

Install Oh My Zsh normally. It should create:

```text
~/.oh-my-zsh
```

Then copy the repository theme:

```bash
mkdir -p ~/.oh-my-zsh/custom/themes
cp /path/to/repo/arch_end.zsh-theme ~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
```

The active theme is:

```text
arch_end
```

The Arch icon requires a **Nerd Font** in the terminal.

**Why:** Oh My Zsh provides the theme/plugin structure, while this repository keeps the actual prompt theme under version control.

---

## Step 3 — Install Zinit

Install Zinit into:

```text
~/.local/share/zinit/zinit.git
```

The repository `.zshrc` loads Zinit and then loads these plugins:

```text
zsh-completions
zsh-autosuggestions
zsh-history-substring-search
fzf-tab
```

Do **not** enable `zsh-syntax-highlighting` in this setup. It caused severe typing lag under MSYS2 during testing.

**Why:** Zinit manages the Zsh plugins without requiring every plugin to be manually sourced in `.zshrc`.

---

## Step 4 — Copy the Configuration Files into MSYS2 Home

This is where the repository becomes the actual working shell configuration.

First find your repository path. For example:

```text
D:\Projects\windows-zsh
```

Then, from the MSYS2 Zsh terminal, copy the files.

### Main Zsh configuration

```bash
cp /path/to/repo/.zshrc ~/.zshrc
```

This becomes:

```text
C:\msys64\home\rosha\.zshrc
```

### Oh My Zsh theme

```bash
mkdir -p ~/.oh-my-zsh/custom/themes
cp /path/to/repo/arch_end.zsh-theme ~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
```

### Fastfetch

```bash
mkdir -p ~/.config/fastfetch/images

cp /path/to/repo/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp /path/to/repo/fastfetch/images/logo.png ~/.config/fastfetch/images/logo.png
```

### Starship

Optional because Starship is not the active prompt:

```bash
mkdir -p ~/.config
cp /path/to/repo/starship.toml ~/.config/starship.toml
```

### The important mapping

```text
Repository                         → Live MSYS2 location
────────────────────────────────────────────────────────────
.zshrc                             → ~/.zshrc
arch_end.zsh-theme                 → ~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
fastfetch/config.jsonc             → ~/.config/fastfetch/config.jsonc
fastfetch/images/logo.png          → ~/.config/fastfetch/images/logo.png
starship.toml                      → ~/.config/starship.toml
```

**Why:** Zsh reads the files under your MSYS2 home. The repository itself is just your managed source/backup.

---

## Step 5 — Configure Windows Terminal

Use the MSYS2 launcher instead of launching `zsh.exe` directly. This ensures the correct UCRT64 environment is initialized first.

Windows Terminal profile:

```json
{
    "commandline": "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64 -use-full-path -shell zsh",
    "name": "Zsh (MSYS2 UCRT64)",
    "startingDirectory": "%USERPROFILE%"
}
```

Open the profile and verify:

```bash
echo $MSYSTEM
```

Expected:

```text
UCRT64
```

**Why:** launching the shell through `msys2_shell.cmd` sets up the MSYS2 environment correctly before Zsh starts.

---

## Step 6 — Configure VS Code Terminal

In VS Code `settings.json`:

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

Open a **new** terminal and check:

```bash
echo $MSYSTEM
echo $TERM_PROGRAM
```

**Why:** VS Code needs to launch the same UCRT64 + Zsh environment as Windows Terminal.

---

## Step 7 — Configure WezTerm

Use the same MSYS2 UCRT64 + Zsh environment used by the other terminals.

After opening WezTerm, verify:

```bash
echo $MSYSTEM
```

Expected:

```text
UCRT64
```

Fastfetch image rendering is terminal-specific, so test `ff` here separately.

---

## Step 8 — Restore VS Code Extensions

The repository contains:

```text
vsc export/vsc-extensions.txt
```

To create/update the list on the current machine:

```powershell
code --list-extensions > "vsc export\vsc-extensions.txt"
```

To restore it on another Windows machine:

```powershell
Get-Content ".\vsc export\vsc-extensions.txt" | ForEach-Object { code --install-extension $_ }
```

**Why:** the extension list is a reproducible record of the VS Code environment without storing the extensions themselves in Git.

---

## Step 9 — Node and Bun

Install Node.js normally for Windows if it is not already installed.

Bun can coexist with Node/npm. A Node version manager is intentionally not part of this setup yet.

Verify:

```bash
node --version
npm --version
bun --version
```

---

## Step 10 — Add btop4win Alias

This setup uses **btop4win** as the program behind the familiar `btop` command.

The `.zshrc` contains:

```zsh
# ------------------------------------------------------------
# BTOP
# ------------------------------------------------------------

# Use btop4win when the familiar `btop` command is entered.
alias btop='btop4win'
```

Make sure `btop4win` is installed on Windows and available from the MSYS2 shell's `PATH`.

```bash
winget install aristocratos.btop4win
```
Verify:

```bash
command -v btop4win
btop
```

**Why:** you can type the standard `btop` command while using the Windows-native btop4win executable.

> Zsh alias syntax has **no spaces** around `=`. `alias btop = 'btop4win'` causes `bad assignment`.

---

## Step 11 — Validate Everything

Run:

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
command -v btop4win
```

Then check the `.zshrc` before restarting the shell:

```bash
zsh -n ~/.zshrc
```

If there is **no output**, the syntax check passed.

Now reload:

```bash
exec zsh
```

Then test the main features:

```bash
ll
z Documents
zi
ff
btop
```

---

# 5. Tools — Quick Reference

| Tool          | What it does                                                      | Basic use                      |
| ------------- | ----------------------------------------------------------------- | ------------------------------ |
| **Zsh**       | Main interactive shell with strong completion and customization.  | `zsh`, `exec zsh`              |
| **Oh My Zsh** | Organizes themes, plugins and useful shell helpers.               | Configured through `.zshrc`    |
| **Zinit**     | Loads and manages Zsh plugins.                                    | `zinit status`, `zinit update` |
| **FZF**       | Fuzzy searching for history and interactive selection.            | `Ctrl+R`, `fzf`                |
| **Zoxide**    | Learns directories you visit and lets you jump to them quickly.   | `z project`, `zi`              |
| **eza**       | Modern replacement for common `ls` usage.                         | `ll`, `la`, `lt`               |
| **bat**       | File viewer with syntax highlighting and formatting.              | `bat file.js`                  |
| **fd**        | Simple, fast file search.                                         | `fd README`                    |
| **ripgrep**   | Fast project text search.                                         | `rg "useState"`                |
| **Fastfetch** | Shows system information and the custom terminal logo.            | `ff`                           |
| **btop4win**  | Windows system/resource monitor exposed through the `btop` alias. | `btop`                         |
| **Bun**       | JavaScript/TypeScript runtime and package tooling.                | `bi`, `brd`, `bunx`            |
| **Git**       | Version control.                                                  | `git status`                   |

Useful replacements:

```text
ls       → eza
cat      → bat
find     → fd
grep -R  → rg
long cd  → zoxide
history  → fzf / Ctrl+R
```

---

# 6. Navigation: AUTO_CD vs Zoxide

These are different features.

### AUTO_CD

AUTO_CD lets you enter a real directory path without typing `cd` first:

```bash
Documents
../
~/Downloads
```

It does **not** learn directories.

### Zoxide

Zoxide learns directories as you visit them and can later jump to them:

```bash
cd ~/Documents/projects/meena
z meena
```

Interactive selection:

```bash
zi
```

Think of it as:

```text
AUTO_CD → shortcut for entering real paths
Zoxide  → learned directory search/jump
```

---

# 7. Fastfetch

The custom logo is stored at:

```text
~/.config/fastfetch/images/logo.png
```

Current rendering:

```text
VS Code          → iTerm image protocol
WezTerm          → iTerm image protocol
Windows Terminal → Sixel
```

The `.zshrc` contains a terminal-aware `ff()` function so the correct image protocol is selected.

Do **not** replace it with:

```zsh
alias ff='fastfetch'
```

That would remove the terminal-specific rendering logic.

---

# 8. Everyday Commands

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

ff              # system information + logo
btop            # Windows btop4win monitor

zshrc           # open .zshrc
zshcheck        # validate .zshrc
reload          # restart Zsh

bi              # bun install
brd             # bun run dev
brb             # bun run build
```

---

# 9. How to Make Changes Safely

Use this process for **every configuration change**.

```text
EDIT REPOSITORY
      ↓
CHECK SYNTAX
      ↓
COPY TO LIVE MSYS2 HOME
      ↓
RELOAD ZSH
      ↓
VERIFY THE CHANGE
      ↓
COMMIT TO GIT
```

## Step 1 — Edit the repository

Change the file inside the repository, not the live MSYS2 copy, when you want the change saved in Git.

Examples:

```text
repo/.zshrc
repo/arch_end.zsh-theme
repo/fastfetch/config.jsonc
repo/fastfetch/images/logo.png
```

## Step 2 — Check before applying

For `.zshrc`:

```bash
zsh -n /path/to/repo/.zshrc
```

No output means the syntax is valid.

Also review the Git change:

```bash
git diff
git status
```

## Step 3 — Copy only what changed

For `.zshrc`:

```bash
cp /path/to/repo/.zshrc ~/.zshrc
```

For the theme:

```bash
cp /path/to/repo/arch_end.zsh-theme ~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
```

For Fastfetch:

```bash
cp /path/to/repo/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp /path/to/repo/fastfetch/images/logo.png ~/.config/fastfetch/images/logo.png
```

For a small change, do **not** replace the entire environment.

## Step 4 — Reload

After changing `.zshrc`:

```bash
zshcheck
reload
```

Or:

```bash
exec zsh
```

## Step 5 — Verify the actual feature

If you changed an alias, run the alias.

Example for the btop change:

```bash
command -v btop4win
alias btop
btop
```

If you changed Zoxide:

```bash
z project
zi
```

If you changed Fastfetch:

```bash
ff
```

If you changed the prompt, open a fresh terminal too.

## Step 6 — Commit only after it works

```bash
git diff
git status
git add .
git commit -m "Update zsh configuration"
git push
```

The repository should represent a configuration that has actually been tested.

---

# 10. Maintenance Checklist

After changing `.zshrc`:

```bash
zshcheck
reload
```

Before pushing:

```bash
zinit status
z Documents
zi
ll
ff
btop
```

Also test Fastfetch separately in:

```text
VS Code
WezTerm
Windows Terminal
```

Keep secrets and machine-specific private values out of the repository.

---

# 11. Common Configuration Mistakes

### `bad assignment` when creating an alias

Wrong:

```zsh
alias btop = 'btop4win'
```

Correct:

```zsh
alias btop='btop4win'
```

Zsh does not allow spaces around the `=` in an alias assignment.

### Alias/function name collision

If Zsh reports something like:

```text
defining function based on alias 'zi'
defining function based on alias 'ff'
```

there is both an alias and a function using the same name. Check before adding another definition:

```bash
type zi
type ff
```

### Repository change is not visible

You probably changed the repository copy but did not copy it to the live MSYS2 location.

Check:

```bash
echo $HOME
cygpath -w "$HOME"
```

Then copy the changed file again.

### `.zshrc` broke after an edit

Check syntax without loading it:

```bash
zsh -n ~/.zshrc
```

Fix the reported line or restore the last known-good repository version, then:

```bash
exec zsh
```

---

# 12. Quick Recovery

If the shell configuration becomes unusable:

1. Open a fresh MSYS2 UCRT64 terminal.
2. Check the live home:

```bash
echo $HOME
cygpath -w "$HOME"
```

3. Restore `.zshrc` from the last known-good repository copy:

```bash
cp /path/to/repo/.zshrc ~/.zshrc
```

4. Check it:

```bash
zsh -n ~/.zshrc
```

5. Restart Zsh:

```bash
exec zsh
```

The safest recovery principle is:

```text
KNOWN GOOD REPOSITORY
        ↓
RESTORE LIVE FILE
        ↓
SYNTAX CHECK
        ↓
RESTART
```

---

# 13. Final New-Machine Checklist

Use this after rebuilding the setup:

```text
[ ] MSYS2 installed
[ ] UCRT64 terminal works
[ ] MSYS2 updated
[ ] Zsh installed
[ ] Git installed
[ ] Oh My Zsh installed
[ ] arch_end theme copied
[ ] Nerd Font configured
[ ] Zinit installed
[ ] Zinit plugins loaded
[ ] .zshrc copied to ~/.zshrc
[ ] Fastfetch config copied
[ ] Fastfetch logo copied
[ ] Windows Terminal uses UCRT64 + Zsh
[ ] VS Code uses UCRT64 + Zsh
[ ] WezTerm uses UCRT64 + Zsh
[ ] VS Code extensions restored
[ ] Node works
[ ] Bun works
[ ] btop4win installed and available in PATH
[ ] btop alias works
[ ] zoxide works
[ ] FZF history works
[ ] Fastfetch works in each terminal
[ ] zsh -n ~/.zshrc passes
```

---

# More Documentation

* [`docs/TOOLS.md`](docs/TOOLS.md) — what each tool/plugin does and how to use it.
* [`docs/CONFIG.md`](docs/CONFIG.md) — file locations, aliases, functions, history, prompts and Fastfetch behavior.
* [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) — fixes for the MSYS2/Zoxide/Zinit/Fastfetch issues encountered while building this setup.
