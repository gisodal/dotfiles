## ============== theme configuration =======================
set -g @catppuccin_flavor 'mocha' # or frappe, macchiato, mocha

# status bar background
set -g status-bg "#000000"

set -g @catppuccin_window_status_style "rounded"

## window elements
set -g @catppuccin_window_number_position "left"

# leave this unset to let applications set the window title
set -g @catppuccin_window_status "none"
set -g @catppuccin_window_current_background "#{@thm_peach}"

set -g @catppuccin_window_default_fill "number" # or 'number' the number is highlighted
set -g @catppuccin_window_default_text "#W#{?window_zoomed_flag, ↕,}"

set -g @catppuccin_window_current_fill "all" # the number and text field are highlighted
set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag, ↕,}"

## status bar stuff
set -g @catppuccin_status_right_separator " "

set -g @catppuccin_status_right_separator_inverse "no"
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "no"

# Load catppuccin
run "$HOME/.config/tmux/plugins/catppuccin/catppuccin.tmux"

# Make the status line pretty and add some modules
set -g status-left " "

set -g @catppuccin_date_time_text "%d-%m-%Y %H:%M"

set -g status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_date_time}"

# disable color change on window activity
set -g window-status-activity-style default