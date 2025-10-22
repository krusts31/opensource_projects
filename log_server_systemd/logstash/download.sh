curl -O https://artifacts.elastic.co/downloads/logstash/logstash-9.1.5-linux-x86_64.tar.gz
curl https://artifacts.elastic.co/downloads/logstash/logstash-9.1.5-linux-x86_64.tar.gz.sha512 | shasum -a 512 -c -
tar -xzf logstash-9.1.5-linux-x86_64.tar.gz

mv logstash-9.1.5 /opt/logstash

sudo groupadd --system logstash

sudo useradd --system \
  --no-create-home \
  --home-dir /opt/logstash \
  --shell /sbin/nologin \
  --gid logstash \
  logstash

sudo mkdir -p /etc/logstash /var/lib/logstash /var/log/logstash /run/logstash

sudo chown -R logstash:logstash /etc/logstash /var/lib/logstash /var/log/logstash /run/logstash

sudo chmod -R 750 /etc/logstash /var/lib/logstash /var/log/logstash /run/logstash

sudo chown -R logstash:logstash /opt/logstash

mv /opt/logstash/config/* /etc/logstash

cp -r /etc/elasticsearch/config/certs/ca /etc/logstash/certs/ca
cp -r /etc/elasticsearch/config/certs/logstash /etc/logstash/certs/logstash

sudo chown -R logstash:logstash /etc/logstash /var/lib/logstash /var/log/logstash /run/logstash
