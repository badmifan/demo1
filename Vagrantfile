ENV["LC_ALL"] = "en_US.UTF-8"
ENV["ANSIBLE_HOST_KEY_CHECKING"]= "0"
$script_ubuntu = <<-EOF
export LC_ALL=en_US.UTF-8
sudo apt update
sudo apt upgrade
sudo apt -y install python3-pip python-mysqldb
export ANSIBLE_HOST_KEY_CHECKING=False
EOF

$script_database = <<-EOF
export LC_ALL=en_US.UTF-8
sudo apt update
sudo apt upgrade
sudo apt install sshpass
export ANSIBLE_HOST_KEY_CHECKING=False
sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart
EOF

$script_nginx = <<-EOF
export LC_ALL=en_US.UTF-8
sudo apt update
sudo apt upgrade
sudo apt -y install nginx
EOF


Vagrant.configure("2") do |config|

  config.vm.define "nginx" do |nginx|
    nginx.ssh.insert_key = false
    nginx.vm.box = "ubuntu/bionic64"
    nginx.vm.hostname = "nginx.box"
    nginx.vm.network :private_network, ip: "192.168.100.100"
    #nginx.vm.network :public_network, :bridge=> 'wlp3s0', use_dhcp_assigned_default_route: true
    nginx.vm.provision "shell", inline: $script_nginx
    nginx.vm.provision "file", source: "default.conf", destination: "/tmp/nginx.conf"
    nginx.vm.provision "shell", inline: "mv /tmp/nginx.conf /etc/nginx/sites-enabled/default"
    nginx.vm.provision "shell", inline: "sudo systemctl restart nginx"
  end
  config.vm.define "java_app_1" do |java_app_1|
    java_app_1.ssh.insert_key = false
    java_app_1.vm.box = "ubuntu/bionic64"
    java_app_1.vm.hostname = "java-app-1.box"
    java_app_1.vm.network :private_network, ip: "192.168.100.20"
    java_app_1.vm.provision "shell", inline: $script_ubuntu
    # java_app_1.vm.provision "file", source: "tomcat.service", destination: "/tmp/tomcat.service"
    # java_app_1.vm.provision "shell", inline: "mv /tmp/tomcat.service /etc/systemd/system/tomcat.service"
  end
  config.vm.define "java_app_2" do |java_app_2|
    java_app_2.ssh.insert_key = false
    java_app_2.vm.box = "ubuntu/bionic64"
    java_app_2.vm.hostname = "java-app-2.box"
    java_app_2.vm.network :private_network, ip: "192.168.100.30"
    java_app_2.vm.provision "shell", inline: $script_ubuntu
  #   java_app_2.vm.provision "file", source: "tomcat.service", destination: "/tmp/tomcat.service"
  #   java_app_2.vm.provision "shell", inline: "mv /tmp/tomcat.service /etc/systemd/system/tomcat.service"
  end
  config.vm.define "database" do |database|
    database.ssh.insert_key = false
    database.vm.box = "ubuntu/bionic64"
    database.vm.hostname = "jenkins-1.box"
    database.vm.network :private_network, ip: "192.168.100.40"
    database.vm.provision "shell", inline: $script_ubuntu
    database.vm.provision "file", source: "dump.sql", destination: "dump.sql"
  end
  config.vm.define "jenkins" do |jenkins|
    jenkins.ssh.insert_key = false
    jenkins.vm.box = "ubuntu/bionic64"
    jenkins.vm.hostname = "jenkins.box"
    jenkins.vm.network :private_network, ip: "192.168.100.10"
    #jenkins.vm.network :public_network, :bridge=> 'wlp3s0', use_dhcp_assigned_default_route: true
    jenkins.vm.provision "shell", inline: $script_ubuntu
    jenkins.vm.provision "file", source: "inventory", destination: "inventory"
    jenkins.vm.provision "file", source: "configure.yml", destination: "configure.yml"
    jenkins.vm.provision "file", source: "tomcat2.service", destination: "tomcat2.service"
    jenkins.vm.provision "file", source: "fbird.war", destination: "fbird.war"
    jenkins.vm.provision "file", source: "tomcat-users.xml", destination: "tomcat-users.xml"
    jenkins.vm.provision "file", source: "context.xml", destination: "context.xml"
    #jenkins.vm.provision "file", source: "/home/mif/.vagrant.d/insecure_private_key", destination: "private_key"
    jenkins.vm.provision "file", source: "/Users/mikhaild/.vagrant.d/insecure_private_key", destination: "private_key"
    #jenkins.vm.provision "shell", inline: $script_ubuntu
    jenkins.vm.provision :ansible_local do |ansible|
        ansible.playbook       = "/home/vagrant/configure.yml"
        ansible.raw_arguments = ["--private-key=/home/vagrant/private_key"]
        ansible.install        = true
        ansible.install_mode = :pip
        ansible.verbose        = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "/home/vagrant/inventory"
        ansible.provisioning_path = "/home/vagrant"
    end
  end
end	