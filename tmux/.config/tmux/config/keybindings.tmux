##  tmux confirm-before -p "Proceed to kill server (y/N)?" kill-server
## force a reload of the config file
bind r source-file ~/.config/tmux/tmux.conf\; display-message "Config reloaded..."

## for nested tmux sessions, with prefix 'C-a C-s'
bind C-s send-prefix

## enter scroll back mode
bind v copy-mode
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi y send -X copy-selection-and-cancel tmux-yank

## ------------------------------------------------------------------------------
## navigation
## ------------------------------------------------------------------------------
#
## session navigation
bind s   choose-session -F 'session #{session_name} #{?session_attached,(attached),          } : #{session_windows} windows (#{window_name}#{pane_title})' \; refresh-client -S
bind n   switch-client -n \; refresh-client -S
bind p   switch-client -p \; refresh-client -S
#
## window/pane navigation
bind k select-pane -U\; refresh-client -S
bind j select-pane -D\; refresh-client -S
bind l select-pane -R\; refresh-client -S
bind h select-pane -L\; refresh-client -S
#unbind .
#unbind ,

# window navigation
bind -r C-a last-window     \; refresh-client -S
bind -r C-p previous-window
bind -r C-n next-window
bind 0 select-window -t 10  \; refresh-client -S

# window creation/splitting
bind [ split-window -h -l 50% -p 50 -c "#{pane_current_path}"
bind ] split-window -v -l 50% -p 50 -c "#{pane_current_path}"
bind C-[ split-window -h -l 20% -p 20 -c "#{pane_current_path}"
bind C-] split-window -v -l 20% -p 20 -c "#{pane_current_path}"

bind c new-window -c "#{pane_current_path}"
bind C \
    run-shell 'tmux set-environment -g PANE_CURRENT_PATH #{pane_current_path}' \; \
    new-session 'cd $(eval "$(tmux showenv -g PANE_CURRENT_PATH)"; echo $PANE_CURRENT_PATH); bash -l'

bind i command-prompt -p 'Insert window at:' 'new-window -c "#{pane_current_path}" -a -t %1; swap-window -t -1'
bind I command-prompt -p 'New window at:' 'new-window -c "#{pane_current_path}" -t %1'

## resize pane
bind -r K resize-pane -U 2
bind -r J resize-pane -D 2
bind -r L resize-pane -R 2
bind -r H resize-pane -L 2
bind    m resize-pane -Z # toggle maximize pane

## window manipulations
bind R command-prompt -p "Rename window:" "rename-window %%"
#bind A command-prompt -p "Rename session:" "rename-session %%"
bind M command-prompt -p "Move window to:" "move-window -t %%"

