#!/bin/bash

# Función para generar dos tipos de mensajes
_generate_message() {
    local message_type="$1"  # Primer argumento: tipo de mensaje (1 o 2)
    local message="$2"       # Segundo argumento: texto del mensaje
	printf "\n"

    if [ "$message_type" -eq 1 ]; then
		printf "${bldblu}========== ${bakblu}$message${txtrst} ${bldblu}========== ${txtrst}"
    elif [ "$message_type" -eq 2 ]; then
        printf "${txtylw}$message${txtrst}"
    elif [ "$message_type" -eq 3 ]; then
        printf "${bldred}$message${txtrst}"
    elif [ "$message_type" -eq 4 ]; then
        printf "${bldgrn}========== ${bakgrn}$message${txtrst} ${bldgrn}========== ${txtrst}"
    else
        echo "Tipo de mensaje no válido. Usa 1 o 2."
    fi
	printf "\n"
}