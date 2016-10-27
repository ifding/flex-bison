.ONESHELL: all update 

all: update docker boot cluster

update:
	sudo yum upgrade --assumeyes --tolerant
	sudo yum update --assumeyes
	uname -r
	sudo tee /etc/modules-load.d/overlay.conf <<-'EOF'
	overlay
	EOF
	reboot
	
docker:
	lsmod | grep overlay
	sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
	[dockerrepo]
	name=Docker Repository
	baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
	enabled=1
	gpgcheck=1
	gpgkey=https://yum.dockerproject.org/gpg
	EOF	
	sudo mkdir -p /etc/systemd/system/docker.service.d && sudo tee /etc/systemd/system/docker.service.d/override.conf <<- EOF
	[Service]
	ExecStart=
	ExecStart=/usr/bin/docker daemon --storage-driver=overlay -H fd://
	EOF
	sudo yum install -y https://yum.dockerproject.org/repo/main/centos/7/Packages/docker-engine-1.11.2-1.el7.centos.x86_64.rpm
	sudo systemctl start docker
	sudo systemctl enable docker
	docker info
	
boot:
	sudo systemctl stop firewalld && sudo systemctl disable firewalld
	sudo docker pull nginx
	sudo yum install -y ntp
cluster:
	sudo yum install -y tar xz unzip curl ipset nano ntp
	sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config
	sudo groupadd nogroup
	sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
	sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
	sudo reboot
