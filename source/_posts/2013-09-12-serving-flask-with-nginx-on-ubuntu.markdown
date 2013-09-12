---
layout: post
title: "Serving Flask with Nginx on Ubuntu"
date: 2013-09-12 22:37
comments: true
categories: Python, Nginx
published: false
keywords: python, flask, nginx, uwsgi, ubuntu, amazon, ec2, aws, tutorial
description: 
---

My background
-------------
I'm a software engineer with double digit years of experience developing complex applications in various languages. Having spent the majority of my career in the Microsoft stake, lately I've decided to step out of my comfort zone and to dive into the world of open source software. The project I'm currently working on at my day job is a RESTful service. The service should be running on commodity hardware, that can be scaled horizontally as needed. To do the job I've decided to use Flask and Nginx. Flask is a lightweight Python web framework, and Nginx is a highly stable web server, that runs extremely well on cheap hardware, namely EC2 micro-instances.

In this post I will show you how to get up and running with serving Flask apps on Nginx servers. The OS I'll be using is Ubuntu 13.04. Before we install Nginx and other required software, let's install some prerequisites.

Prerequisites
-------------
First, we will need PIP to download packages:
	sudo apt-get install python-setuptools
	sudo easy_install pip
We will use virtualenv to isolate our application's environment:
	sudo pip install virtualenv

To install Nginx from apt-get, we have to add Nginx repositories apt-get sources:
	wget http://nginx.org/keys/nginx_signing.key
	apt-key add nginx_signing.key
	rm nginx_signing.key
	echo "deb http://nginx.org/packages/ubuntu/ raring nginx" >> /etc/apt/sources.list
	echo "deb-src http://nginx.org/packages/ubuntu/ raring nginx" >> /etc/apt/sources.list
(Note: At the time of this writing, I am using Ubuntu 13.04, therefore I'm using the codename "raring". If you are running other version, use your repository version instead. More info: http://nginx.org/en/linux_packages.html#stable)

Update repositories and upgrade existing packages:
	sudo apt-get update && apt-get upgrade

Packages required for uWSGI:
	sudo apt-get install build-essential python python-dev

Nginx
-----
Install and start Nginx:
	sudo apt-get install nginx
	sudo /etc/init.d/nginx start

Nginx is a web server. It serves static files, however it cannot execute and host Python application. uWSGI fills that gap. Let's install it first, and later we'll see how Nginx and uWSGI are talking to each other.
	sudo pip install uwsgi

Sample application
------------------
The application we will host is literally a "Hello, world!" application. It will serve only on page, and guess what it will contain.
All the application related files will be stored at the /var/www/demoapp folder.
	sudo mkdir /var/www
	sudo mkdir /var/www/demoapp
	cd /var/www/demoapp
	sudo virtualenv venv
	. venv/bin/activate
	sudo pip install Flask  //// <==== Fix this. It won't work with sudo

sudo vim hello.py
'''
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()
'''

sudo wget https://raw.github.com/nginx/nginx/master/conf/uwsgi_params
sudo chown -R nginx:nginx /var/www/

5. configure nginx
sudo rm /etc/nginx/conf.d/default.conf
sudo vim /var/www/demoapp/demoapp_nginx.conf
'''
server {
    listen      80;
    server_name localhost;
    charset     utf-8;
    client_max_body_size 75M;

    location / { try_files $uri @yourapplication; }
    location @yourapplication {
        include uwsgi_params;
        uwsgi_pass unix:/var/www/run/demoapp_uwsgi.sock;
    }    
}
'''
sudo mkdir -p /var/www/run
sudo chown -R nginx:nginx /var/www/
sudo ln -s /var/www/demoapp/demoapp_nginx.conf /etc/nginx/conf.d/
sudo /etc/init.d/nginx restart

6. configure uwsgi
sudo mkdir -p /var/log/uwsgi
sudo chown -R nginx:nginx /var/log/uwsgi
sudo vim /var/www/demoapp/demoapp_uwsgi.ini
'''
[uwsgi]
# Variables
base = /var/www/demoapp
app = hello
# Generic Config
# plugins = http,python
home = %(base)/venv
pythonpath = %(base)
socket = /var/www/run/%n.sock
module = %(app)
callable = app
chmod-socket    = 666
logto = /var/log/uwsgi/%n.log
env = PRODUCTION=true
'''
sudo mkdir /etc/uwsgi
sudo mkdir /etc/uwsgi/vassals
sudo ln -s /var/www/demoapp/demoapp_uwsgi.ini /etc/uwsgi/vassals

7. uWSGI Emperor
sudo vim /etc/init/uwsgi.conf
'''
description "uWSGI"
start on runlevel [2345]
stop on runlevel [06]
respawn

env UWSGI=/usr/local/bin/uwsgi
env LOGTO=/var/log/uwsgi/emperor.log

exec $UWSGI --master --emperor /etc/uwsgi/vassals --die-on-term --uid nginx --gid nginx --logto $LOGTO
'''
sudo start uwsgi


Then update the sources list and install Nginx.
apt-get update && apt-get install nginx

http://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world
http://jyunderwood.com/posts/serving-php-with-nginx-on-ubuntu.html