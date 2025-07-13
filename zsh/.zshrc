# Variables
export git="/mnt/c/Users/$USER/Code"
export ZSH="$HOME/.oh-my-zsh"
export profile="$HOME/.zshrc"
ZSH_THEME="robbyrussell"

# az cli configuration
az config set cli.interactive_mode=false
az config set core.only_show_errors=true

# Aliases
alias reload='omz reload'
alias info='neofetch'
alias t='touch'
alias v='code -r'
alias vs='code .'
alias push='git push'
alias st='git status'
alias status='git status'
alias st='git status'
alias pu='git pull'
alias pull='git pull'
alias clone='git clone'
alias stash='git stash'
alias branch='git branch $1'
alias ch='git checkout $1'
alias checkout='git checkout $1'
alias tag='git tag -a $1 -m $2'
alias cls='clear'
alias c='cd ..'
alias cc='cd ...'
alias py=python3
alias python=python3
alias pip=pip3
alias tree=tr

# Functions
pa(){
    git add -u
    git commit -m "$1"
    git push
}
add(){
    git add $1
    git status
}
wu(){
    sudo apt update
}
wua(){
    sudo apt update
    sudo apt upgrade
}

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

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