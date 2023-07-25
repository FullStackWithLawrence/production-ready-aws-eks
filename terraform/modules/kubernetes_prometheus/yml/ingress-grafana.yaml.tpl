apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus-grafana
  namespace: prometheus
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: ${cluster_issuer}
spec:
  tls:
  - hosts:
    - "grafana.${domain}"
    secretName: ${domain}-tls
  rules:
  - host: grafana.${domain}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: prometheus-grafana
            port:
              number: 3000
