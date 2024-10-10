#!/bin/bash

function virtualenv_prompt_info {
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function prompt_char {
  command git branch &>/dev/null && echo "┤●" || echo '┤○'
}

function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

function java_version_info {
  local version
  version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  echo "$version"
}

local java_info='$(java_version_info)'
local nvm_info='$(nvm_prompt_info)'
local git_info='$(git_prompt_info)'
local virtualenv_info='$(virtualenv_prompt_info)'
local prompt_char='$(prompt_char)'

PROMPT="%B%{$FG[001]%}╭─${FG[202]}👽 { dev : ${FG[226]}F.L.C ${FG[202]}} ${FG[255]}on %B${FG[226]}%~%b${git_info}
${FG[001]}╰─${prompt_char}%{$reset_color%} $  %{$reset_color%}"


local ja="${FG[202]}{ java : ${FG[226]}${java_info}${FG[202]} } ${FG[239]}%{$reset_color%}"
local no="${FG[202]}{ node : ${FG[226]}${nvm_info}${FG[202]} } ${FG[239]}%{$reset_color%}"

RPROMPT="${ja}${no}"

ZSH_THEME_GIT_PROMPT_PREFIX=" %B%{$FG[255]%}in%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%B%{$FG[001]%} ✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%B%{$FG[001]%} %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%{$FG[040]%} ✔%{$reset_color%}"