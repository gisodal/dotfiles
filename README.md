```
      ██            ██     ████ ██  ██
     ░██           ░██    ░██░ ░░  ░██
     ░██  ██████  ██████ ██████ ██ ░██  █████   ██████
  ██████ ██░░░░██░░░██░ ░░░██░ ░██ ░██ ██░░░██ ██░░░░
 ██░░░██░██   ░██  ░██    ░██  ░██ ░██░███████░░█████
░██  ░██░██   ░██  ░██    ░██  ░██ ░██░██░░░░  ░░░░░██
░░██████░░██████   ░░██   ░██  ░██ ███░░██████ ██████
 ░░░░░░  ░░░░░░     ░░    ░░   ░░ ░░░  ░░░░░░ ░░░░░░
```

## Requirements

Gnu Stow is used to install the config files.

## Installation

To install the config files, type:

    > ./install [[package] .. [package]]


Examples:
    > ./install

    > ./install bash

    > ./install git vim

For more specific instructions go to [INSTALL](INSTALL.md).

## Install applications

These are modern replacements for common applications, and a few that are just very usefull.


|  tool    |  Replacing  |  Github                                         |
|  --      |  ----     |  --                                             |
|  fd      |  find     |  https://github.com/sharkdp/fd                  |
|  jqp     |  -        |  https://github.com/noahgorstein/jqp            |
|  jq      |  -        |  https://github.com/jqlang/jq                   |
|  yq      |  -        |  https://github.com/mikefarah/yq                |
|  dust    |  df       |  https://github.com/bootandy/dust               |
|  ncdu    |  df       |  https://github.com/rofl0r/ncdu                 |
|  duf     |  du       |  https://github.com/muesli/duf                  |
|  sd      |  sed      |  https://github.com/chmln/sd                    |
|  zoxide (z)  |  ch       |  https://github.com/ajeetdsouza/zoxide          |
|  exa     |  ls       |  https://github.com/ogham/exa                   |
|  lf      |  ls       |  https://github.com/gokcehan/lf                 |
|  ranger  |  ls       |  https://github.com/ranger/ranger               |
|  fzf     |  -        |  https://github.com/junegunn/fzf                |
|  ripgrep (rg)      |  grep     |  https://github.com/BurntSushi/ripgrep          |
|  bat     |  cat      |  https://github.com/sharkdp/bat                 |
|  tldr    |  man      |  https://github.com/tldr-pages/tldr             |
|  entr    |  -        |  https://github.com/eradman/entr                |
|  ntfy    |  -        |  https://github.com/binwiederhier/ntfy          |
|  ag      |  ack      |  https://github.com/ggreer/the_silver_searcher  |
|  xh      |  curl     |  https://github.com/ducaale/xh                  |
|  dog     |  dig      |  https://github.com/ogham/dog                   |
| neovim   | vi        |  https://github.com/neovim/neovim               |
| tmux     | screen    | - |
| flameshot | - | https://github.com/flameshot-org/flameshot |

### Applications for i3 based desktop

| application | description
| --          | -- 
| i3          | X11 tiling window manager
| i3lock      | lock screen
| polybar     | i3 bar
| picom       | compositor
| feh         | set desktop wallpaper
| arandr      | graphical screen settings, uses xrandr underneeth
| rofi        | new dmenu
| dunst       | notifications
