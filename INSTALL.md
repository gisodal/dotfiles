## Quick ubuntu install 

	> sudo apt-get install tmux git stow
	> install local
	> install tmux-legacy
	> install bash
	> install git

## update terminfo for alacritty

    > curl -O https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info
    > sudo tic -xe alacritty,alacritty-direct alacritty.info

echo properties with:

    > infocmp -L alacritty alacritty-direct

## Full install (on Fedora 39 (GNOME))
   
    1. Configure ssh

	> cp -r <.ssh/dir> ~/.ssh
	> chmod 700 ~/.ssh
	> chmod 700 ~/.ssh/keys
	> chmod 600 ~/.ssh/*
	> chmod 600 ~/.ssh/keys/*

    2. Install config: 

        > sudo dnf install git
        > git clone https://github.com/gisodal/dotfiles.git ~/trunk/dotfiles
        > sudo dnf install stow
        > rm ~/.config/user-dirs.*
        > rm ~/.bash*
        > cd ~/trunk/dotfiles 
        > ./install
      
    3. Install terminal (gnome)

        > sudo dnf install alacritty
        > gsettings set org.gnome.desktop.default-applications.terminal exec alacritty

    4. Install JetBrainsMono font
	
	* fedora
	> mkdir font
	> cd font
	> wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	> unzip JetBrainsMono.zip
	> mkdir -p ~/.local/share/fonts
	> mv JetBrainsMono ~/.local/share/fonts
        > fc-cache -f -v

	* macos
	> brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font

    5. set up ZSH

        > sudo dnf install zsh
        > sudo chsh -s /bin/zsh <username>
	> cd ~/.config/zsh/install_plugins.sh
        
    6. setup tmux

        > sudo dnf install tmux
        > mkdir -p ~/.config/tmux/plugins
        > git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm 
        
        - install plugins: 
            [Press <prefix> I]
      
      
## Fedora update issue

Try: 

	> sudo dnf distrosync
	> sudo dnf remove --duplicates


## fonts

1. Install the font by placing ttf files in `HOME/.local/share/fonts`
2. Activate bitmaps
	
	> sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf

3. Update the font cache:
	
	- add to .xinitrc (when use X11):
		
		xset +fp $HOME/.local/share/fonts
		xset fp rehash 

	- update cache

		> fc-cache -f -v

4. List font names

	> fc-match NameOfFont -s

5. Check font installation:

	> fc-list | grep -i "<font name>"
	> fc-match <font name>
	> xlsfonts | grep -i "<font name>"

