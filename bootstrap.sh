#!/bin/bash

# Instalador de entorno personalizado

# Lista de paquetes_base:
paquetes_base=(
    bat 
    curl
    tree
    zoxide
    wget
    unzip 
    htop 
    )

paquetes_configurables=(
    zsh
    tmux
    git
    ranger
    neovim
    lsd
    fzf
    starship
    openssh
    )

# Deteccion de SO y armado de estructura base

if [ -z "$PREFIX" ]; then 
    SYSTEM="Linux"
    echo -e "Trabajando en Linux...\n"
    sudo apt update
    sudo apt upgrade -y
else 
    SYSTEM="Termux"
    echo -e "Trabajando en Termux...\n"
    pkg update && pkg upgrade -y
    termux-setup-storage
    #Limpiar sistema
    rm /data/data/com.termux/files/usr/etc/motd 
fi


# Instalación de paquetes base
if [ "$SYSTEM" = "Linux" ]; then 
    sudo apt install -y "${paquetes_base[@]}"
    sudo apt install -y "${paquetes_configurables[@]}"
    sudo apt install -y python3 fd-find
else 
    pkg install -y "${paquetes_base[@]}"
    pkg install -y "${paquetes_configurables[@]}"
    pkg install -y python fd
fi


# Creacion de la estrucutura:
mkdir -p ~/JLimbhert/{dotfiles,projects,tools,images,notes,docs,bin}

# Clonaciòn de Dotfiles 

