# Create a physical volume for use later
pvcreate /dev/sdb

# Install some packages:
sudo apt-get -y install swift swift-proxy swift-account swift-container swift-object memcached xfsprogs curl python-webob python-swiftclient
sudo service ntp restart

# Create signing directory & Set owner to swift
mkdir /var/swift-signing
chown -R swift /var/swift-signing

# Create cache directory & set owner to swift
mkdir -p /var/cache/swift
chown -R swift:swift /var/cache/swift

# Create a loopback filesystem
sudo mkdir /mnt/swift
dd if=/dev/zero of=/mnt/swift/swift-volume bs=1 count=0 seek=2G
mkfs.xfs -i size=1024 /mnt/swift/swift-volume

sudo mkdir /mnt/swift_backend
echo '/mnt/swift/swift-volume /mnt/swift_backend xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab
sudo mount -a

	# Setup our directory structure
	sudo mkdir /mnt/swift_backend/{1..4}
	sudo chown swift:swift /mnt/swift_backend/*
	sudo ln -s /mnt/swift_backend/{1..4} /srv
	sudo mkdir -p /etc/swift/{object-server,container-server,account-server}
	for S in {1..4}; do sudo mkdir -p /srv/${S}/node/sdb${S}; done
	sudo mkdir -p /var/run/swift
	sudo chown -R swift:swift /etc/swift /srv/{1..4}/
	mkdir -p /var/run/swift
	chown swift:swift /var/run/swift

	# Setup rsync
sudo cat > /etc/rsyncd.conf <<EOF
uid = swift
gid = swift
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
address = 127.0.0.1

[account6012]
max connections = 25
path = /srv/1/node/
read only = false
lock file = /var/lock/account6012.lock

[account6022]
max connections = 25
path = /srv/2/node/
read only = false
lock file = /var/lock/account6022.lock

[account6032]
max connections = 25
path = /srv/3/node/
read only = false
lock file = /var/lock/account6032.lock

[account6042]
max connections = 25
path = /srv/4/node/
read only = false
lock file = /var/lock/account6042.lock

[container6011]
max connections = 25
path = /srv/1/node/
read only = false
lock file = /var/lock/container6011.lock

[container6021]
max connections = 25
path = /srv/2/node/
read only = false
lock file = /var/lock/container6021.lock

[container6031]
max connections = 25
path = /srv/3/node/
read only = false
lock file = /var/lock/container6031.lock

[container6041]
max connections = 25
path = /srv/4/node/
read only = false
lock file = /var/lock/container6041.lock

[object6010]
max connections = 25
path = /srv/1/node/
read only = false
lock file = /var/lock/object6010.lock

[object6020]
max connections = 25
path = /srv/2/node/
read only = false
lock file = /var/lock/object6020.lock

[object6030]
max connections = 25
path = /srv/3/node/
read only = false
lock file = /var/lock/object6030.lock

[object6040]
max connections = 25
path = /srv/4/node/
read only = false
lock file = /var/lock/object6040.lock
EOF

sudo sed -i 's/=false/=true/' /etc/default/rsync
sudo service rsync start


