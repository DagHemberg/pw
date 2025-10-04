# pw

![pw showcase with profile specification](showcase.png)

`pw` is a small collection of scripts for picking passwords or other values from your Bitwarden / Vaultwarden items, directly in your terminal.

Under the hood it uses [`rbw`](https://github.com/doy/rbw) as the password manager CLI, [`fzf`](https://github.com/junegunn/fzf) as the picker / fuzzy finder, [`jq`](https://jqlang.org/) for the preview window and [`fx`](https://fx.wtf/) for more detailed inspection of items in your vault (which can then be used to copy values which don't have pre-set shortcut keys)

## Requirements

- rbw
- fzf
- jq
- fx
- A clipboard CLI utility

For information on how to install each required program, please refer to their respective pages.[^1]

[^1]: Depending on your DE / WM / OS, a clipboard CLI utility should likely already come preinstalled -- this script checks for [`wl-copy`](https://github.com/bugaevc/wl-clipboard) (Wayland), [`xclip`](https://github.com/astrand/xclip) (X11), `pbcopy` (macOS) and `clip.exe` (WSL, through Windows interop)

## Installation

```sh
$ git clone git@github.com/daghemberg/pw.git
$ cd pw
$ chmod +x ./pw.sh
$ sudo ln -s "$(pwd -P)/pw.sh" /usr/local/bin/pw
# on macOS:
$ sudo chmod -h +x /usr/local/bin/pw
```

## Usage

```sh
# open the picker
$ pw

# specify RBW_PROFILE
$ pw --profile work
$ pw -p work
```

While in the picker, the following keybinds apply:

| Key | Action |
| -------------- | --------------- |
| `enter` | Copy password[^2] |
| `ctrl+u` | Copy username |
| `ctrl+t` | Copy TOTP code |
| `ctrl+p` | Open item in `fx` |

[^2]: This has slightly different behaviour depending of the type of the item; for normal login items the password is copied, but for cards it's instead the card number, and for identities it's the full name.
