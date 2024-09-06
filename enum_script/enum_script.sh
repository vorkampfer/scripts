#!/usr/bin/env bash

# USAGE: see below
# Encoding the script is recommended depending on the situation. Below are two different examples on how to encode the payload.
#  base64 -w0 /path/to/file.sh && echo

# echo /path/to/file.sh | base64 -w0 | tr -d '\n' ; echo
# echo "base64 payload" | base64 -d | bash
echo "The location of this script is" $0

function ctrl_c(){
    echo -e "\n\n${redColour}[+] You have exited the enum_script...${endColour}\n"
    exit 1
}

# Ctrl+C
trap ctrl_c SIGINT

# Global Variables
GIT=$(find / \-name \*.git 2>/dev/null | grep "git$" | tail -n 1)
WORDS=$(mount | grep ^proc)
USER1=$(whoami)
ESCAPE1=$(hostname -I 2>/dev/null | awk '{print $1}' | cut -d'.' -f1)
HIDEPID_STATUS=$(mount | grep ^proc | awk '{print $3}' FS="," | tr -d ')')
HIDEPIDSHOW=$(mount | grep ^proc | awk '{print $3}' FS="," | tr -d ')' | cut -d'=' -f1)
HOSTIP=$(ip a | grep 'inet 10' | awk '{print $2}')

# Colors
GREEN="\e[0;32m\033[1m"
NOCOLOR="\033[0m\e[0m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
CYAN="\e[0;36m\033[1m"
WHITE="\e[0;37m\033[1m"

echo -e "${PURPLE}=========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking to see if you are in a container or the actual server.${NOCOLOR}"
echo
if [[ "${ESCAPE1}" == 10 ]]; then
        echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW} $USER1 is most likely NOT in a container.${NOCOLOR}"
else
        echo -e "${RED}==>[!]${NOCOLOR} ${YELLOW} $USER1 is likely in a container and will need to escape.${NOCOLOR}"
fi
wait
echo -e "${YELLOW}ᐅ${NOCOLOR} hostname -I"
if [[ -f "/usr/bin/hostname" ]] || [[ -f "/bin/hostname" ]]; then
        hostname -I | awk '{print $1}' 2>/dev/null || ifconfig | grep "inet 10" | awk '{print $2}' FS=" " 2>/dev/null || ip a | grep 'inet 10' | awk '{print $2}'
        echo 
else 
        echo 
        echo -e "${RED}==>[!]${NOCOLOR} ${YELLOW}Sorry, /usr/bin/hostname is not installed on this machine.${NOCOLOR}"
        echo -e "${YELLOW}ᐅ${NOCOLOR} ip a | grep 'inet 10'"
        ip a | grep 'inet 10' | awk '{print $2}' 2>/dev/null
        echo 
        case "$HOSTIP" in 
                *10*)
                echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE} $USER1 is most likely not in a container ${NOCOLOR}"
                ;;
                *)
                echo -e "${RED}==>[-]${NOCOLOR} ${YELLOW} $USER1 is most likely in a container  and will need to escape.${NOCOLOR}"
                ;;
        esac
fi 
wait
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /proc/net/fib_trie"
cat /proc/net/fib_trie | grep "host LOCAL" -B 1 | grep -oP '\d{1,3}\.\d{1,3}.\d{1,3}.\d{1,3}'
wait
echo
echo -e "${PURPLE}=========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about host machine:${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE}hostname information${NOCOLOR}"
hostnamectl 2>/dev/null || lscpu 2>/dev/null | grep -v "Flags"
wait 
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE} Current user:${NOCOLOR} $(id)" | fold
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the OS: ${NOCOLOR}"
uname -srm
cat /etc/os-release
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking which users have a home directory.${NOCOLOR}"
ls -lahr /home | fold
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${YELLOW}Running mount to see if $USER1 is allowed to see root processes:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} mount | grep ^proc"
#mount | grep ^proc
case "$WORDS" in 
  *hidepid*)
    echo -e "${RED}==>[-]${NOCOLOR} ${YELLOW} $USER1 can NOT view root processes ${NOCOLOR}"
    ;;
    *)
    echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE} $USER1 can view root processes ${NOCOLOR}"
    ;;
esac
echo 
echo -e "${PURPLE}=========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the running processes for${NOCOLOR} ${RED}root${NOCOLOR} ${YELLOW}only:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} ps -faux | grep '^root' "
ps -faux | grep "^root" | awk 'length>40' | sed -r '/^.{,30}$/d' | grep -vE "procmon|kworker|0.0  0.0      0     0 ?|defunct"
wait
echo
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the running processes:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} ps -eo user,command"
ps -eo user,command | grep -vE "command|procmon|kworker|defunct" | awk 'length>85' | sort -u
wait
echo
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the running processes:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} ps aux --sort user"
ps aux --sort user | awk '{print $1,$2,$11}' FS=" " | grep -vE "command|procmon|kworker|0.0      0     0 ?|defunct" | awk 'length>40'
wait
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Runnig ps -ef --forest command on one line grepping for anything larger than 80 characters${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} ps -ef --forest | less -S"
ps -ef --forest | less -S | awk 'length>80'
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking for cronjobs${NOCOLOR}"
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /etc/crontab"
cat /etc/crontab
wait
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} systemctl list-timers"
systemctl list-timers
wait
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the tcp/udp sockets:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} ss --tcp -anp"
ss --tcp -anp | grep -v "TIME-WAIT" | awk '{print $1,$4,$5,$6}' FS=" " | column -t -s' '
wait
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} netstat -nat"
netstat -nat
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about any open ports from${NOCOLOR} ${RED}/proc/net/tcp${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /proc/net/tcp"
if [ -f "/proc/net/tcp" ]; then
        echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW} Here are the hex encoded ports from the file${NOCOLOR} '/proc/net/tcp' "
        cat /proc/net/tcp | awk -F":" '{print $3}' | cut -d' ' -f1 | awk '!($3="")' | sed '/^[[:space:]]*$/d' | sort -u
        wait
        echo
        echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Decoding the HEX ports: ${NOCOLOR}"
        #for port in $(cat /proc/net/tcp | awk '{print $2}' | grep -v local | awk '{print $2}' FS=":" | sort -u); do echo "[+] Port $port ==> $(echo "obase=10; ibase=16; $port" | bc)"; done
        for port in $(cat /proc/net/tcp | awk '{print $2}' | grep -v address | awk '{print $2}' FS=":" | sort -u); do echo "[+] Port $port ==> $((16#$port))"; done
else
        echo -e "${RED}==>[*] ERROR:${NOCOLOR} ${YELLOW} File not found:${NOCOLOR} '/proc/net/tcp' "
fi
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking who has bash access.${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /etc/passwd | grep 'sh$'"
cat /etc/passwd | grep -i --color=never "sh$"
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Getting info about the files owned by root with SUID permission enabled:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find / -perm -4000 -user root -ls 2>/dev/null"
/usr/bin/find / -perm -4000 -user root -ls 2>/dev/null
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Looking up linux capabilities:${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} getcap -r / 2>/dev/null"
getcap -r / 2>/dev/null
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Finding executable files for $USER1. Nothing will be displayed unless it is also owned by root ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find / -executable -user $USER1 2>/dev/null"
find /opt -executable -user $USER1 2>/dev/null | awk '{print $5,$6,$11}' FS=" " | grep "^root"
wait
find /var/www/html -user $USER1 -executable -ls 2>/dev/null | awk '{print $5,$6,$11}' FS=" " | grep "^root"
wait
find /home -executable -user $USER1 -ls 2>/dev/null | awk '{print $5,$6,$11}' FS=" " | grep "^root"
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking what files are writable by $USER1 ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find / -group $USER1 -writable -ls 2>/dev/null"
find / -group $USER1 -writable -ls 2>/dev/null | awk 'length>20' | grep -vE "var|sys|proc|home|run"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking what groups $USER1 belongs to ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /etc/group | grep $USER1"
cat /etc/group | grep $USER1
wait
echo -e "${YELLOW}ᐅ${NOCOLOR} groups $USER1"
groups $USER1
wait
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Checking what files and directories $USER1 group/user can write to ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find / -group $USER1 -writable -ls 2>/dev/null | grep -v '/proc\|/run\|/sys\|/home'"
find / -group $USER1 -writable -ls 2>/dev/null | awk '{print $5,$6,$11}' FS=" " | grep "^root"
wait
echo
find / -user $USER1 -writable -ls 2>/dev/null | awk '{print $5,$6,$11}' FS=" " | grep "^root"
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Looking for World Writable directories. Directories anyone can write to. ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find / -maxdepth 3 -type d -perm -777 2>/dev/null"
find / -maxdepth 3 -type d -perm -777 2>/dev/null
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Looking for writable files or directories in '/opt' for $USER1 ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} find /opt -writable"
find /opt -writable
wait
#find /opt -type f -user root -perm -002 2>/dev/null
wait
#find /opt -type f -user $USER1 -perm -002 2>/dev/null
wait
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Password Hunting for configs, databases, passwords in memory, .php, .git files etc....${NOCOLOR}"
echo 
find / \-name \*.git 2>/dev/null | grep --color=always "git$"
wait
echo 
case "$GIT" in 
  *.git*)
    echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE} A .git directory was found. Sometimes the .config file in the .git directory will contain a password.${NOCOLOR}"
    ;;
    *)
    echo ""
    ;;
esac
wait 
echo
cat /home/$USER1/.bash_history | grep -iE --color "passwd|admin|token|secret|auth|sshpass"
wait
#find /var/www \-name \*.php\* 2>/dev/null
#find /var/www/html \-name \*.php\* 2>/dev/null
#find /var/www \-name \*.config\* 2>/dev/null
#find /var/www/html \-name \*.config\* 2>/dev/null
echo
cat /var/www/config.php 2>/dev/null | grep -iE "passw|user" -C2
wait
echo
cat /var/www/wp-config.php 2>/dev/null | grep -iE "passw|user" -C2
wait
echo
cat /var/www/html/wp-config.php 2>/dev/null | grep -iE "passw|user" -C2
wait
echo
timeout --verbose 10s strings /dev/mem -n10 | grep -i --color “PASSWD”
wait
echo
find /var \-name \*.db\* 2>/dev/null
wait
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Password Hunting for configs, databases, passwords in memory, grepping .php files etc....${NOCOLOR}"
echo
find /home -maxdepth 3 -type f -perm -600 2>/dev/null
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Attempting to view the .ssh keys files${NOCOLOR}"
echo
ls -l /home/$USER1/.ssh/id_rsa
if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}==>[+]${NOCOLOR} You can ssh as $USER1 if you want"
        if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
                echo "Never mind you are already in an SESSION_TYPE=remote/ssh"
        else
                echo "You are currently not in an SSH session"
        fi
else
        echo -e ""
fi
wait
echo
cat /root/.ssh/id_rsa 2>/dev/null
wait
echo
cat /root/.ssh/authorized_keys
if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}==>[+]${NOCOLOR} You can view the root authorized_keys file. See if you can inject your public key into it to ssh as root."
else
        echo -e ""
fi
wait
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW}Looking for any files in /home with 600 permissions.${NOCOLOR}"
find /home -type f -perm u=rw,g=,o= 2>/dev/null
wait
echo
echo
#find /root/.ssh -type f -perm u=rw,g=,o= 2>/dev/null
wait
echo
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${GREEN}==>[+]${NOCOLOR} ${YELLOW} Listing all the files of interest in '/opt' for $USER1. Some files/directories may no be viewable by $USER1. ${NOCOLOR}"
echo -e "${YELLOW}ᐅ${NOCOLOR} tree -fas /opt"
if [[ -f "/usr/bin/tree" ]]; then
        tree -fas /opt | grep -iE "\.sh|\.py|\.js|\.yml"
else
        echo -e "${RED}==>[!]ERROR:${NOCOLOR} ${YELLOW}The 'tree' command is not installed on this machine.${NOCOLOR}"
fi 
wait
#tree -fas -L 3 /opt
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} ls -la /opt/scripts"
ls -lahr /opt/scripts 2>/dev/null
wait
echo -e "${PURPLE}==========================================================================================${NOCOLOR}"
echo
echo -e "${YELLOW}ᐅ${NOCOLOR} cat /etc/apache2/sites-enabled/*.conf"
ls /etc/apache2/sites-enabled/*.conf
if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}==>[+]${NOCOLOR} ${BLUE}The 'sites-enable' config file was detected. It is a good idea to give this file a glance.${NOCOLOR}"
        cat /etc/apache2/sites-enabled/*.conf | grep -iE --color=always "auth|token|admin|passw|\.htb|\.local|\.com"
else
        echo -e ""
fi
wait
echo
find / \-name \*apache2.conf\* 2>/dev/null
wait 
echo 
echo -e "${WHITE}Goodbye!${NOCOLOR}"
