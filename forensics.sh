#!/bin/bash

echo "================================================================================"
echo " Recompilación de pruebas forenses en sistemas Linux "
echo -e " Función hash de firmado: \e[0;31mSHA256\e[0m"
echo "================================================================================"

pathDestino=$(pwd)/forensics_output
pathFiles="$pathDestino/archivos"
userPath=""
home=$(ls /home)

#Se comprueban los privilegios
[ "$(id -u)" -ne 0 ] && (echo -ne "\e[0;31mEste script debe ejecutarse con privilegios root\e[0m" >&2) && exit 1;

echo -ne "\n\e[0;33m Escribe el donde se guardaran los archivos (Default: $pathDestino):\033[1m";
read userPath

if [[ -z "$userPath" ]]; then :; elif [[ "$userPath" != "$pathDestino"  ]] ;then pathDestino=$userPath; fi

if ! [[ -d "$pathFiles" ]];then mkdir -p "$pathFiles"; fi

#echo -e "\e[1;34m[*] Instalando Lime\e[0m"
#ver=$(uname -r)
#apt-get install build-essential "linux-headers-$ver"
#git clone "https://github.com/504ensicsLabs/LiME"
#cd LiME/src/ && make
#echo -e "\e[1;34m[*] Creando volcado RAM\e[0m"
#rmmod lime
#insmod lime-*.ko "path=$pathFiles/volcado_ram.lime format=lime"
#cd -
echo -e "\e[1;34m[*] Copiando archivos de los usuarios\e[0m"
cp /etc/sudoers /etc/passwd /etc/shadow "$pathFiles"
# Se obtienen todos los ficheros del sistema con permisos de lectura
echo -e "\e[1;34m[*] Generando el listado de ficheros del sistema\e[0m"
find / -type f -perm -444 2> /dev/null > sys_files.txt
# Se obtienen todos los directorios del sistema
echo -e "\e[1;34m[*] Generando el listado de directorios del sistema\e[0m"
find / -type d -perm -111 2> /dev/null > sys_dirs.txt
# Se vuelcan en un archivo los procesos actuales del sistema
echo -e "\e[1;34m[*] Volcando los procesos del sistema\e[0m"
ps -aux > "$pathFiles/procesos"
# Se copian los historiales de las shells del sistema
echo -e "\e[1;34m[*] Copiando historiales de las shells de los usuarios del sistema\e[0m"
for i in $home; do cat "/home/${i}/.bash_history" 2> /dev/null > "$pathFiles/${i}_bash_history" | cat "/home/${i}/.zsh_history" 2> /dev/null > "$pathFiles/${i}_zsh_history"; done;
echo -e "\e[1;34m[*] Copiando configuraciones de red y conexiones\e[0m"
ip addr > "$pathFiles/configuraciones_red" && netstat -an >> "$pathFiles/configuraciones_red" && dig >> "$pathFiles/configuraciones_red" && route >> "$pathFiles/configuraciones_red"
echo -e "\e[1;34m[*] Copiando logs del sistema\e[0m"
logs="$pathFiles/logs"
mkdir "$logs"
cp -r /var/log/* "$logs"
lastlog > "$pathFiles/lastlog"
echo -e "\e[1;34m[*] Obteniendo los ficheros superiores a 1 GB del sistema\e[0m"
find / -size +1000M 2> /dev/null > "$pathFiles/1gb_files"
# Limpieza de archivos con tamaña 0 bytes
find . -type f -size 0b -delete

echo -e "\e[1;34m[*] Generando las firmas\e[0m"
dirs=$(ls "$pathFiles")
for t in $dirs; do sha256sum "${pathFiles}/${t}" 2> /dev/null >> "${pathDestino}/firmas.txt" ; done;
