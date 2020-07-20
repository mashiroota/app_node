provider "aws" {
  region = var.REGION
}

data "aws_availability_zones" "working" {}

resource "aws_instance" "app_node_1a" {
  ami           = "ami-0f7919c33c90f5b58"
  instance_type = "t2.micro"
  root_block_device {
    volume_size = 8
  }
  
  key_name = "main_2"
  vpc_security_group_ids = [aws_security_group.app_node_1a_SG.id]
  
  #user_data = file("run.sh")
  tags = {
    Name    = "app_node_1a"
    TypeGen = "terraform"
  }
}

## CF configure
module "cloudflare" {
  source             = "./modules/cloudflare"
  DOMAIN             = var.DOMAIN
  APP_NAME           = var.APP_NAME
  APP_NAME_1         = var.APP_NAME_1
  inst_pub_ip        = aws_instance.app_node_1a.public_ip
  CF_EMAIL           = var.CF_EMAIL
  CF_ACCOUNT_ID      = var.CF_ACCOUNT_ID
  CF_API_KEY         = var.CF_API_KEY
  CF_ZONE_ID         = var.CF_ZONE_ID
  HAPROXY_STATS_PORT = var.HAPROXY_STATS_PORT
}

## ACME generate
module "acme" {
  source     = "./modules/acme"
  CF_EMAIL   = var.CF_EMAIL
  CF_API_KEY = var.CF_API_KEY
  DOMAIN     = var.DOMAIN
} 

## install base script
module "app" {
  source                         = "./modules/app"
  AWS_PRIVATE_KEY_ZON            = var.AWS_PRIVATE_KEY_ZON
  USERNAME                       = var.USERNAME
  PORTAINER_VERSION              = var.PORTAINER_VERSION
  PORTAINER_PORT                 = var.PORTAINER_PORT
  PORTAINER_PASS                 = var.PORTAINER_PASS
  HAPROXY_PORT                   = var.HAPROXY_PORT 
  HAPROXY_STATS_PORT             = var.HAPROXY_STATS_PORT
  HAPROXY_STATS_USER             = var.HAPROXY_STATS_USER 
  HAPROXY_STATS_PASSWORD         = var.HAPROXY_STATS_PASSWORD
  TERRAFORM_VERSION              = var.TERRAFORM_VERSION
  SOCKS_DIRECT_PUBLIC_PORT       = var.SOCKS_DIRECT_PUBLIC_PORT
  SOCKS_VERSION                  = var.SOCKS_VERSION
  SOCKS_DIRECT_VERSION           = var.SOCKS_DIRECT_VERSION
  SOCKS_USERNAME                 = var.SOCKS_USERNAME
  SOCKS_PASSWORD                 = var.SOCKS_PASSWORD
  DOKCER_VERSION                 = var.DOKCER_VERSION
  DOMAIN                         = var.DOMAIN
  server_name                    = module.cloudflare.cf_recor_FQDN
  server_name_1                  = module.cloudflare.cf_recor_FQDN_1
  server_grafana                 = module.cloudflare.cf_recor_FQDN_GRAFANA
  GF_ADMIN_PASSWORD              = var.GF_ADMIN_PASSWORD
  GF_ADMIN_USER                  = var.GF_ADMIN_USER
  GRAFANA_VERS                   = var.GRAFANA_VERS
  RENDERER_VERS                  = var.RENDERER_VERS
  PROMETHEUS_VERS                = var.PROMETHEUS_VERS
  ALERTMANAGER_VERS              = var.ALERTMANAGER_VERS
  NODE_EXPORTER_VERS             = var.NODE_EXPORTER_VERS
  NGINX_PROMETHEUS_EXPORTER_VERS = var.NGINX_PROMETHEUS_EXPORTER_VERS
  CADVISOR_VERS                  = var.CADVISOR_VERS
  TELEGRAF_VERS                  = var.TELEGRAF_VERS
  INFLUXDB_VERS                  = var.INFLUXDB_VERS
  INFLUXDB_ADMIN_USER            = var.INFLUXDB_ADMIN_USER  
  INFLUXDB_ADMIN_PASSWORD        = var.INFLUXDB_ADMIN_PASSWORD 
  INFLUXDB_USER                  = var.INFLUXDB_USER
  INFLUXDB_USER_PASSWORD         = var.INFLUXDB_USER_PASSWORD
  SLACK_API_URL                  = var.SLACK_API_URL
  SLACK_API_URL_GF               = var.SLACK_API_URL_GF 
  inst_pub_ip                    = aws_instance.app_node_1a.public_ip
  inst_priv_ip                   = aws_instance.app_node_1a.private_ip
  domain_cert                    = module.acme.domain_cert
  domain_key                     = module.acme.domain_key
  all_sub_cert                   = module.acme.all_sub_cert
  all_sub_key                    = module.acme.all_sub_key
  haproxy_pem                    = module.acme.haproxy_pem
  ca_cert                        = module.acme.ca_cert 
}  

## ssh_key_public add to aws  
resource "aws_key_pair" "main_2" {
  key_name   = "main_2"
  public_key = var.AWS_PUBLIC_KEY_ZON 
}

## security grop add 
resource "aws_security_group" "app_node_1a_SG" {
  name        = "app_node_1a_SG"
  description = "security group app_node_a1 gen terraform"
  
  dynamic "ingress" {
    for_each = ["22","80",var.SOCKS_DIRECT_PUBLIC_PORT,var.HAPROXY_PORT]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

/*  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = module.cloudflare.cf_ip_range_ip4
  }
*/

  dynamic "ingress" {
    for_each = ["443", var.HAPROXY_STATS_PORT]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = module.cloudflare.cf_ip_range_ip4
    }
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name    = "security group app_node_a1 proxy server"
    typeGen = "terraform cloud"
  }

}