# Path adjustments
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$PATH:/snap/bin
export PATH=~/.console-ninja/.bin:$PATH

# Oh My Zsh
export ZSH=$HOME/.oh-my-zsh

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
  # Core Shell Utilities
  aliases
  common-aliases
  command-not-found
  debian
  extract
  history
  safe-paste
  copypath
  rsync
  sudo
  # Git & Version Control
  git
  git-auto-fetch
  git-extras
  git-flow
  gh
  git-open
  gitignore
  github
  # Node Development
  bun
  deno
  npm
  pm2
  yarn
  nvm
  vscode
  # Go Development
  golang
  mise
  # Python Development
  python
  uv
  # Productivity & API Tools
  fzf
  httpie
  jsontools
  web-search
  you-should-use
  # System Tools & Information
  battery
  encode64
  kitty
  ngrok
  nmap
  systemd
  starship
  tailscale
  tmux
  ufw
  # DevOps / Cloud / Infrastructure
  1password
  aws
  azure
  docker
  docker-compose
  gcloud
  gpg-agent
  helm
  k9s
  kube-ps1
  kubectl
  kubectx
  ssh
  ssh-agent
  terraform
  ansible
  vault
  # UX & Input Enhancements
  colored-man-pages
  fzf-tab
  zsh-autopair
  zsh-history-substring-search
  zsh-navigation-tools
  # Navigation / History Helpers
  fasd
  z
  # Syntax & Suggestions (Must be last)
  zsh-autosuggestions
  zsh-syntax-highlighting
)

###################################
# Optional plugin loading
###################################
if command -v direnv &> /dev/null; then
  plugins+=(direnv)
fi

# Remove stale global alias from previously loaded common-aliases plugin.
# Prevents `pygmentize` errors on `reload` when `P` remains in current shell state.
unalias 'P' 2>/dev/null || true

###################################
# Plugin settings
###################################
export SHOW_AWS_PROMPT=false
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes

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

# Keep `common-aliases` loaded but avoid errors when pygmentize is missing.
if ! command -v pygmentize &> /dev/null; then
  alias -g P='2>&1 | cat'
fi

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
# Core shell
alias c='clear'
alias e='exit'
alias reload='source ~/.zshrc'
alias weather='curl wttr.in'
alias myip='curl -s ifconfig.me && echo'

# File listing / viewing
alias l='/usr/bin/lsd --group-dirs=first'
alias la='/usr/bin/lsd -a --group-dirs=first'
alias ll='/usr/bin/lsd -lh --group-dirs=first'
alias lla='/usr/bin/lsd -lha --group-dirs=first'
alias ls='/usr/bin/lsd --group-dirs=first'
alias cat='/usr/bin/batcat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/batcat --paging=never'

# Tools / apps
alias fastfetch='fastfetch --logo ~/.config/ascii/$ZSH_ASCII_ART.txt'
alias ra='ranger'
alias v='nvim'
alias lg='lazygit'
alias lr='lazydocker'
alias or='ollama run $ZSH_OLLAMA_MODEL'
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

# Tmuxifier
alias tmxn='tmuxifier new-session'
alias tmxe='tmuxifier edit-session'
alias tmxl='tmuxifier list-sessions'
alias tmxs='tmuxifier load-session'

# Security / Fail2ban
alias f2b='sudo fail2ban-client'
alias f2bs='sudo fail2ban-client status'
alias f2bj='sudo fail2ban-client status sshd'
alias f2br='sudo systemctl restart fail2ban'
alias f2bl='sudo fail2ban-client set sshd unbanip'
alias f2bb='sudo fail2ban-client set sshd banip'
alias f2blog='sudo journalctl -u fail2ban -f'
alias f2bcfg='sudo ${EDITOR:-nvim} /etc/fail2ban/jail.local'

# PNPM
alias pi='pnpm install'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias prm='pnpm remove'
alias pr='pnpm run'
alias pd='pnpm dev'
alias pb='pnpm build'
alias pt='pnpm test'
alias pl='pnpm lint'
alias pfix='pnpm lint --fix'
alias pwhy='pnpm why'
alias pout='pnpm outdated'
alias pup='pnpm up -Lri'
alias pstore='pnpm store path'
alias pdlx='pnpm dlx'

# Docker / Compose
alias d='docker'
alias dcdown='docker compose down'
alias dprune='docker system prune -af --volumes'
alias dcrs='docker compose restart'
alias dcrsd='docker compose restart && docker compose ps'
alias dcrsl='docker compose restart && docker compose logs -f --tail=200'
alias dcreset='docker compose down && docker compose up -d'
alias dcrecreate='docker compose up -d --force-recreate'
alias dcupw='docker compose up -d --wait'
alias dctop='docker compose top'

# Kubernetes
alias ke='kubectl exec -it'
alias kd='kubectl describe'

# System helpers
alias ss='systemctl status'
alias sr='sudo systemctl restart'
alias sj='journalctl -xeu'
alias ports='ss -tulpen'

###################################
# FZF configuration
###################################
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

###################################
# Tmuxifier
###################################
if command -v tmuxifier &> /dev/null; then
  export PATH=$PATH:$HOME/.config/tmux/plugins/tmuxifier/bin
  eval "$(tmuxifier init -)"
fi

###################################
# Tmux
###################################
ZSH_TMUX_AUTOREFRESH=true
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_AUTONAME_SESSION=true
ZSH_TMUX_UNICODE=true

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
export EDITOR='nvim'

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
if [[ -d "$HOME/Android/Sdk" ]]; then
	export ANDROID_HOME=$HOME/Android/Sdk
elif [[ -d /usr/lib/android-sdk ]]; then
	export ANDROID_HOME=/usr/lib/android-sdk
fi
if [[ -n "${ANDROID_HOME:-}" ]]; then
	export PATH=$PATH:$ANDROID_HOME/emulator
	export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

###################################
# AWS configuration
###################################
export AWS_PROFILE=default

###################################
# Ollama configuration
###################################
export ZSH_OLLAMA_MODEL=gemma3:4b

###################################
# ASCII Art configuration
###################################
export ZSH_ASCII_ART=bruh

# OpenClaw Completion
if [[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
  source "$HOME/.openclaw/completions/openclaw.zsh"
fi
