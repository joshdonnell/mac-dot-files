# Mac Dot Files

My macOS setup, inspired by [Omarchy](https://omarchy.org). Keyboard driven tiling, a minimal status bar, no Dock, no menu bar and the Osaka Jade theme from Omarchy throughout.

Based on these two write ups:

* [Building an Omarchy inspired setup on macOS](https://www.penkin.me/development/tools/productivity/configuration/2025/11/28/building-omarchy-inspired-setup-macos.html) by Christopher Penkin
* [My Mac tiling setup inspired by Omarchy](https://www.eddiedale.com/blog/my-mac-tiling-setup-inspired-by-omarchy) by Eddie Dale

## What's in here

| Package | What it configures |
| --- | --- |
| `aerospace` | [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling, workspaces and every keyboard shortcut |
| `aerospace-swipe` | Settings for [aerospace-swipe](https://github.com/acsandmann/aerospace-swipe), which switches workspaces with a three finger swipe |
| `sketchybar` | [SketchyBar](https://github.com/FelixKratz/SketchyBar), which replaces the menu bar |
| `borders` | [JankyBorders](https://github.com/FelixKratz/JankyBorders), the outline around the focused window |
| `ghostty` | Ghostty terminal and themes |
| `zed` | Zed settings, keymap, Osaka Jade theme and the formatter scripts it calls |
| `starship` | Shell prompt |
| `zsh` | Shell startup files |
| `git` | Git config and global ignore |
| `claude` | Claude instructions, settings, agents and the list of installed skills |

Each package mirrors the home folder, so `zed/.config/zed/settings.json` lives at `~/.config/zed/settings.json`. [GNU Stow](https://www.gnu.org/software/stow/) symlinks them into place.

`macos/defaults.sh` holds the system settings. See [macOS settings](#macos-settings) for the full list.

## Install

```bash
git clone git@github.com:joshdonnell/mac-dot-files.git ~/mac-dot-files
cd ~/mac-dot-files
./install.sh
```

The install script runs `brew bundle`, links every package with Stow, applies the macOS settings and starts the services. Any config already on the machine is adopted into the repo, so run `git diff` afterwards to see what differs.

A few things need doing by hand:

1. Grant AeroSpace and AerospaceSwipe Accessibility access when asked.
2. Turn on Reduce Motion in System Settings > Accessibility > Motion.
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
| Cmd+Ctrl+F | Fullscreen, edge to edge |
| Cmd+Ctrl+Alt+F | Fullscreen, keeping gaps |
| Cmd+Ctrl+C | Screenshot an area (Shottr) |
| Cmd+Ctrl+Alt+C | Screenshot the whole screen (Shottr) |
| Cmd+Ctrl+T | Toggle floating |
| Cmd+Ctrl+J | Toggle split direction |
| Cmd+Ctrl+G | Toggle window group |
| Cmd+Ctrl+minus / equal | Resize |
| Cmd+Ctrl+Tab and Cmd+Ctrl+Shift+Tab | Next or previous workspace with windows |
| Three finger swipe left or right | Next or previous workspace with windows |
| Cmd+Ctrl+Shift+R | Reset layout and reload config |

## macOS settings

Every system setting this setup changes. The ones marked **script** are applied by `macos/defaults.sh`; the ones marked **manual** have to be done by hand because macOS blocks scripts from changing them.

### Menu bar and Dock

| Setting | Value | How |
| --- | --- | --- |
| Automatically hide and show the menu bar | Always | script: `NSGlobalDomain _HIHideMenuBar = true`, `com.apple.controlcenter AutoHideMenuBarOption = 0` |
| Dock auto hide | On | script: `com.apple.dock autohide = true` |
| Delay before the Dock appears | 1000 seconds, so it never shows | script: `com.apple.dock autohide-delay = 1000` |
| Dock show and hide animation | Instant | script: `com.apple.dock autohide-time-modifier = 0` |
| Bounce when opening apps | Off | script: `com.apple.dock launchanim = false` |

### Spaces and Mission Control

| Setting | Value | How |
| --- | --- | --- |
| Automatically rearrange Spaces based on most recent use | Off | script: `com.apple.dock mru-spaces = false` |
| Group windows by application | On, as AeroSpace recommends | script: `com.apple.dock expose-group-apps = true` |
| Mission Control and App Exposé trackpad gestures | Off | script: `com.apple.dock showMissionControlGestureEnabled` and `showAppExposeGestureEnabled = false` |
| Three and four finger swipes up and sideways | Off in macOS, so aerospace-swipe can use three finger sideways swipes for workspaces | script: `Trackpad{Three,Four}Finger{Vert,Horiz}SwipeGesture = 0` for the built in and Bluetooth trackpads, plus the matching `com.apple.trackpad.*SwipeGesture` keys |
| Mission Control (Ctrl+Up) and Application windows (Ctrl+Down) shortcuts | Off | script: symbolic hot keys 32, 33, 34 and 35 disabled |
| Move left or right a Space (Ctrl+Left and Ctrl+Right) | Off | script: symbolic hot keys 79, 80, 81 and 82 disabled |

Hot corners were already off. The Mission Control key (F3) can't be disabled through settings.

### Animations and keyboard

| Setting | Value | How |
| --- | --- | --- |
| Window opening animations | Off | script: `NSGlobalDomain NSAutomaticWindowAnimationsEnabled = false` |
| Window resize animation | Instant | script: `NSGlobalDomain NSWindowResizeTime = 0.001` |
| Finder animations | Off | script: `com.apple.finder DisableAllAnimations = true` |
| Key repeat rate | Fastest (2) | script: `NSGlobalDomain KeyRepeat = 2` |
| Delay until repeat | Shortest (15) | script: `NSGlobalDomain InitialKeyRepeat = 15` |
| Reduce Motion | On | manual: System Settings > Accessibility > Motion > Reduce Motion |

### Apps and appearance

| Setting | Value | How |
| --- | --- | --- |
| Helium theme colour | `#111c18` (Osaka Jade) | script: `net.imput.helium BrowserThemeColor`, applied after Helium restarts |
| Desktop wallpaper | Osaka Jade "glowing city" | manual: System Settings > Wallpaper, using `~/Pictures/Wallpapers/osaka-jade/1-glowing-city.png` |
| Obsidian theme | Verso Osaka Jade | manual: copy `obsidian/Verso Osaka Jade` into the vault's `.obsidian/themes` and pick it in Settings > Appearance |
| AeroSpace and AerospaceSwipe Accessibility access | Allowed | manual: approve the prompt on first launch, or add them in System Settings > Privacy & Security > Accessibility |
| MX Master gesture button | Hold and move left for the next workspace, right for the previous one | manual: Logi Options+ > Buttons > Gesture button > Custom, set left to Cmd+Ctrl+Tab and right to Cmd+Ctrl+Shift+Tab |

AeroSpace starts at login from its own config, and SketchyBar and JankyBorders run as Homebrew services.

### Undoing a setting

Delete the key and restart the process that owns it. For example, to bring the Dock back:

```bash
defaults delete com.apple.dock autohide-delay
killall Dock
```

Trackpad gestures and the Mission Control shortcuts are quicker to turn back on in System Settings > Trackpad > More Gestures and System Settings > Keyboard > Keyboard Shortcuts > Mission Control.

## Notes

* On a notch MacBook, macOS reserves a 38px strip at the top of the built in display even with the menu bar hidden. SketchyBar is sized to fill that strip and AeroSpace only adds a normal gap there. External displays get room for the bar plus the gap.
* The clock sits on the right rather than in the centre like Omarchy, because the centre is hidden behind the notch.
* `obsidian/Verso Osaka Jade` is the [Verso](https://fabrizio.so) Obsidian theme by Fabrizio Rinaldi, with Omarchy's Osaka Jade colours added for dark mode. Copy it into a vault's `.obsidian/themes` folder and pick it in Settings > Appearance.
* Helium takes the Osaka Jade background through Chromium's `BrowserThemeColor` policy, set in `macos/defaults.sh`. It applies after Helium restarts.
* The wallpaper is "glowing city" from Omarchy's Osaka Jade theme. Wallpapers live in `~/Pictures/Wallpapers` and aren't part of this repo.
* Skills are not copied into the repo since most are third party. `claude/.agents/.skill-lock.json` lists the ones installed with `npx skills` and the repo each came from.
