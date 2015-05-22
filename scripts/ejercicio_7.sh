#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que hace resolucion inversa de direcciones IP en una lista
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

# Determina si se paso un solo parametro, que debe ser la lista con direcciones IP
if [ $# -lt 1 ]; then
	echo "Es necesario ingresar archivo con direcciones IP"
	echo "Ejemplo: \"./ejercicio_7.sh direcciones"\"
else
	# Reccore la lista ($1) y por cada IP hace una resolucion inversa, obtiene el dominio
	for i in $(cat $1); do
		DIRECCION=$(dig +noall +answer -x $i | awk {'print $5'})
		DIRECCION=$(echo ${DIRECCION%%.}) # Elimina un punto "." que esta al final de la cadena de texto
		echo "Resolucion inversa de la direccion IP: $i = $DIRECCION"
	done
fi


