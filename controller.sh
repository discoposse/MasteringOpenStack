apt-get install -y ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main" | sudo tee /etc/apt/sources.list.d/grizzly.list
apt-get update && apt-get -y dist-upgrade
reboot



