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
  default = "1.25.5"
}
variable "TERRAFORM_VERSION" {
  default = "0.12.26"
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
  default = "MysssStoNNgPAssWord"
}
variable "APP_NAME_1" {
  description = "haproxy name"
}

# microsocks 
variable "SOCKS_VERSION" {
  default = "latest"
}
variable "SOCKS_USERNAME" {
  default = "admin"
}
variable "SOCKS_PASSWORD" {
  default = "sTONgMmmYPASwORDd"
}
variable "SOCKS_DIRECT_PUBLIC_PORT" {
  default = "30555"
}

## CF & Nginx
variable "DOMAIN" {
  description = "domain name"
}
variable "APP_NAME" {
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
