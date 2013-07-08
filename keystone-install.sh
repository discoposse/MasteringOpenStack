# keystone.sh
export DEBIAN_FRONTEND=noninteractive

export MYSQL_ROOT_PASS=openstack
export MYSQL_HOST=0.0.0.0
export MYSQL_PASS=openstack

echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password seen true" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again seen true" | sudo debconf-set-selections
        
sudo apt-get update
sudo apt-get install ntp python-software-properties -y
sudo add-apt-repository ppa:openstack-ubuntu-testing/grizzly-trunk-testing
sudo add-apt-repository ppa:openstack-ubuntu-testing/grizzly-build-depends
sudo apt-get update && apt-get upgrade -y

sudo apt-get -y install mysql-server python-mysqldb

sudo sed -i "s/^bind\-address.*/bind-address = ${MYSQL_HOST}/g" /etc/mysql/my.cnf

sudo restart mysql

sudo apt-get -y install keystone python-keyring

mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE keystone;"

mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$MYSQL_PASS';"

sudo sed -i 's#^connection.*#connection = mysql://keystone:openstack@127.0.0.1/keystone#' /etc/keystone/keystone.conf

sudo sed -i 's/^# admin_token.*/admin_token = ADMIN/' /etc/keystone/keystone.conf

sudo stop keystone
sudo start keystone

sudo keystone-manage db_sync

sudo apt-get -y install python-keystoneclient

export ENDPOINT=127.0.0.1
export SERVICE_TOKEN=ADMIN
export SERVICE_ENDPOINT=http://${ENDPOINT}:35357/v2.0

