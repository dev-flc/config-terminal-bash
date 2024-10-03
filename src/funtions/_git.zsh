#!/bin/bash

# F - U - N - C - T - I - O - N - S


RUTE_OH_MY_ZSH="$HOME/.oh-my-zsh"
RUTE_OH_MY_ZSH_CUSTOM="$RUTE_OH_MY_ZSH/custom"

source "$RUTE_OH_MY_ZSH_CUSTOM/funtions/_array_as_json_colors_zsh.zsh"
source "$RUTE_OH_MY_ZSH_CUSTOM/funtions/_generate_message_zsh.zsh"

find_git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null | sed 's/\*//')
  if [ "$branch" ]; then
    echo "$branch"
  else
    echo ""
  fi
}


check_git_changes() {
    local branch=$(find_git_branch)
    if [ -n "$branch" ]; then
      # Obtener el estado del repositorio en un formato por líneas
      local status=$(git status --porcelain 2> /dev/null)

      # Variables para indicar el estado
      changes_to_commit=false
      changes_not_staged=false

      # Iterar sobre cada línea del estado
      while IFS= read -r line; do
          # Verificar si la línea indica cambios que están listos para ser comprometidos
          if [[ $line == "A"* || $line == "M"* || $line == "R"* || $line == "C"* || $line == "U"* || $line == "D"* || $line == "?"* ]]; then
              changes_to_commit=true
              # Si encontramos un cambio que está listo para ser comprometido, salimos del bucle
              break
          # Verificar si la línea indica cambios que no están preparados para ser comprometidos
          elif [[ $line == " "* ]]; then
              changes_not_staged=true
          fi
      done <<< "$status"

      # Imprimir el resultado
      if [ "$changes_to_commit" = true ]; then
          echo "🚀"
      elif [ "$changes_not_staged" = true ]; then
          echo "🔥"
      else
        echo ""
      fi
    else
      echo ""
    fi
}

gitcomit() {
  # ========= Imprimiendo objeto de opciones ==========

  keys=("1" "2" "3" "4" "5" "6" "7")
  values=("🎸 feat" "🐛 fix" "💡 refactor" "💄 style" "💍 test" "✏️ docs" "🏹 exit")
	_array_as_json_colors_zsh keys values

  print -P -n "$(_generate_message_zsh 2 '🍻 SELECT THE TYPE OF COMMIT: ')"
  read opcion_type
  # ========= Verificar si el valor es igual a "7" o no está en el arreglo ==========
  if [[ "$opcion_type" == "7" ]]; then
      echo "$(_generate_message_zsh 3 'Bye... 😉')"
      return
  elif [[ ! " ${keys[*]} " =~ " ${opcion_type} " ]]; then
      echo "$(_generate_message_zsh 3 'Invalid option. 🤮')"
      return
  else
    # ========= Imprimiendo objeto de opcion seleccionada ==========
    local opcion_value="${values["${opcion_type}"]}"
    opcion_type_keys=("${opcion_type}")
    opcion_type_values=("${opcion_value}")
    _array_as_json_colors_zsh opcion_type_keys opcion_type_values

    # ========= Imprimiendo Scope del commit ==========
    print -P -n "$(_generate_message_zsh 2 '📌 SCOPE [ MODULE, FILE, CONFIG ] COMMIT: ')"
    read scope
    scope_keys=("SCOPE")
    scope_values=("${scope}")
    _array_as_json_colors_zsh scope_keys scope_values

    # ========= Imprimiendo descripcion del commit ==========
    print -P -n "$(_generate_message_zsh 2 '📕 DESCRIPTION COMMIT: ')"
    read description
    description_keys=("DESCRIPTION")
    description_values=("${description}")
    _array_as_json_colors_zsh description_keys description_values

    # ========= Imprimiendo el commit completo ==========
    echo "$(_generate_message_zsh 2 '🚀 COMMAND')"
    IFS=' ' read -r icon type <<< "$opcion_value"
    description_commit="${type}(${scope}): ${icon} ${description}"
    command_keys=("COMMAND")
    command_values=("git commit -m '${description_commit}'")
    _array_as_json_colors_zsh command_keys command_values

    # ========= ejecutando el comando ==========
    git add . && git commit -m "${description_commit}"
  fi
}

# P U S H
gitpush() {
  local branch=$(find_git_branch)
  if [ -n "$branch" ]; then
    git push origin "$branch"
  fi
}

# D O C K E R

dockerbuild() {
  read -p "Enter the name of the image: " name
  name=${name:-"docker-image"}

  read -p "Enter the version of the image: " version
  version=${version:-"1.0.0"}

  newname="gcr.io/gnp-sica/${name}:v${version}"
  echo "Building the image with the name: $newname"

  docker build -t $newname .
}

dockerrun() {
  read -p "Enter the name of the image: " name
  name=${name:-"docker-image"}

  read -p "Enter the version of the image: " version
  version=${version:-"1.0.0"}

  newname="gcr.io/gnp-sica/${name}:v${version}"
  echo "Building the image with the name: $newname"

  docker run -p 8080:8080 $newname
}

dockerpush() {
  read -p "Enter the name of the image: " name
  name=${name:-"docker-image"}

  read -p "Enter the version of the image: " version
  version=${version:-"1.0.0"}

  newname="gcr.io/gnp-sica/${name}:v${version}"
  echo "Building the image with the name: $newname"

  docker push $name
}