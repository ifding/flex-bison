.ONESHELL: all update 

all: update

update:
	sudo yum update -y
	sudo yum upgrade -y
	sudo systemctl stop firewalld && sudo systemctl disable firewalld
	curl -fsSL https://get.docker.com/ | sh
	sudo systemctl enable docker.service
	sudo systemctl start docker	
	
clean:
	rm ~/my-bosh/bosh-init-*

