sudo groupadd --system nginx

sudo useradd --system \
  --no-create-home \
  --home-dir /opt/nginx \
  --shell /sbin/nologin \
  --gid nginx \
  nginx

sudo mkdir -p /etc/nginx /var/lib/nginx /var/log/nginx /run/nginx

sudo chown -R nginx:nginx /etc/nginx /var/lib/nginx /var/log/nginx /run/nginx

sudo chmod -R 750 /etc/nginx /var/lib/nginx /var/log/nginx /run/nginx
