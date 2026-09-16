
#!/bin/bash

# Limpiar terminal:
clear 

# Imprimir nombre de la herramienta CLI
echo -e "Jbootstrap\n\n"
echo -e "Bienvenido JL,\nIniciando instalación personalizada del sistema..."


# Deteccion del sistema
if [ -z "$PREFIX" ]; then 
    SYSTEM = 

#



# P

    echo -e "\nLos permisos de almacenamiento ya se encuentran activos."
else 
    termux-setup-storage && echo -e "\nPermisos concedidos\n" || echo "No se otorgaron permisos de almacenamiento."
fi

# Crear/abrir archivo log (todo lo que pase de aquí en adelante se guarda ahí)
# Actualización del sistema (paquetes) -> salida oculta, va al log
echo -e "\nIniciando Actualización...\n"
pkg update > log.txt 2>&1 || echo "Hubo un error de instalación, revisa tu archivo log.txt"
pkg upgrade -y >> log.txt 2>&1 || echo "Hubo un error de instalación, revisa tu archivo log.txt"
# Imprimir mensaje con la lista de paquetes que se van a instalar
# Por cada paquete: instalar -> ocultar salida real, mostrar animación/spinner en pantalla, guardar detalle en log
# Revisar si todo salió bien o si algo falló (comparando con el log o el código de salida de cada instalación)
# Mostrar mensaje final: "todo salió bien" o "hubo un error, revisa el log"
# Esperar 5 segundos
# Limpiar pantalla
# Mostrar mensaje de bienvenida
