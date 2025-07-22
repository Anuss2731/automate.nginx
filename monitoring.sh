#!/bin/bash

RED="31"
GREEN="32"
YELLOW="33"
MAGENTA="35"
GRAY="90"
WHITE="97"
ITALICRED="\e[3;${RED}m"
ITALICYELLOW="\e[3;${YELLOW}m"
ITALICWHITE="\e[3;${WHITE}m"
ITALICGREEN="\e[3;${GREEN}m"
BOLDGRAY="\e[1;${GRAY}m"
BOLDYELLOW="\e[1;${YELLOW}m"
BOLDMAGENTA="\e[1;${MAGENTA}m"
ENDCOLOR="\e[0m"


echo -e "${BOLDMAGENTA}\n---------------------------WELCOME----------------------------------\n${ENDCOLOR}"
echo -e "${BOLDYELLOW}\nHey $(whoami), Welcome to the server details corner :-)\n${ENDCOLOR}"

echo -e "${BOLDGRAY}----------------------------***----------------------------------${ENDCOLOR}"
echo -e "${ITALICWHITE}        Current date and Time is : $(date | xargs | awk '{print $3"/"$2"/"$6,$1,$4,$5}')${ENDCOLOR}"
echo -e "${BOLDGRAY}----------------------------***----------------------------------\n${ENDCOLOR}"

echo -e "${BOLDYELLOW}******************************************************************${ENDCOLOR}"
echo -e "${BOLDGRAY}Server Uptime is   : ${ENDCOLOR} ${ITALICWHITE} $(uptime) ${ENDCOLOR}"
echo -e  "${BOLDGRAY}\nLast login details :${ENDCOLOR} ${ITALICWHITE} \n$(last -a | head -5) ${ENDCOLOR}"
echo -e "${BOLDYELLOW}******************************************************************${ENDCOLOR}"

echo -e "${ITALICRED}\n###################################################################${ENDCOLOR}"
echo -e "${ITALICYELLOW}    Disk Space available :${ENDCOLOR} ${ITALICWHITE} $(df -h | xargs | awk '{print $11"/"$9}')${ENDCOLOR}"
echo -e "${BOLDGRAY}\n------------------------------------------------------------------\n${ENDCOLOR}"

echo -e "${ITALICYELLOW}    RAM utilization      :${ENDCOLOR} ${ITALICWHITE} $(free -h | xargs | awk '{print $10"/"$8}')${ENDCOLOR}"
echo -e "${ITALICRED}##################################################################${ENDCOLOR}"

echo -e "${BOLDMAGENTA}\n----------------------------***----------------------------------\n${ENDCOLOR}"
echo -e "${ITALICYELLOW}Top CPU Processes running : ${ENDCOLOR}${ITALICWHITE}"  && top -b | head -10
echo -e "${BOLDMAGENTA}\n----------------------------***---------------------------------\n${ENDCOLOR}"
