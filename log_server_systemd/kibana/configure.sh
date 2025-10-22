# add the config file to /etc/elasticserach.yml

sudo tee /etc/systemd/system/elasticserach.service > /dev/null <<'EOF'
[Unit]
Description=Elasticsearch
Wants=network-online.target
After=network-online.target

[Service]
TimeoutStartSec=300
LimitMEMLOCK=infinity
Type=notify
User=elasticsearch
Group=elasticsearch
Type=simple
ExecStart=/opt/elasticsearch/bin/elasticsearch
WorkingDirectory=/opt/elasticsearch
LimitNOFILE=65535
LimitNPROC=4096
TimeoutStopSec=0
Restart=on-failure
RestartSec=10s
Environment=ES_PATH_CONF=/etc/elasticsearch

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload
sudo systemctl enable --now elasticserach
