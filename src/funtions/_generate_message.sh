#!/bin/bash

# Función para generar dos tipos de mensajes
_generate_message() {
    local message_type="$1"  # Primer argumento: tipo de mensaje (1 o 2)
    local message="$2"       # Segundo argumento: texto del mensaje

    if [ "$message_type" -eq 1 ]; then
		echo -e "${bldblu}========== ${bakblu}$message${txtrst} ${bldblu}========== ${txtrst}"
    elif [ "$message_type" -eq 2 ]; then
        echo -e "${txtylw}$message${txtrst}"
    elif [ "$message_type" -eq 3 ]; then
        echo -e "${bldred}$message${txtrst}"
    elif [ "$message_type" -eq 4 ]; then
       echo -e "${bldgrn}========== ${bakgrn}$message${txtrst} ${bldgrn}========== ${txtrst}"
    else
        echo "Tipo de mensaje no válido. Usa 1 o 2."
    fi
}