<!--

********************************************************************************

WARNING:

    DO NOT EDIT "auto-bspwm/README.md"

    IT IS PARTIALLY AUTO-GENERATED

    (based on init.sh, keybindings, and system configuration)

********************************************************************************

-->

# Quick reference

- **Maintained by**:  
  [Douglas Cabrera](https://cabrera-dev.com)

- **Where to get help**:  
  [GitHub Issues](https://github.com/cabrera-evil/auto-bspwm/issues)

# What is auto-bspwm?

**auto-bspwm** is a Bash-based automation script that provisions a customized, keyboard-centric, and professional desktop environment for Kali Linux using the [bspwm](https://github.com/baskerville/bspwm) window manager. It includes curated defaults for hacking, productivity, and aesthetics with minimal post-install configuration.

# Installation

1. **Update the system**

```bash
sudo apt update
sudo apt upgrade -y
```

2. **Clone the repository**

```bash
git clone https://github.com/cabrera-evil/auto-bspwm.git
cd auto-bspwm
```

3. **Make the script executable**

```bash
chmod +x init.sh
```

4. **Run the setup**

```bash
./init.sh
```

5. **Reboot and select `bspwm`**

After rebooting, select the `bspwm` session from your login manager.

# Environment overview

![overview1](/assets/overview1.png)
![overview2](/assets/overview2.png)
![overview3](/assets/overview3.png)

# Keyboard shortcuts

Below is a categorized list of keybindings configured via `sxhkd`. This environment uses the Super (<kbd>Windows</kbd>) key as the primary modifier.

## Window Manager Hotkeys

- <kbd>Super</kbd> + <kbd>Return</kbd>: Launch terminal (Kitty)
- <kbd>Super</kbd> + <kbd>D</kbd>: Launch Rofi
- <kbd>Super</kbd> + <kbd>Escape</kbd>: Reload `sxhkd`

## BSPWM Control

- <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>: Quit `bspwm`
- <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd>: Restart `bspwm`
- <kbd>Super</kbd> + <kbd>W</kbd>: Close window
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd>: Kill window
- <kbd>Super</kbd> + <kbd>M</kbd>: Toggle layout (monocle/tiled)
- <kbd>Super</kbd> + <kbd>Y</kbd>: Send marked node to preselected node
- <kbd>Super</kbd> + <kbd>G</kbd>: Swap with biggest window

## State & Flags

- <kbd>Super</kbd> + <kbd>T</kbd>: Set tiled mode
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd>: Set pseudo-tiled
- <kbd>Super</kbd> + <kbd>S</kbd>: Set floating
- <kbd>Super</kbd> + <kbd>F</kbd>: Set fullscreen
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>M</kbd>: Toggle mark
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>X</kbd>: Toggle lock
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Y</kbd>: Toggle sticky
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Z</kbd>: Toggle private

## Focus & Swap

- <kbd>Super</kbd> + <kbd>H/J/K/L</kbd>: Move focus (←↓↑→)
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>H/J/K/L</kbd>: Swap windows
- <kbd>Super</kbd> + <kbd>P</kbd>: Focus parent
- <kbd>Super</kbd> + <kbd>B</kbd>: Focus brother
- <kbd>Super</kbd> + <kbd>,</kbd> / <kbd>.</kbd>: Focus first/second child
- <kbd>Super</kbd> + <kbd>C</kbd>: Focus next
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd>: Focus previous
- <kbd>Super</kbd> + <kbd>\[</kbd> / <kbd>]</kbd>: Switch desktop
- <kbd>Super</kbd> + <kbd>Grave</kbd>: Focus last node
- <kbd>Super</kbd> + <kbd>Tab</kbd>: Focus last desktop
- <kbd>Super</kbd> + <kbd>O</kbd>: Focus older
- <kbd>Super</kbd> + <kbd>I</kbd>: Focus newer
- <kbd>Super</kbd> + <kbd>1–9</kbd> / <kbd>0</kbd>: Switch to workspace
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1–9</kbd> / <kbd>0</kbd>: Move window to workspace

## Preselection

- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>H/J/K/L</kbd>: Preselect direction
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>1–9</kbd>: Preselect ratio
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Space</kbd>: Cancel preselection (node)
- <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd>: Cancel preselection (desktop)

## Resize & Move

- <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>H/J/K/L</kbd>: Expand window
- <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>H/J/K/L</kbd>: Contract window
- <kbd>Super</kbd> + <kbd>←/↓/↑/→</kbd>: Move floating window

## Monitors

- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd>: Focus next monitor
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd>: Focus previous monitor

## Application Shortcuts

- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>: Launch Blueman
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>G</kbd>: Launch Google Chrome
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd>: Launch Ranger in Kitty
- <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>: Launch Spotify

## System Controls

- <kbd>Ctrl</kbd> + <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd>: Power off
- <kbd>Ctrl</kbd> + <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd>: Reboot
- <kbd>Ctrl</kbd> + <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>: Lock (i3lock-fancy)

## Media & Audio

- <kbd>XF86AudioPlay</kbd> / <kbd>Prev</kbd> / <kbd>Next</kbd> / <kbd>Stop</kbd>: Media control via `playerctl`
- <kbd>XF86AudioMute</kbd> / <kbd>LowerVolume</kbd> / <kbd>RaiseVolume</kbd>: Volume control via `amixer`
- <kbd>XF86AudioMicMute</kbd>: Toggle microphone

## Brightness

- <kbd>XF86MonBrightnessDown</kbd> / <kbd>Up</kbd>: Adjust screen brightness

## Screenshots

- <kbd>Print</kbd>: Full screenshot to clipboard (`flameshot`)
- <kbd>Ctrl</kbd> + <kbd>Print</kbd>: GUI selection screenshot to clipboard

# Software stack

Includes the following tools and components:

- **WM**: bspwm
- **Hotkey Daemon**: sxhkd
- **Bar**: polybar + polybar-themes
- **Terminal**: kitty, qterminal
- **Launcher**: rofi
- **Compositor**: picom
- **File Manager**: thunar
- **Wallpaper**: feh
- **Shell**: zsh + powerlevel10k + oh-my-zsh
- **Color Scheme**: pywal
- **Browsers**: firefox, google-chrome
- **Screenshot**: flameshot
- **Fonts**: iosevka, hack

# License

This project is released under the [MIT License](LICENSE).
