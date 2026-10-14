# Mac Dot Files

My macOS setup, inspired by [Omarchy](https://omarchy.org). Keyboard driven tiling, a minimal status bar, no Dock, no menu bar and a Catppuccin Frappé theme throughout.

Based on these two write ups:

* [Building an Omarchy inspired setup on macOS](https://www.penkin.me/development/tools/productivity/configuration/2025/11/28/building-omarchy-inspired-setup-macos.html) by Christopher Penkin
* [My Mac tiling setup inspired by Omarchy](https://www.eddiedale.com/blog/my-mac-tiling-setup-inspired-by-omarchy) by Eddie Dale

## What's in here

| Package | What it configures |
| --- | --- |
| `aerospace` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling, workspaces and every keyboard shortcut |
| `sketchybar` | [SketchyBar](https://github.com/FelixKratz/SketchyBar), which replaces the menu bar |
| `borders` | [JankyBorders](https://github.com/FelixKratz/JankyBorders), the outline around the focused window |
| `ghostty` | Ghostty terminal and Catppuccin themes |
| `zed` | Zed settings, keymap and the formatter scripts it calls |
| `starship` | Shell prompt |
| `zsh` | Shell startup files |
| `git` | Git config and global ignore |
| `claude` | Claude instructions, settings, agents and the list of installed skills |

Each package mirrors the home folder, so `zed/.config/zed/settings.json` lives at `~/.config/zed/settings.json`. [GNU Stow](https://www.gnu.org/software/stow/) symlinks them into place.

`macos/defaults.sh` holds the system settings: hidden Dock and menu bar, Mission Control shortcuts and gestures turned off, fewer animations and faster key repeat.

## Install

```bash
git clone git@github.com:joshdonnell/mac-dot-files.git ~/mac-dot-files
cd ~/mac-dot-files
./install.sh
```

The install script runs `brew bundle`, links every package with Stow, applies the macOS settings and starts the services. Any config already on the machine is adopted into the repo, so run `git diff` afterwards to see what differs.

A few things need doing by hand:

1. Grant AeroSpace Accessibility access when asked.
2. Turn on Reduce Motion in System Settings > Accessibility > Display.
3. Log out and back in so the trackpad and key repeat settings apply.

## Keyboard shortcuts

Cmd plays the part of Omarchy's Super key. Shortcuts that would clash with everyday macOS shortcuts (Cmd+W, Cmd+T, Cmd+F and so on) move to Cmd+Ctrl instead. Press Cmd+Ctrl+K for the full cheat sheet.

### Apps

| Shortcut | Opens |
| --- | --- |
| Cmd+Enter | New terminal (Ghostty) |
| Cmd+Ctrl+Enter | Existing terminal |
| Cmd+Shift+Enter | Browser (Helium) |
| Cmd+Shift+N | Editor (Zed) |
| Cmd+Shift+F | Finder |
| Cmd+Shift+O | Obsidian |
| Cmd+Shift+G | GitHub Desktop |
| Cmd+Shift+B | Bloom |
| Cmd+Shift+M | Spotify |
| Cmd+Ctrl+Shift+D | TablePlus |
| Cmd+Ctrl+Shift+H | Herd |
| Cmd+Ctrl+Shift+I | PhpStorm |
| Cmd+Ctrl+Shift+T | Activity Monitor |
| Cmd+Space | Raycast |

App shortcuts focus the app's existing window on whatever workspace it is on, and only launch it when it has no window.

Web apps open in their own Helium window: Cmd+Ctrl+Shift with A (Claude), C (Calendar), E (Gmail), Y (YouTube), X, P (Photos), S (Maps), or Cmd+Ctrl+Alt+Shift+G (WhatsApp).

### Windows and workspaces

| Shortcut | Action |
| --- | --- |
| Cmd+1 to 9 | Switch workspace |
| Cmd+Ctrl+Shift+1 to 9 | Move window to workspace |
| Cmd+Ctrl+arrows | Focus window |
| Cmd+Ctrl+Shift+arrows | Swap window |
| Cmd+Ctrl+W | Close window |
| Cmd+Ctrl+F | Fullscreen |
| Cmd+Ctrl+T | Toggle floating |
| Cmd+Ctrl+J | Toggle split direction |
| Cmd+Ctrl+G | Toggle window group |
| Cmd+Ctrl+minus / equal | Resize |
| Cmd+Ctrl+Tab | Next workspace |
| Cmd+Ctrl+Shift+R | Reset layout and reload config |

## Notes

* On a notch MacBook, macOS reserves a 38px strip at the top of the built in display even with the menu bar hidden. SketchyBar is sized to fill that strip and AeroSpace only adds a normal gap there. External displays get room for the bar plus the gap.
* The clock sits on the right rather than in the centre like Omarchy, because the centre is hidden behind the notch.
* The wallpaper is "glowing city" from Omarchy's Osaka Jade theme. Wallpapers live in `~/Pictures/Wallpapers` and aren't part of this repo.
* Skills are not copied into the repo since most are third party. `claude/.agents/.skill-lock.json` lists the ones installed with `npx skills` and the repo each came from.
