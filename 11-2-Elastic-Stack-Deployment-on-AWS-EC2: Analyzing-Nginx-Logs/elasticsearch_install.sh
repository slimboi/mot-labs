#!/bin/bash
apt-get update
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install -y elasticsearch kibana logstash

# Elasticsearch configurations
cp /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.bak
sed -i 's/^## -Xmx4g/-Xmx1g/' /etc/elasticsearch/jvm.options
sed -i 's/^## -Xms4g/-Xms1g/' /etc/elasticsearch/jvm.options

# Kibana configurations
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak
sed -i 's/^#server.host: .*/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml

# Create Logstash Nginx configuration and pattern
mkdir -p /etc/logstash/pattern
chmod 755 /etc/logstash/pattern

# Nginx configuration
cat << 'EOF' > /etc/logstash/conf.d/nginx.conf
input {
  beats {
    port => 5044
  }
}
filter {
    grok {
      patterns_dir => ["/etc/logstash/pattern"]
      match => { "message" => "%{IPORHOST:clientip} %{NGUSER:ident} %{NGUSER:auth} \[%{HTTPDATE:timestamp}\] \"%{WORD:verb} %{URIPATHPARAM:request} HTTP/%{NUMBER:httpversion}\" %{NUMBER:response}" }
    }
}
output {
  elasticsearch {
      hosts => ["127.0.0.1:9200"]
      index => "nginx-%{+YYYY.MM.dd}"
  }
}
EOF

# Nginx pattern
cat << 'EOF' > /etc/logstash/pattern/nginx
NGUSERNAME [a-zA-Z\.\@\-\+_%]+
NGUSER %{NGUSERNAME}
EOF

# Start and enable services
systemctl daemon-reload
systemctl start elasticsearch.service
systemctl start kibana.service
systemctl start logstash.service
systemctl enable elasticsearch.service
systemctl enable kibana.service
systemctl enable logstash.service