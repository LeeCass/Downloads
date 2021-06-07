#!/bin/bash
###CHECK CPANEL ISNT INSTALLED
if test -f "/usr/local/cpanel/cpanel"; then
true
else
echo "cPanel not detected!!!!"
echo ""
echo "Please install cPanel and CSF before running this script"
echo ""
exit
fi


rm -rf /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.d/userparameter* > /dev/null

echo "Downloading Zabbix Configuration"
wget -4 "https://mirror.cov.ukservers.com/managed/zabbix_agentd.conf" -P /etc/zabbix/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/userparameter_services.conf" -P /etc/zabbix/zabbix_agentd.d/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/userparameter_mysql.conf" -P /etc/zabbix/zabbix_agentd.d/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/userparameter_md.conf" -P /etc/zabbix/zabbix_agentd.d/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/userparameter_phpfpm.conf" -P /etc/zabbix/zabbix_agentd.d/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/userparameter_version.conf" -P /etc/zabbix/zabbix_agentd.d/ > /dev/null

###RUN ZABBIX AS ROOT
mkdir /etc/systemd/system/zabbix-agent.service.d/ > /dev/null
echo "[Service]" > /etc/systemd/system/zabbix-agent.service.d/override.conf
echo "User=root" >> /etc/systemd/system/zabbix-agent.service.d/override.conf
echo "Group=root" >> /etc/systemd/system/zabbix-agent.service.d/override.conf
systemctl daemon-reload
usermod -a -G wheel zabbix
usermod -a -G root zabbix
echo "zabbix  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

##check for mysql
mysql_check=$(netstat -ltn | grep 3306 | wc -l)
mysql_pass_check=$(mysql -e 'show databases;' | grep Database | wc -l)

if [[ "$mysql_check" -gt "0" ]] && [[ "$mysql_pass_check" -gt "0" ]] ; then
mkdir /var/lib/zabbix/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/.my.cnf" -P /var/lib/zabbix/ > /dev/null
chown -R zabbix.zabbix /var/lib/zabbix/ > /dev/null
echo "MySQL Detected...adding zabbix user"
mysql -e "grant all on *.* to zbx_monitor@localhost identified by 'ffsou812'; flush privileges;"
fi

if [[ "$mysql_check" -gt "0" ]] && [[ "$mysql_pass_check" -lt "1" ]] ; then
mkdir /var/lib/zabbix/ > /dev/null
wget -4 "https://mirror.cov.ukservers.com/managed/.my.cnf" -P /var/lib/zabbix/ > /dev/null
chown -R zabbix.zabbix /var/lib/zabbix/ > /dev/null
echo "MySQL Detected...please enter the MySQL root password"
mysql -p -e "grant all on *.* to zbx_monitor@localhost identified by 'ffsou812'; flush privileges;"
fi

echo ""
echo "Adding Zabbix IP to CSF"
service csf start > /dev/null
echo "77.75.120.4 #UKSERVERS ZABBIX" >> /etc/csf/csf.allow
csf -r
echo ""
echo "Checking time is correct with ntp.ukservers.com"
ntpdate ntp.ukservers.com > /dev/null

echo ""
echo "Starting Zabbix Agent and setting to start on boot"
service zabbix-agent restart > /dev/null
chkconfig zabbix-agent on > /dev/null




### ADD TO ZABBIX !!!!!!!!!!!!!!!
connected_interface=$(ip link | grep UP | grep -v "lo" | sed 's/://g' | awk '{print $2}')
#ip_address=$(ip addr | grep "$connected_interface" | grep global | head -n1 | awk '{print $2}' | sed 's|/.*||')
ip_address=$(curl -s ifconfig.me)

function goto
{
 local label=$1
 cmd=$(sed -En "/^[[:space:]]*#[[:space:]]*$label:[[:space:]]*#/{:a;n;p;ba};" "$0")
 eval "$cmd"
 exit
}

#start:#

echo ""
echo "Enter the customer ID i.e HOW002"
echo -n "Please enter: "
read -r
cust_id=$REPLY

echo ""
echo "Enter the server ID i.e UKDSL R44-19"
echo -n "Please enter: "
read -r
server_id=$REPLY

echo ""
echo "Server IP address seems to be $ip_address is this correct?"
echo -n "y/n: "
read -r
ip=$REPLY

if [[ "$ip" == "y" ]]; then
ip="$ip_address"
else
echo -n "Please enter the IP: "
read -r
ip=$REPLY
fi

echo
echo "Is the following correct....."
echo "Customer ID: $cust_id"
echo "Server ID: $server_id"
echo "Main server IP: $ip"
echo -n "y/n: "
read -r
correct=$REPLY

if [[ "$correct" == "y" ]]; then
echo ""
echo "Server will now be added into Zabbix. Please wait..."
sleep 5
curl --insecure -H "Content-type: application/json-rpc" -X POST https://zabbix.ukservers.com/api_jsonrpc.php -d'
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "'"$cust_id"' - '"$server_id"'",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "'"$ip"'",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "20"
            }
        ],
        "templates": [
            {
                "templateid": "10392"
            }
        ]
    },
    "auth": "dbcf4729059980b4fe761a86c7544be7",
    "id": 1
}'
else
goto start
fi
## END ADD TO ZABBIX!!!!!!!!!!!!!!!

echo ""
echo ""
echo "Finished"
echo 'export HISTTIMEFORMAT="%F %T "' >> /root/.bashrc
wget -q -4 https://mirror.cov.ukservers.com/managed/version -P /etc/zabbix/
rm -rf zabbix-cpanel.sh > /dev/null
exit