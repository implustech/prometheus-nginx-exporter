# Usage

https://github.com/nginxinc/nginx-prometheus-exporter

https://github.com/martin-helmich/prometheus-nginxlog-exporter

# Docker-compose.yml

```
version: '3.2'

services:
  nginx-exporter:  
    image: {{docker_image}}
    command: /usr/bin/prometheus-nginx-exporter
    restart: always
    hostname: {{hostname}} 
    container_name: nginx-exporter
    ports:
      - "9113:9113"
    environment:
      - SCRAPE_URI=http://{{private_ip}}:7788/nginx_status


  nginx-log-exporter:
    image: {{docker_image}}
    command: /usr/bin/prometheus-nginxlog-exporter -config-file /etc/prometheus-nginxlog-exporter.hcl
    restart: always
    hostname: {{hostname}} 
    container_name: nginx-log-exporter
    ports:
      - "9114:4040"
    volumes:
      - "/opt/log/nginx/servers.log:/var/log/nginx/access.log"
      - "./config.hcl:/etc/prometheus-nginxlog-exporter.hcl"


```

# config.hcl
```
listen {
  port = 4040
}

consul {
  enable = false
  address = "localhost:8500"
  datacenter = "dc1"
  scheme = "http"
  token = ""
  service {
    id = "nginx-exporter"
    name = "nginx-exporter"
    tags = ["foo", "bar"]
  }
}

namespace "nginx" {
  format = "$host $remote_addr $remote_user [$time_local] $uri \"$request\" $request_length $status $bytes_sent $body_bytes_sent $request_time \"$http_referer\" \"$http_user_agent\" $content_type $upstream_cache_status $upstream_response_time $upstream_addr"
  source {
    files = [
      "/var/log/nginx/access.log"
    ]
  }

  histogram_buckets = [.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10]
}
```


