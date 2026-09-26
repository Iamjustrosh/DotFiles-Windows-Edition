# Windows Virtual Desktop Shortcuts with AutoHotkey

A small AutoHotkey setup that replaces the default Windows Virtual Desktop keyboard shortcuts with custom shortcuts while keeping Komorebi completely separate.

## Why this exists

Windows provides native shortcuts for switching between Virtual Desktops:

- `Win + Ctrl + Left` — switch to the previous desktop
- `Win + Ctrl + Right` — switch to the next desktop

This setup maps those actions to:

- `Alt + Shift + ;` — previous Windows Virtual Desktop
- `Alt + Shift + '` — next Windows Virtual Desktop

The shortcuts are handled by AutoHotkey, while Komorebi continues to manage its own workspaces and window management.

## Setup

### 1. Install AutoHotkey v2

Install AutoHotkey v2 on Windows.

The script uses the 64-bit executable installed at:

```text
C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe
```

If AutoHotkey is installed somewhere else, update the launcher path accordingly.

### 2. Create the AutoHotkey script

Create:

```text
%USERPROFILE%\Documents\AutoHotkey\WindowsDesktop.ahk
```

Contents:

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force

!+SC027::SendInput "#^{Left}"
!+SC028::SendInput "#^{Right}"
```

### Why scan codes are used

The first attempt used the literal `;` and `'` keys in the hotkey definitions. On this setup, those bindings were not parsed reliably.

The script therefore uses keyboard scan codes:

- `SC027` → `;`
- `SC028` → `'`

This makes the bindings work reliably on the keyboard layout used for this setup.

## 3. Start the script automatically with Windows

A direct `.ahk` file in the Startup folder can be opened by its file association instead of being launched by AutoHotkey.

To avoid that, use a `.cmd` launcher.

Create:

```text
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\WindowsDesktop.cmd
```

Contents:

```bat
@echo off
start "" "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" "%USERPROFILE%\Documents\AutoHotkey\WindowsDesktop.ahk"
```

This explicitly launches the AutoHotkey executable and passes the script as its argument.

### Startup flow

```text
Windows Login
     │
     ▼
Startup\WindowsDesktop.cmd
     │
     ▼
AutoHotkey64.exe
     │
     ▼
WindowsDesktop.ahk
     │
     ├── Alt + Shift + ; ──► Win + Ctrl + Left
     │
     └── Alt + Shift + ' ──► Win + Ctrl + Right
```

## 4. Komorebi and native Windows Virtual Desktops

This setup does **not** modify Komorebi.

Komorebi continues to use its existing configuration and WHKD shortcuts.

Conceptually:

```text
┌───────────────────────────────┐
│        Windows Desktop        │
│                               │
│  AutoHotkey                   │
│  └─ Native Virtual Desktop    │
│                               │
│  Komorebi                     │
│  └─ Komorebi Workspaces       │
│                               │
│  WHKD                         │
│  └─ Komorebi keybindings      │
└───────────────────────────────┘
```

The two systems are intentionally kept separate.

Switching a native Windows Virtual Desktop should therefore leave Komorebi running normally. Komorebi's own workspace/window-management configuration is not changed by this AutoHotkey setup.

## Files

Recommended structure:

```text
Documents/
└── AutoHotkey/
    └── WindowsDesktop.ahk

AppData/
└── Roaming/
    └── Microsoft/
        └── Windows/
            └── Start Menu/
                └── Programs/
                    └── Startup/
                        └── WindowsDesktop.cmd
```

## Verification

After logging into Windows:

1. Confirm no script/editor error appears.
2. Press `Alt + Shift + ;`.
3. Confirm Windows switches to the previous native Virtual Desktop.
4. Press `Alt + Shift + '`.
5. Confirm Windows switches to the next native Virtual Desktop.
6. Confirm Komorebi is still running and its existing shortcuts/workspaces continue to work.

## Notes

- This setup only replaces the **desktop switching hotkeys**.
- It does not replace Komorebi's workspace management.
- It does not move applications between native Windows Virtual Desktops.
- It does not require the PowerShell `VirtualDesktop` module.
- It does not require a custom background helper application.
- Keep the AutoHotkey script and Startup launcher together in your dotfiles repository if you want to reproduce the setup on another Windows installation.

## Recreating the setup

1. Install AutoHotkey v2.
2. Copy `WindowsDesktop.ahk` to:
   `%USERPROFILE%\Documents\AutoHotkey\`
3. Copy `WindowsDesktop.cmd` to:
   `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\`
4. Verify the AutoHotkey executable path in the `.cmd`.
5. Log out/reboot and test the shortcuts.
