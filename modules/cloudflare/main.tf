provider "cloudflare" {
  #version    = "~> 2.7"
  email      = var.CF_EMAIL
  account_id = var.CF_ACCOUNT_ID
  api_key    = var.CF_API_KEY
}

data "cloudflare_zones" "get" {
  filter {
    name   = var.DOMAIN
    status = "active"
    paused = false
  }
}

data "cloudflare_ip_ranges" "cloudflare" {}

resource "cloudflare_record" "app_name" {
  #zone_id = data.cloudflare_zones.get.zones[0].id
  zone_id = var.CF_ZONE_ID
  name    = var.APP_NAME
  value   = var.inst_pub_ip
  type    = "A"
  ttl     = 1 # ttl must be set to 1 when `proxied` is true
  proxied = true
}

resource "cloudflare_record" "app_name_1" {
  zone_id = var.CF_ZONE_ID
  name    = var.APP_NAME_1
  value   = var.inst_pub_ip
  type    = "A"
  ttl     = 120 
  proxied = false
}

resource "cloudflare_record" "app_name_1_stats" {
  zone_id = var.CF_ZONE_ID
  name    = "${var.APP_NAME_1}_stats"
  value   = var.inst_pub_ip
  type    = "A"
  ttl     = 1 # ttl must be set to 1 when `proxied` is true
  proxied = true
}

resource "cloudflare_page_rule" "haps" {
  zone_id = var.CF_ZONE_ID
  target = "https://${cloudflare_record.app_name_1_stats.hostname}:443"

  actions {
    forwarding_url {
      url = "https://${cloudflare_record.app_name_1_stats.hostname}:${var.HAPROXY_STATS_PORT}/"
      status_code = "301"
    }
  }
}