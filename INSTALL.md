
## applications

	- feh    (set desktop wallpaper)
	- arandr (graphical screen settings, uses xrandr underneeth)
	- rofi   ( new dmenu)
	- dunst  (notifications)
	- scrot, imagemagick, i3lock. (lock screen)


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

## brightness control in i3

* install brightnessctl

    > sudo apt-get install brightnessctl


* Paste these lines in your i3 config file(~/.config/i3/config)

	- Increase brightness

	    bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +5%

	- Decrease brightness
   
	    bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 5%-

[source](https://github.com/particleofmass/i3wm_screen_brightness)
