FROM scratch

WORKDIR /app

# prometheus-nginxlog-exporter default port 4040
COPY --from=quay.io/martinhelmich/prometheus-nginxlog-exporter:v1.4.1 /prometheus-nginxlog-exporter /usr/bin/prometheus-nginxlog-exporter

# nginx-prometheus-exporter default port 9113
COPY --from=nginx/nginx-prometheus-exporter:0.6.0 /usr/bin/exporter /usr/bin/prometheus-nginx-exporter

