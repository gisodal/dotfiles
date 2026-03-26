#!/bin/zsh

function nvims() {
  items=("default" "nvim-custom" )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

function rebuild_completions() {
    rm "$ZSH_CONFIG_PATH/.zcompdump"
    compinit
}

function fzf-nx-widget() {
  # 1. Select Project
  # We use 'pnpm nx show projects' to get the list
  local project=$(pnpm nx show projects | fzf  --height='~40%' --layout=reverse --border --prompt="Nx Project > ")
  
  # If user cancels (Esc), abort and redraw prompt
  if [[ -z "$project" ]]; then zle redisplay; return; fi

  # 2. Select Target
  # We look up targets specifically for the chosen project using jq
  local target=$(pnpm nx show project "$project" --json | jq -r '.targets | keys[]' | fzf  --height='~40%' --layout=reverse --border --prompt="Nx Task ($project) > ")
  
  if [[ -z "$target" ]]; then zle redisplay; return; fi

  # 3. For synth/deploy, ask for environment and additional options
  if [[ "$target" == "synth" || "$target" == "deploy" || "$target" == "destroy" ]]; then
    # Get current git branch name
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "default")
    
    # Select environment
    local env=$(printf "%s\n" \
      "$current_branch" \
      "dev" \
      "default" \
      "qa" \
      "prod" \
      | fzf --height='~40%' --layout=reverse --border --prompt="Environment > ")
    
    if [[ -z "$env" ]]; then zle redisplay; return; fi
    
    # Get project path from nx
    local project_path="$(git rev-parse --show-toplevel)/$(pnpm nx show project "$project" --json | jq -r '.root')"
    
    # Select additional options
    local extra_args=""
    if [[ "$target" == "deploy" || "$target" == "destroy" ]]; then
      # For deploy, list stack templates from cdk.out or allow --all
      # Use glob pattern instead of find for better performance
      local stacks=()
      [[ -d "$project_path/cdk.out" ]] && stacks=(${(@f)"$(ls -1 "$project_path/cdk.out"/*.template.json 2>/dev/null | xargs -n1 basename -s .template.json | sort -V)"})
      local opts=$(printf "%s\n" \
        "--all" \
        ${stacks[@]} \
        "(none)" \
        | fzf  --height='~40%' --multi --layout=reverse --border --prompt="Deploy options > ")
      
      if [[ -z "$opts" ]]; then zle redisplay; return; fi
      [[ "$opts" != "(none)" ]] && extra_args=" $(echo "$opts" | tr '\n' ' ')"
    else
      # For synth, always use --all
      extra_args=" --all"
    fi
    
    [[ "$target" == "deploy" ]] && extra_args="$extra_args --require-approval=never"

    LBUFFER="${LBUFFER}pnpm nx $target $project -- --context env=$env$extra_args"
  else
    # For other targets, just insert the base command
    LBUFFER="${LBUFFER}pnpm nx $target $project -- "
  fi
  
  # Refresh the prompt so you see the text
  zle redisplay
}

# Register the widget with Zsh
zle     -N   fzf-nx-widget

# Bind it to Ctrl+n (You can change '^n' to whatever you like)
#bindkey '^n' fzf-nx-widget
# Bind to Ctrl+o in both Insert and Command modes
# This will NOT touch your Ctrl+n (down) binding
bindkey -M viins '^o' fzf-nx-widget
bindkey -M vicmd '^o' fzf-nx-widget
