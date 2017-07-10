#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 2.0.1" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irá:" ; echo ""
echo "● Instalar y configurar proxy squid usando los puertos 80, 3128, 8080 y 8799" ; echo "  para permitir conexiones SSH para este servidor"
echo "● Configurar OpenSSH para funcionar en puertos 22 e 443"
echo "● Instalar un conjunto de scripts con comandos del sistema para la administración de usuarios" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Presione cualquier tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Al utilizar 'VPS Manager 2.0' Usted acepta los siguientes términos de uso:"
echo ""
echo "1. Tu puedes:"
echo "a. Instalar y usar 'VPS Manager 2.0' en su(s) servidor(es)."
echo "b. Crear, administrar y quitar un número ilimitado de usuarios a través de este conjunto de secuencias de comandos."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Presione cualquier tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. Tu no puedes:"
echo "a. Editar, modificar, compartir o redistribuir (gratuitamente o comercialmente)"
echo "Este conjunto de secuencias de comandos sin autorización del desarrollador."
echo "b. Modificar o editar el conjunto de secuencias de comandos para hacer que se vea el desarrollador de secuencias de comandos."
echo ""
echo "3. Usted acepta que:"
echo "a. El valor pagado por este conjunto de secuencias de comandos no incluye garantías ni soporte adicional,"
echo "Pero el usuario podrá, de forma promocional y no obligatoria, por tiempo limitado,"
echo "Recibir soporte y ayuda para la solución de problemas siempre que respete los términos de uso."
echo "b. El usuario de este conjunto de secuencias de comandos es el único responsable de cualquier tipo de implicación"
echo "Ética o legal causada por el uso de este conjunto de secuencias de comandos para cualquier tipo de propósito."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Presione cualquier tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. Usted acuerda que el desarrollador no se responsabilizará por los siguientes:"
echo "a. Problemas causados por el uso de los scripts distribuidos sin autorización."
echo "b) Problemas causados por conflictos entre este conjunto de secuencias de comandos y secuencias de comandos de otros desarrolladores. "
echo "c. Problemas causados por ediciones o modificaciones del código de secuencia de comandos sin autorización. "
echo "d. Problemas del sistema causados por programas de terceros o modificaciones / experimentaciones del usuario."
echo "e. Problemas causados por modificaciones en el sistema del servidor."
echo "f. Los problemas causados por el usuario no seguir las instrucciones de la documentación del conjunto de secuencias de comandos."
echo "g. Problemas durante el uso de secuencias de comandos para obtener beneficios comerciales."
echo "h. Problemas que pueden ocurrir al utilizar el conjunto de secuencias de comandos en sistemas que no están en la lista de sistemas probados."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Presione cualquier tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme la IP de este servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo "No ha introducido el IP de este servidor. Inténtalo de nuevo. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Una base de dados  ('usuarios.db') fue encontrada!"
	echo "Desea mantenerla (Preservando el límite de conexiones simultáneas de los usuarios)"
	echo "O crear una nueva base de datos?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Mantener Base de Dados Actual"
	echo "[2] Crear una Nueva Base de Dados"
	echo "" ; tput sgr0
	read -p "Opcion?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Desea activar la compresion SSH (puede aumentar el consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Espere la configuración automática" ; echo "" ; tput sgr0
sleep 3
yum -y update
yum -y upgrade
rm /bin/crearusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ayuda > /dev/null
rm /root/ExpCleaner.sh /root/CrearUsuario.sh /root/sshlimiter.sh > /dev/null
yum -y install squid
killall apache2
#yum purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid/" ]
then
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/squid2.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/pass.sh -O /bin/pass
	chmod +x /bin/pass
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/crearusuario.sh -O /bin/crearusuario
	chmod +x /bin/crearusuario
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/expcleaner.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/fecha.sh -O /bin/fecha
	chmod +x /bin/fecha
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/sshlimiter.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/ayuda.sh -O /bin/ayuda
	chmod +x /bin/ayuda
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/sshmonitor.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/squid.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/payload.txt -O /etc/squid/payload.txt
	echo " " >> /etc/squid/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/pass.sh -O /bin/pass
	chmod +x /bin/pass
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/crearusuario.sh -O /bin/crearusuario
	chmod +x /bin/crearusuario
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/expcleaner.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/fecha.sh -O /bin/fecha
	chmod +x /bin/fecha
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/sshlimiter.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/ayuda.sh -O /bin/ayuda
	chmod +x /bin/ayuda
	wget https://github.com/Lyzen/vps/blob/master/CENTOS/vpsmanager/scripts/sshmonitor.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid Instalado y escuchando en los puertos: 80, 3128, 8080 y 8799" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH funcinando en los puertos 22 y 443" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Scripts para administracion de usuarios instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Lea la documentación para evitar dudas y problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver los comandos disponíbles use el comando: ayuda" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1