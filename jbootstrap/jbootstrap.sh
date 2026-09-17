#!/bin/bash

# Spinner
spinner(){
    local pid=$1
    local spinner_chars=('|' '/' '-' '\')
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        local index=$((i%4))
        echo -n -e "\r${spinner_chars[index]}"
        i=$((i+1))
        sleep 0.1
    done

    echo -n -e "\r"
}

# Limpiar terminal:
clear 

# Imprimir nombre de la herramienta CLI
echo -e "Jbootstrap\n\n"
echo -e "Bienvenido JL,\nIniciando instalación personalizada del sistema..."

# Contador de errores:
ERROR=0


# Deteccion del sistema
if [[ -z "$PREFIX" ]]; then 
	SYSTEM="Linux"
	echo -e "\nTrabajando en Linux..."
else
	SYSTEM="Termux"
	echo -e "\nTrabajando en Termux..."
fi


# ACCIONES PERMITIDAS EN AMBOS ENTORNOS:

# Preparar directorio personal:
# Designar nombre del directorio principal:

read -p "Ingresa el nombre de el directorio principal:\n" DIR_PRINCIPAL
# Ruta del directorio principal para el entorno
DIR_PRINCIPAL="$HOME/$DIR_PRINCIPAL"
if [[ ! -d "$DIR_PRINCIPAL" ]]; then
	mkdir -p "$DIR_PRINCIPAL"/{tools,project}
fi


# Rutas para el directorio raiz de la herramienta bootstrap e hijos
DIR_BOOTSTRAP=$(dirname "$0")
DIR_DATA="$DIR_BOOTSTRAP/data"
FILE_LOG="$DIR_DATA/log.txt"

# Creación de la carpeta data 
mkdir -p "$DIR_DATA"

# Comprobación de conexión activa, necesaria para el funcionamiento:
ping -c 1 google.com &> "$FILE_LOG" && echo -e "\nConexión activa" || echo -e "\nNo se encontro una conexión activa."

#Lista de paquetes base:
paquetes_base=(
    bat
    curl
    git
    lsd
    neovim
    openssh
    ranger
    tmux
    tre
    unzip
    wget
    zoxide
    zsh
    )

# Trabajando en Linux:
if [[ "$SYSTEM" == "Linux" ]]; then
	# Actualización de entorno:
	sudo apt update >> "$FILE_LOG" 2>&1 & 
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('apt update'), para mas información revisa el archivo log.txt "$FILE_LOG"\n"
        ERROR=1 
    fi

	sudo apt upgrade -y >> "$FILE_LOG" 2>&1 & 
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('apt upgrade'), para mas información revisa el archivo log.txt "$FILE_LOG"\n"
        ERROR=1 
    fi

    # instalación de los paquetes basicos:
    sudo apt install -y "${paquetes_base[@]}" python3 fd-find >> "$FILE_LOG" 2>&1 & 
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un e    rror en la instalación, para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1 
    fi
fi



# Trabajando en Termux:
if [[ "$SYSTEM" == "Termux" ]]; then
	# Solicitar permisos de almacenamiento en termux:
	if [[ -d "$HOME/storage" ]]; then
        echo -e "\nLos permisos de almacenamiento ya se encuentran activos."
	else 
    	termux-setup-storage && echo -e "\nPermisos concedidos\n" || echo "No se otorgaron permisos de almacenamiento."
    fi
	# Actualización de entorno:
	pkg update >> "$FILE_LOG" 2>&1 & 
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('pkg update'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1 
    fi

	pkg upgrade -y >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('pkg upgrade'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1 
    fi

    # instalación de los paquetes base:
    pkg install -y "${paquetes_base[@]}" python3 fd >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
    echo -e "\nError en la instalación"
        ERROR=1 
    fi
fi

# Resultados final
if [[ "$ERROR" -eq 0 ]]; then
    echo "instalación completada con exito"
else
    echo "Hubo errores, revisa el log"
fi
