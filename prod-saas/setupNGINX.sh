#!/bin/bash -e

prepVM() {
  echo "deb http://archive.ubuntu.com/ubuntu precise restricted multiverse" >> /etc/apt/sources.list
  apt-get update
  apt-get install -y python-software-properties software-properties-common
}

installNGINX() {
  apt-add-repository -y ppa:nginx/stable
  apt-get update
  apt-get install -y nginx
  echo "daemon off;" >> /etc/nginx/nginx.conf
  cp default /etc/nginx/sites-enabled/default
}

startNGINX() {
  service nginx start
}

main() {
  prepVM
  installNGINX
  #startNGINX
}

main
