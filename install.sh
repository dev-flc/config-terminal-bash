#!/bin/bash

# ========= Importando los archivos ==========
source "./src/utils/colors.sh"
source "./src/funtions/_array_as_json_colors.sh"
source "./src/funtions/_generate_message.sh"

# ========= Funcion para determinar el tipo de sistema operativo ==========
get_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        printf "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        printf "linux"
    else
        printf "Sistema operativo no soportado..."
    fi
}

# ========= Funcion para instalar paquetes ==========
install_packages() {
    local os_type=$1
    shift
    local packages=("$@")
    local keys=()
    local values=()

    if [[ "$os_type" != "macos" && "$os_type" != "linux" ]]; then
        _generate_message 1 "Sistema operativo no soportado: $os_type"
        return 1
    fi

    for package in "${packages[@]}"; do
        case "$package" in
            "brew")
                if ! command -v brew &> /dev/null; then
                    _generate_message 2 "Procediendo a instalar Homebrew..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    if [[ "$os_type" == "linux" ]]; then
                        _generate_message 2 "Añadiendo Homebrew al PATH..."
                        printf 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
                        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                        # Instalar dependencias esenciales
                        _generate_message 2 "Instalando dependencias de Homebrew..."
                        sudo apt-get install build-essential -y
                        # Recomendar la instalación de GCC
                        _generate_message 2 "Instalando GCC para Homebrew..."
                        brew install gcc
                    fi
                else
                    keys+=("Homebrew")
                    values+=("✔")
                fi
                ;;
            "zsh"|"curl"|"grep")
                if ! command -v $package &> /dev/null; then
                    _generate_message 2 "Procediendo a instalar $package..."
                    if [[ "$os_type" == "macos" ]]; then
                        brew install $package
                    elif [[ "$os_type" == "linux" ]]; then
                        sudo apt update && sudo apt install $package -y
                    fi
                else
                    keys+=("$package")
                    values+=("✔")
                fi
                ;;
            "oh-my-zsh")
                if [ ! -d "$HOME/.oh-my-zsh" ]; then
                    _generate_message 2 "Procediendo a instalar Oh My Zsh..."
                    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                else
                    keys+=("oh-my-zsh")
                    values+=("✔")
                fi
                ;;
            "bun")
                if ! command -v bun &> /dev/null; then
                    _generate_message 2 "Procediendo a instalar bun..."
                    curl -fsSL https://bun.sh/install | bash
                    echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.zshrc
                    export PATH="$HOME/.bun/bin:$PATH"
                else
                    keys+=("bun")
                    values+=("✔")
                fi
                ;;
            *)
                _generate_message 2 "Paquete '$package' no reconocido. Omitiendo..."
                ;;
    	esac
    done

    _generate_message 1 "Paquetes Instalados"
    _array_as_json_colors keys[@] values[@]
}

replace_dir_alias(){

	local CURRENT_PATH=$(pwd)
	local ALIAS_FILE="alias_replace_zsh.zsh"
	local HOME_DIR="$HOME"

	# ========= Eliminando copia del archivo original ==========
	local URL_NEW_FILE="$CURRENT_PATH/src/utils/alias_zsh.zsh"
	rm -rf "$URL_NEW_FILE"
	# ========= Generar una copia del archivo original ==========
	cp "$CURRENT_PATH/src/utils/alias_replace_zsh.zsh" "$URL_NEW_FILE"

	# ========= Verificar si existe la carpeta "documents" o "documentos" en $HOME =========
	if [ -d "${HOME_DIR}/Documents" ]; then
		REPLACE_DIR="Documents"
	elif [ -d "${HOME_DIR}/Documentos" ]; then
		REPLACE_DIR="Documentos"
	else
		_generate_message 1 "Ninguna de las carpetas 'documents' o 'documentos' existe en el directorio HOME."
		return
	fi
	# ========= Reemplazar "REPLACE" por la carpeta correspondiente en el nuevo archivo =========
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sed -i '' "s/REPLACE/$REPLACE_DIR/g" "$URL_NEW_FILE"
	else
		sed -i "s/REPLACE/$REPLACE_DIR/g" "$URL_NEW_FILE"
	fi
}

customize_shell_config(){
	# ========= Variables ==========
	local SO="$1"
	local CURRENT_PATH=$(pwd)
	local NAME_THEME="dev-flc"
	local THEME_EXTENSION="$NAME_THEME.zsh-theme"
	local RUTE_ZSHRC_FILE="$HOME/.zshrc"
	local RUTE_OH_MY_ZSH="$HOME/.oh-my-zsh"
	local RUTE_OH_MY_ZSH_CUSTOM="$RUTE_OH_MY_ZSH/custom"
	local os_type=$(get_os_type)

	# ========= Sistema Operativo ==========
	_generate_message 1 "Sistema Operativo"
	keys_system=("sistema")
	values_system=("$os_type")
	_array_as_json_colors keys_system[@] values_system[@]
	printf ""


	_generate_message 1 "Paquetes ha Instalar"
	# ========= Menu de paquetes ==========
	keys_package=("0" "1" "2" "3" "4" "5")
	values_package=("Homebrew" "Zsh" "curl" "Oh My Zsh" "grep" "bun")
	_array_as_json_colors keys_package[@] values_package[@]
	printf ""

	# ========= Instalando paquetes ==========
	install_packages "$os_type" "brew" "zsh" "curl" "oh-my-zsh" "grep" "bun"

	# ========= Creando alias  de documentos ==========
	_generate_message 1 "Generando alias"
	replace_dir_alias
	printf ""

	# ========= Eliminando y creando los archivos custom ==========
	_generate_message 1 "Instalando archivos de oh-my-zsh"
	if [ -f "$RUTE_ZSHRC_FILE" ]; then
		# ========= Verificar si el directorio .oh-my-zsh/custom existe ==========
		if [ -d "$RUTE_OH_MY_ZSH_CUSTOM" ]; then
			# ========= Eliminar todos los archivos ==========
			_generate_message 1 "Eliminando archivos anteriores..."
			rm -rf "$RUTE_OH_MY_ZSH_CUSTOM/themes/$THEME_EXTENSION"
			rm -rf "$RUTE_OH_MY_ZSH_CUSTOM/main.sh"
			rm -rf "$RUTE_OH_MY_ZSH_CUSTOM/img"
			rm -rf "$RUTE_OH_MY_ZSH_CUSTOM/utils"
			rm -rf "$RUTE_OH_MY_ZSH_CUSTOM/funtions"
			# ========= Copiar todos los archivos ==========
			_generate_message 1 "Generando archivos nuevos..."
			cp -r "$CURRENT_PATH/src/themes/$THEME_EXTENSION" "$RUTE_OH_MY_ZSH_CUSTOM/themes/$THEME_EXTENSION"
			cp "$CURRENT_PATH/src/main.sh" "$RUTE_OH_MY_ZSH_CUSTOM"
			cp -r "$CURRENT_PATH/src/img" "$RUTE_OH_MY_ZSH_CUSTOM"

			mkdir "$RUTE_OH_MY_ZSH_CUSTOM/utils"
			cp -r "$CURRENT_PATH/src/utils/alias_zsh.zsh" "$RUTE_OH_MY_ZSH_CUSTOM/utils/alias_zsh.zsh"
			cp -r "$CURRENT_PATH/src/utils/colors_zsh.zsh" "$RUTE_OH_MY_ZSH_CUSTOM/utils/colors_zsh.zsh"
			mkdir "$RUTE_OH_MY_ZSH_CUSTOM/funtions"
			cp -r "$CURRENT_PATH/src/funtions/_git.zsh" "$RUTE_OH_MY_ZSH_CUSTOM/funtions/_git.zsh"
			cp -r "$CURRENT_PATH/src/funtions/_array_as_json_colors_zsh.zsh" "$RUTE_OH_MY_ZSH_CUSTOM/funtions/_array_as_json_colors_zsh.zsh"
			cp -r "$CURRENT_PATH/src/funtions/_generate_message_zsh.zsh" "$RUTE_OH_MY_ZSH_CUSTOM/funtions/_generate_message_zsh.zsh"

			local SOURCE_LINE_MAIN="source '$RUTE_OH_MY_ZSH_CUSTOM/main.sh'"
			# ========= validamos si ya sxiste el main en el archivo .zshrc ==========
			if ! grep -Fxq "$SOURCE_LINE_MAIN" "$RUTE_ZSHRC_FILE"; then
				# ========= Agregando el archivo main al .zshrc ==========
				_generate_message 1 "Agregando el archivo main al .zshrc"
				printf "source '$RUTE_OH_MY_ZSH_CUSTOM/main.sh'" >> "$RUTE_ZSHRC_FILE"
			fi
			# ========= Agregando el nombre del tema al archivo zshrc ==========
			_generate_message 1 "Agregando el tema al .zshrc"
			if [[ "$OSTYPE" == "darwin"* ]]; then
				sed -i '' "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$NAME_THEME\"/" "$RUTE_ZSHRC_FILE"
			else
				sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$NAME_THEME\"/" "$RUTE_ZSHRC_FILE"
			fi
			# ========= Eliminando copia del archivo original ==========
			local URL_NEW_FILE="$CURRENT_PATH/src/utils/alias_zsh.zsh"
			rm -rf "$URL_NEW_FILE"

			printf ""
			_generate_message 4 "Instalación completada. Reinicia la terminal para ver los cambios."
		else
			_generate_message 3 "El directorio $RUTE_OH_MY_ZSH_CUSTOM no existe."
			return 1
		fi
	else
		_generate_message 3 "El archivo .zshrc no existe"
		return 1
	fi
}

customize_shell_config "linux"
