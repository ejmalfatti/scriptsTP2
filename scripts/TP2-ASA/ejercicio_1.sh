#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que obtiene información sobre los dispositivos del sistema.
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################


if [ `id -u` -ne 0 ];then
	echo "Este programa debe ser ejecutado como root"
	echo "Ejemplo: \"sudo ./ej_1.sh"\"
	echo "Saliendo..."
	sleep 1
else
	DISPOSITIVO=$(blkid | cut -d':' -f1) # Obtiene cada dispositivo existente
	echo "============================================="
	for dev in $(echo $DISPOSITIVO); do # recorre cada dispositivo y sobre el obtiene los datos UUID, Nombre, Tipo y el montaje
		UUID=$(blkid -o value -s UUID $dev)
		NOMBRE=$(blkid -o value -s LABEL $dev)
		TIPO=$(blkid -o value -s TYPE $dev)
	
		if [ "$NOMBRE" == "" ]; then # si la variable NOMBRE esta vacia es por que la particion no tiene etiqueta
			NOMBRE="SIN NOMBRE"
		fi
	
		MONTAJE=$(mount | grep $dev | cut -d' ' -f3) # Obtenemos el punto de montaje del dispositivo
		
		echo "UUID: $UUID"
		echo "NOMBRE: $NOMBRE"
		echo "TIPO: $TIPO"
		
		if [ "$MONTAJE" == "" ]; then # si la variable $MONTAJE esta vacia es porque el dispositivo no esta montado
			MONTAJE="No esta montado"
			echo "PUNTO DE MONTAJE: $dev $MONTAJE"
		else
			echo "PUNTO DE MONTAJE: $dev en $MONTAJE"
		fi
		echo "============================================="
	done
fi
