#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que obtiene información sobre las conexiones SSH recibidas, su duración y usuario.
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

# Esta funcion calcula el tiempo de conexion de cada usuario
function calculoTiempo(){
	# Se recibe como parametro la hora inicial y la hora final de los logs
	HORAINICIAL=$1
	HORAFINAL=$2
	VACIO=" "

	# Si la hora final es nulo o vacio, se debe a que no se puede obtener esa informacion
	# que el usuario este en una sesion activa, por lo tanto no hay hora de finalizacion
	if [ $HORAFINAL = $VACIO 2>/dev/null ];then
		echo "El usuario [$USERS] mantuvo una sesion SSH de: Informarcion incompleta y/o la sesion esta activa"
	else
		#Obtengo la hora, minutos y segundos de la hora inicial de la conexion
		HI=$(echo $HORAINICIAL | cut -d':' -f1)
		MI=$(echo $HORAINICIAL | cut -d':' -f2)
        SI=$(echo $HORAINICIAL | cut -d':' -f3)
	
		# Obtengo la hora, minutos y segundos de la hora final de la conexion
		HF=$(echo $HORAFINAL | cut -d':' -f1)
		MF=$(echo $HORAFINAL | cut -d':' -f2)
        SF=$(echo $HORAFINAL | cut -d':' -f3)

		# Realizo la resta de la hora, minutos y segundo final con los tiempo iniciales
		# resultado es el tiempo que estuvo conectado
		HH=$(expr $HF - $HI 2>/dev/null)
		MM=$(expr $MF - $MI 2>/dev/null)
        SS=$(expr $SF - $SI 2>/dev/null)

		# Si la hora resulta un numero negativo, le sumo 24 (horas)
		# resultando la hora correcta y en numero positivo
		if [ $HH -lt 0 ]; then
			HH=$(expr $HH + 24)
		fi

		# Si los minutos resultan un numero negativo, le sumo 60 (minutos)
		# y le resto a la hora 1 (hora) a $HH que son los 60 minutos que le sume a $MM
		if [ $MM -lt 0 ]; then
			MM=$(expr $MM + 60)
			HH=$(expr $HH - 1)
		fi

		# Si los segundos es negativo, le sumo 60 (segundos)
		# y le resto a $MM un minuto, que son los 60 segundos que le sume a $SS
        if [ $SS -lt 0 ]; then
            SS=$(expr $SS + 60)
            MM=$(expr $MM - 1)
        fi
        
        # CON ESTO LOGRO QUE EL RESULTADO EN HORAS, MINUTOS Y SEGUNDOS SEAN CORRECTOS
        
		echo "El usuario [$USERS] mantuvo una sesion SSH de $HH horas, $MM minutos y $SS segundos"
	fi	
}


PID=$(cat /var/log/auth.log* | grep "sshd" | grep "Accepted" | cut -d'[' -f2 | cut -d']' -f1)

for i in $PID; do
	USERS=$(cat /var/log/auth.log* | grep "sshd" | grep $i | grep "Accepted" | awk {'print $9'}) # Obtengo el usuario
	
	HORAINICIAL=$(cat /var/log/auth.log* | grep "sshd" | grep $i | grep "Accepted" | awk {'print $3'}) # Obtengo la hora inicial de conexion
	
	HORAFINAL=$(cat /var/log/auth.log* | grep "sshd" | grep "$i" | grep "closed" | awk {'print$3'}) # Obtengo la hora final de conexion
	
	# Llamo a la funcion que calcula el tiempo de conexion de cada usuario y le paso como argumento
	# la variables que contienen la hora inicial y final de cada conexion de los logs
	calculoTiempo $HORAINICIAL $HORAFINAL
done
