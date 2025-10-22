# add the config file to /etc/logstash.yml

sudo tee /etc/systemd/system/logstash.service > /dev/null <<'EOF'
[Unit]
Description=Logstash
Wants=network-online.target
After=network-online.target

[Service]
TimeoutStartSec=300
LimitMEMLOCK=infinity
Type=notify
User=logstash
Group=logstash
Type=simple
ExecStart=/opt/logstash/bin/logstash "--path.settings" "/etc/logstash"
WorkingDirectory=/opt/logstash
LimitNOFILE=65535
LimitNPROC=4096
TimeoutStopSec=0
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now logstash
