resource "template_dir" "config" {
  source_dir      = "${path.module}/template"
  destination_dir = "${path.cwd}/app"
  
  vars = {
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
    server_grafana                 = var.server_grafana 
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
    server_name                    = var.server_name
    server_name_1                  = var.server_name_1
    USERNAME                       = var.USERNAME
    inst_priv_ip                   = var.inst_priv_ip
  }
}  

resource "null_resource" "app" {
  connection {
    host = var.inst_pub_ip
    type     = "ssh"
    user     = var.USERNAME
    timeout  = "30s"
    private_key = var.AWS_PRIVATE_KEY_ZON
  }

  provisioner "file" {
    source      = template_dir.config.destination_dir
    destination = "/tmp"
  }
 
  provisioner "file" {
    content     = var.domain_cert
    destination = "/tmp/app/cert/${var.DOMAIN}.pem"
  }
  
  provisioner "file" {
    content     = var.domain_key
    destination = "/tmp/app/cert/${var.DOMAIN}.key"
  }  

  provisioner "file" {
    content     = var.all_sub_cert
    destination = "/tmp/app/cert/all_${var.DOMAIN}.pem"
  }
  
  provisioner "file" {
    content     = var.all_sub_key
    destination = "/tmp/app/cert/all_${var.DOMAIN}.key"
  }

  provisioner "file" {
    content   = var.haproxy_pem
     destination = "/tmp/app/cert/all_haproxy_${var.DOMAIN}.pem"
  } 

  provisioner "file" {
    content     = var.ca_cert
    destination = "/tmp/app/cert/ca.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app/run.sh",
      "sudo /tmp/app/run.sh args",
    ]
  }

}    