# Jenkins

## Tool prerequisites

* OS
  * win 
  * mac
  * linux \( centos\ubuntu\amazon\)

## **Linux Installation:**

### centos installation

```bash
ELASTIC_VER="6.6.0"
rpm -i https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTIC_VER}.rpm
sed -i 's/#MAX_LOCKED_MEMORY=.*$/MAX_LOCKED_MEMORY=unlimited/' /etc/sysconfig/elasticsearch
chkconfig --add elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
sudo service elasticsearch start
cat <<EOF >>/etc/security/limits.conf
# allow user 'elasticsearch' mlockall
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
elasticsearch  -  nofile  65536
EOF

/usr/share/elasticsearch/bin/elasticsearch-plugin install --batch x-pack
/usr/share/elasticsearch/bin/elasticsearch-plugin install --batch discovery-ec2
```

**ubuntu installation**

```text
TBD
```

## Mac Installations:

```text
TBD
```

