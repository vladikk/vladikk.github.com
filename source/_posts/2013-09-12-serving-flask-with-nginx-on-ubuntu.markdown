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

### Milestone #1
Browse to your server and you should get the Nginx greeting page:
<Screenshot>

Sample application
------------------
The application we will host is literally a "Hello, world!" application. It will serve only one page, and guess what text it will contain.
All the application related files will be stored at the /var/www/demoapp folder.
	sudo mkdir /var/www
	sudo mkdir /var/www/demoapp
	cd /var/www/demoapp
	sudo virtualenv venv
	. venv/bin/activate
	sudo pip install Flask  //// <==== Fix this. It won't work with sudo
Create the hello.py file, with the following code:
'''
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()
'''
	sudo chown -R nginx:nginx /var/www/ <====== Fix this!!!

### Milestone #2
Let's execute the script we just created:
python hello.py  ////// <====== Fix this. Add host 0.0.0.0
Now you can browse to your server's port 5000 and see the app in action:
<Picture>
The app is served by Flask's built in web server. It is a great tool for developing, but it is not recommended in production environment. Let's configure Nginx to do the heavy lifting.

Configuring Nginx
-----------------
Let's start by removing the Nginx's default site configuration:
	sudo rm /etc/nginx/conf.d/default.conf
Instead, create a configuration file for our application:
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
        uwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;
    }    
}
'''
And symlink it to Nginx configuration files' directory:
	sudo ln -s /var/www/demoapp/demoapp_nginx.conf /etc/nginx/conf.d/
All the files should be owned by the nginx user:
	sudo chown -R nginx:nginx /var/www/
Restart Nginx to reload configuration files:
	sudo /etc/init.d/nginx restart

### Milestone #3
Browser to server's public ip address, and you will get a 502 error:
<Picture>
Actually, this is a "good" error. It says that Nginx uses the configuration file we just created, but it has a trouble connecting to our Python application host, uWSGI. The connection to uWSGI is defined in the configuration file at line #10:
	uwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;
It says that Nginx should use a socket file, located at /var/www/demoapp/demoapp_uwsgi.sock to communicate with uWSGI. We still haven't configured uWSGI, thereforr the file doesn't exist, and Nginx returns the "bad gateway error". Let's fix this now.

Configuring uWSGI
-----------------
Create a new uWSGI configuration file:
	sudo vim /var/www/demoapp/demoapp_uwsgi.ini
'''
[uwsgi]
base = /var/www/demoapp
app = hello
home = %(base)/venv
pythonpath = %(base)
socket = /var/www/demoapp/%n.sock
module = %(app)
callable = app
chmod-socket    = 666
logto = /var/log/uwsgi/%n.log
'''
This configuration states a few things:
Line #1: Our applications base folder
Line #2: Python module to import
Line #5: The socket file's location
Line #7: The variable that hold our Flask application
Line #9: Location for a log file

Let's create a folder for log files, and make nginx its owner:
	sudo mkdir -p /var/log/uwsgi
	sudo chown -R nginx:nginx /var/log/uwsgi

### Milestone #4
Let's execute uWSGI and pass it the newly created configuration file:
	uwsgi --ini /var/www/demoapp/demoapp/_uwsgi.ini
Next, browse to your server. Now Nginx should be able to connect to uWSGI process, and display our very informative page:
<Picture>

We are almost finished. The only thing left to do, is to configure uWSGI to run as a background service. That's a task of uWSGI Emperor.

uWSGI Emperor
-------------
uWSGI Emperor (quite a name, isn't it?) is responsible for reading configuration files, like the one we just created, and spawing processes to execute them.
Create a new upstart configuration file to execute emperor:
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
Line #9 tells emperor to look for config files at the /etc/uwsgi/vassals folder. Let's create the folder:
	sudo mkdir /etc/uwsgi
	sudo mkdir /etc/uwsgi/vassals
And symlink our app's uwsgi config file into it:
	sudo ln -s /var/www/demoapp/demoapp_uwsgi.ini /etc/uwsgi/vassals
Now we can start the uWSGI job:
	sudo start uwsgi

### Milestone #5
Now both Nginx and uWSGI are configured to correctly server our application on system start up:
<Picture>