#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que determina cuando se abrieron nuevas conecciones (puertos) y a que APP corresponde
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

# Script debe ejecutarse como root
if [ `id -u` -ne 0 ]; then
	echo "Este programa debe ejecutarse como root"
	echo "Ejemplo: \"sudo ./ejercicio_5.sh"\"
else
	IFS=$(echo -en "\n\b") # Variable de separacion interna de espacios
	VACIO=" "

	# Encuentra solo los puestos ya establecidas o abiertas
	PUERTOS=$(netstat -punta | grep "ESTABLECIDO" | sed 's/:::/:/g' | awk {'print$4'} | cut -d':' -f2)
	# Luego de 30 segundos, obtiene otra captura de puesrtos abiertos
	sleep 30
	# Envia la nueva captura a un archivo temporal
	netstat -punta | grep "ESTABLECIDO" > /tmp/netstat.log
	
	# Por cada puerto que ya estaban abiertos, con "sed" va eliminado del archivo temporal la linea
	# que corresponda con dicho puertos, quedando así solo las conecciones
	for i in $PUERTOS; do
		sed -i "/${i}/d" /tmp/netstat.log
	done

	# Luego recorre el archivo temporal y obtiene el puerto y la aplicacion correspondiente a ese puerto.
	for x in $(cat /tmp/netstat.log); do
		PORT=$(echo $x | sed 's/:::/:/g' | awk {'print$4'} | cut -d':' -f2)
		APP=$(echo $x | awk {'print$7'} | cut -d'/' -f2)
		echo "Puerto nuevo abierto [$PORT] por la aplicacion [$APP]"
	done
	rm /tmp/netstat.log
fi
