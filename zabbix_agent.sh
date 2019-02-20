yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y
systemctl start zabbix-agent
sed -i 's/#DebugLevel=3/DebugLevel=3/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# StartAgents=3/StartAgents=3/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf 
sed -i 's/Server=127.0.0.1/Server=192.168.55.55/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.55.55/' /etc/zabbix/zabbix_agentd.conf
service zabbix-agent restart

#Install OracleJDK for application
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
yum install jdk-8u131-linux-x64.rpm -y
#Download and install TOMCAT
yum install unzip  -y 
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.zip
unzip apache-tomcat-8.5.37.zip

if [ ! -d /var/lib/tomcat ]; then mkdir -p /var/lib/tomcat; else echo "Such directory is existed! ";fi

cp -rf ./apache-tomcat-8.5.37/* /var/lib/tomcat/
chmod +x /var/lib/tomcat/bin/*.sh
chown vagrant: -R /var/lib/tomcat/	

#Install Java JMX
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/extras/catalina-jmx-remote.jar
sudo cp ./catalina-jmx-remote.jar /var/lib/tomcat/lib/

bash -c 'cat<< EOF > /var/lib/tomcat/bin/setenv.sh
export CATALINA_OPTS="-Dcom.sun.management.jmxremote=true \
-Dcom.sun.management.jmxremote.port=12345 \
-Dcom.sun.management.jmxremote.rmi.port=12346 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Djava.rmi.server.hostname=192.168.55.56"
EOF'


sleep 2
chmod +x /var/lib/tomcat/bin/setenv.sh
chown vagrant: /var/lib/tomcat/bin/setenv.sh

sed -i '/ThreadLocalLeak/a<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" />\' /var/lib/tomcat/conf/server.xml