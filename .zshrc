# ============================================================
# ZSH CONFIGURATION
# Windows Terminal + MSYS2 UCRT64 + Zsh
# ============================================================
#
# Stack:
#
#   Windows Terminal
#        ↓
#   MSYS2 UCRT64
#        ↓
#   Zsh
#        ├── Oh My Zsh
#        ├── Zinit
#        ├── FZF
#        ├── Zoxide
#        └── Modern CLI tools
#
# ============================================================


# ------------------------------------------------------------
# 1. ENVIRONMENT
# ------------------------------------------------------------

# Default terminal editor.
# Programs that respect $EDITOR will use VS Code.
export EDITOR="code"

# Location of the Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# ------------------------------------------------------------
# 2. ZSH OPTIONS
# ------------------------------------------------------------

# Allow comments when entering commands interactively.
#
# Example:
#   git status # check repository
setopt INTERACTIVE_COMMENTS


# Automatically enter directories without typing `cd`.
#
# Instead of:
#   cd /c/Users/rosha/Documents
#
# You can type:
#   /c/Users/rosha/Documents
setopt AUTO_CD


# ------------------------------------------------------------
# 3. HISTORY
# ------------------------------------------------------------
#
# Zsh normally keeps command history in memory.
# These settings make history persistent and useful across
# multiple terminal sessions.
# ------------------------------------------------------------

# Directory where we keep Zsh-specific persistent data.
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Create it automatically if it doesn't exist.
mkdir -p "$ZSH_CONFIG_DIR"

# File containing persistent shell history.
HISTFILE="$ZSH_CONFIG_DIR/history"

# Number of commands kept in memory.
HISTSIZE=50000

# Number of commands written to disk.
SAVEHIST=50000


# Append commands instead of replacing the history file.
setopt APPEND_HISTORY

# Share history between multiple open Zsh terminals.
setopt SHARE_HISTORY

# Ignore immediately repeated commands.
#
# Example:
#
#   git status
#   git status
#
# won't unnecessarily create duplicate entries.
setopt HIST_IGNORE_DUPS

# Remove older duplicates when the same command occurs again.
setopt HIST_IGNORE_ALL_DUPS

# Avoid writing duplicate commands to the history file.
setopt HIST_SAVE_NO_DUPS

# Remove unnecessary whitespace before storing commands.
setopt HIST_REDUCE_BLANKS


# ------------------------------------------------------------
# 4. ZINIT
# ------------------------------------------------------------
#
# Zinit is our Zsh plugin manager.
#
# It manages:
#
#   zsh-autosuggestions
#   history-substring-search
#   fzf-tab
#
# Oh My Zsh remains installed separately.
# ------------------------------------------------------------

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
else
    echo "Zinit not found at: $ZINIT_HOME"
fi


# ------------------------------------------------------------
# 5. OH MY ZSH
# ------------------------------------------------------------
#
# Oh My Zsh provides:
#
#   - Zsh framework
#   - completion initialization
#   - Git plugin
#   - arch_end prompt theme
#
# ------------------------------------------------------------

# Current prompt theme.
#
# If we switch permanently to Starship later,
# change this to:
#
#   ZSH_THEME=""
#
ZSH_THEME="arch_end"


# Oh My Zsh plugins.
#
# `git` provides many Git aliases and helpers.
plugins=(
    git
)


# ----- Additional Zsh Completions -----
#
# Provides extra completion definitions for commands that
# aren't included in Zsh by default.
#
zinit light zsh-users/zsh-completions

# Initialize Oh My Zsh.
#
# Keep this ONCE in the entire .zshrc.
source "$ZSH/oh-my-zsh.sh"


# ------------------------------------------------------------
# 6. ZINIT PLUGINS
# ------------------------------------------------------------


# ----- Autosuggestions -----
#
# Shows faded suggestions while typing based on command history.
#
# Example:
#
#   git sta...
#       ↓
#   git status
#
zinit light zsh-users/zsh-autosuggestions


# ----- History Substring Search -----
#
# Allows searching history using text already entered.
#
# Example:
#
#   git + ↑
#
# cycles only through previous commands beginning/matching "git".
#
zinit light zsh-users/zsh-history-substring-search






# ----- FZF Tab -----
#
# Replaces normal completion lists with an interactive
# fuzzy-search interface powered by FZF.
#
# Example:
#
#   cd <TAB>
#   git switch <TAB>
#
zinit light Aloxaf/fzf-tab

# ----- Auto Notify -----
#
# Sends a desktop notification when a long-running command
# finishes.
#
# zinit light MichaelAquilina/zsh-auto-notify

# ------------------------------------------------------------
# 7. KEY BINDINGS
# ------------------------------------------------------------

# Connect the Up/Down arrow keys to history-substring-search.
#
# Type part of a command and press ↑ / ↓ to search only
# matching history entries.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# ------------------------------------------------------------
# 8. ALIASES
# ------------------------------------------------------------
#
# Aliases are simple shortcuts.
#
# For anything requiring arguments or logic, prefer a function.
# ------------------------------------------------------------

#Fastfetch
alias ff='fastfetch'

# ----- Navigation -----

# Move up one directory.
alias ..='cd ..'

# Move up two directories.
alias ...='cd ../..'

# Move up three directories.
alias ....='cd ../../..'


# Quick common directories.
alias home='cd ~'
alias desktop='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'

# ----- Zsh Configuration -----

# Open this configuration in VS Code.
alias zshrc='code ~/.zshrc'

# Restart Zsh and reload the configuration.
#
# We use `exec zsh` rather than repeatedly sourcing .zshrc
# because OMZ/Zinit/plugins initialize interactive shell state.
alias reload='exec zsh'

# Validate .zshrc syntax without executing it.
alias zshcheck='zsh -n ~/.zshrc'

# ----- Modern File Listing -----

# Only create these aliases when eza is installed.
if command -v eza >/dev/null 2>&1; then

    # Detailed listing including hidden files.
    alias ll='eza -lah'

    # Show hidden files.
    alias la='eza -a'

    # Directory tree limited to two levels.
    alias lt='eza --tree --level=2'

    # Tree including hidden files.
    alias lta='eza --tree --level=2 -a'

fi


# ----- Terminal Utilities -----

# Clear the terminal.
alias c='clear'

# Human-readable disk usage.
alias duh='du -h'

# Display PATH with one directory per line.
alias path='echo "$PATH" | tr ":" "\n"'


# ----- VS Code -----

# Open the current directory in VS Code.
alias c.='code .'


# ----- NPM -----

# npm install
alias npmi='npm install'

# npm run dev
alias nerd='npm run dev'


# ----- Bun -----

alias bi='bun install'
alias br='bun run'
alias brd='bun run dev'
alias brb='bun run build'
alias bx='bunx'

# ----- Windows Clipboard -----

# Pipe output into the Windows clipboard.
#
# Examples:
#
#   pwd | copy
#   cat package.json | copy
#   git branch --show-current | copy
#
alias copy='clip.exe'


# ----- BTOP -----
alias btop='btop4win'

# ------------------------------------------------------------
# 9. FUNCTIONS
# ------------------------------------------------------------
#
# Functions are preferable to aliases when:
#
#   - arguments are required
#   - conditions are required
#   - multiple commands must run
#
# ------------------------------------------------------------


# ----- mkcd -----
#
# Create a directory and immediately enter it.
#
# Instead of:
#
#   mkdir new-project
#   cd new-project
#
# Use:
#
#   mkcd new-project
#
mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi

    mkdir -p "$1" && cd "$1"
}


# ----- open -----
#
# Open a file/directory using Windows Explorer.
#
# Examples:
#
#   open
#       → opens current directory
#
#   open .
#       → opens current directory
#
#   open ~/Downloads
#       → opens Downloads
#
open() {
    if [[ $# -eq 0 ]]; then
        explorer.exe .
    else
        explorer.exe "$@"
    fi
}


# ----- paste -----
#
# Print the current Windows clipboard contents.
#
# Example:
#
#   paste
#
paste() {
    powershell.exe -NoProfile -Command Get-Clipboard
}


# ----- winpath -----
#
# Convert an MSYS/Unix path into a Windows path.
#
# Example:
#
#   winpath /c/Users/rosha/Documents
#
# becomes:
#
#   C:\Users\rosha\Documents
#
# With no argument, converts the current directory.
#
winpath() {
    cygpath -w "${1:-$PWD}"
}


# ----- unixpath -----
#
# Convert a Windows path into an MSYS path.
#
# Example:
#
#   unixpath 'C:\Users\rosha\Documents'
#
# becomes:
#
#   /c/Users/rosha/Documents
#
unixpath() {
    if [[ -z "$1" ]]; then
        echo "Usage: unixpath <windows-path>"
        return 1
    fi

    cygpath -u "$1"
}


# ----- extract -----
#
# Extract common archive formats using one command.
#
# Examples:
#
#   extract project.zip
#   extract source.tar.gz
#   extract archive.tar.xz
#
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <archive>"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        echo "File not found: $1"
        return 1
    fi

    case "$1" in

        *.tar.gz|*.tgz)
            tar -xzf "$1"
            ;;

        *.tar.bz2|*.tbz2)
            tar -xjf "$1"
            ;;

        *.tar.xz|*.txz)
            tar -xJf "$1"
            ;;

        *.tar)
            tar -xf "$1"
            ;;

        *.zip)
            unzip "$1"
            ;;

        *)
            echo "Unsupported archive format: $1"
            return 1
            ;;

    esac
}


# ------------------------------------------------------------
# 10. EXTERNAL TOOLS
# ------------------------------------------------------------


# ----- FZF -----
#
# FZF is a fuzzy finder.
#
# Zsh integration gives us features such as:
#
#   Ctrl + R → fuzzy history search
#
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi


# ----- Zoxide -----
#
# Zoxide is a smarter replacement/addition to `cd`.
#
# Examples:
#
#   z Documents
#   z project
#
# Zoxide learns which directories you use frequently.
#
if command -v zoxide >/dev/null 2>&1; then

    eval "$(zoxide init zsh)"


    # --------------------------------------------------------
    # MSYS2 + UCRT64 compatibility fix
    # --------------------------------------------------------
    #
    # The native UCRT64 Zoxide binary generated an incorrect
    # cygpath call for Zsh's builtin `pwd`.
    #
    # Zsh itself correctly returns:
    #
    #   /c/Users/rosha/...
    #
    # so we override Zoxide's path function.
    #
    __zoxide_pwd() {
        builtin pwd -L
    }


    # --------------------------------------------------------
    # Zinit / Zoxide `zi` conflict
    # --------------------------------------------------------
    #
    # Zinit defines:
    #
    #   zi → zinit
    #
    # Zoxide also wants:
    #
    #   zi → interactive directory selector
    #
    # We keep the full `zinit` command for Zinit and give
    # `zi` to Zoxide.
    #
    unalias zi 2>/dev/null


    # Interactive Zoxide directory selector using FZF.
    function zi {
        __zoxide_zi "$@"
    }

fi


# ------------------------------------------------------------
# 11. SYNTAX HIGHLIGHTING
# ------------------------------------------------------------
#
# Normally this plugin highlights valid/invalid commands while
# typing.
#
# It is intentionally DISABLED in this setup because it caused
# severe per-keystroke input lag under MSYS2 Zsh.
#
# The plugin can remain installed in Zinit; it simply isn't
# loaded.
#
# zinit light zsh-users/zsh-syntax-highlighting


# ------------------------------------------------------------
# 12. PROMPT
# ------------------------------------------------------------


# ----- Current Prompt -----
#
# Currently handled by:
#
#   Oh My Zsh → arch_end
#
# configured earlier using:
#
#   ZSH_THEME="arch_end"
#


# ----- Starship -----
#
# Starship is installed/testable as an alternative prompt.
#
# DO NOT enable Starship while arch_end is controlling the
# prompt.
#
# To switch to Starship:
#
# 1. Change:
#
#      ZSH_THEME="arch_end"
#
#    to:
#
#      ZSH_THEME=""
#
# 2. Uncomment:
#
# if command -v starship >/dev/null 2>&1; then
#     eval "$(starship init zsh)"
# fi

# 13. FASTFETCH
# ------------------------------------------------------------
# ------------------------------------------------------------
# FASTFETCH
# ------------------------------------------------------------

unalias ff 2>/dev/null

FASTFETCH_LOGO="C:/msys64/home/rosha/.config/fastfetch/images/logo.png"

ff() {
    if ! command -v fastfetch >/dev/null 2>&1; then
        echo "fastfetch is not installed"
        return 1
    fi

    # --------------------------------------------------------
    # VS Code
    # --------------------------------------------------------
    #
    # VS Code may inherit WT_SESSION from Windows Terminal,
    # so we MUST detect VS Code before checking WT_SESSION.
    #
    if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        fastfetch \
            --logo-type iterm \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    # --------------------------------------------------------
    # WezTerm
    # --------------------------------------------------------
    elif [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
        fastfetch \
            --logo-type iterm \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    # --------------------------------------------------------
    # Windows Terminal
    # --------------------------------------------------------
    elif [[ -n "$WT_SESSION" ]]; then
        fastfetch \
            --logo-type sixel \
            --logo "$FASTFETCH_LOGO" \
            --logo-width 30 \
            --logo-height 15

    # --------------------------------------------------------
    # Other terminals
    # --------------------------------------------------------
    else
        fastfetch
    fi
}

# Display Fastfetch when Zsh starts.
ff