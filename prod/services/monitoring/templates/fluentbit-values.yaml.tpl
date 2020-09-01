input:
  tail:
    memBufLimit: 5MB
    parser: docker
    path: /var/log/containers/*.log
  systemd:
    enabled: false
    filters:
      systemdUnit:
        - docker.service
        - kubelet.service
        - node-problem-detector.service
    maxEntries: 1000
    readFromTail: true
    tag: host.*

parsers:
  enabled: true
  regex:
    - name: k8s-nginx-ingress
      regex: '^(?<host>[^ ]*) - \[(?<real_ip>)[^ ]*\] - (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*) "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" (?<request_length>[^ ]*) (?<request_time>[^ ]*) \[(?<proxy_upstream_name>[^ ]*)\] \[] (?<upstream_addr>[^ ]*) (?<upstream_response_length>[^ ]*) (?<upstream_response_time>[^ ]*) (?<upstream_status>[^ ]*) (?<last>[^$]*)'
      timeKey: time
      Time_Format: "%d/%b/%Y:%H:%M:%S %z"
    - 

filter:
  kubeURL: https://kubernetes.default.svc:443
  kubeCAFile: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  kubeTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubeTag: kube.*
  kubeTagPrefix: kube.var.log.containers.

  # If true, check to see if the log field content is a JSON string map, if so,
  # it append the map fields as part of the log structure.
  mergeJSONLog: true

  # If set, all unpacked keys from mergeJSONLog (Merge_Log) will be packed under
  # the key name specified on mergeLogKey (Merge_Log_Key)
  mergeLogKey: ""

  # If true, enable the use of monitoring for a pod annotation of
  # fluentbit.io/parser: parser_name. parser_name must be the name
  # of a parser contained within parsers.conf
  enableParser: true

  # If true, enable the use of monitoring for a pod annotation of
  # fluentbit.io/exclude: true. If present, discard logs from that pod.
  enableExclude: true

backend:
  type: es
  es:
    host: ${ES_HOST}
    port: 9243
    # Elastic Index Name
    index: kubernetes_cluster
    type: flb_type
    logstash_prefix: kubernetes_cluster
    replace_dots: "On"
    time_key: "@timestamp"
    # Optional username credential for Elastic X-Pack access
    http_user: ${ES_USER}
    # Password for user defined in HTTP_User
    http_passwd: ${ES_PASSWORD}
    # Optional TLS encryption to ElasticSearch instance
    tls: "on"
    tls_verify: "on"
    # TLS certificate for the Elastic (in PEM format). Use if tls=on and tls_verify=on.
    tls_ca: ""
    # TLS debugging levels = 1-4
    tls_debug: 1