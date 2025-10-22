curl -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-9.1.5-linux-x86_64.tar.gz
curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-9.1.5-linux-x86_64.tar.gz.sha512 | shasum -a 512 -c -
tar -xzf filebeat-9.1.5-linux-x86_64.tar.gz

mv filebeat-9.1.5 /opt/filebeat

sudo groupadd --system filebeat

sudo useradd --system \
  --no-create-home \
  --home-dir /opt/filebeat \
  --shell /sbin/nologin \
  --gid filebeat \
  filebeat

sudo mkdir -p /etc/filebeat /var/lib/filebeat /var/log/filebeat /run/filebeat

sudo chown -R filebeat:filebeat /etc/filebeat /var/lib/filebeat /var/log/filebeat /run/filebeat

sudo chmod -R 750 /etc/filebeat /var/lib/filebeat /var/log/filebeat /run/filebeat

sudo chown -R filebeat:filebeat /opt/filebeat
