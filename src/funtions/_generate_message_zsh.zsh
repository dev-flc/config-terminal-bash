#!/bin/zsh

# Función para generar dos tipos de mensajes
_generate_message_zsh() {
    local message_type="$1"  # Primer argumento: tipo de mensaje (1 o 2)
    local message="$2"       # Segundo argumento: texto del mensaje

    if [ "$message_type" -eq 1 ]; then
        # Mensaje tipo 1: con delimitadores
		echo -e "${bldblu}========== ${bakblu}$message${txtrst} ${bldblu}========== ${txtrst}"
    elif [ "$message_type" -eq 2 ]; then
        # Mensaje tipo 2: mensaje simple
        echo -e "${txtylw}$message${txtrst}"

    elif [ "$message_type" -eq 3 ]; then
        # Mensaje tipo 2: mensaje simple
        echo -e "${bldred}$message${txtrst}"
    else
        echo "Tipo de mensaje no válido. Usa 1 o 2."
    fi
}