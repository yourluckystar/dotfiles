#!/bin/bash

PASSWORDS_FILE="/mnt/usb/passwords"
KEY_FILE="/mnt/usb/passwords/key.bin"

if [ ! -f "$KEY_FILE" ]; then
    echo "Couldn't find the key.bin file"
    echo -e "\e[43mWARNING:\e[0m If this is not your first time using the script,"
    echo "It's more than likely that you already have a key.bin file,"
    echo "but the PATH is incorrect. So please update it in the script."
    echo ""
    echo "If you are new, then you are safe to create a new one .3"
    echo ""
    read -p "Do you want to create a new one? (y/N): " input

    if [[ "$input" == "y" || "$input" == "Y" ]]; then
        openssl rand -base64 32 > "$KEY_FILE"
        echo "Created key.bin file in $KEY_FILE"
    fi
fi

encrypt() {
    local data="$1"
    echo -n "$data" | openssl enc -aes-256-cbc -pbkdf2 -salt -out "$PASSWORDS_FILE/$service.enc" -pass file:"$KEY_FILE"
}

decrypt() {
    openssl enc -aes-256-cbc -pbkdf2 -d -in "$PASSWORDS_FILE/$name.enc" -pass file:"$KEY_FILE"
}

add_password() {
    read -p "Service: " service
    read -p "Email: " email
    read -s -p "Password: " password
    echo
    read -s -p "2FA secret (Optional): " secret
    echo

    info="$service $email $password $secret"
    encrypt "$info"

    echo "Saved successfully .3"
}

generate_codes() {
    current_code=$(oathtool --totp -b "$secret")
    next_code=$(oathtool --totp -N "$(date -d "@$(( $(date +%s) + 30 ))" '+%Y-%m-%d %H:%M:%S')" -b "$secret")
    echo "$current_code" "$next_code"
}

show_passwords() {
    decrypted_output=$(decrypt)

    if [ $? -eq 0 ]; then
        echo "$decrypted_output" | while IFS=' ' read -r service email password secret; do
            echo "Service: $service"
            echo "Email: $email"
            echo "Password: $password"
            if [ -n "$secret" ]; then
                while true; do
                    seconds=$(date +%S)
                    interval=$((30 - seconds % 30))

                    read current_code next_code <<< "$(generate_codes)"
                    for ((i=interval; i>0; i--)); do
                        printf "\033[1G\033[K2FA code: %s (%d) \e[2m%s (next)\e[0m " "$current_code" "$i" "$next_code"
                        sleep 1
                    done
                done
            else
                echo "2FA code: Not set"
            fi
        done
    else
        echo "Decryption failed."
    fi
}

if [ -z "$1" ]; then
    echo -e "\e[44mTIP:\e[0m To see your passwords, run the script with an argument. (./password-manager.sh <service>)"
    echo
    echo "1. Add password"
    echo "2. Exit"
    read -p "Choose an option .3: " option

    case $option in
        1) add_password ;;
        2) exit ;;
        *) echo "invalid option" ;;
    esac
else
    name="$1"
    show_passwords
fi
