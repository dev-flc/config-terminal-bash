#!/bin/bash

# Función para convertir un arreglo a JSON coloreado
_array_as_json_colors() {
    local keys=("${!1}")    # Obtener las claves como el primer arreglo
    local values=("${!2}")  # Obtener los valores como el segundo arreglo
    local json=""
    # Definir colores
    txtylw='\e[1;33m'
    bldblu='\e[1;34m'
    txtgrn='\e[1;32m'
    txtrst='\e[0m'

    printf "${txtylw}{${txtrst}\n"  # Abrir la estructura JSON

    for i in "${!keys[@]}"; do
        # Añadir la llave personalizada en color azul
        json+="  ${bldblu}\"${keys[$i]}\"${txtrst}: "

        # Añadir el valor personalizado en color verde
        json+="${txtgrn}\"${values[$i]}\"${txtrst}"

        # Añadir coma si no es el último elemento
        if [ "$i" -lt $((${#keys[@]} - 1)) ]; then
            json+=","
        fi
        # Añadir nueva línea si no es el último elemento
        if [ "$i" -lt $((${#keys[@]} - 1)) ]; then
            json+="\n"
        fi
    done

    # Imprimir el JSON generado
    printf "$json\n"
    printf "${txtylw}}${txtrst}"  # Cerrar la estructura JSON
}