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
openssl dhparam -out /tmp/app/cert/nginx_dhparam.pem  1024 #4096
docker swarm init --advertise-addr ${inst_priv_ip}
docker swarm update --task-history-limit 1

if [ -d '/tmp/app' ]; then
  mv /tmp/app /opt
fi

# old trick :)
#FILE="/opt/app/portainer/pwd/pass.txt"
# if [ ! -f $FILE ] || [ ! -s $FILE ]; then
#   -nb -B admin  | echo $(cut -d ":" -f 2) > $FILE
# fi

# trick for run portainer with pass
VARC="command: -H unix:///var/run/docker.sock --admin-password "
export genpass="$VARC $(htpasswd -nb -B admin "${PORTAINER_PASS}" | cut -d ":" -f 2 | sed -r 's/[$]/\x24\x24/g')"
#echo $genpass
sed -i 's|commandpassgenport|'"$${genpass}"'|' /opt/app/docker-compose.yml
sed -i 's|commandpassgenport|'"$${genpass}"'|' /opt/app/app_node_1a.yml

cd /opt/app
docker stack deploy -c <(docker-compose -f app_node_1a.yml config) app
#docker-compose up -d
rm /opt/app/run.sh