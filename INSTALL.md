
## Dependencies

### applications
	- feh    (set desktop wallpaper)
	- arandr (graphical screen settings, uses xrandr underneeth)
	- rofi   ( new dmenu)
	- dunst  (notifications)
	- scrot, imagemagick, i3lock. (lock screen)
	- polybar (i3 bar)
	- picom  (compositor)
	- lf (https://github.com/gokcehan/lf)

### fonts
	- Nerd fonts:
		- available at https://www.nerdfonts.com/font-downloads
	- JetBrainsMono Nerd font
		- available at: https://github.com/ryanoasis/nerd-fonts/releases
	- Hack
		- available at: https://github.com/source-foundry/Hack/releases
	- System San Francisco Display
		- available at: https://github.com/supermarin/YosemiteSanFranciscoFont/tree/master
	- Siji icons
		- available at: https://github.com/stark/siji

## appearance

### intall Arc dark theme
	
	* GTK theme:
		- github: horst3180/arc-theme
		- ubuntu: sudo apt-get install arc-theme
		- use lxappearance and select arc-dark

	* chrome:
		- https://chromewebstore.google.com/detail/arc-dark/adicoenigffoolephelklheejpcpoolk

	* icons
		- download moka theme: https://www.snwh.org/moka/download
		- install
		- use lxappearance -> tab icon theme
	
	* rofi
		- run rofi-theme-selector
		- select Arc-dark

## fonts

1. Install the font by placing ttf files in `HOME/.local/share/fonts`
2. Activate bitmaps
	
	> sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf

3. Update the font cache:
	
	- add to .xinitrc:
		
        xset +fp $HOME/.local/share/fonts
        xset fp rehash 

	- update cache

		> xset +fp $HOME/.local/share/fonts 
        > xset fp rehash  
        > fc-cache -f -v

4. Check font installation:

	> fc-list | grep -i "<font name>"
	> fc-match <font name>
	> xlsfonts | grep -i "<font name>"


## brightness control in i3

* install brightnessctl

    > sudo apt-get install brightnessctl


* Paste these lines in your i3 config file(~/.config/i3/config)

	- Increase brightness

	    bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +5%

	- Decrease brightness
   
	    bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 5%-

[source](https://github.com/particleofmass/i3wm_screen_brightness)
