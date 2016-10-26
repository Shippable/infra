#!/bin/bash -e

prepVM() {
  sudo echo "deb http://archive.ubuntu.com/ubuntu precise restricted multiverse" >> /etc/apt/sources.list
  sudo apt-get update
  sudo apt-get install -y python-software-properties software-properties-common
}

installNGINX() {
  sudo apt-add-repository -y ppa:nginx/stable
  sudo apt-get update
  sudo apt-get install -y nginx
  sudo echo "daemon off;" >> /etc/nginx/nginx.conf
  sudo cp default /etc/nginx/sites-enabled/default
}

startNGINX() {
  sudo service nginx start
}

main() {
  prepVM
  installNGINX
  startNGINX
}

main
