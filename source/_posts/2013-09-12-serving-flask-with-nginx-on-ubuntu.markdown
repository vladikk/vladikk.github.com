---
layout: post
title: "Serving Flask with Nginx"
date: 2013-09-12 22:37
comments: true
categories: Python Nginx Flask
published: true
keywords: python, flask, nginx, uwsgi, ubuntu, amazon, ec2, aws, tutorial
description: In this post I'll walk you through the process of installing and configuring the nginx server to host Flask applications.
---

Having spent the majority of my career in the Microsoft stack, lately I've decided to step out of my comfort zone and to dive into the world of open source software. The project I'm currently working on at my day job is a RESTful service. The service will be running on a commodity hardware, that should be able to scale horizontally as needed. To do the job I've decided to use Flask and Nginx. Flask is a lightweight Python web framework, and nginx is a highly stable web server, that works great on cheap hardware.

In this post I will guide you through the process of installing and configuring nginx server to host Flask based applications. The OS I'll be using is Ubuntu 13.04.

Prerequisites
-------------
Before we install Nginx and other required software, let's install some prerequisites. First, we will need PIP and Virtualenv:
``` bash
sudo apt-get install python-setuptools
sudo easy_install pip
sudo pip install virtualenv
```

To install nginx from apt-get, we have to add Nginx repositories apt-get sources:
``` bash
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
rm nginx_signing.key
echo "deb http://nginx.org/packages/ubuntu/ raring nginx" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://nginx.org/packages/ubuntu/ raring nginx" | sudo tee -a /etc/apt/sources.list
```
*Note: At the time of this writing, I am using Ubuntu 13.04, therefore on lines 4 and 5 I'm using the codename "raring". If you are running other version of Ubuntu, use your repository version instead. [More info on nginx.org](http://nginx.org/en/linux_packages.html#stable)*

Upgrade existing packages and make sure you have the required compilers and tools for uWSGI:
``` bash
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential python python-dev
```
<!-- more -->

Nginx
-----
Install and start Nginx:
``` bash
sudo apt-get install nginx
sudo /etc/init.d/nginx start
```

Nginx is a web server. It serves static files, however it cannot execute and host Python application. uWSGI fills that gap. Let's install it first, and later we'll configure nginx and uWSGI to talk to each other.
``` bash
sudo pip install uwsgi
```

### Milestone #1
Browse to your server and you should get the Nginx greeting page:
<img src="{{ root_url }}/images/nginx-flask-ubuntu/milestone_1.png" alt="nginx" />

Sample application
------------------
The application we will host is literally a "Hello, world!" application. It will serve only one page, and guess what text it will contain.
All the application related files will be stored at the /var/www/demoapp folder. Let's create this folder, and initialize a virtual environment in it:
``` bash
sudo mkdir /var/www
sudo mkdir /var/www/demoapp
cd /var/www/demoapp
sudo virtualenv venv
sudo venv/bin/pip install flask
```
Create the hello.py file, with the following code:
``` python /var/www/demoapp/hello.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=81)
```

### Milestone #2
Let's execute the script we've just created:
``` bash
sudo venv/bin/python hello.py
```
Now you can browse to your server's port 81 and see the app in action:
<img src="{{ root_url }}/images/nginx-flask-ubuntu/milestone_1.png" alt="flask" />
*Note: I've used port 81 because port 80 is already in use by nginx*

Currently the app is served by Flask's built in web server. It is a great tool for development needs, but it is not recommended in production environment. Let's configure nginx to do the heavy lifting.

Configuring Nginx
-----------------
Let's start by removing the Nginx's default site configuration:
``` bash
	sudo rm /etc/nginx/conf.d/default.conf
	sudo vim /var/www/demoapp/demoapp_nginx.conf
```
Instead create a new configuration file for our application **/var/www/demoapp/demoapp_nginx.conf**:
``` text /var/www/demoapp/demoapp_nginx.conf
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
```
And symlink the new file to nginx's configuration files directory and restart nginx:
``` bash
	sudo ln -s /var/www/demoapp/demoapp_nginx.conf /etc/nginx/conf.d/
	sudo /etc/init.d/nginx restart
```

### Milestone #3
Browser to server's public ip address, and you will be greeted by an error:
<img src="{{ root_url }}/images/nginx-flask-ubuntu/milestone_3.png" alt="502" />
No need to worry, this is a "good" error. It says that nginx uses the configuration file we just created, but it has a trouble connecting to our Python application host, uWSGI. The connection to uWSGI is defined in the configuration file at line #10:
	uwsgi_pass unix:/var/www/demoapp/demoapp_uwsgi.sock;
It says that the communication between nginx and uWSGI is done via a socket file, that should be located at */var/www/demoapp/demoapp_uwsgi.sock*. Since we still haven't configured uWSGI yet, the file doesn't exist, and Nginx returns the "bad gateway" error. Let's fix this now.

Configuring uWSGI
-----------------
Create a new uWSGI configuration file **/var/www/demoapp/demoapp_uwsgi.ini**:
``` text /var/www/demoapp/demoapp_uwsgi.ini
[uwsgi]
#application's base folder
base = /var/www/demoapp

#python module to import
app = hello
module = %(app)

home = %(base)/venv
pythonpath = %(base)

#socket file's location
socket = /var/www/demoapp/%n.sock

#permissions for the socket file
chmod-socket    = 666

#the variable that holds a flask application inside the module imported at line #6
callable = app

#location of log files
logto = /var/log/uwsgi/%n.log

```
Let's create a new directory for uwsgi log files:
``` bash
sudo mkdir -p /var/log/uwsgi
```

### Milestone #4
Let's execute uWSGI and pass it the newly created configuration file:
``` bash
sudo uwsgi --ini /var/www/demoapp/demoapp_uwsgi.ini
```
Next, browse to your server. Now nginx should be able to connect to uWSGI process:
<img src="{{ root_url }}/images/nginx-flask-ubuntu/milestone_4.png" alt="uwsgi" />

We are almost finished. The only thing left to do, is to configure uWSGI to run as a background service. That's the duty of uWSGI Emperor.

uWSGI Emperor
-------------
uWSGI Emperor (quite a name, isn't it?) is responsible for reading configuration files and spawing uWSGI processes to execute them.
Create a new upstart configuration file to execute emperor - **/etc/init/uwsgi.conf**:
``` bash /etc/init/uwsgi.conf
description "uWSGI"
start on runlevel [2345]
stop on runlevel [06]
respawn

env UWSGI=/usr/local/bin/uwsgi
env LOGTO=/var/log/uwsgi/emperor.log

exec $UWSGI --master --emperor /etc/uwsgi/vassals --die-on-term --uid nginx --gid nginx --logto $LOGTO
```

The last line executes the uWSGI daemon and sets it to look for config files in the **/etc/uwsgi/vassals** folder. Let's create this folder and symlink the configuration file we created earlier into it:
``` bash
	sudo mkdir /etc/uwsgi && sudo mkdir /etc/uwsgi/vassals
	sudo ln -s /var/www/demoapp/demoapp_uwsgi.ini /etc/uwsgi/vassals
```
Also, the last line states the the user that will be used to execute the daemon is nginx. For simplicity's sake, let's set him as the owner of the application and log folder:
``` bash
	sudo chown -R nginx:nginx /var/www/demoapp/
	sudo chown -R nginx:nginx /var/log/uwsgi/
```
Since both, nginx and uWSGI, are now being run by the same user, we can make a security improvement to our uWSGI configuration. Open up the uwsgi config file and change the value of chmod-socket from **666** to **644**:
``` text /var/www/demoapp/demoapp_uwsgi.ini
...
#permissions for the socket file
chmod-socket    = 644
```

Now we can start the uWSGI job:
``` bash
	sudo start uwsgi
```
Finally, both Nginx and uWSGI are configured to correctly serve our application on system start up.

Troubleshooting
---------------
If something goes wrong, the first place to check is the log files. By default, nginx writes error message to the file **/var/log/nginx/errors.log**.

We've configured uWSGI emperor to write it's logs to **/var/log/uwsgi/emperor.log**. Also this folder contains separate log files for each configured application. In our case - **/var/log/uwsgi/demoapp_uwsgi.log**.

P.S. Hosting Multiple Applications
----------------------------------
If you want to host multiple Flask applications on a single server, create a separate folder for each application, as we did earlier, and symlink nginx and uWSGI configuration files to the appropriate folder.

P.P.S. Deploying Applications with Distribute
---------------------------------------------
To deploy Flask apps using [distribute](https://pypi.python.org/pypi/distribute), first follow the steps in [Flask documentation](http://flask.pocoo.org/docs/patterns/packages/#larger-applications) to convert your application into a package. Next, copy the generated distribute setup package to the server, and use the virtual environment's Python to install it. E.g.:
``` bash
sudo /var/www/demoapp/venv/bin/python setup.py install
```
And last but not least, the "app" property of uWSGI configuration's file should be equal to name of the package that holds the Flask application.