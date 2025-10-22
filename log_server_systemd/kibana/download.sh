curl -O https://artifacts.elastic.co/downloads/kibana/kibana-9.1.5-linux-x86_64.tar.gz
curl https://artifacts.elastic.co/downloads/kibana/kibana-9.1.5-linux-x86_64.tar.gz.sha512 | shasum -a 512 -c -
tar -xzf kibana-9.1.5-linux-x86_64.tar.gz

mv kibana-9.1.5 /opt/kibana

sudo groupadd --system kibana

sudo useradd --system \
  --no-create-home \
  --home-dir /opt/kibana \
  --shell /sbin/nologin \
  --gid kibana \
  kibana

sudo mkdir -p /etc/kibana /var/lib/kibana /var/log/kibana /run/kibana

sudo chown -R kibana:kibana /etc/kibana /var/lib/kibana /var/log/kibana /run/kibana

sudo chmod -R 750 /etc/kibana /var/lib/kibana /var/log/kibana /run/kibana

sudo chown -R kibana:kibana /opt/kibana

mv /opt/kibana/config/* /etc/kibana

cp -r /etc/elasticsearch/config/certs/ca /etc/kibana/certs/ca
cp -r /etc/elasticsearch/config/certs/kibana /etc/kibana/certs/kibana

sudo chown -R kibana:kibana /etc/kibana 
