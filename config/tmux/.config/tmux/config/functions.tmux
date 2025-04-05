# kill pane/window/session
bind C-x command-prompt -p 'Windows to kill:' '             \
    run-shell "                                             \
        for w in \$(echo %% | sort -n -r); do               \
            tmux kill-window -t \$w;                        \
        done;                                               \
    "'

bind-key X if-shell '[ $(tmux list-sessions | wc -l) -ne 1 ]' \
                    "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'" \
                    "run-shell 'tmux kill-session -t \"#S\"'"

bind D confirm-before -p 'Kill tmux (y/N)?' '                                                   \
    run-shell "                                                                                 \
        for s in \$(tmux list-sessions -F \"\##{session_name}\"); do                            \
            for w in \$(tmux list-windows -t \$s -F \"##{window_index}\"); do                   \
                for p in \$(tmux list-panes -t \"\$s:\$w\" -F \"##{pane_index}\"); do           \
                    t=\"\$s:\$w.\$p\";                                                          \
                    bin=\$(tmux display-message -t \$t -p -F \"##{pane_current_command}\");     \
                    if [ \"\$bin\" = \"vim\" ]; then                                            \
                        tmux send-keys -t \$t Escape;                                           \
                        tmux send-keys -t \$t :qa;                                              \
                        tmux send-keys -t \$t Enter;                                            \
                        sleep 0.5; tmux refresh-client -S;                                      \
                        bin=\$(tmux display-message -t \$t -p -F \"##{pane_current_command}\"); \
                        if [ \"\$bin\" = \"vim\" ]; then                                        \
                            tmux send-keys -t \$t Escape;                                       \
                            tmux select-pane -t \$t;                                            \
                            tmux select-window -t \"\$s:\$w\";                                  \
                            tmux display-message \"Exit vim and re-run the command...\";        \
                            exit 0;                                                             \
                        fi;                                                                     \
                    fi;                                                                         \
                done;                                                                           \
            done;                                                                               \
        done;                                                                                   \
        tmux confirm-before -p \"Confirm kill tmux (y/N)?\" kill-server;                        \
    "'


