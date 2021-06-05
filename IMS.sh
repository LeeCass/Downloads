#!/bin/bash

x=0
while [ $x = 0 ]
do
echo -e "\n"
echo "-----------------------------Menu---------------------------"
echo -e "\n""1) Change Interface"
echo "2) Restart Interface"
echo "3) CSF Install"
echo "4) CPanel install"
echo "5) Zabbix Install"
echo "6) JetApps Install"
echo "7) Change root password"
echo "8) Cron jobs"
echo "11) System Update/Upgrade"
echo "12) Exit."
echo -e "\n""Please enter an option: "
read answer #reads users input


case "$answer" in
        1)      echo -e "\n""-----Configuring Interfaces------"
                #Set the filename
                intpath='test-'
                echo -e "\n" 'What Interface are you changing: ens,eth?'
                read name0

                filename="${intpath}${name0}"
                # Create an empty file
                touch $filename
                # Check the file is exists or not
                if [ -f $filename ]; then
                        rm  $filename
                        echo "$filename is removed"
                fi

                #INET
                INET='INET='
                echo 'INET=STATIC' >> $filename

                #IP Address
                IP='IPADDR='
                echo "Enter IP Address"  "(""$IP"")"
                read name
                IP1="${IP}${name}"
                echo -e "\n"
				
				
                #NETMASK
                NET='NETMASK='
                echo "Enter NetMask" "(""$NET" ")"
                read name1
                NET1="${NET}${name1}"
                echo -e "\n"

                #GATEWAY
                GW='GATEWAY='
                echo  'Enter Gateway Address' "(""$GW"")"
                read name2
                GW1="${GW}${name2}"
                echo -e "\n"

                #Confirmation of  Input
                echo -e "${GW1}""\n""${NET1}""\n""${IP1}"
                echo -e "\n"
                read -p "Are these Correct (y/n)?" choice
                if [ "$choice" = "y" ]; then
                  echo -e "${GW1}""\n""${NET1}""\n""${IP1}" >> $filename;
                else
                        echo -e "\n"
                        echo "Exiting menu, please redo";
                x=1;
                fi



                #DNS RESOLVERS
                DNS1="DNS1=99.25.89.54"
                DNS2="DNS2=99.25.00.00"
                NM='NM_CONTROLLER=no'
                echo -e "$NM""\n""$DNS1""\n""$DNS2" >> $filename

                echo -e "\n"
                cat $filename
                ;;
        2)

                sudo systemctl restart network # restart network
                ;;
        3)
                cd /usr/src
                wget https://download.configserver.com/csf.tgz
                sudo tar -xzf csf.tgz
                cd csf

        4)
                sudp apt install perl
                hostname server.server.com
                cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
                ;;
        5)
                ;;
        6)
                ;;

        7)      passwd root
                sleep 3
                echo "root Password has been changed, Please keep a copy of the password"
                ;;
        8)
                nano crontab -e
                ;;

        11)

                sudo apt update
                sudo apt upgrade
                ;;
        12)
        x=1 #exits
        ;;
        *)
        echo "this is not an option, Please enter between 1-12"
        sleep 3
        ;;
esac
done