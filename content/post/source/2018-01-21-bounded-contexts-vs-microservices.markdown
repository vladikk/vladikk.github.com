---
comments: true
date: 2018-01-21T00:00:00Z
keywords: Domain-Driven Design, DDD, Microservices, Architecture, Bounded Contexts, Decomposition
title: 'Bounded Contexts are NOT Microservices'
url: /2018/01/21/bounded-contexts-vs-microservices/
share_img: /images/bc-ms/rebel-scum.jpg
categories: [Domain-Driven Design, Microservices]
---

<img src="/images/bc-ms/rebel-scum.jpg" alt="Rebel scum" />

I’ve always considered Domain-Driven Design’s Bounded Context as a guideline for defining the boundaries of Microservices. I was wrong. Not only is this heuristic flawed, but Bounded Contexts are the exact opposite of Microservices! To explain this point of view, I’ll start with a quick refresh of what Bounded Contexts are; then I’ll discuss the relationship between Bounded Contexts and Microservices.

<!--more--> 

## Crash Course in Domain-Driven Design and Bounded Contexts
In "Domain-Driven Design: Tackling Complexity in the Heart of Software", Eric Evans argues that poor collaboration between domain experts and software development teams causes many development efforts to fail. DDD aims to increase the success rates by bridging this collaboration and communication gap.

### Ubiquitous Language
To allow for the fluent sharing of knowledge, DDD calls for cultivation of a shared, business-domain-oriented language: Ubiquitous Language. This language should resemble the business domain, its terms, entities, and processes. The Ubiquitous Language should be extensively used throughout the project. All communication should be done in the Ubiquitous Language, and all documentation should be formulated in it. Even the code should "speak" the Ubiquitous Language as well. The Ubiquitous Language becomes the model of the business domain implemented in code.

### Bounded Contexts
Defining a Ubiquitous Language is not a trivial task. Since software doesn't cope well with ambiguity, each Ubiquitous Language term should have exactly one meaning. Unfortunately, that's not how human languages work — words often have different meanings in different contexts. To overcome this hurdle, DDD requires each language to have a strict applicability context. This context is called a Bounded Context. It defines a boundary, inside of which a Ubiquitous Language can be used freely. Outside of it, the language’s terms may have different meanings. 

### Examples
Those “meanings” can differ in multiple ways. First, the same term might describe completely different things. Martin Fowler has a nifty example of such a case: He relates how, when he worked for an electrical utility, the word “meter” had different meanings in different parts of the organization. In one department, it referred to the connection between the grid and a location. Others understood “meter” as the connection between the grid and the customer, or, of course, a physical meter attached to a house to measure electrical consumption.  

Second, different stakeholders might represent the same business entity in different models. For example, an Advertising Campaign is a complex entity with many rules and invariants for campaign managers; but for sales agents, an Advertising Campaign is merely a data structure that describes a subset of its metadata. Those are two different models, and thus belong to two different Bounded Contexts.

Finally, since in Domain-Driven Design the language is the model, and vice versa, each Bounded Context defines the applicability context of a specific model. A model is only valid in its Bounded Context.

What does it all mean in the context of Microservices?

## Microservices
In the context of Microservices, it means one simple thing: a Bounded Context is the exact opposite of a Microservice!

A Bounded Context defines the boundaries of the biggest services possible: services that won’t have any conflicting models inside of them. If you cross the boundary, those conflicting models will eventually lead to a big ball of mud. If you follow the Bounded Context strictly, you will get monoliths. Those will be “good” monoliths, since there won’t be any conflicting models in them, but still, they are not Microservices. But if you decompose the Bounded Context further, you’ll find those sought-after Microservices. However, neither Domain-Driven Design in general, nor Bounded Contexts in particular, do not provide any guidance on how to do it. 

<img src="/images/bc-ms/monolith-vs-ms.jpg" alt="" />

A big monolith and a small monolith, from Domain-Driven Design perspective, are perfectly valid Bounded Contexts, as long as they don't have any conflicting models in them. Therefore, A Microservice is a Bounded Context, but not vice versa. Not every Bounded Context is a Microservice.

<img src="/images/bc-ms/diagram.jpg" alt="Bounded Contexts are not Microservices" />

## ... Maybe Subdomains?
No.

Aligning Bounded Contexts with business subdomains is another popular heuristic for decomposing systems into Microservices. However, even Subdomains can be decomposed further.

Hence, aligning Bounded Contexts with business subdomains is not a recipe for decomposing a system into Microservices either. 

## What Then?
But if Bounded Contexts are not Microservices, then what are those Microservices? That’s going to be the topic of my next post on Microservices.
