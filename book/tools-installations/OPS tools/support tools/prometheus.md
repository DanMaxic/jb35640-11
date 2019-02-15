# PROMETHEUS

## Tool prerequisites

* OS
  * mac
  * linux \( centos\ubuntu\amazon\)

## **Linux Installation:**

### centos installation

```bash
export RELEASE=2.4.2
wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /var/lib/prometheus
for i in rules rules.d files_sd; do sudo mkdir -p /etc/prometheus/${i}; done
tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz
cd prometheus-${RELEASE}.linux-amd64/
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles/ console_libraries/ /etc/prometheus/

cat <<EOF >>/etc/prometheus/prometheus.yml
# Global config
global: 
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.  
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.  
  scrape_timeout: 15s  # scrape_timeout is set to the global default (10s).

# A scrape configuration containing exactly one endpoint to scrape:# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']
EOF

```

**ubuntu installation**

```text

```

## Mac Installations:

```text
TBD
```

