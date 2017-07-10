#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Crear Usuário SSH" ; tput sgr0
echo ""
read -p "Nombre de usuario: " username
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Este usuario ya existe. Crear un usuario con otro nombre." ; echo "" ; tput sgr0
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario invalido!" ; tput setab 1 ; echo "Use letras, números, puntos y guiones." ; tput setab 4 ; echo "No utilice espacios, acentos o caracteres especiales!" ; echo "" ; tput sgr0
		exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario muy corto," ; echo "usar como minimo dos caracteres!" ; echo "" ; tput sgr0
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 32 ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario muy grande," ; echo "use como maximo 32 caracteres!" ; echo "" ; tput sgr0
				exit 1
			else
				if [[ -z $username ]]
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario vacío!" ; echo "" ; tput sgr0
					exit 1
				else	
					read -p "contraseña: " password
					if [[ -z $password ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido una contraseña vacía!" ; echo "" ; tput sgr0
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 6 ]]
						then
							tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido una contraseña corta!" ; echo "Para tener un usuario seguro use al menos 6 caracteres" ; echo "combinando diferentes letras y números!" ; echo "" ; tput sgr0
							exit 1
						else	
							read -p "Dias para expirar: " dias
							if (echo $dias | egrep '[^0-9]' &> /dev/null)
							then
								tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un número no válido de días!" ; echo "" ; tput sgr0
								exit 1
							else
								if [[ -z $dias ]]
								then
									tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Dejaste vacio el número de días para expiracion de la cuenta!" ; echo "" ; tput sgr0
									exit 1
								else	
									if [[ $dias -lt 1 ]]
									then
										tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Debe ingresar un número de días superior a cero!" ; echo "" ; tput sgr0
										exit 1
									else
										read -p "Nº de conexiones simultáneas permitidas: " sshlimiter
										if (echo $sshlimiter | egrep '[^0-9]' &> /dev/null)
										then
											tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un número no válido de conexiones!" ; echo "" ; tput sgr0
											exit 1
										else
											if [[ -z $sshlimiter ]]
											then
												tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Dejaste vacio el número de conexiones simultáneas!" ; echo "" ; tput sgr0
												exit 1
											else
												if [[ $sshlimiter -lt 1 ]]
												then
													tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Debe introducir un número mayor que cero para las conexiones simultáneas!" ; echo "" ; tput sgr0
													exit 1
												else
													final=$(date "+%Y-%m-%d" -d "+$dias days")
													gui=$(date "+%d/%m/%Y" -d "+$dias days")
													pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
													useradd -e $final -M -s /bin/false -p $pass $username
													[ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo "Usuario $username creado" ; echo "Fecha de expiracion: $gui" ; echo "Nº de conexiones simultaneas permitidas: $sshlimiter" ; echo "" || echo "No se pudo crear el usuario!" ; tput sgr0
													echo "$username $sshlimiter" >> /root/usuarios.db
												fi
											fi
										fi
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi	
fi