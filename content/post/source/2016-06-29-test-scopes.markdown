---
categories: TDD
comments: true
date: 2016-06-29T00:00:00Z
keywords: TDD, Test Driven Development, NDepend, Unit Testing, Cyclomatic Complexity,
  Agile, Software craftsmanship
title: Finding Proper Scopes for Unit Tests
url: /2016/06/29/test-scopes/
categories: [TDD, Architecture]
---

In my previous <strike>rant</strike> [post on TDD](http://vladikk.com/2016/01/22/tdd-what-went-wrong/) I’ve argued that the majority of the problems many experience doing TDD are caused by testing in too narrow scopes - using classes as units of testability, instead of functional use cases. However, widening the scope of the test too much is just another extreme. So how one finds the sweet spot? In this post I’d like to share the heuristic that I use.

<!--more-->

## Cyclomatic Complexity
Cyclomatic complexity is a software metric, used to indicate the complexity of a program. We can use this measurement to measure the complexity of a class or a method, and choose a suitable testing strategy. If the cyclomatic complexity is too high for the testing unit, the testing scope is too wide, and should be narrowed. This heuristic may sound easy in theory, but its no picnic to verify it in practice. Luckily, there are tools that were invented for that kind of heavy lifting. Enter [NDepend](http://www.ndepend.com/).

## Automatically Testing Test Scopes
[NDepend](http://www.ndepend.com/) is an excellent static analysis tool for the .Net platform. In addition to the abundance of built in tests, NDepend allows writing custom queries to check code quality. The following is an example of a CQL query that returns test methods with a scope that should narrowed:

``` csharp
from m in JustMyCode.Methods
where 	m.CyclomaticComplexity > 30 ||
 	  	m.ILCyclomaticComplexity > 60 ||
	  	m.ILNestingDepth > 6
let indirectTestTypes = m.MethodsCallingMe
 		.FillIterative(c => c.SelectMany(m1 => m1.MethodsCallingMe))
		.DefinitionDomain
		.Where(m1 => m1.ParentAssembly.Name.Contains("Tests"))
		.Select(m1 => m1.ParentType)
		.Distinct()
		.ToArray()
let directTestTypes = m.MethodsCallingMe
		.Where(m1 => m1.ParentAssembly.Name.Contains("Tests"))
		.Select(m1 => m1.ParentType)
		.Distinct()
		.ToArray()
orderby m.CyclomaticComplexity descending,
		m.ILCyclomaticComplexity descending,
		m.ILNestingDepth descending
select new {
		m, m.CyclomaticComplexity, 
		m.ILCyclomaticComplexity,
		m.ILNestingDepth, indirectTestTypes, directTestTypes
```

Actually, I've just started using NDepend, and so far it is an invaluable tool in software architect's toolbox. In my next post I'll show how this tool can automate more code checking chores.