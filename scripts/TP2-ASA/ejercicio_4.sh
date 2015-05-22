#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que determina si la conexion con los hosts, en una lista, se perdio. 
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

# Determina si se paso al script un solo parametro (deberia ser la lista).
# si no lo pasaste, el script te avisa que es necesario.
if [ $# -lt 1 ]; then
	echo "Es necesario ingresar archivo con direcciones IP"
	echo "Ejemplo: \"./ejercicio_4.sh lista"\"
elif [ $# -eq 1 ]; then
	for i in `cat $1`; do # la lista con direcciones IP es $1
		ping -c 3 $i > /dev/null # por cada IP hace tres ping

		if [ "$?" != "0" ]; then # si no responde al ping, entonces se perdio la conexion. Devuelve un valor distinto de 0 en $?.
		   echo "Se perdió la conexión con $i"
		fi
	done
fi

