#!/bin/bash

print_ascii() {
    cat << "EOF"
                  -`                 
                 .o+`                
                `ooo/                
               `+oooo:               
              `+oooooo:              
              -+oooooo+:             
            `/:-:++oooo+:            
           `/++++/+++++++:           
          `/++++++++++++++:          
         `/+++ooooooooooooo/`        
        ./ooosssso++osssssso+`       
       .oossssso-````/ossssss+`      
      -osssssso.      :ssssssso.     
     :osssssss/        osssso+++.    
    /ossssssss/        +ssssooo/-    
  `/ossssso+/:-        -:/+osssso+-  
 `+sso+:-`                 `.-/+oso: 
`++:.                           `-/+/
.`                                 ` 
EOF
}

usr=$(whoami)
host=$(uname -n)
os="arch linux"
ker=$(uname -r)
up=$(uptime -p)
sh=$SHELL
pkg=$(pacman -Q | wc -l)
draw=$(~/.local/bin/krita_tracker.sh)
col=$(echo -e "$(for row in {0..1}; do for col in {0..7}; do color=$((row * 8 + col)); echo -ne "\033[48;5;${color}m    \033[0m"; done; echo; done)")
art=$(print_ascii)

IFS=$'\n'

mapfile -t art_lines <<< "$art"
info_lines=(
    "$usr@$host"
    ""
    "os: $os"
    "ker: $ker"
    "up: $up"
    "sh: $sh"
    "pkg: $pkg (Pacman)"
    "draw: $draw"
    ""
    ""
    $col
)

max_width=$(printf "%s" "${art_lines[0]}" | wc -c)

for ((i=0; i<${#art_lines[@]}; i++)); do
    art_line="${art_lines[i]}"
    info_line="${info_lines[i]:-}"
    printf "%-${max_width}s %s\n" "$art_line" " $info_line"
done

echo ""
