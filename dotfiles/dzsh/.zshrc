# --------------------------------------------------
# POWERLEVEL10K INSTANT PROMPT
# --------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------------------------------------
# PATH
# --------------------------------------------------
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --------------------------------------------------
# COMPLETIONS
# --------------------------------------------------
fpath+=($HOME/JLimbhert/dotfiles/dzsh/plugins/zsh-completions/src)

autoload -Uz compinit
compinit -u

# --------------------------------------------------
# ZOXIDE
# --------------------------------------------------
eval "$(zoxide init zsh)"

# --------------------------------------------------
# HISTORIAL
# --------------------------------------------------
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

setopt appendhistory
setopt sharehistory
setopt histignorealldups
setopt histreduceblanks

# --------------------------------------------------
# OPCIONES
# --------------------------------------------------
setopt autocd
setopt correct

# --------------------------------------------------
# PLUGINS
# --------------------------------------------------
source $HOME/JLimbhert/dotfiles/dzsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/JLimbhert/dotfiles/dzsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/JLimbhert/dotfiles/dzsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --------------------------------------------------
# P10K CONFIG
# --------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --------------------------------------------------
# ALIAS
# --------------------------------------------------
alias ls="lsd --group-dirs=first --icon=always"
alias ll="lsd -l --group-dirs=first --icon=always"
alias la="lsd -la --group-dirs=first --icon=always"

alias mkev="python -m venv venv"
alias ev+="source venv/bin/activate"
alias ev-="deactivate"

# --------------------------------------------------
# FUNCIONES
# --------------------------------------------------

# Actualizar el sistema segun el entorno (Linux o Termux)
up() {
    if [ -z "$PREFIX" ]; then
        sudo apt update && sudo apt upgrade -y
    else
        pkg update && pkg upgrade -y
    fi
}

# --------------------------------------------------
# CONFIGURACION PERSONAL (no incluida en el repo publico)
# --------------------------------------------------
ALIAS_PERSONALIZADAS=$HOME/JLimbhert/jdotfiles/dzsh/alias_personalizadas.zsh
if [ -e "$ALIAS_PERSONALIZADAS" ]; then
    source "$ALIAS_PERSONALIZADAS"
fi
