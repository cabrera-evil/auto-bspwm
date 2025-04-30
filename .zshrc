# Path adjustments
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$PATH:/snap/bin
export PATH=~/.console-ninja/.bin:$PATH

# Oh My Zsh
export ZSH=$HOME/.oh-my-zsh

# Starship prompt
eval "$(starship init zsh)"

###################################
# Compinit configuration
###################################
autoload -Uz compinit
if [[ ! -d ~/.cache ]]; then
  mkdir -p ~/.cache
fi
compinit -d ~/.cache/zcompdump

###################################
# Plugins configuration
###################################
plugins=(
  # Core utilities
  fasd
  z
  extract
  safe-paste
  colored-man-pages
  web-search

  # Git
  git
  git-auto-fetch
  git-flow
  gitignore
  github
  git-extras
  # git-open
  # git-recall

  # DevOps / Infrastructure
  docker
  kubectl
  kubectx
  helm
  terraform
  # kube-aliases
  aws
  vault
  1password
  gpg-agent

  # Node / Frontend
  npm
  yarn
  vscode
  httpie

  # Productivity
  # zsh-abbr
  # zsh-you-should-use
  zsh-navigation-tools
  # navi

  # Input & UX enhancements
  # zsh-autopair
  zsh-history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  # fzf-tab
  # zsh-notify
)

###################################
# Completion configuration
###################################
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
zstyle ':completion:*' format '%F{blue}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*' select-prompt %SScrolling: current item at %p%s
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' list-prompt %SAt %p: hit TAB to select, or type more%s
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b)([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:aliases' auto-description 'alias for %d'
zstyle ':completion:*' use-compctl false

###################################
# Oh My Zsh startup
###################################
source $ZSH/oh-my-zsh.sh

###################################
# Prompt configuration
###################################
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###################################
# History configuration
###################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000

###################################
# Aliases
###################################
alias ll='/usr/bin/lsd -lh --group-dirs=first'
alias la='/usr/bin/lsd -a --group-dirs=first'
alias l='/usr/bin/lsd --group-dirs=first'
alias lla='/usr/bin/lsd -lha --group-dirs=first'
alias ls='/usr/bin/lsd --group-dirs=first'
alias lg='lazygit'
alias cat='/usr/bin/batcat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/batcat --paging=never'
alias c='clear'
alias e='exit'
alias v='nvim'
alias tmxn='tmuxifier new-session'
alias tmxe='tmuxifier edit-session'
alias tmxl='tmuxifier list-sessions'
alias tmxs='tmuxifier load-session'

###################################
# FZF configuration
###################################
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=border:#313244,label:#cdd6f4"

###################################
# Tmuxifier
###################################
if command -v tmuxifier &> /dev/null; then
  export PATH=$PATH:$HOME/.config/tmux/plugins/tmuxifier/bin
  eval "$(tmuxifier init -)"
fi

ZSH_TMUX_AUTOQUIT=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"
ZSH_TMUX_AUTONAME_SESSION=true

###################################
# Kubernetes configuration
###################################
if [ -d "$HOME/.kube" ]; then
  configs=($HOME/.kube/config*)
  export KUBECONFIG="${KUBECONFIG:+${KUBECONFIG}:}$(printf "%s:" "${configs[@]}" | sed 's/:$//')"
fi

###################################
# Editor configuration
###################################
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

###################################
# NVM configuration
###################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

###################################
# PNPM configuration
###################################
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

###################################
# Android SDK configuration
###################################
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

###################################
# AWS configuration
###################################
export AWS_PROFILE=default

###################################
# Docker configuration
###################################
export DOCKER_VOLUMES=/opt/docker/volumes
