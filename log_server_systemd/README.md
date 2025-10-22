# ELK STACK

RPLACE DNS with you hostname or IP

![ARCH](./ELK.svg)

## SERVER

### DISABLED SWAP

```bash
sudo vim /etc/fstab
#UUID=aab93eb9-7a26-496a-b5ca-9ee3f5afbdce none                    swap    defaults        0 0
```

### SERVER DOCUMENTATION ON SOURCE OF TRUTH WHEN IT COMES TO ROCKY BALBOAH LINUX

[Rocky linux guid](https://docs.rockylinux.org/10/guides/)

```bash
dnf install -y nginx
```

### INSTALED

```bash
#first this
dnf install epel-release
#then this
dnf install nginx certbot python3-certbot-nginx perl-Digest-SHA
```

### PORTS
openports are 443 80 5044
```bash
#close
firewall-cmd --zone=public --remove-port=9300/tcp --permanent
#open
firewall-cmd --zone=public --add-port=8080/tcp --permanent
#reload
firewall-cmd --reload
```

### NGINX WITH CERTS

[nginx cert bot doc](https://docs.rockylinux.org/10/guides/security/generating_ssl_keys_lets_encrypt/)

So you need to install all the above packages and open port 80 and 443.
This is a guid showing how certs was added from scratch.


Then run this
```bash
systemctl enable nginx --now
certbot --nginx
#this will fail
#then add the bellow config
vim /etc/nginx/conf.d/logs.conf
```

add this to `/etc/nginx/conf.d/logs.conf`

```conf
server {
    server_name $DNS;

    listen 80;
    listen [::]:80;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

```bash
#then run this again
certbot --nginx
certbot install --cert-name $DNS -v
```
If you edit nginx files then make sure that nginx configuration is applied by restarting nginx with systemctl.

Go to `$DNS` to see if worked.

```bash
#then run this again
certbot --nginx
certbot install --cert-name $DNS -v
systemctl restart nginx
```

adjust your nginx conf in `/etc/nginx/conf.d/$DNS.conf`
```conf
server {
    server_name $DNS;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/$DNS/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/$DNS/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location /kibana/ {
        proxy_pass http://127.0.0.1:5601/;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/kibana/(.*)$ /$1 break;
    }
}

server {
    if ($host = $DNS) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    server_name $DNS;

    listen 80;
    listen [::]:80;
    return 404; # managed by Certbot


}
```

## ELASTIC SEARCH

Elastic search trafic is encrypted by default.

This is the part that store the logs and does all the heavy stuff.

Elastic search JVM automaticaly alocates half of the ram available.

[Config reference](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference)
[Guid used for installing](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-from-archive-on-linux-macos)

in elasticsarch dir run `downlaod.sh` this is download and configure users for elastic search.
files are stored under `/opt/elasticsearch` since that is a writable folder for elastic serach
to downlaod stuff if need be.

confi files are stored in `/etc/elasticserach`.
log dir `/var/log/elasticsearch/`.
data dir `/var/lib/elasticsearch/`.

then run `gen_certs.sh`. this will generated the need certificates for elk stack to talk to each other over tls.

then configure `/etc/elasticsearch/elasticsearch.yml` to match the example.

### ELASTIC CONFIG refrence for ssl/tls

https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/security-settings#http-tls-ssl-settings

Relevent configuration.

```yaml
http.host: localhost		#listens on localhost
discovery.type: single-node	#need for single node setup
```

then run `bash ./configure.sh` this should start elastic serach you can use systemct to check its status un logs in case there is something wrong. You can look for GREEN log entry that means the elastic serach is up and running.

once its up and running run `/opt/elasticsearch/bin/elasticsearch-setup-passwords auto` this will change default password and print it to the terminal. Save them.

That is is elastic serach is up and now you need to configure the rest.

## KIBANA

This is the gui

trafic from ngixn to kibana is unecnrypted but that is irelevent since its on localhost.
trafic to nginx is encrypted therfor we have tls from client to server.

Kibana is inslated under `/opt` since it needs to write to system. it install sombe plugins.

log dir `/var/log/kibana/`.
data dir `/var/lib/kibana/`.

```yaml
server.basePath: "/kibana"
server.rewriteBasePath: false
server.publicBaseUrl: "https://$DNS/kibana" #since kibana is behind proxy 
elasticsearch.hosts: ["https://localhost:9200"] #where elastic search is
elasticsearch.username: "" #set this to kibana user
elasticsearch.password: "" #-||-
```

in kibana dir run `downlaod.sh` this is download and configure users for kibana.
then configure `/etc/kibana/kibana.yml` to match the example.

then run `bash ./configure.sh` this should start kibana serach you can use systemct to check its status un logs in case there is something wrong. 

if this works then you will be able to go to `https://$DNS/kibana`;


## LOGSTASH

This is the part the recive the logs and process them

in logstash dir run `downlaod.sh` this is download and configure users for logstash .

then configure `/etc/kibana/logstash.yml` to match the example.

then configure `/etc/kibana/conf.d/pipeline.conf` to match the example. The parsing and socket get configured here

then run `bash ./configure.sh` this should start logstash serach you can use systemct to check its status un logs in case there is something wrong. 

Relevant config

```yaml
xpack.monitoring.elasticsearch.username: change_me
xpack.monitoring.elasticsearch.password: change_me
xpack.monitoring.elasticsearch.hosts: ["https://localhost:9200"]
```
```conf
input {
  beats {
    port => 5044 #prot to listen on
    ssl_enabled => true #ssl
    host => $DNS" #ip
    ssl_certificate => "/etc/logstash/certs/logstash/logstash.crt"
    ssl_key => "/etc/logstash/certs/logstash/logstash.key"
    ssl_client_authentication => "required" #makes auth with certs only
    ssl_certificate_authorities => ["/etc/logstash/certs/ca/ca.crt"]
  }
}
output {
  elasticsearch {
    hosts => ["https://localhost:9200"]
    user => "" #set  your username
    password => "" # set your pass
    ssl_certificate_authorities => "/etc/logstash/certs/ca/ca.crt"
  }
}
```

Filebeat will authenticate with certificates.

## FILEBEAT

This is the part that collects the logs and sends them

in filebat dir run `downlaod.sh` this is download and configure users for logstash .

then configure `/etc/filebat/filebat.yml` to match the example.

then run `bash ./configure.sh` this should start filebeat serach you can use systemct to check its status un logs in case there is something wrong. 

relevant config
```yaml
filebeat.inputs:

- type: filestream
  id: nginx-access
  enabled: true
  paths:
    - /var/log/nginx/access.log #path to logs
  fields_under_root: true #if runing as root

setup.kibana:
  host: "https://$DNS/kibana"
  ssl.enabled: true


output.logstash:
  hosts: ["$DNS:5044"]
  ssl.enabled: true
  ssl.certificate_authorities: ["/etc/filebeat/certs/ca/ca.crt"] #ca cert
  ssl.certificate: "/etc/filebeat/certs/filebeat/filebeat.crt" #filebat client crt
  ssl.key: "/etc/filebeat/certs/filebeat/filebeat.key" #filebeat key
  ssl.verification_mode: full
```


## LOGROTATE

This is the part that rotae the logs
