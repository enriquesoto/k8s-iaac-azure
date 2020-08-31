admin:
  existingSecret: ${LOGIN_SECRETS}
  userKey: admin-user
  passwordKey: admin-password
grafana.ini:
  server:
    domain: ${DOMAIN}
  paths:
    data: /var/lib/grafana/data
    logs: /var/log/grafana
    plugins: /var/lib/grafana/plugins
    provisioning: /etc/grafana/provisioning
  analytics:
    check_for_updates: true
  log:
    mode: console
  grafana_net:
    url: https://grafana.net
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  hosts:
    - ${DOMAIN}
  tls:
    - secretName: prometheus-tls
      hosts:
        - ${DOMAIN}
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        orgId: 1
        url: http://prometheus-server.monitoring

dashboards:
  default:
    custom-dashboard:
      # This is a path to a file inside the dashboards directory inside the chart directory
      file: grafana-dashboards/kubernetes-cluster-monitoring_rev6.json
    prometheus-stats:
      # Ref: https://grafana.com/dashboards/2
      gnetId: 2
      revision: 2
      datasource: Prometheus