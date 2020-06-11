resource "template_dir" "config" {
  source_dir      = "${path.module}/template"
  destination_dir = "${path.cwd}/app"
  
  vars = {
    PORTAINER_VERSION        = var.PORTAINER_VERSION
    PORTAINER_PORT           = var.PORTAINER_PORT
    PORTAINER_PASS           = var.PORTAINER_PASS
    HAPROXY_PORT             = var.HAPROXY_PORT 
    HAPROXY_STATS_PORT       = var.HAPROXY_STATS_PORT
    HAPROXY_STATS_USER       = var.HAPROXY_STATS_USER 
    HAPROXY_STATS_PASSWORD   = var.HAPROXY_STATS_PASSWORD
    TERRAFORM_VERSION        = var.TERRAFORM_VERSION
    SOCKS_DIRECT_PUBLIC_PORT = var.SOCKS_DIRECT_PUBLIC_PORT
    SOCKS_VERSION            = var.SOCKS_VERSION
    SOCKS_USERNAME           = var.SOCKS_USERNAME
    SOCKS_PASSWORD           = var.SOCKS_PASSWORD
    DOKCER_VERSION           = var.DOKCER_VERSION
    DOMAIN                   = var.DOMAIN
    server_name              = var.server_name
    server_name_1            = var.server_name_1
    USERNAME                 = var.USERNAME
    inst_priv_ip             = var.inst_priv_ip         
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