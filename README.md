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

To install the dotfiles files, use `dot`:

    Usage: run [-v|-vv|-d] <command> [args]:

      Commands                    Description
      --------                    -----------
      stow                        List (and select) stowable packages
      stow <package>              Stow <package>
      ls                          List installers
      install [<package>]         Run an installer
      env                         Load environment variables
      test [run command]          Run tests, or test a specific command
      check <package>             Check if a package is installed

      Flags
      -----
      -v                          Debug output
      -vv                         Verbose output
      -d                          Dry run

      Examples
      --------
      run stow
      run stow nvim
      run install
      run install lynx
      run env

Examples:

    > ./dot stow shell
    > ./dot stow bash
    > ./dot stow git
    > ./dot stow git

To bootstrap a new user (default: `dotkeeper`) with a basic config setup, type:

```bash
curl -fsSL https://raw.githubusercontent.com/gisodal/dotfiles/main/bootstrap.sh | bash -s -- install
```

To remove the user, type

```bash
curl -fsSL https://raw.githubusercontent.com/gisodal/dotfiles/main/bootstrap.sh | bash -s -- clean
```

To have the script locally and run it, type:

```bash
curl -fsSL https://raw.githubusercontent.com/gisodal/dotfiles/main/bootstrap.sh -o /tmp/bootstrap.sh && bash /tmp/bootstrap.sh install
```

## Install applications

These are modern replacements for common applications, and a few that are just very useful.

| tool         | Replacing | Github                                          |
| ------------ | --------- | ----------------------------------------------- |
| fd           | find      | <https://github.com/sharkdp/fd>                 |
| jqp          | -         | <https://github.com/noahgorstein/jqp>           |
| jq           | -         | <https://github.com/jqlang/jq>                  |
| yq           | -         | <https://github.com/mikefarah/yq>               |
| dust         | df        | <https://github.com/bootandy/dust>              |
| ncdu         | df        | <https://github.com/rofl0r/ncdu>                |
| duf          | du        | <https://github.com/muesli/duf>                 |
| sd           | sed       | <https://github.com/chmln/sd>                   |
| zoxide (z)   | cd        | <https://github.com/ajeetdsouza/zoxide>         |
| eza          | ls        | <https://github.com/eza-community/eza>          |
| lsd          | ls        | <https://github.com/lsd-rs/lsd>                 |
| lf           | ls        | <https://github.com/gokcehan/lf>                |
| ranger       | ls        | <https://github.com/ranger/ranger>              |
| fzf          | -         | <https://github.com/junegunn/fzf>               |
| ripgrep (rg) | grep      | <https://github.com/BurntSushi/ripgrep>         |
| bat          | cat       | <https://github.com/sharkdp/bat>                |
| tldr         | man       | <https://github.com/tldr-pages/tldr>            |
| entr         | -         | <https://github.com/eradman/entr>               |
| ntfy         | -         | <https://github.com/binwiederhier/ntfy>         |
| ag           | ack       | <https://github.com/ggreer/the_silver_searcher> |
| xh           | curl      | <https://github.com/ducaale/xh>                 |
| dog          | dig       | <https://github.com/ogham/dog>                  |
| neovim       | vi        | <https://github.com/neovim/neovim>              |
| tmux         | screen    | -                                               |
| flameshot    | -         | <https://github.com/flameshot-org/flameshot>    |
| age          | gpg       | <https://github.com/FiloSottile/age>            |
| termshark    | wireshark | <https://github.com/gcla/termshark>             |
| atac         | insomnia  | <https://github.com/Julien-cpsn/ATAC>           |
| direnv       | -         | <https://github.com/direnv/direnv>              |
| getnf        | -         | <https://github.com/getnf/getnf>                |
| pwgen        | -         |

## Install TLDR; pages

    > sudo apt-get install tldr
    > tldr --update
