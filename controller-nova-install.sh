export MYSQL_ROOT_PASS=openstack
export MYSQL_HOST=0.0.0.0
export MYSQL_PASS=openstack

mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE nova;"

mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL ON keystone.* TO 'nova'@'localhost' IDENTIFIED BY '$MYSQL_PASS';"

sudo apt-get install -y nova-api nova-cert nova-common nova-conductor nova-scheduler python-nova python-novaclient nova-consoleauth novnc nova-novncproxy


sudo sed -i 's#^admin_tenant_name.*#admin_tenant_name = service#' /etc/nova/api-paste.ini
sudo sed -i 's#^admin_user.*#admin_user = nova#' /etc/nova/api-paste.ini
sudo sed -i 's#^admin_password.*#admin_password = nova#' /etc/nova/api-paste.ini

# fix the nova.conf
#
#

nova-manage db sync