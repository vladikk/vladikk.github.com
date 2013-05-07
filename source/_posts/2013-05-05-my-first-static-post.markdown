---
layout: post
title: "Uncoupling Configuration Files"
date: 2013-05-05 23:39
comments: true
categories: [Awesome, Amazing, Beautiful] 
published: false
---
We use configuration files and other configuration storages such as databases
to modify applications’ behavior to suit various deployment scenarios. Many
software frameworks provide classes to easily access data stored in
configuration files. For example in Microsoft .NET framework if we have a
configuration file like this:
``` xml Typical configuration file
<?xml version="1.0"?>
<configuration>
  <appSettings>
    <add key="Foo" value="1"/>
    <add key="Bar" value="2"/>
  </appSettings>
</configuration>
```
<!-- more -->

The values of “Foo” and “Bar” can be accessed via the
ConfigurationManager class:
``` c# Accessing configuration values
int foo = int.Parse(ConfigurationManager.AppSetttings[“Foo”]);
int bar = int.Parse(ConfigurationManager.AppSettings[“Bar”]);
```
