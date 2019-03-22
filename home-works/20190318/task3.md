#**Task #3: Building CI Infrastructure**
  
##Task review
* Here you will need to build a full DevOps Infra servers, using vagrant.
* see the table bellow for config reference
* see the "**resources**" directory for code snips
* see the "**training-sessions/20190227/script analysis**" directory for more code snips
* when writing the user data scripts, pay attention for proper usage of the following:
  * commands exit code (remember the _**$?**_)
  * proper usage of bash\shell scripts
  * proper name conventions for variables & function names
  * when using variables, check when you will need to use "local variables" vs "global variables"
  * you may skip the gitlab server installation
* **DO NOT FORGET**: attach proper diagram
  
  | IP ADDR     | HOST NAME | COMPONENTS to INSTALL | PORTS EXPOSED TO HOST (vm port->host) |
  | ------------- | ------------- | ----- | ----- |
  | 172.16.1.101 | artifactory.cilab | `nexus`, `java` | 8081->38081 |
  | 172.16.1.102 | gitserver.cilab | `gitlabserver` | 80->38000 |
  | 172.16.1.103 | buildserver.cilab| `jenkins`, `SCM tools`, `BUILD tools` | 8080->38080 |
  | 172.16.1.104 | buildnode.cilab | `SCM tools`, `BUILD tools` | N\A |


Gitlab installation:
* more info: https://www.vultr.com/docs/how-to-install-gitlab-community-edition-ce-11-x-on-centos-7
```bash
sudo yum update -y
sudo yum install -y curl policycoreutils-python openssh-server openssh-clients
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.example.com" yum install -y gitlab-ce

```