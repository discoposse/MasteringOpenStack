sudo apt-get install -y glance glance-api glance-registry python-glanceclient glance-common

sudo sed -i 's#^connection.*#connection = mysql://glance:openstack@127.0.0.1/glance#' /etc/glance/glance-registry.conf
sudo sed -i 's#^admin_tenant_name.*#admin_tenant_name = service#' /etc/glance/glance-registry.conf
sudo sed -i 's#^admin_user.*#admin_user = glance#' /etc/glance/glance-registry.conf
sudo sed -i 's#^admin_password.*#admin_password = glance#' /etc/glance/glance-registry.conf

sudo sed -i 's#^connection.*#connection = mysql://glance:openstack@127.0.0.1/glance#' /etc/glance/glance-api.conf
sudo sed -i 's#^admin_tenant_name.*#admin_tenant_name = service#' /etc/glance/glance-api.conf
sudo sed -i 's#^admin_user.*#admin_user = glance#' /etc/glance/glance-api.conf
sudo sed -i 's#^admin_password.*#admin_password = glance#' /etc/glance/glance-api.conf

service glance-api restart && service glance-registry restart

glance-manage db_sync

