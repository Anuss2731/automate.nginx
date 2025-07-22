#!/bin/bash

TO="anussali29@gmail.com"

ram_space=$(free -mt | grep Total | awk '{print $4}')
mini=1000
show_space=$(free -h -mt | grep Total | awk '{print $4}')

if [[ $ram_space -lt $mini ]]
then 
	echo "WARNING ..............hello $(whoami) your RAM is low $show_space"
else
	echo "HELLO $(whoami) RAM is suufficent $show_space"
fi

echo "disk space"
disk_avaiable=$(df  | grep /dev/mapper/ubuntu--vg-ubuntu--lv | awk '{print $4}')
disk_show=$(df -h | grep /dev/mapper/ubuntu--vg-ubuntu--lv | awk '{print $4}')
total=$(df -h  | grep /dev/mapper/ubuntu--vg-ubuntu--lv | awk '{print $2}')
mini=2000
if [[ $disk_avaiable -lt $mini ]]
then 
	echo "WAENING your DISK space is FULL "
	echo "AVAIABLE SPACE $disk_show"
	echo "TOTAL DISK SPACE $total"
else
	echo "YOU HAVE $show_space disk space avaiable" | mail -s "linux DISK SPACE" $TO
        echo "TOTAL DISK SPACE $total"
       
fi

