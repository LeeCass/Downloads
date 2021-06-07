!/bin/bash

x=0
while [ $x = 0 ]
do
echo -e "\n"
echo "--------Menu--------"
echo -e "\n""1) Change Interface"
echo "2) Restart Interface"
echo "3) CSF Install"
echo "4) CPanel Install"
echo "5) Zabbix Install"
echo "6) Raid Monitoring"
echo "7) Change root password"
echo "8) Cron jobs"
echo "9) "
echo "11) System Update/Upgrade"
echo "12) Exit."
echo "13) Clean up"
echo -e "\n""Please enter an option: "
read answer #reads users input
clear -x

case "$answer" in
        1)      echo -e "\n""-----Configuring Interfaces------"
                #Set the filename
                intpath='test-'
                echo -e "\n"'What Interface are you changing: ens,eth?'
                read name0
                clear -x

                filename="${intpath}${name0}"
                # Create an empty file
                touch $filename
                # Check the file is exists or not
                if [ -f $filename ]; then
                        rm  $filename
                        echo "$filename is removed"
                fi
                clear -x

                #INET
                INET='INET='
                echo 'INET=STATIC' >> $filename

                #IP Address
                IP='IPADDR='
                echo "Enter IP Address"  "(""$IP"")"
				
				  #NETMASK
                NET='NETMASK='
                echo "Enter NetMask" "(""$NET"")"
                read name1
                NET1="${NET}${name1}"
                echo -e "\n"
                clear -x

                #GATEWAY
                GW='GATEWAY='
                echo  'Enter Gateway Address' "(""$GW"")"
                read name2
                GW1="${GW}${name2}"
                echo -e "\n"
                clear -x

                #Confirmation of  Input
                echo -e "${GW1}""\n""${NET1}""\n""${IP1}"
                echo -e "\n"
                read -p "Are these Correct (y/n)?" choice
                if [ "$choice" = "y" ]; then
                  echo -e "${GW1}""\n""${NET1}""\n""${IP1}" >> $filename;
                else
                        echo -e "\n"
                        echo "Exiting menu, Please redo the network configurtion";
                break
                fi



                #DNS RESOLVERS
                DNS1="DNS1=99.25.89.54"
                DNS2="DNS2=99.25.00.00"
                NM='NM_CONTROLLER=no'
                echo -e "$NM""\n""$DNS1""\n""$DNS2" >> $filename

                echo -e "\n"
                echeo "Current file configuation"
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
                sh install.sh
                sed -i "s/TESTING = "1"/TESTING = "0"/g" /etc/csf/csf.conf
                ;;

        4)
                sudo apt install perl
                hostname server.server.com
                cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
                ;;
        5)
                while [ $x = 0 ]
                do
                echo -e "\n"
                echo "---Test Menu---"
                echo "Download and run the following script. This must be done **after** installing cPanel and CSF:"
                echo -e "\n""1) cPanel Servers"
                echo "2) Plain Linux Servers"
                echo "3) RHEL 8"
                echo "4) Load Balanced Servers"
                echo "5) OnApp controllers"
                echo "6) Remove Zabbix agent from the server"
                echo "7) Exit"
                echo -e "\n" "Information found at: http://wiki.ukservers.com/index.php/Zabbix"
                echo -e "\n""Please enter an option: "
                read choice #reads users input
                clear -x

                case "$choice" in

                1) 
                wget http://mirror.cov.ukservers.com/managed/zabbix-cpanel.sh
                sh zabbix-cpanel.sh

                ;;
                2) 
                wget http://mirror.cov.ukservers.com/managed/zabbix-linux.sh
                sh zabbix-linux.sh
                ;;
                3) 
                dnf install zabbix-agent
                systemctl enable zabbix-agent
                systemctl start zabbix-agent
                wget https://raw.githubusercontent.com/LeeCass/Downloads/main/zabbix-cpanel-NOAGENT!.sh
                sh zabbix-cpanel-NOAGENT!.sh
                ;;
				4)
                        while [ $x = 0 ]
                        do
                        echo -e "\n"
                        echo "---Test Menu---"
                        echo "Download and run the following script. This must be done **after** installing cPanel and CSF:"
                        echo -e "\n""1) Load Balancer(s)"
                        echo "2) DB Server(s)"
                        echo "3) Web Server(s) "
                        echo "4) Exit"
                        echo -e "\n""Please enter an option: "
                        read choice #reads users input
                        clear -x

                        case "$choice" in
                        1) #Load balancer
                        wget http://mirror.cov.ukservers.com/managed/zabbix-cpanel.sh
                        sh zabbix-cpanel.sh

                        ;;
                        2) #DBServers
                        wget http://mirror.cov.ukservers.com/managed/zabbix-linux.sh
                        sh zabbix-linux.sh
                        ;;

                        3) #Webservers
                        wget http://mirror.cov.ukservers.com/managed/zabbix-lb-web.sh
                        sh zabbix-lb-web.sh                        

                        ;;
                        4) 
                        break
                  
                        ;;
                5)
                wget http://mirror.cov.ukservers.com/managed/zabbix-onapp.sh
                sh zabbix-onapp.sh
                ;;

                6)
                yum remove zabbix-agent
                rm -rf /etc/zabbix/ /usr/local/zabbix/
                ;;               
                7) #exits
                break
                ;;


                esac
                done
                ;;
        6)          while [ $x = 0 ]
                        do
                        echo -e "\n"
                        echo "---Test Menu---"
                        echo "This document is to assist with setting up RAID Monitoring on Adaptec 6405 and 8405 RAID Controllers. This is required for all customers with Level 3 Management and can be useful for all customers to assist with server issues."
                        echo -e "\n""Installing RAID Monitoring on CentOS"
                        echo "2) DB Server(s)"
                        echo "3) Web Server(s) "
                        echo "4) Monitoring Alerts on Linux Servers"
                        echo "5) Exit"
                        echo -e "\n""Please enter an option: "
                        read choice #reads users input
                        clear -x

                        case "$choice" in
                        
                        1) #CentOS RAID Monitoring
                        cd /
                        wget http://download.adaptec.com/raid/storage_manager/arcconf_v3_00_23484.zip
                        unzip arcconf_v3_00_23484.zip
                        chmod +x linux_x64/cmdline/arcconf
                        cp linux_x64/cmdline/arcconf /usr/sbin/arcconf
                        /usr/sbin/arcconf getconfig 1
                        ;;

                        2) #Ubuntu RAID Monitoring
                        echo "Working Progress"
                        ;;

                        3) # VMWare ESXI RAID Monitoring          
                        df -l
                        cd /vmfs/volumes/datastore1 && mkdir raid && cd raid
                        wget http://download.adaptec.com/raid/storage_manager/arcconf_v1_1_20324.zip
                        unzip arcconf_v1_1_20324.zip
                        chmod +x linux_x64/arcconf
                        cp linux_x64/arcconf /usr/sbin/arcconf
                        rm -rf /vmfs/volumes/datastore1/raid/*
                        /usr/sbin/arcconf getconfig 1

                        echo -e "\n" "Create script file"
                        RS1=raid-monitoring.sh
                        ServerID=SID
                        touch RS1
                        echo -e "What is the server_id?"
                        read SID
                    
                        vi /vmfs/volumes/datastore1/raid/$RS1 
                        echo "  server_id="${SID}"
                                logical_status=$(/usr/sbin/arcconf getconfig 1 | grep "Status of logical device" | awk '{print $NF}')
                                TESTING="false"

                                while getopts ':t' option
                                    do
                                         case "${option}" in
                                                 t) TESTING="true";;
                                         esac
                                    done

                                if [ $TESTING == "true" ]
                                       then
                                               logical_status="error"
                                fi

                                if [ $logical_status == "Optimal" ]
                                       then
                                               echo "OK - logical device is optimal."; exit 0
                                       else
                                               wget -s http://control.ukservers.com/raid-api.php?server_id=$server_id; exit 1
                                fi





	                        " >> $RS1
	                    clear -x
	                    chmod +x /vmfs/volumes/datastore1/raid/$RS1
	                    echo "Script is now executable"
	                    echo -e "\n"
	                    read -p "To test script confirm with y" choice
	                    if [ "$choice" = "y" ]; then
	                            /vmfs/volumes/datastore1/raid/$RS1 -t
	                    break
	                    read -p "Checking for Error: Type y to continue" choice
	                    if [ "$choice" = "y" ]; then
	                           /vmfs/volumes/datastore1/raid/$RS1 
	                    break

	                    clear -x
	                    echo "Add script to crontab: 0 * * * * /vmfs/volumes/datastore1/raid/raid-monitoring.sh"
	                    read -p "Open Crantab confirm with y" choice
	                    if [ "$choice" = "y" ]; then
	                         nano  /var/spool/cron/crontabs/root
	                    break

	                    clear -x
	                    echo "Make sure to do the following for the cron entry to survive a reboot "
	                    echo "Add lines below to /etc/rc.local.d/local.sh (before last line 'exit 0')"
	                    echo ""
	                    echo "/bin/kill $(cat /var/run/crond.pid)
	                              /bin/echo '0 * * * * /vmfs/volumes/datastore1/raid/raid-monitoring.sh' >> /var/spool/cron/crontabs/root
	                              /bin/busybox crond "
	                    read -p "Open file? confirm with y" choice
	                    if [ "$choice" = "y" ]; then
	                         nano  /etc/rc.local.d/local.sh 
	                    break
	                    clear -x
	                     read -p "Apply changes?" choice
	                    if [ "$choice" = "y" ]; then
	                         auto-backup.sh
                       	fi
                        ;;
                    4)
                    cd /
                    mkdir /raid/
                    RS1=adaptec-monitoring.sh
                    ServerID=SID
                    touch RS1
                    echo -e "What is the server_id?"
                    read SID
                    nano /raid/RS1
                     echo "  server_id="${SID}"
                                logical_status=$(/usr/sbin/arcconf getconfig 1 | grep "Status of logical device" | awk '{print $NF}')
                                TESTING="false"

                                while getopts ':t' option
                                    do
                                         case "${option}" in
                                                 t) TESTING="true";;
                                         esac
                                    done

                                if [ $TESTING == "true" ]
                                       then
                                               logical_status="error"
                                fi

                                if [ $logical_status == "Optimal" ]
                                       then
                                               echo "OK - logical device is optimal."; exit 0
                                       else
                                               wget -s http://control.ukservers.com/raid-api.php?server_id=$server_id; exit 1
                                fi

                        " >> $RS1
                    clear -x
                    chmod +x  /raid/$RS1
                    echo "Script is now executable"
                    echo -e "\n"
                    read -p "To test script confirm with y" choice
                    if [ "$choice" = "y" ]; then
                         /raid/$RS1 -t
                    break
                    read -p "Checking for Error: Type y to continue" choice
                    if [ "$choice" = "y" ]; then
                            /raid/$RS1 
                    break

                    clear -x
                    echo "Add script to crontab: 0 */12 * * * /raid/adaptec-monitoring.sh"
                    read -p "Open Crantab confirm with y" choice
                    if [ "$choice" = "y" ]; then
                        nano  crontab -e
                    break

                    ;;

        7)      passwd root
                sleep 3
                echo "root Password has been changed, Please keep a copy of the password"
                ;;
        8)
                nano crontab -e
                ;;
        9)

                ;;

        10)
                ;;

        11)
                sudo apt update
                sudo apt upgrade
				;;
		12)
				x=1 #exits
				;;
		
        13)
		
				shell=test.sh
					if [ -f $shell ]; then
						rm  $shell
						echo "$shell is removed"
				fi
				;;
        *)
				echo "this is not an option, Please enter between 1-12"
				sleep 3
				;;
esac
done
