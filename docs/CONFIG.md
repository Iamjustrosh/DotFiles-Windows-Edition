# Configuration Reference

## Important Runtime Files

```text
~/.zshrc
~/.zshrc.local
~/.config/zsh/history
~/.config/fastfetch/config.jsonc
~/.config/fastfetch/images/logo.png
~/.config/starship.toml
~/.oh-my-zsh/custom/themes/arch_end.zsh-theme
~/.local/share/zinit/zinit.git
```

## `.zshrc`

The main shell configuration contains:

```text
environment
Zsh options
history
Zinit
Oh My Zsh
plugins
key bindings
aliases
functions
FZF
Zoxide
Fastfetch
optional local config
```

Only source Oh My Zsh once.

Validate before reloading:

```bash
zsh -n ~/.zshrc
exec zsh
```

## History

```zsh
HISTSIZE=50000
SAVEHIST=50000
```

The setup appends/shares history between sessions and removes common duplicate entries.

History file:

```text
~/.config/zsh/history
```

## Prompt

Active:

```text
arch_end.zsh-theme
```

Example:

```text
rosha:~/Documents  $
```

Alternative:

```text
starship.toml
```

Do not intentionally enable both prompt systems simultaneously.

## Aliases

### Navigation

```text
..          cd ..
...         cd ../..
....        cd ../../..
home        home directory
desktop     Desktop
downloads   Downloads
documents   Documents
```

### Files

```text
ll          eza -lah
la          eza -a
lt          tree view
lta         tree including hidden files
```

### Development

```text
c.          code .
npmi        npm install
nerd        npm run dev
bi          bun install
br          bun run
brd         bun run dev
brb         bun run build
bx          bunx
```

### Zsh

```text
zshrc       open ~/.zshrc
zshcheck    syntax-check ~/.zshrc
reload      exec zsh
```

## Functions

### `mkcd`

Creates a directory and enters it.

```bash
mkcd project
```

### `open`

Opens a path using Windows Explorer.

```bash
open .
```

### `winpath`

Converts an MSYS path to Windows syntax.

```bash
winpath
winpath /c/Codes
```

### `unixpath`

Converts a Windows path to MSYS syntax.

```bash
unixpath 'C:\Codes'
```

### `extract`

Extracts common archive formats through one command.

```bash
extract archive.zip
extract archive.tar.gz
```

## Zoxide Compatibility

MSYS2 required an override so Zoxide receives the actual Zsh working directory:

```zsh
__zoxide_pwd() {
    builtin pwd -L
}
```

Zinit also owns a `zi` alias, so it is removed before defining Zoxide's interactive `zi` command:

```zsh
unalias zi 2>/dev/null
```

## Fastfetch

Default config uses the iTerm image protocol and the custom PNG.

Working terminal mapping:

```text
VS Code          iTerm
WezTerm          iTerm
Windows Terminal Sixel
```

The `.zshrc` detects the host and chooses the protocol.

Detection order matters:

```text
VS Code
WezTerm
Windows Terminal
fallback
```

VS Code can inherit `WT_SESSION`, so testing Windows Terminal first can select the wrong protocol.

The custom `ff()` function must not conflict with an `ff` alias:

```zsh
unalias ff 2>/dev/null
```

## `.zshrc.local`

Optional machine-specific settings can be placed here:

```text
~/.zshrc.local
```

Use it for local PATH additions or settings that should not be shared.

Never commit secrets.
