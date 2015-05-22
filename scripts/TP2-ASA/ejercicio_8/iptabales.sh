#!/bin/bash
# -- UTF 8 --
###################################################################################
# Aplicacndo IPTables para el funcionamiento del script "ejercicio_8.sh".
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################

if [ `id -u` -ne 0 ]; then
	echo "Debe ser ejecutado como root"
	echo "Ejemplo: \"sudo ./iptables.sh\""
else
	IPTABLES=$(which iptables)
	SAVE=$(which iptables-save)

	$IPTABLES -F
	$IPTABLES -X
	$IPTABLES -Z

	$IPTABLES -A INPUT -j LOG --log-prefix "INPUT_Connection: "
	$IPTABLES -A OUTPUT -j LOG --log-prefix "OUTPUT_Connection: "

	$SAVE
fi
