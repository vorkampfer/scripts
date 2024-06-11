#!/bin/bash

# May require to sitch to bash. Use command `bash` to get a bash shell if in zsh.
# mini port scanner by S4vitar

function ctrl_c(){
    echo -e "\n\n${redColour}[+] Exiting the port scanner...${endColour}\n"
    exit 1
}

# Ctrl+C
trap ctrl_c SIGINT

# Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

read -p $'\e[34mEnter the IP Address of the server: \e[0m: ' target


for i in $(seq 1 65535); do
	timeout 1 bash -c "(echo '' > /dev/tcp/$target/$i) &> /dev/null" && echo -e "${greenColour}[+] Port $i - OPEN ${endColour}" &
done; wait
