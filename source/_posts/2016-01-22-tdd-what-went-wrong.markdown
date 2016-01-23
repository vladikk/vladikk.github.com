---
layout: post
title: "TDD: What Went Wrong …Or Did It?"
date: 2016-01-22 20:57
comments: true
categories: TDD Architecture DDD
published: true
keywords: TDD, tdd2, TDD 2.0, tddisdead, #tddisdead, tddisnotdead, #tddisnotdead, tests, software, design, architecture, DDD, domain driven design, test driven development, tdd is dead, DHH, software craftsmanship, clean code

description: In this post I'll analyze common misconceptions about TDD that lead to vast disappointments in the methodology, and discuss a number of reassessments that can solve the issues developers experience with TDD.
---

Test Driven Development is praised by our industry's aficionados for a long time. However, there are lots of harsh words towards TDD lately. TDD is being blamed for causing bad software design and not keeping many of its promises. This trend culminated in David Heinemeierhansson’s post [“TDD is dead. Long live testing”](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html).

How is it possible, that the same technique, that is so advantageous to many developers, is disastrous to others?
In this post I want to talk about 3 misconceptions that might explain this phenomenon.

Let's start with the most subtle and destructive one.

## 1. TDD is NOT “Test Driven *Design*”
TDD stands for “Test Driven *Development*”. Unfortunately, many misinterpret it as “Test Driven _Design_”. This inaccuracy may sound innocent, but believe me, it isn't. Let me explain.

<!-- more -->

Test Driven Design implies that automatic tests should drive your software design decisions. Seriously? With all due respect, automatic tests are no end goal for developing software. The true goal is delivering projects on time, on budget, and most importantly, meeting all quality requirements. That's where all your design and development efforts should be aimed at.

If you design first and foremost for testability, you get what you pay for — testable code. More often than not, this design will be totally disconnected from the project's business domain and requirements. It will resemble an enormous object graph, full of accidental complexities ...but it will be testable. Testable by tests that are drowning in mocks, and will fail altogether after changing a single bit in the implementation. That's what they call "test induced damage", and it is vividly depicted in DHH’s [“TDD is Dead”](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html) blog post:

> The current fanatical TDD experience leads to a primary focus on the unit tests, because those are the tests capable of driving the code design (the original justification for test-first) I don't think that's healthy. Test-first units leads to an overly complex web of intermediary objects and indirection in order to avoid doing anything that's "slow". Like hitting the database. Or file IO. Or going through the browser to test the whole system. It's given birth to some truly horrendous monstrosities of architecture. A dense jungle of service objects, command patterns, and worse.

How it should be? Your business domain should drive your design decisions. Choose the implementation that best suits the problem you are trying to solve. There is no sense in a full-blown [Domain Model](http://martinfowler.com/eaaCatalog/domainModel.html) if all you need is a vanilla CRUD interface - implement the [Active Record pattern](http://www.martinfowler.com/eaaCatalog/activeRecord.html) instead! If all you need is an ETL script, go with the [Transaction Script pattern](http://martinfowler.com/eaaCatalog/transactionScript.html)!

How on earth can it make sense to solve all problems with the same solution - hexagonal architecture and a domain model? "- Because this design is ideal for unit tests!". I see. It's time talk about the second misconception.

## 2. TDD Isn't About Unit Tests (only) 
It is widely accepted that if you are doing TDD, you should write unit tests. This makes no sense. Unit tests are no magic bullet, and by the way, if you look up TDD on [Wikipedia](https://en.wikipedia.org/wiki/Test-driven_development), you won't find nothing about unit tests:

> Test-driven development (TDD) is a software development process that relies on the repetition of a very short development cycle: first the developer writes an (initially failing) automated test case that defines a desired improvement or new function, then produces the minimum amount of code to pass that test, and finally refactors the new code to acceptable standards.

The emphasis is on the automated tests, and they can be categorized in 3 types: 
unit tests, integration tests, and end-to-end tests. I don't believe that every project needs each and every one of them. Again, this decision should be driven by you problem domain:

1. Are you dealing with a complex business logic? - You do need unit tests here
2. All you do is simple CRUD operations? - Go ahead with integration tests, or event end-to-end tests
3. An ETL script? End-to-end tests will suffice

Pick a testing strategy that best suits your domain. Write your tests first, and Voila, you are doing TDD and not letting tests to lead your design astray.

...And speaking of unit tests, what is a unit anyway?

## 3. Unit != Class
Another common misconception is that unit tests should be exercising individual classes, and all the class's dependencies should be mocked out. This approach is inaccurate. It is a recipe for strong coupling between tests and implementation. This coupling will undermine all your refactoring efforts, thus breaking one of the fundamental TDD promises.

The definition of a unit I like the most, belongs to [Roy Osherove](http://artofunittesting.com/definition-of-a-unit-test/), the author of [The Art of Unit Testing](http://www.amazon.com/gp/product/1617290890):

> A unit test is an automated piece of code that invokes a unit of work in the system and then checks a single assumption about the behavior of that unit of work.

> A unit of work is a single logical functional use case in the system that can be invoked by some public interface (in most cases). A unit of work can span a single method, a whole class or multiple classes working together to achieve one single logical purpose that can be verified.

Testing functional uses cases uncouples the tests from the implementation. It will make refactoring possible, and will require significantly less mocking. 

## The Missing "D" in TDD
Ultimately, there is one more observation that I want to share, because it sums up all the aforementioned misconceptions.

It is recognized that a well designed code is also a testable one. However, this relation is not commutative: well designed code is testable, but not all testable code is well designed. The proof is trivial:

* How can you identify a testable code? Easy — whether it has tests or not.

* How can you evaluate the design quality? Sorry, no shortcuts here — it is all about the context. A well-thought-out solution for one project, is an over-engineering for another. And an over-engineering at one domain, is a negligence for a more complicated one.

Therefore, even if the implementation is testable, it can still miss by a mile its problem and business domain. Consequently, the missing "D" in TDD is the business/problem "Domain". That's why I believe that [Domain Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design)(DDD) is a prerequisite to Test Driven Development. The DDD methodology doesn't apply to complex domain models only - on the contrary, it provides a clear set of guidelines for choosing the best tool for the job, according to the problem domain. But that's a topic for a whole other post.

## P.S. TDD 2.0
TDD was "rediscovered" by Kent Beck over a decade ago. Maybe it's about time for TDD to be rediscovered again. In addition to Unit Tests, the new specification should relate to other automated test types, that weren't available back then. And of course, instead of working against, it should closely cooperate with the business domain.
