export MYSQL_ROOT_PASS=openstack
export MYSQL_HOST=0.0.0.0
export MYSQL_PASS=openstack

mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE cinder;"

mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$MYSQL_PASS';"

sudo apt-get install -y cinder-api cinder-scheduler cinder-volume open-iscsi iscsitarget-dkms python-cinderclient tgt rabbitmq-server linux-headers-`uname -r`

sudo rabbitmqctl change_password guest password

sudo sed -i 's/false/true/g' /etc/default/iscsitarget
service iscsitarget start
service open-iscsi start




#
sudo sed -i 's#^connection.*#connection = mysql://cinder:openstack@127.0.0.1/cinder#' /etc/cinder/cinder.conf
# add the rabbit_password line


sudo sed -i 's#^admin_tenant_name.*#admin_tenant_name = service#' /etc/cinder/cinder.conf
sudo sed -i 's#^admin_user.*#admin_user = cinder#' /etc/cinder/cinder.conf
sudo sed -i 's#^admin_password.*#admin_password = cinder#' /etc/cinder/cinder.conf

sudo sed -i 's#^admin_tenant_name.*#admin_tenant_name = service#' /etc/cinder/api-paste.ini
sudo sed -i 's#^admin_user.*#admin_user = cinder#' /etc/cinder/api-paste.ini
sudo sed -i 's#^admin_password.*#admin_password = cinder#' /etc/cinder/api-paste.ini

pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb

cinder-manage db sync

service cinder-api restart
service cinder-scheduler restart
service cinder-volume restart



