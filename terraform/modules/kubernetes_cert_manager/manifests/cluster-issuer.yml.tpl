apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${domain}
  namespace: ${namespace}
spec:
  acme:
    email: no-reply@${domain}
    privateKeySecretRef:
      name: ${domain}
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          # hosted Zone ID for the admin domain.
          route53:
            region: ${aws_region}
            hostedZoneID: ${hosted_zone_id}
