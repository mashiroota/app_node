sudo yum install gcc openssl-devel bzip2-devel libffi-devel -y
sudo curl -L "https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz" -o /opt/Python-3.8.2.tgz
sudo tar xzf /opt/Python-3.8.2.tgz -C /opt
sudo rm -f /opt/Python-3.8.2.tgz
cd /opt/Python-3.8.2
sudo ./configure --enable-optimizations
sudo make altinstall
