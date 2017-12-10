---
categories:
- Dependency Injection
- OOP
- OOD
- Patterns
- C#
comments: true
date: 2012-09-10T00:00:00Z
description: Overview of 3 patterns of implementing dependency injection - constructor
  injection, property injection, builder.
keywords: dependency injection, patterns, objection oriented design, oop, ood, c#,
  constructor injection, property injection, builder
title: Dependency Injection Patterns
url: /2012/09/10/dependency-injection-patterns/
---

Choosing the right pattern for implementing dependency injection is an important task and can affect your class’s usability and functionality. In this post I’ll overview 3 patterns of implementing dependency injection - constructor injection, property injection, builder (Joshua Bloch’s pattern, not GoF pattern).
For demonstration purposes we will work with a class called TextTranslator, that requires 3 dependencies: TextReader, TranslationService and TextWriter:
``` c#
public class TextTranslator
{
    protected TextReader textReader;
    protected TranslationService translationService;
    protected TextWriter textWriter;    
}
```
The sample code will be written in C#, but the examples are applicable to Java and other object oriented languages.

<!--more-->

Constructor Injection
---------------------

The implementation of this pattern is simple - expose a constructor that accepts its dependencies as arguments. This pattern works best for required dependencies - when the user of your class shouldn't be able to instantiate an object without passing the dependencies:
``` c#
public class TextTranslator
{
    protected readonly TextReader textReader;
    protected readonly TranslationService translationService;
    protected readonly TextWriter textWriter;    

    public TextTranslator(TextReader textReader,
                          TranslationSerivce translationService,
                          TextWriter textWriter) {
        this.textReader = textReader;
        this.translationService = translationService;
        this.textWriter = textWriter;
    }
}
```
Usage:
``` c#
public class Program
{
    public static void Main() {
        // create the dependencies
        var textReader = new TextReader();
        var translationService = new TranslationService();
        var textWriter = new TextWriter();

        // instantiate the TextTranslator class and pass its dependencies
        var translator = new TextTranslator(textReader,
                                            translationService, textWriter);
    }
}
```

### Pros
* This pattern is the best choice for required dependencies. It communicates clearly what instances should be provided. Also, this is the only choice if the injected dependency is to be stored in a readonly field.
* Simple implementation.
* Integrates easily with dependency injection containers - you are not required to add any special attributes in order for a container to supply the dependencies.

### Cons

* This pattern causes the number of constructor parameters to grow. It's considered a bad practice for a constructor to have more than 3-4 arguments. When this happens, it's time to step back and consider some refactorings. First, being dependant on many objects may be a clear sign of breaking the single responsibility principle. If this is the case, split the functionality between multiple classes. Otherwise, use the Introduce Parameter Object refactoring.


Property Injection (Setter Injection)
-------------------------------------

The class that needs a dependency exposes a property with public setter that is used for injection of the dependency. Since the dependencies are passed after the object is instantiated, this pattern works best for optional dependencies - when default instances of the dependencies are created in a constructor, and the user should be able to inject an alternative implementation:
``` c#
public class TextTranslator
{
    public TextReader TextReader { get; set; }
    public TranslationService TranslationService { get; set; }
    public TextWriter TextWriter { get; set; }

    public TextTranslator() {
        this.TextReader = new DefaultTextReader();
        this.TranslationService = new DefaultTranslationService();
        this.TextWriter = new DefaultTextWriter();
    }
}
```
Usage:
``` c#
public class Program
{
    public static void Main() {
        // instantiate the TextTranslator class
        var translator = new TextTranslator();

        // create and pass the dependencies
        translator.TextReader = new CustomTextReader();
        translator.TranslationService = new CustomTranslationService();
        translator.TextWriter = new CustomTextWriter();        
    }
}
```
### Pros

* The best choice for optional dependencies.
* Simple implementation.
* Integrates with dependency injection containers (the properties that hold dependencies should be marked with a special attribute, e.g. “[Dependency]”).

### Cons

* Not suitable  for required dependencies. It doesn’t communicate well what dependencies should be supplied, and allows the user not to supply them.
* The dependency is mutable. Users can inject different implementations of the same dependency during the object’s lifetime.


Builder (Joshua Bloch’s pattern)
--------------------------------

This pattern gives you the best of two worlds - it allows you to limit the constructor parameters to the required dependencies, yet it still allows setting optional dependencies during the instantiation phase.
To implement this pattern you have to expose a public constructor that takes instances of the required dependencies as arguments and define private/protected fields to hold the optional dependencies. The optional dependencies can be set by using an instance of inner Builder class. Because Builder is an inner class, it can access and modify parent class’s protected and private fields.
Let’s see how this pattern can be implemented. In this example TranslationService is a required dependency, but TextReader and TextWriter are optional:
``` c#
public class TextTranslator
{
    private TextReader textReader;
    private TranslationService translationService;
    private TextWriter textWriter;

    public TextTranslator(TranslationService translationService) {
        // set the required dependency
        this.translationService = translationService;
        // set default values for the optional dependencies
        this.textReader = new DefaultTextReader();
        this.textWriter = new DefaultTextWriter();
    }

    public class Builder
    {
        private TextReader textReader;
        private TranslationService translationService;
        private TextWriter textWriter;

        public Builder(TranslationService translationService) {
            this.translationService = translationService;
        }

        public Builder WtihTextReader(TextReader textReader) {
            this.textReader = textReader;
            return this.
        }

        public Builder WithTextWriter(TextWriter textWriter) {
            this.textWriter = textWriter;
            return this.
        }

        public TextTranslator Build() {
            var result = new TextTranslator(translationService);
            if (textReader != null) {
                result.textReader = textReader;
            }
            if (textWriter != null) {
                result.textWriter = textWriter;
            }

            return result;
        }
    }
}
```
Usage:

``` c#
public class Program
{
    public static void Main() {
        // create the dependencies
        var textReader = new TextReader();
        var translationService = new TranslationService();
        var textWriter = new TextWriter();

        // instantiate the TextTranslator class using its Builder
        var translator = new TextTranslator.Builder(translationService)
                            .WithTextReader(textReader)
                            .WithTextWriter(textWriter)
                            .Build();    
    }
}
```
As you can see, Builder’s constructor mirrors its parent’s constructor - it accepts the same required dependencies. The optional dependencies are set via fluent interface that follows the “.WithFieldName(fieldValue)” convention. When all the values are passed, the Build method is called, which constructs a new instance and passes the available optional dependencies.

### Pros

* Minimises the number of constructor arguments to the number of the required dependencies.
* All the dependencies are immutable for the user.
* Doesn’t require exposal of public setters for optional dependencies.
* Dependency injection containers can supply required dependencies

### Cons

* Extra code you have to write to implement this pattern.
* Dependency injection containers cannot supply optional dependencies.


Conclusion
----------
Use Constructor Injection for required dependencies. For optional dependencies, if you can allow mutable dependencies, use Property Injection, otherwise implement the Builder pattern.
