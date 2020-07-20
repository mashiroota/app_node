output "id" {
  #value = data.cloudflare_zones.get.zones[0].id
  value = var.CF_ZONE_ID
}

output "cf_ip_range_ip4" {
  value = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
}

output "cf_ip_range_ip6" {
  value = data.cloudflare_ip_ranges.cloudflare.ipv6_cidr_blocks
}

output "cf_recor_FQDN" {
  value =  cloudflare_record.app_name.hostname
}

output "cf_recor_FQDN_1" {
  value =  cloudflare_record.app_name_1.hostname
}

output "cf_recor_FQDN_GRAFANA" {
  value =  cloudflare_record.grafana.hostname
}