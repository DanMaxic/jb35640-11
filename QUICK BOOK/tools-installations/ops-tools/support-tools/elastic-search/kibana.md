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
rpm -i https://artifacts.elastic.co/downloads/kibana/kibana-${ELASTIC_VER}-x86_64.rpm
chown kibana:kibana -R /usr/share/kibana/
chkconfig --add kibana
systemctl daemon-reload
systemctl enable kibana.service
sudo service kibana start
```

**ubuntu installation**

```text
TBD
```

## Mac Installations:

```text
TBD
```

