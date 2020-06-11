provider "acme" {
  server_url = var.letsencrypt_api_endpoint
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
    account_key_pem = tls_private_key.private_key.private_key_pem
    email_address   = var.CF_EMAIL
}

resource "acme_certificate" "domain_certificate" {
  account_key_pem       = acme_registration.reg.account_key_pem
  common_name           = var.DOMAIN
  recursive_nameservers = var.dns_servers

  dns_challenge {
    provider = var.letsencrypt_dns_provider
    config = {
      CLOUDFLARE_EMAIL   = var.CF_EMAIL
       CF_API_KEY        = var.CF_API_KEY
    }
  }
}

resource "acme_certificate" "all_subdomain_certificate" {
  account_key_pem       = acme_registration.reg.account_key_pem
  common_name           = "*.${var.DOMAIN}"
  recursive_nameservers = var.dns_servers

  dns_challenge {
    provider = var.letsencrypt_dns_provider
    config = {
      CLOUDFLARE_EMAIL   = var.CF_EMAIL
      CF_API_KEY         = var.CF_API_KEY
    }
  }
}

data "http" "letsencrypt_ca_cert" {
  url = "https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt"
}

