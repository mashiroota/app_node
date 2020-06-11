variable "letsencrypt_api_endpoint" {
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  description = "API endpoint.  default to prod.  for staging use: https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "letsencrypt_dns_provider" {
  description = "dns provider for dns01 challenge"
  default     = "cloudflare"
}

variable "all_subdomain" {
  description = "subdomain where apps will be deployed"
  default     = "*"
}

variable "DOMAIN" {
  description = "dns CNAME for master VIP"
}

variable "dns_servers" {
  type    = "list"
  default = ["1.1.1.1:53"]
}

variable "CF_API_KEY"  {
}

variable "CF_EMAIL" {
}