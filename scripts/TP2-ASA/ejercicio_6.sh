#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que determina origenes maximos y minimos. Tambien los bytes enviados y recibidos por interfaz de red. 
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

CAPTURAR=$(which tcpdump)
TIEMPO=$1
VACIO=" "

# Script debe ser ejecutado como root y por parametro (uno solo) debe ingresar el tiempo en segundos
if [ `id -u` -ne 0 ] || [ $# -ne 1 ]; then
	echo "Debe ser ejecutado como usuario root."
	echo "Y debe ingresar el tiempo que desea capturar el trafico (en segundos)"
	echo "Ejemplo: \"sudo ./ejercicio_6.sh 30"\"
	echo "Se captura el trafico de red durante 30 segundos"
else
	# Determina las interfaces actiavs
	INTERFAZ=$(ip link show up | grep "state UP"| awk {'print$2'} | cut -d':' -f1)

	# Por cada interfaz determina origenes maximos y minimos; bytes enviados y recibidos.
	for i in $INTERFAZ; do
		# Saca la direccion IP de cada interfaz
		HOST=$(ifconfig $i | grep inet | grep -v inet6 | cut -d: -f2 | awk {'print$1'})
		
		# Captura el trafico de la interfaz y lo guarda en un archivo temporal
		$CAPTURAR -i $i -nn > /dev/null 2>&1 > /tmp/escuchando.log &
		# Pasado el tiempo, mata el proceso que ejecuta tcpdump
		sleep $TIEMPO
		kill $(ps -aux | grep root | grep tcpdump | sed '2,5d' | awk '{print $2}')		
		
		# Determina las conexiones recibidas a nuestro host, eliminando aquellas conexiones de nuestro host.
		cat /tmp/escuchando.log | grep IP | grep -v IP6 | awk '{print $3}' | grep -v $HOST | cut -d : -f1 | cut -d . -f1,2,3,4 > /tmp/conexiones.log
		
		# Obtengo solo las direcciones IP que se conectaron a nuestro host, no las veces que lo hicieron.
		ORIGENES=$(cat /tmp/escuchando.log | grep IP | grep -v IP6 | awk '{print $3}' | grep -v $HOST | cut -d : -f1 | sort -u | cut -d . -f1,2,3,4 | uniq)
		
		# Por cada IP cuento cuantas veces se conecto y lo guardo en archivo temporal
		for x in $ORIGENES; do
			CONT=$(cat /tmp/conexiones.log | grep $x | wc -l)
			echo $CONT  $x >> /tmp/origenes.log
		done
		
		# Determino el origen maximo y minimo
		ORIGENMAX=$(sort -n /tmp/origenes.log | tail -1 | awk {'print$2'})
		ORIGENMIN=$(sort -n /tmp/origenes.log | head -1 | awk {'print$2'})

		# Determino los bytes enviados y recividos.
		BYTERECIBIDO=$(ifconfig $i | grep "TX bytes" | cut -d'(' -f2 | cut -d')' -f1)
		BYTEENVIADO=$(ifconfig $i | grep "TX bytes" | awk 'BEGIN {FS="("}; {print $3}' | cut -d')' -f1)

		echo "=================================================="
		echo "Interfaz de red analizada: $i"
		echo "Origenes maximos: $ORIGENMAX"
		echo "Origenes minimos: $ORIGENMIN"
		echo "Bytes maximo recibidos: $BYTERECIBIDO"
		echo "Bytes maximo enviados: $BYTEENVIADO"
		echo "=================================================="
	done
	rm /tmp/escuchando.log /tmp/conexiones.log /tmp/origenes.log
fi
