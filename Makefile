.ONESHELL: all update 

all: update

update:
	sudo yum update

clean:
	rm ~/my-bosh/bosh-init-*
	rm ~/my-bosh/cf-release/spiff_linux_*
	rm ~/my-bosh/cf-release/bosh-stemcell-*
