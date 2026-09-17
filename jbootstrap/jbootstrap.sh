#!/bin/bash

# ==========================================================
# FUNCION: SPINNER
# ==========================================================
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

# ==========================================================
# INICIO / PRESENTACION
# ==========================================================
clear

echo -e "Jbootstrap\n\n"
echo -e "Bienvenido JL,\nIniciando instalación personalizada del sistema..."

# Contador de errores:
ERROR=0

# ==========================================================
# DETECCION DEL SISTEMA
# ==========================================================
echo -e "Detectando sistema..."
if [[ -z "$PREFIX" ]]; then
	SYSTEM="Linux"
	echo -e "\nTrabajando en Linux..."
else
	SYSTEM="Termux"
	echo -e "\nTrabajando en Termux..."
fi

# ==========================================================
# ACCIONES PERMITIDAS EN AMBOS ENTORNOS
# ==========================================================

# --- Preparar directorio personal ---
# Designar nombre del directorio principal:
echo -e "Ingresa el nombre de el directorio principal:\n"
read DIR_PRINCIPAL
# Ruta del directorio principal para el entorno
DIR_PRINCIPAL="$HOME/$DIR_PRINCIPAL"
if [[ ! -d "$DIR_PRINCIPAL" ]]; then
    echo -e "\nCreando estructura principal..."
	mkdir -p "$DIR_PRINCIPAL"/{tools,project}
else
    echo -e "\nEstrucutura existente encontrada."
fi

# --- Rutas para el directorio raiz de la herramienta bootstrap e hijos ---
DIR_BOOTSTRAP=$(dirname "$0")
DIR_DATA="$DIR_BOOTSTRAP/data"
FILE_LOG="$DIR_DATA/log.txt"

# --- Creación de la carpeta data ---
echo -e "Se creo la carpeta '$DIR_DATA'.\n"
mkdir -p "$DIR_DATA"

# --- Comprobación de conexión activa, necesaria para el funcionamiento ---
echo -e "\nComprobando conexion a internet..."
ping -c 1 google.com &> "$FILE_LOG" && echo -e "Conexión activa\n" || echo -e "\nNo se encontro una conexión activa."

# --- Lista de paquetes base ---
paquetes_base=(
    bat
    curl
    git
    lsd
    neovim
    openssh
    ranger
    tmux
    tree
    unzip
    wget
    zoxide
    zsh
    )

# ==========================================================
# BLOQUE LINUX
# ==========================================================
if [[ "$SYSTEM" == "Linux" ]]; then
	# --- Actualización de entorno ---
    echo -e "Actualizando lista de paquetes..."
	sudo apt update >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('apt update'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1
    fi

    echo -e "Actualizando entorno de Linux..."
	sudo apt upgrade -y >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('apt upgrade'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1
    fi

    # --- Instalación de los paquetes basicos ---
    echo -e "Instalando paquetes base para el funcionamiento de Linux..."

    echo -e "Acontinuacion se instalaran los siguientes paquetes:\n"
    for paquete in "${paquetes_base[@]}"; do
        echo "$paquete"
    done
    echo ""

    sudo apt install -y "${paquetes_base[@]}" python3 fd-find >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación, para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1
    fi
fi

# ==========================================================
# BLOQUE TERMUX
# ==========================================================
if [[ "$SYSTEM" == "Termux" ]]; then
	# --- Solicitar permisos de almacenamiento en termux ---
    echo -e "\nSolicitando permisos de almacenamiento..."
	if [[ -d "$HOME/storage" ]]; then
        echo -e "Los permisos de almacenamiento ya se encuentran activos."
	else
    	termux-setup-storage && echo -e "Permisos concedidos\n" || echo "No se otorgaron permisos de almacenamiento."
    fi

	# --- Actualización de entorno ---
    echo -e "\nActualizando lista de paquetes..."
	pkg update >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('pkg update'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1
    fi

    echo -e "\nActualizando entorno de Termux..."
	pkg upgrade -y >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nHubo un error en la instalación('pkg upgrade'), para mas información revisa el archivo log.txt '$FILE_LOG'\n"
        ERROR=1
    fi

    # --- Instalación de los paquetes base ---
    echo -e "Instalando paquetes base para el funcionamiento de Termux..."

    echo -e "Acontinuacion se instalaran los siguientes paquetes:\n"
    for paquete in "${paquetes_base[@]}"; do
        echo "$paquete"
    done
    echo ""

    pkg install -y "${paquetes_base[@]}" python3 fd >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "\nError en la instalación"
        ERROR=1
    fi
fi

# ==========================================================
# RESULTADO FINAL
# ==========================================================
if [[ "$ERROR" -eq 0 ]]; then
    echo -e "\ninstalación completada con exito" | tee -a "$FILE_LOG"
else
    echo "Hubo errores, revisa el log" | tee -a "$FILE_LOG"
fi

echo -e "\n\n\n"

echo -e "Bienvenido a tu entorno personalizado JL\nTu sistema ya esta configurado y listo para usar.\n"
echo -e "Presiona enter para continuar..."

read salir
clear
exit

