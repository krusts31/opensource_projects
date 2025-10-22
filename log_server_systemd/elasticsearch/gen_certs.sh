CERTS_DIR="/etc/elasticsearch/config/certs"

mkdir -p "$CERTS_DIR"

if [ ! -f "$CERTS_DIR/ca.zip" ]; then
  echo "🔐 Creating new CA..."
  /opt/elasticsearch/bin/elasticsearch-certutil ca --silent --pem -out "$CERTS_DIR/ca.zip" --days 10000
  unzip -qo "$CERTS_DIR/ca.zip" -d "$CERTS_DIR"
  mkdir -p "$CERTS_DIR/ca"
fi

if [ ! -f "$CERTS_DIR/certs.zip" ]; then
  echo "📜 Creating instance certificates..."

  cat > "$CERTS_DIR/instances.yml" <<EOF
instances:
- name: elasticsearch
  dns:
    - elasticsearch
    - elasticsearch.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: kibana
  dns:
    - kibana
    - kibana.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: logstash
  dns:
    - logstash
    - logstash.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: filebeat
  dns:
    - filebeat
    - filebeat.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: heartbeat
  dns:
    - heartbeat
    - heartbeat.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: auditbeat
  dns:
    - auditbeat
    - auditbeat.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: metricbeat
  dns:
    - metricbeat
    - metricbeat.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP

- name: packetbeat
  dns:
    - packetbeat
    - packetbeat.local
    - localhost
    - $DNS
  ip:
    - 127.0.0.1
    - $IP
EOF

  /opt/elasticsearch/bin/elasticsearch-certutil cert \
    --silent --pem \
    -out "$CERTS_DIR/certs.zip" \
    --in "$CERTS_DIR/instances.yml" \
    --ca-cert "$CERTS_DIR/ca/ca.crt" \
    --ca-key "$CERTS_DIR/ca/ca.key"  --days 10000

  unzip -qo "$CERTS_DIR/certs.zip" -d "$CERTS_DIR"
fi

echo "✅ All certificates created successfully!

chown -R elasticsearch:elasticsearch /etc/elasticsearch
