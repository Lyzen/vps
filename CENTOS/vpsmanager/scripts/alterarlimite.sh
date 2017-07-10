#!/bin/bash
database="/root/usuarios.db"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%20s%s\n' "   Cambiar el límite de conexiones SSH simultáneas   " ; tput sgr0
if [ ! -f "$database" ]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Archivo $database no encontrado" ; echo "" ; tput sgr0
	exit 1
else
	tput setaf 2 ; tput bold ; echo ""; echo "Límite de conexiones simultáneas de los usuarios:" ; tput sgr0
	tput setaf 3 ; tput bold ; echo "" ; cat $database ; echo "" ; tput sgr0
	read -p "Nombre de usuario para cambiar el límite: " usuario
	if [[ -z $usuario ]]
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario vacío o no existente en la lista!" ; echo "" ; tput sgr0
		exit 1
	else
		if [[ `grep -c "^$usuario " $database` -gt 0 ]]
		then
			read -p "Número de conexiones simultáneas permitidas para el usuario: " sshnum
			if [[ -z $sshnum ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un número no válido!" ; echo "" ; tput sgr0
				exit 1
			else
				if (echo $sshnum | egrep [^0-9] &> /dev/null)
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un número no válido!" ; echo "" ; tput sgr0
					exit 1
				else
					if [[ $sshnum -lt 1 ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Debe introducir un número de conexiones simultáneas mayor que cero!" ; echo "" ; tput sgr0
						exit 1
					else
						grep -v ^$usuario[[:space:]] /root/usuarios.db > /tmp/a
						sleep 1
						mv /tmp/a /root/usuarios.db
						echo $usuario $sshnum >> /root/usuarios.db
						tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Se ha cambiado el número de conexiones simultáneas permitidas para el usuario $usuario:" ; tput sgr0
						tput setaf 3 ; tput bold ; echo "" ; cat $database ; echo "" ; tput sgr0
						exit
					fi
				fi
			fi			
		else
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "El Usuario $usuario no se encontró en la lista!" ; echo "" ; tput sgr0
			exit 1
		fi
	fi
fi