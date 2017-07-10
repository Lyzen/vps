#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-10s\n' "Comandos disponibles:" ; tput sgr0 ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "addhost " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Agregar domínio 'host' a lista de dominios permitidos en Proxy Squid" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "alterarlimite " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Modificar un número máximo de conexiones simultaneas permitidas para un usuario" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "pass " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Modificar contraseña de un usuario" ; echo "" ;
tput setaf 2 ; tput bold ; printf '%s' "crearusuario " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Crear usuario SSH sin acesso a la terminal y con fecha de expiracion" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "delhost " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Remover dominio 'host' de lista de domínios permitidos en Proxy Squid" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "expcleaner " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Remover usuarios SSH expirados" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "fecha " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Cambiar la fecha de vencimiento de un usuario" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "remover " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Remover un usuario SSH" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "sshlimiter " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Limitador de conexiones SSH simultaneas (Se debe ejecutar en una sesión de pantalla)" ; echo ""
tput setaf 2 ; tput bold ; printf '%s' "sshmonitor " ; tput setaf 7 ; printf '%s' "- " ; tput setaf 3 ; echo "Verifica el numero de conexiones de cada usuario" ; echo ""
tput sgr0