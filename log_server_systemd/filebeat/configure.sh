# add the config file to /etc/filebeat.yml

sudo tee /etc/systemd/system/filebeat.service > /dev/null <<'EOF'
[Unit]
Description=Filebeat
Wants=network-online.target
After=network-online.target

[Service]
TimeoutStartSec=300
LimitMEMLOCK=infinity
Type=notify
User=filebeat
Group=filebeat
Type=simple
ExecStart=/opt/filebeat/filebeat --path.config /etc/filebeat
WorkingDirectory=/opt/filebeat
LimitNOFILE=65535
LimitNPROC=4096
TimeoutStopSec=0
Restart=on-failure
RestartSec=10s
Environment=ES_PATH_CONF=/etc/filebeat

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload
sudo systemctl enable --now filebeat
