Vagrant.configure("2") do |config|
  config.vm.box = "sbeliakou/centos"
  config.vm.define "zabbix_srv" do |zabbix_srv|
    zabbix_srv.vm.network :private_network, ip: "192.168.55.55"
    zabbix_srv.vm.hostname = "zabbix-srv"
    zabbix_srv.vm.provision :shell, path: "zabbix_srv_agent.sh"
  end
  config.vm.provider "zabbix_srv" do |zabbix_srv|
    zabbix_srv.memory=2048
  end

config.vm.define "zabbix_ag" do |zabbix_ag|
  zabbix_ag.vm.network :private_network, ip: "192.168.55.56"
  zabbix_ag.vm.hostname = "zabbix-ag"
  zabbix_ag.vm.provision :shell, path: "zabbix_agent.sh"
 end
  config.vm.provider "zabbix_ag" do |zabbix_ag|
  zabbix_ag.memory=2048
 end

end