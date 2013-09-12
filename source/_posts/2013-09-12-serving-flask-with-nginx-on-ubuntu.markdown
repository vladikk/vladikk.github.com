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
I'm a software engineer with double digit years of experience developing complex applications in several languages. Having spent the majority of my career in the Microsoft stake, lately I've decided to step out of my comfort zone and to dive into the world of open source software.


, and lately   I first learned Python as part of an effort to create bindings for a C++ library at work.

In addition to Python, I've written web apps in PHP, Ruby, Smalltalk and believe it or not, also in C++. Of all these, the Python/Flask combination is the one that I've found to be the most flexible.



Nginx is gaining against IIS and Apache because it's very good at being a web server and using less resources to do its job, and serving PHP with Nginx is easy to do, too. While most guides have custom fcgi spawners and init.d scripts, serving PHP with Nginx can be done even quicker and easier with mostly apt-get installed software.


Nginx from apt-get

First you need to get the Nginx signing key so your machine can trust the download and install the software provided by nginx.org.

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
rm nginx_signing.key
Add the nginx repo to /etc/apt/sources.list.d.

echo "deb http://nginx.org/packages/ubuntu precise nginx" > /etc/apt/sources.list.d/nginx.list
Note: I'm on Ubuntu 12.04 LTS so I'm using “precise”. At the time of this writing, there is also “lucid”, “oneiric” and “quantal” builds available. Use your version in the repo instead.

Then update the sources list and install Nginx.

apt-get update && apt-get install nginx



http://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world
http://jyunderwood.com/posts/serving-php-with-nginx-on-ubuntu.html