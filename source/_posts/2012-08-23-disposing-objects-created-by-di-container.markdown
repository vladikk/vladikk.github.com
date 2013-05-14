---
layout: post
title: "Disposing Objects Created by DI Container"
date: 2012-08-23 07:57
comments: true
categories: [C#, Container, Dependency Injection, Dispose, Unity]
keywords: C#, container, dependency injection, unity, di, solid, oop, object oriented design, dispose objects
description: How to properly dispose instances that were created by a dependency injection container.
---
The general rule says that if you created an object, then it is your responsibility to dispose it. Things get a bit tricky when objects are created by a dependency injection container. The responsibility of containers is to construct objects and inject the dependencies they need. An error I’ve seen people doing again and again is to dispose objects that were injected into an object via constructor or property injection. Consider the class “Foo” that requires an instance of class “Bar”:
``` c#
public class Foo : IDisposable {  
    protected Bar bar;  
    public Foo(Bar bar) {  
        this.bar = bar;  
    }  
    public void Dispose() {  
        bar.Dispose();  
    }  
}  

public class Program {  
    static void Main() {  
        var foo = container.Resolve<Foo>();  
        ...  
        foo.Dispose();  
    }  
}  
```
The problem with this approach is that the “Foo” class will know too much about the environment it runs in. At least it will think it does. An instance of “Foo” can’t and shouldn’t know who passed in the instance of “Bar”, and what he intends to do with it after the instance of “Foo” will be disposed.

<!-- more -->

So who should dispose “Bar”? As I said in the beginning of the post, if you created an instance, then you should dispose it. In our case, a dependency injection container has created an object and its dependencies, and therefore it should be responsible for disposing them. Usually containers will have a special method for disposing objects, for example “TearDown” in Unity and “Release” in Windsor.
Let’s see what the correct disposal strategy will look like in our Foo & Bar case:
``` c#
public class Foo : IDisposable {  
    protected Bar bar;  
    public Foo(Bar bar) {  
        this.bar = bar;  
    }  
    public void Dispose() { }  
}  

public class Program {  
    static void Main() {  
        var foo = container.Resolve<Foo>();  
        ...  
        container.TearDown(foo);  
    }  
}  
```
Note: Microsoft being Microsoft, didn’t implement the TearDown method correctly in their Unity framework. Out of the box, the method only disposes the passed object, and ignores the dependencies it created to construct it. The best solution to this issue is to use Rory Primrose’s [plugin that implements the absent functionality](http://www.neovolve.com/post/2010/06/18/Unity-Extension-For-Disposing-Build-Trees-On-TearDown.aspx).
