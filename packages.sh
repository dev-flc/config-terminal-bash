#!/bin/bash

# Comprobar e instalar Homebrew
if ! command -v brew &> /dev/null; then
    _generate_message 2 "Procediendo a instalar Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     # Añadir Homebrew al PATH si es necesario (solo en Linux)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        _generate_message 2 "Añadiendo Homebrew al PATH..."
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    # Instalar dependencias esenciales
    _generate_message 2 "Instalando dependencias de Homebrew..."
    sudo apt-get install build-essential -y
    # Recomendar la instalación de GCC
    _generate_message 2 "Instalando GCC para Homebrew..."
    brew install gcc
else
    _generate_message 2 "Homebrew, instalado."
fi

# Comprobar e instalar zsh
if ! command -v zsh &> /dev/null; then
    _generate_message 2 "Procediendo a instalar zsh..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    else
        sudo apt update && sudo apt install zsh -y
    fi
else
    _generate_message 2 "Zsh, instalado."
fi

# Comprobar e instalar curl
if ! command -v curl &> /dev/null; then
    _generate_message 2 "Procediendo a instalar curl..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install curl
    else
        sudo apt update && sudo apt install curl -y
    fi
else
    _generate_message 2 "curl, instalado."
fi

# Comprobar e instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    _generate_message 2 "Procediendo a instalar Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    _generate_message 2 "Oh My Zsh, instalado."
fi

# Comprobar e instalar grep
if ! command -v grep &> /dev/null; then
    _generate_message 2 "Procediendo a instalar grep..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install grep
    else
        sudo apt update && sudo apt install grep -y
    fi
else
    _generate_message 2 "grep, instalado."
fi


echo ""
