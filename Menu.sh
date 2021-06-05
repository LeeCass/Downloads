#!/bin/bash  


x=0
while [ $x = 0 ]
do
echo "-----------------------------Menu---------------------------"
echo -e "\n"
echo "1) Display information about the CPUs."
echo -e "\n"
echo "2) Display a list of device drivers configured into the currently
running kernel."
echo -e "\n"
echo "3) Display the load average of the system.  "
echo -e "\n"
echo "4) Display the PID and PPID of a process that is running on the
server."
echo -e "\n"
echo "5) Exit."
echo -e "\n"
echo "please enter an option" 
read answer #reads users input



case "$answer" in
        1)
        cat /proc/cpuinfo #displays the cpuinfo
        ;;
        2)
        cat /proc/devices # displays the devices on the system
        ;;
        3)
         uptime #sows the average load on the system
        ;;
        4)
        ps -o pid,ppid # processes running
        ;;
        5)
        x=1 #exits
        ;;
        *)
        echo "this is not an option, Please enter between 1-5"
        sleep 3
        ;;
esac
done
