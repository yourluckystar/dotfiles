[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias rpi="ssh -f -L 11945:localhost:11945 rpi -N"
alias yt="yt-dlp -f \"bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b\""
alias pass="~/.local/bin/password_manager.sh"
