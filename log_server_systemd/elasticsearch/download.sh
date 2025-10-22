curl -https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.1.5-linux-x86_64.tar.gz
curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.1.5-linux-x86_64.tar.gz.sha512 | shasum -a 512 -c -
tar -xzf elasticsearch-9.1.5-linux-x86_64.tar.gz

mv elasticsearch-9.1.5 /opt/elasticsearch

sudo groupadd --system elasticsearch

sudo useradd --system \
  --no-create-home \
  --home-dir /opt/elasticsearch \
  --shell /sbin/nologin \
  --gid elasticsearch \
  elasticsearch

sudo mkdir -p /etc/elasticsearch /var/lib/elasticsearch /var/log/elasticsearch /run/elasticsearch

sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch /var/lib/elasticsearch /var/log/elasticsearch /run/elasticsearch

sudo chmod -R 750 /etc/elasticsearch /var/lib/elasticsearch /var/log/elasticsearch /run/elasticsearch

sudo chown -R elasticsearch:elasticsearch /opt/elasticsearch

mv /opt/elasticsearch/config/* /etc/elasticsearch
