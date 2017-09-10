#
# User configuration sourced by interactive shells
#

#source $HOME/.profile

# Change default zim location 
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Source zim
if [[ -s ${ZIM_HOME}/init.zsh ]]; then
  source ${ZIM_HOME}/init.zsh
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/davide/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall

export KEYTIMEOUT=1

bindkey -r "^["
#bindkey "^[" send-break


#autoload -U promptinit; promptinit
#prompt pure

