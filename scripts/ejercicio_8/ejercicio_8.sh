#!/bin/bash
# -- UTF 8 --
###################################################################################
# Script que genera un histograma de acceso a nuestro host por cada IP.
# Este script funciona con la aplicacion de reglas iptables "iptables.sh"
# Autor: Emanuel Malfatti 
# E-mail: ejmalfatti@outlook.com
# Licencia: GPLv2
###################################################################################


cat /var/log/syslog | grep "INPUT_Connection: " | awk {'print$12'} | cut -d'=' -f2 > /tmp/accesosIN.log
cat /var/log/syslog | grep "OUTPUT_Connection: " | awk {'print$12'} | cut -d'=' -f2 > /tmp/accesosOUT.log
FECHA=$(date)
echo "============================================================================"
echo "# La contabilización corresponde a la fecha [$FECHA] #"
echo "============================================================================"
echo


echo "Histograma de acceso por dominio entrante: "
echo
echo "[Dominio] [Nº acceso] [Histograma]"

cat /tmp/accesosIN.log | awk '{h[$1]++}END{for(i in h){print h[i],i|"sort -rn|head -20"}}' | awk '!max{max=$1;}{r="";i=s=60*$1/max;while(i-->0)r=r"#";printf "%15s %5d %s %s",$2,$1,r,"\n";}'

echo

echo "Histograma de acceso por dominio saliente: "

echo "[Dominio] [Nº acceso] [Histograma]"

cat /tmp/accesosOUT.log | awk '{h[$1]++}END{for(i in h){print h[i],i|"sort -rn|head -20"}}' | awk '!max{max=$1;}{r="";i=s=60*$1/max;while(i-->0)r=r"#";printf "%15s %5d %s %s",$2,$1,r,"\n";}'

echo









