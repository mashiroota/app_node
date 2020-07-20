#!/bin/bash

# install
sudo yum update -y
sudo yum install mc -y
sudo yum install docker -y
sudo usermod -aG docker ${USERNAME}
sudo service docker start
sudo chkconfig docker on
sudo curl -L "https://github.com/docker/compose/releases/download/${DOKCER_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo curl -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /home/${USERNAME}/terraform.zip
sudo unzip /home/${USERNAME}/terraform.zip -d /home/${USERNAME}
sudo mv /home/${USERNAME}/terraform /opt
sudo chmod +x /opt/terraform
sudo ln -s /opt/terraform /usr/bin/terraform
sudo rm -f /home/${USERNAME}/terraform.zip
sudo yum install httpd-tools -y
sudo yum install python3 -y
sudo amazon-linux-extras install epel
sudo yum install s3cmd -y
openssl dhparam -out /tmp/app/cert/nginx_dhparam.pem  1024 #4096
sudo yum install nc -y
sudo yum install htop -y
sudo yum install iperf3 -y
docker swarm init --advertise-addr ${inst_priv_ip}
docker swarm update --task-history-limit 1

if [ -d '/tmp/app' ]; then
  mv /tmp/app /opt
fi

cat > "/etc/logrotate.d/nginx" << 'EOF'
/opt/app/nginx/log/*.log {
  daily
  compress
  delaycompress
  rotate 2
  missingok
  nocreate
  sharedscripts
  postrotate
     sudo docker exec -it $(docker ps -f name=webserver --format {{.Names}}) sh -c "nginx -s reload";
  endscript
}
EOF

# trick for run portainer with pass
VARC="command: -H unix:///var/run/docker.sock --admin-password "
export genpass="$VARC $(htpasswd -nb -B admin "${PORTAINER_PASS}" | cut -d ":" -f 2 | sed -r 's/[$]/\x24\x24/g')"
sed -i 's|commandpassgenport|'"$${genpass}"'|' /opt/app/app_node_1a.yml

# CF & ingress real_ip
INS=$(docker network inspect ingress --format="{{json .IPAM.Config}}" |  python3 -c "import sys, json; print(json.loads(sys.stdin.read()[1:-2]).get('Subnet'))")
sed -i 's|INS|'"$${INS}"'|' /opt/app/nginx/conf.d/inc
chmod +x /opt/app/nginx/cloudflare-update-ip-ranges.sh
sudo /opt/app/nginx/cloudflare-update-ip-ranges.sh

cd /opt/app
docker stack deploy -c <(docker-compose -f app_node_1a.yml config) app
#docker network connect monitor $(docker ps -f name=webserver --format {{.Names}})
docker-compose up -d
rm /opt/app/run.sh