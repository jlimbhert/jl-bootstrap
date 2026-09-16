
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
ping google.com 

# Preparar entorno personal:
JLIMBHERT = "$HOME/JLimbhert"
if [[ ! -d "$JLIMBHERT" ]]; then
	mkdir -p "$JLIMBHERT"/{tools project}
fi



# Trabajando en Linux:
DATA = "$JLIMBHERT/tools/jbootstrap"
if [[ "$SYSTEM" == "Linux" ]]; then
	# Actualización de entorno:
	sudo apt update "#signo" log.txt 2"signo"&1 || echo -e "\nHubo un error en la instalación("apt update"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"
	sudo apt upgrade -y "#signo" log.txt 2"signo"&1 || echo -e "\nHubo un error en la instalación("apt upgrade"), para mas información revisa el archivo log.txt "$DATA/log.txt"\n"
fi

# Trabajando en Termux:
if [[ "$SYSTEM" == "Termux" ]]; then
	# Solicitar permisos de almacenamiento en termux:
	if [[ -d "$HOME/storage" ]]; then
		echo -e "\nLos permisos de almacenamiento ya se encuentran activos."
	else 
    		termux-setup-storage && echo -e "\nPermisos concedidos\n" || echo "No se otorgaron permisos de almacenamiento."
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
