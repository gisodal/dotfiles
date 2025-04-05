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


