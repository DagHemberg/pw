# pw

A small utility script for picking passwords or other values from your Bitwarden / Vaultwarden items directly in your terminal.

![`pw` showcase with profile specification](showcase.png)

## Requirements

- [`rbw`](https://github.com/doy/rbw)
- [`fzf`](https://github.com/junegunn/fzf)
- [`jq`](https://jqlang.org/)
- [`fx`](https://fx.wtf/)
- [`wl-copy`](https://github.com/bugaevc/wl-clipboard) / [`xclip`](https://github.com/astrand/xclip) / `pbcopy`

For information on how to install each required program, please refer to their respective pages.[^1]

[^1]: Depending on your distro, one of these should likely already come preinstalled

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

[^2]: This has slightly different behaviour depending of the type of the item; for normal logins the password is copied, but for cards it's the card number, and for identities it's the name.
