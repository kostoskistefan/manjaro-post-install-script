if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=/usr/bin/nvim
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export ZSH="$HOME/.oh-my-zsh"
export BROWSER=/usr/bin/google-chrome-stable

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git tmux colored-man-pages)

#ZSH_TMUX_AUTOSTART=true
#ZSH_TMUX_AUTOSTART_ONCE=true

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias ls='LC_COLLATE=C ls -lah --color --group-directories-first'
alias cd..='cd ..'
alias mylocalip='sudo ifconfig | grep wlan0 -A 1 | grep inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep 192 -m 1'
alias myip='curl https://ipinfo.io/ip'
alias vim='nvim'
alias pg='ps aux | grep '
alias pacman='sudo pacman'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/scyllius/Programs/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/scyllius/Programs/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/scyllius/Programs/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/scyllius/Programs/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

