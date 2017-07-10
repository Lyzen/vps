#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-10s\n' "Cambiar contraseña de usuario" ; tput sgr0
tput bold ; echo "" ; echo "Lista de usuarios:" ; echo "" ; tput sgr0
tput setaf 3 ; tput bold ; awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody' ; echo "" ; tput sgr0
read -p "Nombre de usuario para cambiar la contraseña: " user
if [[ -z $user ]]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario vacío o no válido!" ; echo "" ; tput sgr0
	exit 1
else
	if [[ `grep -c /$user: /etc/passwd` -ne 0 ]]
	then
		read -p "Escriba una nueva contraseña para el usuario: " password
		sizepass=$(echo ${#password})
		if [[ $sizepass -lt 6 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "No se ha cambiado la contraseña!" ; echo "Ha introducido una contraseña muy corta!" ; echo "Para mantener el usuario seguro utilice al menos 6 caracteres" ; echo "combinando diferentes letras y números." ; echo "" ; tput sgr0
			exit 1
		else
			ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
			if [[ `grep -c $user /tmp/rem` -eq 0 ]]
			then
				echo "$user:$password" | chpasswd
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "La contraseña del usuario $user se ha cambiado a: $password" ; echo "" ; tput sgr0
				exit 1
			else
				echo ""
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "Usuario conectado. Desconectando..." ; tput sgr0
				pkill -f $user
				echo "$user:$password" | chpasswd
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "La contraseña del usuario $user se ha cambiado a: $password" ; echo "" ; tput sgr0
				exit 1
			fi
		fi
	else
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "El usuario $user no existe!" ; echo "" ; tput sgr0
	fi
fi