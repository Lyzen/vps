#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%32s%s%-13s\n' "Remover Usuario SSH" ; tput sgr0
echo ""
tput bold ; echo "Lista de usuarios:" ; echo "" ; tput sgr0
tput setaf 3 ; tput bold ; awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody' ; tput sgr0
echo ""
read -p "nombre de usuario para remover: " user
if [[ -z $user ]]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha digitado un nombre de usuario vacio o invalido!" ; echo "" ; tput sgr0
	exit 1
else
	if [[ `grep -c /$user: /etc/passwd` -ne 0 ]]
	then
		ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
		if [[ `grep -c $user /tmp/rem` -eq 0 ]]
		then
			userdel $user > /dev/null
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "El usuario $user Se ha eliminado con éxito!" ; echo "" ; tput sgr0
			grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
			exit 1
		else
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Usuario conectado. Desconectando..." ; tput sgr0
			pkill -f "$user"
			userdel $user > /dev/null
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "El usuario $user Se ha eliminado con éxito!" ; echo "" ; tput sgr0
			grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
			exit 1
		fi
	else
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "El usuario $user no existe!" ; echo "" ; tput sgr0
	fi
fi