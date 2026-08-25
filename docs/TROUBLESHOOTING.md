# Troubleshooting

Only the issues actually encountered while building this setup are collected here.

## Check the Environment First

```bash
echo $MSYSTEM
echo $MINGW_PREFIX
```

Expected:

```text
UCRT64
/ucrt64
```

Check command resolution:

```bash
type -a zsh
type -a zinit
which node
which bun
which fastfetch
```

## VS Code: `zsh: command not found`

Do not launch `zsh.exe` directly.

VS Code should launch:

```text
msys2_shell.cmd
   ↓
-ucrt64
   ↓
-shell zsh
```

Then create a completely new integrated terminal.

## Zinit Plugin Looks Installed but Not Loaded

Check Zinit itself:

```bash
type zinit
zinit version
zinit status
```

Make sure plugins are loaded only once and in the correct part of `.zshrc`.

## Typing Becomes Extremely Slow

`zsh-syntax-highlighting` caused severe input lag in this environment.

Keep it disabled.

Autosuggestions and history-substring-search were retained because they worked normally.

## Zoxide: `C:\builtin pwd -L`

MSYS2 path conversion generated a bad value.

Keep the compatibility override:

```zsh
__zoxide_pwd() {
    builtin pwd -L
}
```

## `zi` Opens Zinit

Zinit defines `zi` as an alias while Zoxide also wants `zi` for its interactive selector.

Fix:

```zsh
unalias zi 2>/dev/null
```

Then define/use the Zoxide `zi` function from `.zshrc`.

## `defining function based on alias 'zi'`

An alias exists before a function with the same name is declared.

Remove it first:

```zsh
unalias zi 2>/dev/null
```

The same issue occurred with `ff`.

## `defining function based on alias 'ff'`

Do not keep:

```zsh
alias ff='fastfetch'
```

when using the terminal-aware `ff()` function.

Before the function:

```zsh
unalias ff 2>/dev/null
```

## Fastfetch Shows the Default Windows Logo

Run:

```bash
fastfetch --show-errors
```

Confirm the logo path exists and that the terminal supports the selected image protocol.

## Fastfetch Image Is Pixelated

Chafa renders images using terminal character cells, so a photographic/smooth logo can appear pixelated.

The final setup uses image protocols instead:

```text
VS Code / WezTerm → iTerm
Windows Terminal  → Sixel
```

## Fastfetch Works in Windows Terminal but Not VS Code

VS Code requires terminal image support:

```json
"terminal.integrated.enableImages": true
```

It also needs the proper MSYS2 UCRT64 profile.

## VS Code Gets the Wrong Fastfetch Protocol

VS Code can inherit `WT_SESSION` from Windows Terminal.

Check `$TERM_PROGRAM == vscode` before checking `$WT_SESSION` in `.zshrc`.

## Validate After Any Edit

```bash
zsh -n ~/.zshrc
```

If valid:

```bash
exec zsh
```

Then test:

```bash
zinit status
z Documents
zi
ll
ff
```
