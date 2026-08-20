# ============================================================
# ZSH CONFIGURATION
# Windows + MSYS2 UCRT64
# ============================================================


# ------------------------------------------------------------
# 1. ENVIRONMENT
# ------------------------------------------------------------

# Preferred editor
export EDITOR="code"

# Oh My Zsh installation directory
export ZSH="$HOME/.oh-my-zsh"


# ------------------------------------------------------------
# 2. ZSH OPTIONS
# ------------------------------------------------------------

# Allow comments when typing commands interactively.
# Example:
#   git status # check repository
setopt INTERACTIVE_COMMENTS

# Enter a directory without explicitly typing `cd`.
# Example:
#   /c/Users
# instead of:
#   cd /c/Users
setopt AUTO_CD


# ------------------------------------------------------------
# 3. HISTORY
# ------------------------------------------------------------

# Store Zsh-related persistent data here.
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Create the directory if it doesn't exist.
mkdir -p "$ZSH_CONFIG_DIR"

# History file location.
HISTFILE="$ZSH_CONFIG_DIR/history"

# Number of commands kept in memory.
HISTSIZE=50000

# Number of commands written to the history file.
SAVEHIST=50000


# Append commands instead of replacing the history file.
setopt APPEND_HISTORY

# Share history between multiple Zsh terminal sessions.
setopt SHARE_HISTORY

# Don't record a command when it is the same as
# the immediately previous command.
setopt HIST_IGNORE_DUPS

# Remove older duplicate commands from history.
setopt HIST_IGNORE_ALL_DUPS

# Don't write duplicate commands to the history file.
setopt HIST_SAVE_NO_DUPS

# Remove unnecessary extra spaces before storing commands.
setopt HIST_REDUCE_BLANKS


# ------------------------------------------------------------
# 4. OH MY ZSH
# ------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"
else
    echo "Zinit not found at: $ZINIT_HOME"
fi


# ------------------------------------------------------------
# 5. USER CONFIGURATION
# ------------------------------------------------------------

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
# ------------------------------------------------------------
# ZSH PLUGINS
# ------------------------------------------------------------

# Suggest commands based on shell history.


# Search matching history using Up/Down arrows.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Keep syntax highlighting last among interactive Zsh plugins.
zinit light zsh-users/zsh-syntax-highlighting

# Current prompt theme.
#
# We'll keep arch_end for now.
# Later, if we use Starship, Starship will replace this prompt.
ZSH_THEME="arch_end"

# Oh My Zsh plugins.
#
# `git` provides useful Git aliases and helper functionality.
plugins=(
    git
)

# Load Oh My Zsh.
#
# Oh My Zsh initializes its own completion system, so we do NOT
# manually run `compinit` while OMZ is handling completion.
source "$ZSH/oh-my-zsh.sh"




# ------------------------------------------------------------
# 6. ALIASES
# ------------------------------------------------------------

# We'll add our own aliases later.


# ------------------------------------------------------------
# 7. FUNCTIONS
# ------------------------------------------------------------

# We'll add custom Zsh/Windows functions later.


# ------------------------------------------------------------
# 8. EXTERNAL TOOLS
# ------------------------------------------------------------

# FZF
# Zoxide
# Starship
# Fastfetch
#
# These will be configured later.