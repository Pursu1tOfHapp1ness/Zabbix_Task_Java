#Install MySQL DB (MariaDB)
sudo yum install mariadb mariadb-server -y
sleep 1
sudo /usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
#Make changes in mariaDB
mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to zabbix@localhost identified by 'password'"
#Install Zabbix Server
sudo yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
sudo yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | sudo mysql -uzabbix -ppassword zabbix

#Front-end Installation and Configuration

sed -i '1s/#/DocumentRoot \/usr\/share\/zabbix/' /etc/httpd/conf.d/zabbix.conf
sed -i 's/#DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i 's/#\ DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf
sed -i '19s/#//' /etc/httpd/conf.d/zabbix.conf 
sed -i '19s/Europe\/Riga/Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf
systemctl start zabbix-server
systemctl start httpd

#Install Zabbix Agent 
yum install zabbix-agent -y
systemctl start zabbix-agent
sed -i 's/#DebugLevel=3/DebugLevel=3/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# StartAgents=3/StartAgents=3/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf 
service zabbix-agent restart

yum install zabbix-java-gateway -y
systemctl start zabbix-java-gateway
systemctl enable zabbix-java-gateway
sed -i '219s/#\ JavaGateway=/JavaGateway=192.168.55.55/' /etc/zabbix/zabbix_server.conf
sed -i 's/# StartJavaPollers=0/StartJavaPollers=5/' /etc/zabbix/zabbix_server.conf

systemctl restart zabbix-server