#!/bin/zsh

# Función para convertir dos arreglos a JSON coloreado
_array_as_json_colors_zsh() {
    # Obtener los arreglos como argumentos
    local -a keys=("${(@P)1}")    # Desreferenciar el nombre del arreglo con (@P)
    local -a values=("${(@P)2}")

    # Definir colores
    local txtylw='\e[1;33m'
    local bldblu='\e[1;34m'
    local txtgrn='\e[1;32m'
    local txtrst='\e[0m'

    # Abrir la estructura JSON
    echo -e "${txtylw}{${txtrst}"

    # Inicializar JSON vacío
    local json=""

    # Recorrer las claves y valores
    for i in {1..${#keys[@]}}; do
        # Añadir la llave personalizada en color azul
        json+="  ${bldblu}\"${keys[$i]}\"${txtrst}: "

        # Añadir el valor personalizado en color verde
        json+="${txtgrn}\"${values[$i]}\"${txtrst}"

        # Añadir coma si no es el último elemento
        if [ "$i" -lt $((${#keys[@]} - 1)) ]; then
            json+=","
        fi
       # Añadir nueva línea si no es el último elemento
        if [ "$i" -lt $((${#keys[@]} - 0)) ]; then
            json+="\n"
        fi
    done

    # Imprimir el JSON generado
    echo -e "$json"

    # Cerrar la estructura JSON
    echo -e "${txtylw}}${txtrst}"
}