#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

ctrl_c() {
  echo -e "\n\n${redColour}[!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"


# Como usar el script
helpPanel() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
  echo -e "\t${purpleColour}[u]${endColour} ${grayColour}Descargar o actualizar archivos necesarios ${endColour}"
  echo -e "\t${purpleColour}[m]${endColour} ${grayColour}Buscar por un nombre de máquina ${endColour}"
  echo -e "\t${purpleColour}[i]${endColour} ${grayColour}Buscar por Dirección IP ${endColour}"
  echo -e "\t${purpleColour}[d]${endColour} ${grayColour}Buscar todas las máquinas con un nivel de dificultad en concreto${endColour}" # Fácil, Medio, Difícil e Insane
  echo -e "\t${purpleColour}[o]${endColour} ${grayColour}Buscar todas las máquinas con un sistema operativo determinado${endColour}" # Linux o Windows
  echo -e "\t${purpleColour}[s]${endColour} ${grayColour}Buscar por Skills${endColour}" # Para introducir dos campos o mas se deben poner comillas, ejemplo: "Active Directory"
  echo -e "\t${purpleColour}[c]${endColour} ${grayColour}Buscar por certificación${endColour}" # Pasamos el tipo de certificación, ejemplo: OSCP y muestra sus máquinas  
  echo -e "\t${purpleColour}[y]${endColour} ${grayColour}Obtener link de la resolución de la máquina en youtube${endColour}"
  echo -e "\t${purpleColour}[h]${endColour} ${grayColour}Mostrar este panel de ayuda ${endColour}\n"
  exit 0
}

# Funcion para descargar y actualizar archivos necesarios, se necesita js-beautify para darle formato al fichero.
updateFiles() {
  # Si el archivo no existe lo descarga, pero si ya existe descarga una copia para comparar ambos ficheros
   if [ ! -f bundle.js ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Descargando archivos necesarios...${endColour}"
    curl -s $main_url | js-beautify >bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados${endColour}"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...${endColour}"
    curl -s $main_url | js-beautify >bundle_temp.js
    # Verifica si las sumas MD5 de bundle.js y bundle_temp.js son iguales:
    # 1. Calcula las sumas MD5 de ambos archivos.
    # 2. awk extrae solo las sumas MD5 (primera columna).
    # 3. uniq elimina líneas duplicadas para ver si las sumas MD5 son diferentes.
    # 4. wc -l cuenta el número de líneas únicas.
    # 5. Si hay una sola línea única, significa que ambos archivos son idénticos (sin actualizaciones).
    if [[ $(md5sum bundle.js bundle_temp.js | awk '{print $1}' | uniq | wc -l) == 1 ]]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones, lo tienes todo al día ;)${endColour}"
        rm bundle_temp.js
    else
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles${endColour}"
        sleep 1
        rm bundle.js && mv bundle_temp.js bundle.js
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
    fi
    tput cnorm
  fi
}

# Busqueda por nombre de maquina que imprime todas sus características.
searchMachine() {
  machineName="$1"
  # Si el nombre de la máquina no esta vacío, se imprimen sus propiedades, si no, se muestra el mensaje de error.
  machineName_checker="$(awk "/name: \"$machineName\"/,/resuelta:/" bundle.js | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
  if [ ! -z "$machineName_checker" ]; then
    echo -e "\n ${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la máquina${endColour} ${blueColour}$machineName${endColour}\n"
  # Proceso para colorear los campos específicos
    awk "/name: \"$machineName\"/,/resuelta:/" bundle.js | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | while read -r line; do
      #field: Captura la primera parte de la línea, antes del : (es decir, el nombre del campo).
      #value: Captura la segunda parte de la línea, después del : (es decir, el valor del campo).
      field=$(echo "$line" | cut -d ':' -f 1)
      value=$(echo "$line" | cut -d ':' -f 2-)
      case "$field" in
          name|ip|so|dificultad|skills|like|youtube)
          echo -e "${turquoiseColour}${field}:${endColour} ${grayColour}${value}${endColour}"
          ;;
        *)
          echo -e "${grayColour}${line}${endColour}"
          ;;
      esac
    done
   else
      echo -e "\n ${redColour}[!] El nombre de la máquina proporcionada no existe${endColour}"
  fi
}

# Busqueda por IP nos imprime la máquina a la que pertenece
searchIP(){
  ipAddress="$1"
  machineName="$(grep -B 3 "ip: \"$ipAddress\"" bundle.js | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ",")"
  #Validación para la IP
  if [ ! -z "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La dirección IP${endColour} ${blueColour}$ipAddress${endColour}${grayColour} pertenece a la máquina:${endColour}${purpleColour} "$machineName" ${endColour}"
  else
    echo -e "\n ${redColour}[!] La dirección IP que acabas de introducir no existe${endColour}"
  fi
}

# Busqueda del enlace a youtube de una máquina 
getYoutubeLink(){
  machineName="$1"
  youtubeLink="$(awk "/name: \"$machineName\"/,/resuelta:/" bundle.js | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "youtube: " | awk NF'{print $NF}')"
  if [ ! -z "$youtubeLink" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Para ver la resolución de la máquina ${endColour}${purpleColour}$machineName ${endColour}${grayColour}puedes acceder al siguiente enlace de youtube${endColour} ${blueColour}$youtubeLink${endColour}"
  else
    echo -e "\n ${redColour}[!] El nombre de la máquina proporcionada no existe${endColour}"
  fi
}

# Busqueda de todas las máquinas que tienen un determinado nivel de dificultad: Fácil, Medio, Difícil e Insane
getMachinesDifficulty(){
  difficulty="$1"
  difficultyCkeck="$(grep -B 5 "dificultad: \"$difficulty\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column)"
  if [ ! -z "$difficultyCkeck" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Estas son las máquinas con nivel de dificultad${endColour} ${purpleColour}$difficulty${endColour}${grayColour}:${endColour}\n"
    grep -B 5 "dificultad: \"$difficulty\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column
  else
    echo -e "\n ${redColour}[!] La dificultad indicada no existe${endColour}"
  fi
}

# Busqueda de máquinas por sistema operativo: Linux o Windows.
getMachinesOperatingSystem(){
  operatingSystem="$1"
  machineOperatingSystem_check="$(grep -B 4 "so: \"$operatingSystem\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column)"
  if [ ! -z "$machineOperatingSystem_check" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Estas son las maquinas con el sistema operativo ${endColour}${blueColour}$operatingSystem${endColour}${grayColour}:${endColour}\n"
    grep -B 4 "so: \"$operatingSystem\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column
  else
    echo -e "\n ${redColour}[!] El sistema operativo indicado no existe${endColour}"
  fi
}

# Busqueda de máquinas por un nivel de dificultad y por un sistema operativo, ejemplo: -d Fácil -o Linux
getMachinesOsDifficulty(){
  difficulty="$1"
  operatingSystem="$2"
  difficultyCkeck="$(grep -B 5 "dificultad: \"$difficulty\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column)"
  machineOperatingSystem_check="$(grep -B 4 "so: \"$operatingSystem\"" bundle.js | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column)"
  # Si dificultad y sistema operativo no estan vacios, imprimo la información
  if [ ! -z "$difficultyCkeck" ] && [ ! -z "$machineOperatingSystem_check" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour}Buscando maquinas con sistema operativo ${endColour}${blueColour}$operatingSystem${endColour}${grayColour} y dificultad ${endColour}${blueColour}$difficulty${endColour}${grayColour}:${endColour}\n"
    grep "so: \"$operatingSystem\"" -C 4 bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk NF'{print $NF}' | tr -d '",' | column
  else
    echo -e "\n ${redColour}[!] Los datos introducidos no son correctos${endColour}"
  fi
}

# busqueda de máquinas por skill
getSkills(){
  skill="$1"
  skillMachineCheck="$(grep -B 6 "skills: " bundle.js | grep "$skill" -i -B 6 | grep "name: " | awk NF'{print $NF}' | tr -d '",' | column)"
  if [ ! -z "$skillMachineCheck" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La skill${endColour}${blueColour} $skill${endColour} ${grayColour}poporcionada esta en las siguientes máquinas:${endColour}\n"
    grep -B 6 "skills: " bundle.js | grep "$skill" -i -B 6 | grep "name: " | awk NF'{print $NF}' | tr -d '",' | column
  else
    echo -e "\n${redColour}[!] La skill proporcionada no es correcta${endColour}"
  fi
}

# Busqueda de máquinas por certificado
getMachineCertificate(){
  certificate="$1"
  certificateCkeck="$(grep "like: \"$certificate\"" -B 7 -i bundle.js | grep "name: " | awk NF'{print $NF}' | tr -d '",' | column)"
  if [ ! -z "$certificateCkeck" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando máquinas con el certificado ${endColour}${purpleColour}$certificate${endColour}\n"
    grep "like: \"$certificate\"" -B 7 -i bundle.js | grep "name: " | awk NF'{print $NF}' | tr -d '",' | column
  else
    echo -e "\n${redColour}[!] El certificado proporcionado no existe${endColour}"
  fi
}

declare -i parameter_counter=0
#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:c:h" opcion; do
  case $opcion in
  m)
    machineName="$OPTARG";
    let parameter_counter+=1
    ;;
  u)
    let parameter_counter+=2
    ;;
  i)
    ipAddress="$OPTARG";
    let parameter_counter+=3
    ;;
  y)
    machineName="$OPTARG";
    let parameter_counter+=4
    ;;
  d)
    difficulty="$OPTARG";
    let parameter_counter+=5;
    chivato_difficulty=1
    ;;
  o)
    operatingSystem="$OPTARG";
    let parameter_counter+=6;
    chivato_os=1
    ;;
  s)
    skill="$OPTARG"
    let parameter_counter+=7
    ;;
  c)
    certificate="$OPTARG"
    let parameter_counter+=8
    ;;
  h)
    helpPanel
    exit 0
    ;;
  *)
    echo -e "\n${redColour} Opción inválida ${endColour}"
    exit 1
    ;;
  esac
done

# Si no se introduce ningun valor, se mostrará el panel de ayuda.
if [ $parameter_counter -eq 1 ]; then
  searchMachine "$machineName"
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP "$ipAddress"
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink "$machineName"
elif [ $parameter_counter -eq 5 ]; then
  getMachinesDifficulty "$difficulty"
elif [ $parameter_counter -eq 6 ]; then
  getMachinesOperatingSystem "$operatingSystem"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getMachinesOsDifficulty "$difficulty" "$operatingSystem"
elif [ $parameter_counter -eq 7 ]; then
  getSkills "$skill"
elif [ $parameter_counter -eq 8 ]; then
  getMachineCertificate "$certificate"
else
  helpPanel
fi