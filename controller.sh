sudo apt-get install -y ubuntu-cloud-keyring
sudo echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main" | sudo tee /etc/apt/sources.list.d/grizzly.list
sudo apt-get update && sudo apt-get -y dist-upgrade
sudo reboot



