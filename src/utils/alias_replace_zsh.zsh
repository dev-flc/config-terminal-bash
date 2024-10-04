#!/bin/zsh

# S Y S T E M
# alias ..='cd ..'
# alias ...='cd ../..'
# alias ....='cd ../../..'
# alias .....='cd ../../../..'

# L I S - F I L E S
# alias l='ls -CF'
# alias ll='ls -al'
# alias la='ls -A'

# B A S H
alias reloadzsh='source ~/.zshrc'
alias configzsh='code ~/.zshrc'
alias congizshdir= 'code ~/.oh-my-zsh'

# N P M
alias dev='npm run dev'
alias devwin='npm run dev:win'
alias start="npm start"
alias build="npm run build"
alias buildwin="npm run build:win"

# J A V A
alias jclean='./gradlew clean build --refresh-dependencies'
alias jbuild='./gradlew clean build'
alias jrun='./gradlew bootRun'

# D O C K E R
alias dinit='sudo systemctl start docker'
alias dbuild=dockerbuild
alias drun=dockerrun
alias dpush=dockerpush

# D I R E C T O R Y
alias pj="cd ${HOME}/REPLACE/projects"
alias vault="cd ${HOME}/REPLACE/projects/gnp/gke-gnp-test-vault-secret"
alias gnp="cd ${HOME}/REPLACE/projects/gnp"
alias example="cd ${HOME}/REPLACE/projects/exmaple"

# G I T
alias configgit='git config --global -e'
alias commit=gitcomit
alias com='npm run commit'
alias push=gitpush
alias status='git status'
alias add='git add .'