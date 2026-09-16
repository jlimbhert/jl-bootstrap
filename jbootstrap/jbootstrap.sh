
#!/bin/bash

# Limpiar terminal:
clear 

# Imprimir nombre de la herramienta CLI
echo -e "Jbootstrap\n\n"
echo -e "Bienvenido JL,\nIniciando instalación personalizada del sistema..."


# Deteccion del sistema
if [[ -z "$PREFIX" ]]; then 
	SYSTEM = "Linux"
	echo -e "\nTrabajando en Linux..."
else
	SYSTEM = "Termux"
	echo -e "\nTrabajando en Termux..."
fi


# (ACCIONES PERMITIDAS EN AMBOS ENTORNOS):
# Comprobación de conexión activa, necesaria para el funcionamiento:
ping -c 1 google.com &> /dev/null && echo "\nConexión activa" || echo -e "\nNo se encontro una conexión activa."

# Preparar directorio personal:
JLIMBHERT = "$HOME/JLimbhert"
if [[ ! -d "$JLIMBHERT" ]]; then
	mkdir -p "$JLIMBHERT"/{tools project}
fi

# Ruta para guardar el o los archivos de información:
DATA = "$JLIMBHERT/tools/jbootstrap"

#Lista de paquetes base:
paquetes_base = (
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
	sudo apt update > log.txt 2>&1 || echo -e "\nHubo un error en la instalación("apt update"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"
	sudo apt upgrade -y > log.txt 2>&1 || echo -e "\nHubo un error en la instalación("apt upgrade"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"

    # instalación de los paquetes basicos:
    sudo apt install -y "${paquetes_base[@]}" 
    sudo apt install -y python3 fd-find
fi




# Trabajando en Termux:
if [[ "$SYSTEM" == "Termux" ]]; then
	# Solicitar permisos de almacenamiento en termux:
	if [[ -d "$HOME/storage" ]]; then
		echo -e "\nLos permisos de almacenamiento ya se encuentran activos."
	else 
    		termux-setup-storage && echo -e "\nPermisos concedidos\n" || echo "No se otorgaron permisos de almacenamiento."
	# Actualización de entorno:
	pkg update > log.txt 2>&1 || echo -e "\nHubo un error en la instalación("apt update"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"
	pkg upgrade -y > log.txt 2>&1 || echo -e "\nHubo un error en la instalación("apt upgrade"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"
    # instalación de los paquetes base:
    pkg install -y "${paquetes_base[@]}" 
    pkg install -y python3 fd

fi


# Crear/abrir archivo log (todo lo que pase de aquí en adelante se guarda ahí)
# Actualización del sistema (paquetes) -> salida oculta, va al log
#echo -e "\nIniciando Actualización...\n"
#pkg update > log.txt 2>&1 || echo "Hubo un error de instalación, revisa tu archivo log.txt"
#pkg upgrade -y >> log.txt 2>&1 || echo "Hubo un error de instalación, revisa tu archivo log.txt"
# Imprimir mensaje con la lista de paquetes que se van a instalar
# Por cada paquete: instalar -> ocultar salida real, mostrar animación/spinner en pantalla, guardar detalle en log
# Revisar si todo salió bien o si algo falló (comparando con el log o el código de salida de cada instalación)
# Mostrar mensaje final: "todo salió bien" o "hubo un error, revisa el log"
# Esperar 5 segundos
# Limpiar pantalla
# Mostrar mensaje de bienvenida
