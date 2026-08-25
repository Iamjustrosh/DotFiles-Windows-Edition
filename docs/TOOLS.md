# Tools & Plugins

Detailed reference for the tools used by the Windows MSYS2 + Zsh environment.

## Shell Layer

### Zsh

The interactive shell. It was chosen over Bash for this environment because its completion system, history behavior and plugin ecosystem make an interactive development shell easier to customize.

```bash
zsh
exec zsh
```

### Oh My Zsh

Framework around Zsh that organizes themes and plugins. We keep it mainly for the `git` plugin and the custom `arch_end` theme rather than loading a large plugin collection.

Runtime:

```text
~/.oh-my-zsh
```

### Zinit

Plugin manager. It keeps third-party Zsh plugins declarative in `.zshrc` instead of manually cloning and sourcing each repository.

```bash
zinit version
zinit status
zinit update
```

Plugins:

- `zsh-completions` — additional completion definitions.
- `zsh-autosuggestions` — suggests commands from history while typing.
- `zsh-history-substring-search` — type part of a command and use Up/Down to search matching history.
- `fzf-tab` — fuzzy interactive TAB completion.

`zsh-syntax-highlighting` is intentionally disabled because it caused severe per-keystroke lag in this MSYS2 environment.

## Navigation & Search

### FZF

General-purpose fuzzy finder. It is useful when an exact name is unknown and is also integrated into history/completion workflows.

```text
Ctrl+R
```

or:

```bash
fzf
```

### Zoxide

Smart `cd` alternative. It builds a database from directories you visit and ranks them by usage.

```bash
z project
z Documents
zi
zoxide query -l
```

You do not manually train it in normal use: navigate with `cd`/AUTO_CD and it learns automatically.

### AUTO_CD

This is a Zsh option, not a separate CLI tool.

```zsh
setopt AUTO_CD
```

Typing an existing directory/path can act like `cd`:

```bash
Documents
~/Downloads
../
```

Unlike Zoxide, AUTO_CD does not search learned directories.

## Modern CLI Utilities

### eza

Modern file listing tool used instead of `ls` for richer everyday output.

```bash
ll
la
lt
lta
```

### bat

File viewer used instead of plain `cat` when reading source/config files because it provides line numbers and syntax-aware formatting.

```bash
bat ~/.zshrc
bat src/App.jsx
```

### fd

File finder used for simple project searches because its default interface is more convenient than traditional `find`.

```bash
fd README
fd package
fd '\.tsx$'
```

### ripgrep (`rg`)

Fast recursive text search used instead of common `grep -R` workflows. It works especially well in source repositories.

```bash
rg "TODO"
rg "useAuth" src/
```

## System & Development

### Fastfetch

Displays a quick system summary when opening the shell and renders the custom logo.

```bash
fastfetch
ff
```

The custom `ff()` function selects the image protocol according to the terminal.

### Git

Version control for development projects and this configuration repository.

```bash
git status
git add .
git commit
git push
```

Oh My Zsh's `git` plugin also provides Git-oriented shell helpers.

### Node.js / npm

Primary JavaScript runtime/package ecosystem and kept for maximum compatibility with existing projects.

```bash
node --version
npm install
npm run dev
```

### Bun

Additional JS/TS runtime and package tooling. It is used when a project supports it rather than forcing every Node project to migrate.

```bash
bun install
bun run dev
bun run build
bunx <package>
```

Configured aliases:

```text
bi   → bun install
br   → bun run
brd  → bun run dev
brb  → bun run build
bx   → bunx
```

### Starship

Cross-shell prompt engine kept as an optional alternative. It is not currently active because the lightweight `arch_end` Oh My Zsh theme is being used.

Config:

```text
~/.config/starship.toml
```

## Windows Bridge Utilities

### cygpath

Converts between MSYS and Windows paths.

```bash
cygpath -w "$PWD"
cygpath -u 'C:\Users\name'
```

The `.zshrc` wraps this with `winpath` and `unixpath`.

### explorer.exe

Lets the Unix-like shell open Windows Explorer.

```bash
open .
```

### clip.exe / PowerShell Clipboard

Used by the `copy`/`paste` helpers to bridge shell pipelines with the Windows clipboard.

```bash
pwd | copy
paste
```
