
## applications

	- feh    (set desktop wallpaper)
	- arandr (graphical screen settings, uses xrandr underneeth)
	- rofi   ( new dmenu)
	- dunst  (notifications)




## brightness control in i3

* install brightnessctl

    > sudo apt-get install brightnessctl


* Paste these lines in your i3 config file(~/.config/i3/config)

	- Increase brightness

	    bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +5%

	- Decrease brightness
   
	    bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 5%-

[source](https://github.com/particleofmass/i3wm_screen_brightness)
