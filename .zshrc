# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
eval "$(starship init zsh)"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # Git & Git-related
  git
  git-auto-fetch
  git-flow
  git-prompt
  gitignore
  github
  git-extras

  # AWS, Docker, Terraform, Kubernetes
  aws
  docker
  kubectl
  kubectx
  helm
  terraform

  # Tools & Utilities
  battery
  tmux
  you-should-use
  zsh-autosuggestions
  zsh-interactive-cd
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-navigation-tools
  fasd
  history
  history-substring-search

  # Security & Password Management
  1password
  vault

  # Other tools
  npm
  yarn
)

###################################
# TMUX configuration
###################################
# Auto-start tmux if not already in a session
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true

# Use a default named session (you can attach manually to others if needed)
ZSH_TMUX_DEFAULT_SESSION_NAME="dev"

# Auto-reconnect to existing session on tmux exit (e.g., if tmux crashes)
ZSH_TMUX_AUTOCONNECT=true

# Don't close terminal if tmux exits — for debugging or fallback shell
ZSH_TMUX_AUTOQUIT=true

# Fix $TERM properly to support 256-color + tmux
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

# Auto-name sessions by folder (nice for multiple projects)
ZSH_TMUX_AUTONAME_SESSION=true

# Optional: Set config path (useful if you use ~/.config/tmux/tmux.conf)
# ZSH_TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

###################################
# Oh My Zsh startup
###################################
source $ZSH/oh-my-zsh.sh

###################################
# User configuration
###################################

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

###################################
# Custom configuration
###################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###################################
# Terminal configuration
###################################
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

###################################
# History configuration
###################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000

###################################
# Aliases configuration
###################################
alias ll='/usr/bin/lsd -lh --group-dirs=first'
alias la='/usr/bin/lsd -a --group-dirs=first'
alias l='/usr/bin/lsd --group-dirs=first'
alias lla='/usr/bin/lsd -lha --group-dirs=first'
alias ls='/usr/bin/lsd --group-dirs=first'
alias cat='/usr/bin/batcat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/batcat --paging=never'
alias c='clear'
alias e='exit'
alias v='nvim'
alias wgs="sudo wg-quick up wg0"
alias wgf="sudo wg-quick down wg0"
alias tmxn='tmuxifier new-session'
alias tmxe='tmuxifier edit-layout'
alias tmxl='tmuxifier list-layouts'
alias tmxs='tmuxifier load-session'

###################################
# Tmuxifier configuration
###################################
export PATH=$PATH:$HOME/.config/tmux/plugins/tmuxifier/bin
eval "$(tmuxifier init -)"
###################################
# K8s Configuration
###################################
if [ -d "$HOME/.kube" ]; then
  configs=($HOME/.kube/config*)
  export KUBECONFIG="${KUBECONFIG:+${KUBECONFIG}:}$(printf "%s:" "${configs[@]}" | sed 's/:$//')"
  function kubectx_prompt_info() {
    local ctx=$(kubectl config current-context 2>/dev/null)
    [[ -z "$ctx" ]] && return
    local color symbol
    case "$ctx" in
      *raspberry*|*pi*)
        color="%F{162}"
        symbol=""
        ;;
      *local*)
        color="%F{70}"
        symbol="󰟐"
        ;;
      *staging*)
        color="%F{33}"
        symbol=""
        ;;
      *prod*|*production*)
        color="%F{160}"
        symbol="󰞵"
        ;;
      *dev*)
        color="%F{106}"
        symbol=""
        ;;
      *gke*)
        color="%F{39}"
        symbol=""
        ;;
      *eks*)
        color="%F{172}"
        symbol=""
        ;;
      *aks*)
        color="%F{27}"
        symbol=""
        ;;
      *)
        color="%F{249}"
        symbol="⎈"
        ;;
    esac
    echo "${color}[${symbol} ${ctx}]%f"
  }
  RPROMPT='$(kubectx_prompt_info)'
fi

###################################
# Console Ninja configuration
###################################
PATH=~/.console-ninja/.bin:$PATH

###################################
# Snap configuration
###################################
export PATH=$PATH:/snap/bin

###################################
# NVM configuration
###################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

###################################
# PNPM configuration
###################################
export PNPM_HOME="/home/douglas/.local/share/pnpm"
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

