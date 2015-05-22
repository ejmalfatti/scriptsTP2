#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que obtiene información vmstat y determina si hay picos en el sistema
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

MAXSWAP=2018
MAXPROCRUN=10
MAXPROCSLEEP=10
MAXINPUT=80
MAXOUTPUT=80

# Obtengo los picos de I/O
INPUT=$(vmstat 1 2 -S m | awk {'print$9'})
OUTPUT=$(vmstat 1 2 -S m | awk {'print$10'})

INPUT=$(echo $INPUT | awk {'print $2'})
OUTPUT=$(echo $OUTPUT | awk {'print $2'})

# Obtengo el uso de memoria SWAP
SWAP=$(vmstat 1 2 -S m | awk {'print$3'})
SWAP=$(echo $SWAP | awk {'print$3'})

#Obtengo los procesos en ejecucion y en estado sleep o durmiendo.
PROCRUN=$(vmstat 1 2 -S m | awk {'print$1'} | grep -v "procs")
PROCSLEEP=$(vmstat 1 2 -S m | awk {'print$2'} | grep -v "memory")

PROCRUN=$(echo $PROCRUN | awk {'print$2'})
PROCSLEEP=$(echo $PROCSLEEP | awk {'print$2'})

#Realizo las comparaciones los valores maximos establecidos y determina si  se sobrepaso o no.
if [ $INPUT -gt $MAXINPUT ]; then
	if [ $OUTPUT -gt $MAXOUTPUT ]; then
		echo "Existencia de picos de I/O. INPUT:$INPUT OUTPUT:$OUTPUT"
	fi
fi

if [ $SWAP -gt $MAXSWAP ]; then
	echo "Uso excesivo de memoria de intercambio: $SWAP MB"
fi

if [ $PROCRUN -gt $MAXPROCRUN ];then
	echo "Existencia de picos maximos en procesos ejecutados: $PROCRUN"
fi

if [ $PROCSLEEP -gt $MAXPROCSLEEP ]; then
	echo "Existencia de picos maximos en procesos esperando: $PROCSLEEP"
fi


