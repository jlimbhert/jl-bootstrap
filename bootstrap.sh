#!/bin/bash

# ==================================================
# JL-BOOTSTRAP
# Instalador de entorno personalizado (JLimbhert)
# ==================================================

echo -e "\n=================================================="
echo -e " Iniciando instalacion del entorno JLimbhert..."
echo -e "==================================================\n"

# --------------------------------------------------
# Lista de paquetes base (no requieren configuracion)
# --------------------------------------------------
paquetes_base=(
    bat
    curl
    tree
    zoxide
    wget
    unzip
    htop
    )

# --------------------------------------------------
# Lista de paquetes configurables (se instalan aqui,
# se configuran despues en configure.py)
# --------------------------------------------------
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

# --------------------------------------------------
# 1. Deteccion de sistema operativo y actualizacion
# --------------------------------------------------
if [ -z "$PREFIX" ]; then
    SYSTEM="Linux"
    echo -e "Sistema detectado: Linux\n"
    sudo apt update
    sudo apt upgrade -y
else
    SYSTEM="Termux"
    echo -e "Sistema detectado: Termux\n"
    pkg update
    pkg upgrade -y
    # Permisos de almacenamiento
    termux-setup-storage
fi

# --------------------------------------------------
# 2. Limpieza de sistema (solo aplica en Termux)
# --------------------------------------------------
MOTD=/data/data/com.termux/files/usr/etc/motd
if [ -e "$MOTD" ]; then
    rm "$MOTD"
fi

# --------------------------------------------------
# 3. Instalacion de paquetes
# --------------------------------------------------
echo -e "\nInstalando paquetes base y configurables...\n"

if [ "$SYSTEM" = "Linux" ]; then
    sudo apt install -y "${paquetes_base[@]}"
    sudo apt install -y "${paquetes_configurables[@]}"
    sudo apt install -y python3 fd-find
else
    pkg install -y "${paquetes_base[@]}"
    pkg install -y "${paquetes_configurables[@]}"
    pkg install -y python fd
fi

# --------------------------------------------------
# 4. Creacion de la estructura de carpetas base
# --------------------------------------------------
echo -e "\nCreando estructura de carpetas en ~/JLimbhert...\n"

mkdir -p ~/JLimbhert/{dotfiles,projects,tools,images,notes,docs,bin}

# --------------------------------------------------
# 5. Clonacion del repositorio de dotfiles
# --------------------------------------------------
DOTFILES=$HOME/JLimbhert/dotfiles/

if [ -d "$DOTFILES" ]; then
    echo "El repo dotfiles ya existe, se omite la clonacion."
else
    echo -e "\nClonando repositorio de dotfiles...\n"
    git clone git@github.com:jlimbhert/Dotfiles.git "$DOTFILES"
fi

echo -e "\n=================================================="
echo -e " Instalacion base completada."
echo -e " Continuando con la configuracion (configure.py)..."
echo -e "==================================================\n"

# --------------------------------------------------
# 6. Llamado al script de configuracion (Python)
# --------------------------------------------------
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

chmod +x "$SCRIPT_DIR"/configure.py
"$SCRIPT_DIR"/configure.py
