---
layout: post
title: "Uncoupling Configuration Files"
date: 2013-05-14 17:34
comments: true
categories: [managing dependencies, configs, c#, unit testing, refactoring]
keywords: c#, configuration, configuration files, dependency, pattern, ood, clean code, object oriented design, dependency injection, tdd, unit testing, refactoring
description:
---
Tight coupling is a known source for inflexible and hard to test code. In this post I want to talk about a rather unexpected source of tight coupling - configuration files.
Configuration files are external dependencies. As other external dependencies, its infrastructure may change in the future, and it should be easily mocked for unit testing. Modern software frameworks provide means for easy access to the values stored in configuration files. In the .NET framework configuration files can be accessed using the ConfigurationManager:
``` xml
<?xml version="1.0"?>
<configuration>
  <appSettings>
    <add key="Foo" value="1"/>
    <add key="Bar" value="2"/>
  </appSettings>
</configuration>
```

``` c#
int foo = int.Parse(ConfigurationManager.AppSetttings[“Foo”]);
int bar = int.Parse(ConfigurationManager.AppSettings[“Bar”]);
```

ConfigurationManager makes it trivial to access data in the config file, however in most cases it also introduces various code smells that make the code tight coupled and hard to test. In the next sections I’ll introduce a simple class and will use it to demonstrate the code smells and violations of principles of clean object oriented design. The code will be gradually refactored to a better and cleaner solution.

<!-- more -->

FooBarBaz
=========

Consider the following class:

``` c#
public class FooBarBaz {
  protected readonly bool foo;
  protected readonly int bar;
  protected readonly int baz;

  public FooBarBaz() {
    foo = bool.Parse(ConfigurationManager.AppSettings[“foo”]);
    bar = int.Parse(ConfigurationManager.AppSettings[“bar”]);
    baz = int.Parse(ConfigurationManager.AppSettings[“baz”]);
  }

  public int Execute(bool value) {
    return foo == value ? bar : baz;
  }
}
```

This class depends on three values stored in the configuration file - a boolean “foo”, and two integers, “bar” and “baz”. Let’s see what issues we can find in this simple code.

### Smell #1 Impaired Testability
How would you test the “Execute” method? Probably, you would have to assign the Foo’s value manually using ConfigurationManager in each test case:
``` c#
[Test]
public void Test_if_foo_is_false_then____() {
  ...
  ConfigurationManager.AppSettings[“foo”] = false;
  ...
}

[Test]
public void Test_if_foo_is_true_then____() {
  ...
  ConfigurationManager.AppSettings[“foo”] = true;
  ...
}
```
This is a viable approach, yet it is prone to a flaw. To test the method you have to be familiar with its internals. You have to know where the class loads its configuration from, what framework it uses, and finally, what configuration keys are.
More often than not, hard to test code is guilty of violating principles of clean object oriented design. Let’s see what violations we can identify here.

### Smell #2 Violation of the Single Responsibility Principle (SRP)
Currently this class does two things:

* Executing some logic defined in the “Execute” method
* Loading and parsing values from the configuration file

These two responsibilities are a clear violation of the Single Responsibility Principle, which states that each class should have only one responsibility, or in other words, every class should have only one reason for change. Currently FooBarBaz will be change if its logic changes or if there are changes in the configuration storage.

### Smell #3 Violation of the Dependency Inversion Principle (DIP)
According to the Dependency Inversion Principle, high level modules should not depend on low level modules. In this case, the logic defined in the “Execute” method is a part of a high level module, but ConfigurationManager is a low level implementation detail. The two are tightly coupled because of the direct reference and use of ConfigurationManager by FooBarBaz.

### Smell #4 Violation of the Don’t Repeat Yourself Principle (DRY)
Since ConfigurationManager returns a string representation of each configuration value, the class is also responsible for casting the strings to the correct types. This can be seen as a violation of the DRY principle: Each parameter’s type is defined by its variable’s type, and also in the parsing part, which states once again to what type the value should be parsed.

Refactoring #1
==============
To get rid of these smells, let’s remove the dependency on ConfigurationManager, and make it a responsibility of FooBarBaz’s caller:
``` c#
public class FooBarBaz {
  protected readonly bool foo;
  protected readonly int bar;
  protected readonly int baz;

  public FooBarBaz(bool foo, int bar, int baz) {
    this.foo = foo;
    this.bar = bar;
    this.baz = baz;
  }

  public int Execute(bool value) {
    return foo == value ? bar : baz;
  }
}
```
This refactoring provides the following benefits:
The class is responsible only for executing the logic, and therefor it has a single reason for change.
All execution flows can be easily tested by passing the configurations values to the constructor.

### Smell #5 Many Constructor Arguments
The obvious downside of this refactoring is that the number of constructor arguments has grown. Currently the constructor has 3 parameters. It's advisable to minimize the number of constructor's arguments. Let's see how we shrink the number of arguments to one.

Refactoring #2
==============
Since the three arguments, foo, bar, and baz, are naturally go together, we can apply the “Introduce Parameter Object” refactoring:
``` c#
public class FooBarBaz {
  protected readonly Config config;

  public FooBarBaz(Config config) {
    this.config = config;
  }

  public int Execute(bool value) {
    return config.Foo == value ? config.Bar : config.Baz;
  }

  public class Config {
    public bool Foo { get; private set; }
    public int  Bar { get; private set; }
    public int  Baz { get; private set; }

    public Config(bool foo, int bar, int baz) {
      this.Foo = foo;
      this.Bar = bar;
      this.Baz = baz;	
    }
  }
}
```
This simple refactoring reduces the number of constructor arguments to one, however it introduces another code smell.

### Smell #6 Too Much Ceremony
In case we’ll need to introduce a new configuration parameter, it will require too much ceremony - adding it in at least four places:

1. New public property should be added to hold the new value
2. The new value should be added to Config’s constructor
3. Assignment of the value passed to the constructor to the new public property
4. The code that loads values from configuration source and creates an instance of the Config object

Adding the new public property is probably inevitable, but let’s see how the code can be refactored to eliminate the other three modifications.

Refactoring #3
==============
``` c#
public class FooBarBaz {
  protected readonly Config config;

  public FooBarBaz(Config config) {
    this.config = config;
  }

  public int Execute(bool value) {
    return config.Foo == value ? config.Bar : config.Baz;
  }

  public interface Config {
    bool Foo { get; }
    int  Bar { get; }
    int  Baz { get; }
  }
}
```

As you can see, converting the Config class to an interface reduced the required modifications to a bare minimum. On the other hand, it looks like an added headache for the caller, the code that has to pass an instance of the Config object. Now it has both to load the data from the configuration storage and to provide its own implementation of the Config interface. Let’s see how this burden can be minimized:

ConfigurationFactory
====================
The process of instantiating configuration objects will be the responsibility of this abstract factory:

``` c#
public interface ConfigurationFactory {
  TConfig Load<TConfig>() where TConfig : class;
}
```

An implementation of this interface is a low-level detail and therefore should reside in low-level modules of the application. Let's see a simple implementation that uses .NET’s ConfigurationManager as configuration source.

AppSettingsConfigurationFactory
===============================
``` c#
using ImpromptuInterface;

public class AppSettingsConfigurationFactory : ConfigurationFactory {
  public TConfig Build<TConfig>() where TConfig : class {
    var type = typeof(TConfig);
    var typeName = type.FullName.Split('.').Last();
    var properties = type.GetProperties();
    var configDict = (IDictionary<string, object>)new ExpandoObject();
    foreach (var property in properties) {
      var key = string.Format("{0}.{1}", typeName, property.Name);
      var stringValue = ConfigurationManager.AppSettings[key];
      var castedValue = Convert.ChangeType(stringValue, property.PropertyType);
      configDict[property.Name] = castedValue;
    }
    return configDict.ActLike();
  }
}
```
This class harnesses the ImpromptuInterface library and some low-level magic to determine on the fly what configuration values should be loaded, and to create a class that implements the interface TConfig.
Each key stored in the configuration file is a concatenation of enclosing class's name(FooBarBaz), configuration interface(Config), and the configuration parameter name:
``` xml
<configuration>
  <appSettings>
    <add key="FooBarBaz+Config.Foo" value="true"/>
    <add key="FooBarBaz+Config.Bar" value="7"/>
    <add key="FooBarBaz+Config.Baz" value="17"/>
  </appSettings>
</configuration>
```
Usage
=====
``` c#
var configFactory = new AppSettingsConfigurationFactory();
var config = configFactory.Build<FooBarBaz.Config>();
var foo = new FooBarBaz(config)
```
To instantiate the FooBarBaz class, the caller should get an instance of ConfigurationFactory, use it to build an instance of the Config object, and finally create an instance of FooBarBaz using the Config object.
The process can complicate things if you are using a dependency injection container. In this case, a custom plugin should be written that will identify Config interface and build them using the set up implementation of ConfigurationFactory.

Refactoring #4: Simplifying The Usage
=====================================
The three step process of instantiating a class can be seen as an redundant ceremony that can be simplified. To simplify the process, let’s introduce a base class for classes that require configuration settings:

``` c#
public abstract class Configurable<TConfig> where TConfig : class {
  public TConfig Configuration { get; set; }
  
  protected Configurable() {
    Configuration = ServiceLocator[“ConfigurationFactory”].Build<TConfig>();
  }
}
```

And FooBarBaz inheriting Configurable<TConfig>:

``` c#
public class FooBarBaz : Configurable<Config> {
  public int Execute(bool value) {
    return config.Foo == value ? config.Bar : config.Baz;
  }

  public interface Config {
    bool Foo { get; }
    int  Bar { get; }
    int  Baz { get; }
  }
}
```
Now FooBarBaz became even smaller. It no longer needs to explicitly hold an instance of a Config object, the base class does it. The base class also uses the [ServiceLocator pattern](http://en.wikipedia.org/wiki/Service_locator_pattern) to acquire a ConfigurationFactory and build the configuration object. It also exposes a public property, “Configuration”, that can be used for [property injection](http://blog.kh-v.net/2012/09/10/dependency-injection-patterns/) of the configuration object, e.g. for testing purposes.

Conclusion
==========
 Therefore, as with other dependencies, it should be encapsulated to guard against changes in the future and to make testing easier. In this post I presented an approach that I use to encapsulate configs.  