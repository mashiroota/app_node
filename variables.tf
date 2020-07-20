## variables AWS 
variable "REGION" {
  description = "AWS Region "
  default     = "us-east-2"
}
variable "AWS_SECRET_ACCESS_KEY" {
}
variable "AWS_ACCESS_KEY_ID" {
}

## variables ssh key
variable "AWS_PUBLIC_KEY_ZON" {
  description = "public key to my host"
}
variable "AWS_PRIVATE_KEY_ZON" { 
}

## variables PORTAINER
variable "PORTAINER_PASS" {
}
variable "PORTAINER_PORT" {
  default = "9000"
}
variable "PORTAINER_VERSION" {
  default = "1.24.0"
}

## variable tpl
variable "DOKCER_VERSION" {
  default = "1.26.2"
}
variable "TERRAFORM_VERSION" {
  default = "0.12.28"
}
variable "USERNAME" {
  default = "ec2-user"
}

## HAPROXY
variable "HAPROXY_PORT" {
  default = "30222"
}
variable "HAPROXY_STATS_PORT" {
  default = "2053"  
}
variable "HAPROXY_STATS_USER" {
  default = "admin"
}
variable "HAPROXY_STATS_PASSWORD" {
  default = "MysssStoNNgPAssWord_STAT"
}
variable "APP_NAME_1" {
  default = "hap"
  description = "haproxy name"
}

# microsocks 
variable "SOCKS_VERSION" {
  default = "1.0.195-alpine"
}
variable "SOCKS_DIRECT_VERSION" {
  default = "1.0.195-photon"
}
variable "SOCKS_USERNAME" {
  default = "admin"
  description = "microsocks proxy user name"
}
variable "SOCKS_PASSWORD" {
  default = "sTONgMmmYPASwORDd_SOCKS"
}
variable "SOCKS_DIRECT_PUBLIC_PORT" {
  default = "30555"
}

## CF & Nginx
variable "DOMAIN" {
  description = "domain name"
}
variable "APP_NAME" {
  default = "port"
  description = "portraine name"
}

# CF ACCOUNT 
variable "CF_EMAIL" {
}
variable "CF_ACCOUNT_ID" {
}
variable "CF_API_KEY" {
}
variable "CF_ZONE_ID" {
}

## monitoring
# grafana
variable "GF_ADMIN_USER" {
  default = "admin"
}
variable "GF_ADMIN_PASSWORD" {
  default = "MysssStoNNgPAssWord_GF"
}
variable "GRAFANA_VERS" {
  default = "7.1.0"
}
variable "RENDERER_VERS" {
  default = "2.0.0"
}
variable "PROMETHEUS_VERS" {
  default = "v2.19.2"
} 
variable "ALERTMANAGER_VERS" {
  default = "v0.21.0"
}
variable "NODE_EXPORTER_VERS" {
  default = "v1.0.1"
}
variable "NGINX_PROMETHEUS_EXPORTER_VERS" {
  default = "0.8.0"
}
variable "CADVISOR_VERS" {
  default = "v0.36.0"
}
variable "INFLUXDB_VERS" {
  default = "1.8-alpine"
}
variable "INFLUXDB_ADMIN_USER" {
  default = "admin"
}
variable "INFLUXDB_ADMIN_PASSWORD" {
  default = "MysssStoNNgPAssWord_DB_ADMIN"
}
variable "INFLUXDB_USER" {
  default = "user"
}
variable "INFLUXDB_USER_PASSWORD" {
  default = "MysssStoNNgPAssWord_DB_USER"
}
variable "TELEGRAF_VERS" {
  default = "1.14.5-alpine"
}
variable "SLACK_API_URL" {
  description = "slack api url for alertmanger https://hooks.slack.com/services/xxxxx/xxxxxxxxxxxxxxxxxx"
}
variable "SLACK_API_URL_GF" {
  description = "slack api url for grafana https://hooks.slack.com/services/xxxxx/xxxxxxxxxxxxxxxxxx"
}