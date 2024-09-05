#!/usr/bin/env bash

# The is an automation script for the BlackArch platform only for basic HTB connectivity and status information.
# You are welcome to modify this script for Debian/Ubuntu based systems.
# For a soft exit of OpenVPN do the following:
# Type: Ctrl + c if that does not work then do sudo killall openvpn
# To create the openvpn.log simply append | tee -a openvpn.log
# to your openvpn command when you connect to a server
# or you can use the options in 'openvpn --help'
# --status : Cat out the operational status . <<< I like this one becaus it just gives you the status, but it requires you to be running openvpn.log


function ctrl_c(){
    echo -e "\n\n${redColour}[+] You have exited the HTB script...${endColour}\n"
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


if [ -z "$1" ]; then
    /usr/bin/python2.7 $HOME/python_projects/color_banner_htb_status.py
    echo "Usage: ./htb.sh <argument>"
    echo "Arguments: status|--status|-s ::Shows your connection status"
    echo "Arguments: [--start-logging] [path/to/.ovpn] [/path/to/openvpn.log] ::Start Openvpn with logging feature"
    echo "Example: ./htb.sh --start-logging user.ovpn"
    echo "Arguments: start user.ovpn"
    echo "Example: ./htb.sh start ::Same command to start OpenVPN connection except without logging feature for status querries"
    echo "Arguments: --set <ip> <hostname> ... ::Allows you to change your hostname without having to open up the editor."
    echo "Example: ./htb.sh '10.10.x.x' worldbank.megacorp.local megahosting.htb megacorp.local"
    echo "Arguments: --set-verbose <ip> <hostname> ...::Same command as inserting htb hostname, except it is verbose"
    echo "Arguments: --kill|--kill-all|-k, ::Runs the killall command on OpenVpn"
    echo "Arguments: --reset|-reset ::This argument kills your OpenVPN connection, gives you a new IP and MAC number for your machine."
    echo "Arguments: --reset-all ::This command does several things to the box and is recommened only if you continue having issues with openvpn."
    echo -e "${redColour}[!] Warning:${endColour} ${yellowColour}The --reset-all flag deletes OpenVPN completely from your system including configs then purges the system of OpenVPN.${endColour}"
    echo "Lastly, it re-installs OpenVPN and OpenVPN-NetworkManager"
    echo "======================================================================================================="
    echo "Example of starting OpenVPN with logging feature."
    echo "ᐅ htb_status.sh --start-logging user.ovpn openvpn.log"
    echo "[sudo] password for h@x0r:"
    echo "==> [!] Starting OpenVPN with logging. Log is located in: openvpn.log"
    exit 1
elif [[ $1 == @(-h|--help) ]]; then
    echo "Usage: ./htb.sh <argument>"
    echo "Arguments: status|--status|-s ::Shows your connection status"
    echo "Arguments: [--start-logging] [path/to/.ovpn] [/path/to/openvpn.log] ::Start Openvpn with logging feature"
    echo "Example: ./htb.sh --start-logging user.ovpn"
    echo "Arguments: start user.ovpn"
    echo "Example: ./htb.sh start ::Same command to start OpenVPN connection except without logging feature for status querries"
    echo "Arguments: --set <ip> <hostname> ... ::Allows you to change your hostname without having to open up the editor."
    echo "Example: ./htb.sh '10.10.x.x' worldbank.megacorp.local megahosting.htb megacorp.local"
    echo "Arguments: --set-verbose <ip> <hostname> ...::Same command as inserting htb hostname, except it is verbose"
    echo "Arguments: --kill|--kill-all|-k, ::Runs the killall command on OpenVpn"
    echo "Arguments: --reset|-reset ::This argument kills your OpenVPN connection, gives you a new IP and MAC number for your machine."
    echo "Arguments: --reset-all ::This command does several things to the box and is recommened only if you continue having issues with openvpn."
    echo -e "${redColour}[!] Warning:${endColour} ${yellowColour}The --reset-all flag deletes OpenVPN completely from your system including configs then purges the system of OpenVPN.${endColour}"
    echo "Lastly, it re-installs OpenVPN and OpenVPN-NetworkManager"
    echo "======================================================================================================="
    echo "Example of starting OpenVPN with logging feature."
    echo "ᐅ htb_status.sh --start-logging user.ovpn openvpn.log"
    echo "[sudo] password for h@x0r:"
    echo "==> [!] Starting OpenVPN with logging. Log is located in: openvpn.log"
fi

# Global Variables
statusOPENVPN=$(ps auxww | grep openvpn | awk '{print $11,$12}' | awk 'NR==1{print $1,$2}')            # Is the sudo openvpn command executed?
OVPNpid=$(sudo netstat -nutlp | grep -i openvpn | awk '{print $1}' FS=/ | awk 'NF{print $NF}' FS=" ")  # OpenVPN PID number
OVPNup=$(cat $HOME/haCk54CrAcK/openvpn.log | grep "Initialization Sequence Completed" | tail -n 1 | awk '{print $3,$4,$5}') # equals 'Initialization Sequence Completed'
OVPNdown3=$(cat $HOME/haCk54CrAcK/openvpn.log | grep --color=never "Cannot resolve host address" | tail -n 1 | awk '{print $4,$5,$6,$7}' | tr -d ':') # equals 'Cannot resolve host address'
OVPNdown2=$(cat $HOME/haCk54CrAcK/openvpn.log | grep --color=never "Network unreachable, restarting" | tail -n 1 | tr -d ',' | awk '{print $3,$4}') # equals 'Network unreachable'
OVPNdown1=$(cat $HOME/haCk54CrAcK/openvpn.log | grep --color=never "Inactivity timeout" | awk '{print $4,$5}' | tail -n 1) # equals 'Inactivity timeout'
tun0ip=$(ifconfig | grep 'inet 10' | awk '{print $2}')
boxIP=$(cat /etc/hosts | grep '^10') # shows HTB target box IP plus the hostname
boxIPclean=$(cat /etc/hosts | grep '^10' | cut -d' ' -f1) # shows only the HTB target server IP
checknet192=$(ifconfig | grep "inet 192" | awk '{print $2}' FS=" " | cut -d '.' -f1)
checknet172=$(ifconfig | grep "inet 172" | awk '{print $2}' FS=" " | cut -d '.' -f1)
checknet10=$(ifconfig | grep "inet 10" | awk '{print $2}' FS=" " | cut -d '.' -f1)
IP192=$(ifconfig | grep "inet 192" | awk '{print $2}' FS=" ")
IP172=$(ifconfig | grep "inet 172" | awk '{print $2}' FS=" ")
IP10=$(ifconfig | grep "inet 10" | awk '{print $2}' FS=" ")
# Global variables for --reset, and --reset-all command
rIP=$(shuf -n 1 /$HOME/Videos/.vid80s8098d09/DO_NOT_DELETE_83409802/rand_iplist/ipaddresses.txt | head -1 | awk '!($3="")' | sed '/^[[:space:]]*$/d' | sed 's/ //g')
varIP=$(ifconfig | grep 'inet 192' | awk '{print $2}')


if [[ "$1" == @(--status|status|-s) ]]; then
    echo ""
    if [[ "${OVPNdown2}" == "Network unreachable" ]] || [[ "${OVPNdown3}" == "Cannot resolve host address" ]]; then
        echo -e "${redColour}[!]${endColour} ${yellowColour} OpenVPN network issue detected:${endColour}"
        cd $HOME
        find . -name "openvpn.log" -exec cat openvpn.log 2> /dev/null {} \; | grep --color=never "Inactivity timeout" | tail -n 1                          # Change Log path
        find . -name "openvpn.log" -exec cat openvpn.log 2> /dev/null {} \; | grep --color=never "Cannot resolve host address" | tail -n 1                 # Change Log path
        find . -name "openvpn.log" -exec cat openvpn.log 2> /dev/null {} \; | grep --color=never "Network unreachable, restarting" | tail -n 1             # Change Log path
        echo
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} Your Tun0 ip is:${endColour} NULL"
        echo
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} The${endColour} ${greenColour}HackTheBox${endColour} ${blueColour}server IP is:${endColour}" $boxIP
    else
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} OpenVPN is up and running. ${endColour}"
        cd $HOME
        wait
        find . -name "openvpn.log" -exec cat openvpn.log 2> /dev/null {} \; | grep "Initialization Sequence Completed" | tail -n 1
        echo
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} The PID number for OpenVPN is:${endColour}" $OVPNpid
        echo
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} Your Tun0 ip is:${endColour}" $tun0ip
        echo
        echo -e "${greenColour}==>[+]${endColour} ${blueColour} The HackTheBox server IP is:${endColour}" $boxIP
        echo
        ping -c 1 $boxIPclean | sed 's/PING/\=\=\>\[\+\] PING/'
        wait
        echo
        $HOME/bashscripting/whichsystem.py $boxIPclean
    fi
elif [[ "$1" == @(--start-logging) ]]; then
        rm -rf $3
        wait
        #read -p $'\e[34mPlease enter the filename of your .ovpn file that you will use to connect to HTB:\e[0m' OVPNFILE
        #read -p $'\e[34mPlease enter the path to where you want to write the openvpn.log file to:\e[0m' LOClogger
        #read -p $'\e[34mPlease enter the filename of your '.ovpn' file that you will use to connect to HTB:\e[0m' OVPNFILE
        # Option to implement in future would be for the read input to ask for alternative path for log file otherwise type no or hit enter
        # Need to learn to better use OpenVPN and learn its real logging capabilities and location of logs.
        echo -e "${redColour}==> [!]${endColour} ${yellowColour}Starting OpenVPN with logging. Log is located in:${endColour}" $3
        sudo openvpn --config $2 | tee -a $3
        wait
        sleep 1
        sudo netstat -nutlp | grep -i openvpn > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo -e "${greenColour}==> [+]${endColour} ${blueColour}OpenVPN tunnel with logging has started successfully${endColour}"
                #cat $HOME/haCk54CrAcK/openvpn.log | grep --color=never "Initialization Sequence Completed" | tail -n 1
            else
                echo -e "${redColour}==> [!] Exiting:${endColour} ${yellowColour} The OpenVPN logger has been terminated.${endColour}"
                exit 1
            fi
elif [[ $1 == @(start) ]]; then
        rm -rf $3
        wait
        echo -e "${greenColour}==> [+]${endColour} ${blueColour}Starting OpenVPN without logging. Log is located in: ${endColour}" $3
        sudo openvpn --config $2
        sudo netstat -nutlp | grep -i openvpn > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo -e "${greenColour}==> [+]${endColour} ${blueColour}OpenVPN tunnel started with no logging${endColour}"
                echo -e "${yellow}Warning! Logging is necessary for status inquiries${endColour}"
            else
                echo -e "${redColour}==> [!] ERROR:${endColour} ${yellowColour} OpenVPN did not start${endColour}"
                exit 1
            fi
elif [[ $1 == @(--kill|--kill-all|-k) ]]; then
        echo -e "${redColour}==> [!]${endColour} ${yellowColour}Sending SIGTERM command to OpenVPN.${endColour}"
        sudo killall openvpn
        wait
        sudo netstat -nutlp | grep -i openvpn > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo ""
            else
                echo -e "${redColour}==> [+]${endColour} ${yellowColour} OpenVPN is stopped. ${endColour}"
                exit 1
            fi
elif [[ $1 == @(--set) ]]; then
        sudo sed -i "s/^10.*/${2} ${3} ${4} ${5} ${6} ${7}/g" /etc/hosts
        if [[ $? -eq 0 ]]; then
            echo
            sleep 1
            cat /etc/hosts | grep --color=never ^10
        else
            echo -e "${redColour}==> [-]${endColour} ${yellowColour} Hostname could NOT be injected.${endColour}"
            exit 1
        fi
elif [[ $1 == @(--set-verbose) ]]; then
        sudo sed -i "s/^10.*/${2} ${3} ${4} ${5} ${6} ${7}/g" /etc/hosts
        if [[ $? -eq 0 ]]; then
            echo -e "${greenColour}==> [+]${endColour} ${blueColour} Hostname successfully injected! ${endColour}"
            echo
            sleep 1
            cat /etc/hosts | grep --color=never ^10
            echo
            echo
            head -n 10 /etc/hosts | bat -l QML --paging=never -p
        else
            echo -e "${redColour}==> [-]${endColour} ${yellowColour} Hostname could NOT be injected.${endColour}"
            exit 1
        fi
elif [[ $1 == @(reset|--reset|-reset|-r|--reset-all) ]]; then
        echo -e "${redColour}==> [!]${endColour} ${yellowColour}Sending SIGTERM command to OpenVPN.${endColour}"
        sudo killall openvpn
        wait
        sudo netstat -nutlp | grep -i openvpn > /dev/null 2>$1
        if [[ $? -eq 0 ]]; then
            echo ""
        else
            echo -e "${redColour}==> [+]${endColour} ${yellowColour} OpenVPN is stopped. ${endColour}"
            exit 1
        fi
        wait
        sleep 2
        echo
        if [[ -f "/usr/bin/nmcli" ]]; then
            echo -e "${greenColour}==> [+]${endColour} ${cyanColour}Changing ethernet IP address to a random ip. ${endColour}"
            echo -e "${greenColour}==> [+]${endColour} ${cyanColour}The current IP is:${endColour}" $varIP
            echo
            nmcli connection modify "Wired\\ connection\\ 1" ipv4.method manual ipv4.address $rIP/24 ipv4.gateway 192.168.8.1 ipv4.dns 192.168.8.1
            wait
            sleep 2
            nmcli connection down "Wired\\ connection\\ 1" > /dev/null 2>&1
            wait
            sleep 1
            nmcli connection up "Wired\\ connection\\ 1"
            wait
            sleep 1
            nmcli --fields UUID,TIMESTAMP-REAL con show | grep never |  awk '{print $1}' | while read line; do nmcli con delete uuid  $line; done
            wait
            echo -e "${greenColour}==> [+]${endColour} ${cyanColour}SUCCESS, the ip has been changed, and obsolete connections have been deleted! ${endColour}"
            echo
            wait
            sleep 2
            echo
            newIP=$(ifconfig | grep 'inet 192' | awk '{print $2}')
            echo -e "${greenColour}==> [+]${endColour} ${cyanColour}Your new IP is:${endColour}" $newIP
        else
            echo "${redColour}[!] ERROR!:${endColour} ${yellowColour}Please install nmcli to run this script.${endColour} ${redColour}Quitting!${endColour}"
            exit 1
        fi
            wait
            sleep 3
            source $HOME/bashscripting/changeMac.sh
            wait
else
    echo "Not a valid argument. Type --help for usage."
    exit 1
fi
echo
echo -e "${yellowColour}Done! ${endColour}"
