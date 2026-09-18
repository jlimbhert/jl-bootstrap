#!/bin/bash

# ==========================================================
# RUTAS BASE Y CARGA DE COLORES
# ==========================================================
DIR_BOOTSTRAP=$(dirname "$0")
source "$DIR_BOOTSTRAP/colors.sh"

# ==========================================================
# FUNCION: SPINNER
# ==========================================================
spinner(){
    local pid=$1
    local spinner_chars=('|' '/' '-' '\')
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        local index=$((i%4))
        echo -n -e "\r${B_CIAN}${spinner_chars[index]}${RESET}"
        i=$((i+1))
        sleep 0.1
    done

    echo -n -e "\r"
}

# ==========================================================
# INICIO / PRESENTACION
# ==========================================================
clear

echo -e "${B_MAGENTA}${NEGRITA}Jbootstrap${RESET}\n"
echo -e "${VERDE}${COHETE} Bienvenido JL,${RESET}\n${B_BLANCO}Iniciando instalación personalizada del sistema...${RESET}"

# Contador de errores:
ERROR=0

# ==========================================================
# DETECCION DEL SISTEMA
# ==========================================================
echo -e "\n${AZUL}${INFO} Detectando sistema...${RESET}"
if [[ -z "$PREFIX" ]]; then
	SYSTEM="Linux"
	echo -e "${B_AZUL}${FLECHA} Trabajando en Linux...${RESET}"
else
	SYSTEM="Termux"
	echo -e "${B_AZUL}${FLECHA} Trabajando en Termux...${RESET}"
fi

# ==========================================================
# ACCIONES PERMITIDAS EN AMBOS ENTORNOS
# ==========================================================

# --- Preparar directorio personal ---
# Designar nombre del directorio principal:
echo -e "\n${AMARILLO}Ingresa el nombre de el directorio principal:${RESET}\n"
read DIR_PRINCIPAL
# Ruta del directorio principal para el entorno
DIR_PRINCIPAL="$HOME/$DIR_PRINCIPAL"
if [[ ! -d "$DIR_PRINCIPAL" ]]; then
    echo -e "${CIAN}${FLECHA} Creando estructura principal...${RESET}"
	mkdir -p "$DIR_PRINCIPAL"/{tools,project}
else
    echo -e "${CIAN}${FLECHA} Estrucutura existente encontrada.${RESET}"
fi

# --- Rutas para el directorio de datos y log ---
DIR_DATA="$DIR_BOOTSTRAP/data"
FILE_LOG="$DIR_DATA/log.txt"

# --- Creación de la carpeta data ---
mkdir -p "$DIR_DATA"
echo -e "${CIAN}${FLECHA} Se creo la carpeta '${DIR_DATA}'.${RESET}\n"

# --- Comprobación de conexión activa, necesaria para el funcionamiento ---
echo -e "${AZUL}${INFO} Comprobando conexion a internet...${RESET}"
ping -c 1 google.com &> "$FILE_LOG" && echo -e "${VERDE}${CHECK} Conexión activa${RESET}\n" || echo -e "${ROJO}${CRUZ} No se encontro una conexión activa.${RESET}"

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
    echo -e "${AMARILLO}${CARGANDO} Actualizando lista de paquetes...${RESET}"
	sudo apt update -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Hubo un error en la instalación('apt update'), para mas información revisa el archivo log.txt '$FILE_LOG'${RESET}\n"
        ERROR=1
    fi

    echo -e "${AMARILLO}${CARGANDO} Actualizando entorno de Linux...${RESET}"
	sudo apt upgrade -y -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Hubo un error en la instalación('apt upgrade'), para mas información revisa el archivo log.txt '$FILE_LOG'${RESET}\n"
        ERROR=1
    fi

    # --- Instalación de los paquetes basicos ---
    echo -e "${AMARILLO}${CARGANDO} Instalando paquetes base para el funcionamiento de Linux...${RESET}"

    echo -e "${CIAN}A continuación se instalaran los siguientes paquetes:${RESET}\n"
    for paquete in "${paquetes_base[@]}"; do
        echo -e "${CIAN}  ${FLECHA} ${paquete}${RESET}"
    done
    echo ""

    sudo apt install -y -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" "${paquetes_base[@]}" python3 fd-find >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Hubo un error en la instalación, para mas información revisa el archivo log.txt '$FILE_LOG'${RESET}\n"
        ERROR=1
    fi
fi

# ==========================================================
# BLOQUE TERMUX
# ==========================================================
if [[ "$SYSTEM" == "Termux" ]]; then
	# --- Solicitar permisos de almacenamiento en termux ---
    echo -e "\n${AMARILLO}${CANDADO} Solicitando permisos de almacenamiento...${RESET}"
	if [[ -d "$HOME/storage" ]]; then
        echo -e "${VERDE}${CHECK} Los permisos de almacenamiento ya se encuentran activos.${RESET}"
	else
    	termux-setup-storage && echo -e "${VERDE}${CHECK} Permisos concedidos${RESET}\n" || echo -e "${ROJO}${CRUZ} No se otorgaron permisos de almacenamiento.${RESET}"
    fi

	# --- Actualización de entorno ---
    echo -e "\n${AMARILLO}${CARGANDO} Actualizando lista de paquetes...${RESET}"
	pkg update -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Hubo un error en la instalación('pkg update'), para mas información revisa el archivo log.txt '$FILE_LOG'${RESET}\n"
        ERROR=1
    fi

    echo -e "\n${AMARILLO}${CARGANDO} Actualizando entorno de Termux...${RESET}"
	pkg upgrade -y -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Hubo un error en la instalación('pkg upgrade'), para mas información revisa el archivo log.txt '$FILE_LOG'${RESET}\n"
        ERROR=1
    fi

    # --- Instalación de los paquetes base ---
    echo -e "${AMARILLO}${CARGANDO} Instalando paquetes base para el funcionamiento de Termux...${RESET}"

    echo -e "${CIAN}A continuación se instalaran los siguientes paquetes:${RESET}\n"
    for paquete in "${paquetes_base[@]}"; do
        echo -e "${CIAN}  ${FLECHA} ${paquete}${RESET}"
    done
    echo ""

    pkg install -y -qq -o Dpkg::Progress-Fancy="0" -o APT::Color="0" "${paquetes_base[@]}" python3 fd >> "$FILE_LOG" 2>&1 &
    PID=$!
    spinner "$PID"
    wait $PID
    if [[ $? -ne 0 ]]; then
        echo -e "${ROJO}${CRUZ} Error en la instalación${RESET}"
        ERROR=1
    fi
fi

# ==========================================================
# RESULTADO FINAL
# ==========================================================
if [[ "$ERROR" -eq 0 ]]; then
    echo -e "\n${VERDE}${CHECK} instalación completada con exito${RESET}" | tee -a "$FILE_LOG"
else
    echo -e "${ROJO}${CRUZ} Hubo errores, revisa el log${RESET}" | tee -a "$FILE_LOG"
fi

echo -e "\n\n\n"

echo -e "${B_VERDE}${ESTRELLA} Bienvenido a tu entorno personalizado JL${RESET}\n${B_BLANCO}Tu sistema ya esta configurado y listo para usar.${RESET}\n"
echo -e "${AMARILLO}Presiona enter para continuar...${RESET}"

read salir
clear
exit

