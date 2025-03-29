---
comments: true
date: 2025-03-29T00:00:00Z
keywords: modular software architecture, modular design in software, AI and software architecture, modularity in software engineering, designing for AI, modern software architecture, modular code design, software modularity and AI, AI-friendly code, large language models and code design, how to design modular software, cognitive load in software design, boundaries in system architecture, domain-driven design and AI, balanced coupling model, scalable software architecture, software design for LLMs, AI coding practices, future of software engineering, modular systems and AI
description: >
  Discover why modular software design is more relevant than ever in the age of AI. Learn how clear boundaries help both developers and large language models build and evolve systems with confidence.
title: 'The Golden Age of Modularity'
subtitle: 'Why Modern Architecture—and AI—Depend on Better Boundaries'
url: /2025/03/30/golden-age-of-modularity/
draft: false
categories: [Microservices, Architecture, EDA]
share_img: /images/ai-modularity.png
---

<img src="/images/ai-modularity.png" alt="The Golden Age of Modularity: Why Modern Architecture—and AI—Depend on Better Boundaries" />

My news feed these days:  
“Take a look at the app I built with zero coding skills!”  
“50% of our code is now written by AI!”  
“Engineering hiring freeze: AI is the future!”  

Alright then. Time for me to jump on the vibe coding bandwagon and share an opinion that some may categorize as a hot take.

The notion of modularity was introduced to software engineering way back in the late 1960s. Today — many decades later — we're entering the golden age of modularity. To understand why, let’s first define what modularity actually is. 

## Modularity

There are many ways to define modularity — from designing software systems as interchangeable LEGO blocks to chasing the holy grail of reusable “building blocks” meant to be plugged into anything and everything. I prefer a more practical perspective. To me, a modular design satisfies two key criteria:

1. When you need to change the codebase—whether to adjust existing functionality or introduce a new one—it’s crystal clear what parts of the system need to be touched. Ideally, the number of affected components should be as small as possible. Preferably, just one.

2. When you introduce a change to a modular system, you know exactly what the effect of that change will be. You can predict the system’s behavior.
<!--more-->
That makes modularity all about **change**. A system can work perfectly—but if it can’t evolve, it’s not modular. Only systems that are flexible enough to accommodate reasonable changes can be considered modular.

What if you’re working on a proof of concept that’s unlikely to evolve? Or a non-critical component that won’t be optimized in the future? In such cases, modularity can be traded for shorter go-to-market time.

Modularity used to be all about long-term goals. It was an effort you invested today to make your life easier in the future. But if all you needed was a system that worked today, modularity wasn’t that important.

**Until now.**

Everything changes with the introduction of large language models (LLMs). To fully leverage their ability to generate code, a modular design is essential. To understand why, let’s look at the opposite of modularity.

## Complexity

The simplest way to define what makes a design complex is to contrast it with modularity. A complex design either makes it unclear what parts need to change to accommodate new functionality, or makes it hard to predict the outcomes of a change.

Ever worked on a system where you weren’t sure if you changed all the necessary components? Or maybe you made a change and were surprised by its impact in production? Those are clear signs of a **complex design**.

But why does this happen? Why are some designs easy to change while others feel like defusing a bomb?

It all comes down to **cognitive load**. If the information you need to hold in your head to make a change exceeds the limits of our natural cognitive abilities, that design becomes complex.

LLMs have cognitive limits too. Their context windows are limited, and even within those bounds, they often struggle to fully comprehend large or tightly coupled codebases.

Helping LLMs work within those limits isn’t a new challenge—it’s the same one we’ve faced ourselves. The solutions have many names: objects, services, microservices, self-contained systems, autonomous components… but the common denominator is the same: modularity.

## It’s All About Boundaries
As Ruth Malan famously said, system design is all about boundaries: *what’s in, what’s out, and what goes across*. The quality of those boundaries determines whether a design is modular or complex. As our industry evolves, the accepted terminology changes. New levels of abstraction are introduced from time to time. But the core goal remains the same: design boundaries that **maximize knowledge encapsulated within**, and **minimize knowledge shared across**. The more knowledge is shared across component boundaries, the more likely it is that those components will need to change together. And the more such cascading changes appear, the more complex the system’s design becomes.

Modular design minimizes the contextual knowledge required when working on a component. It’s true for us, and the same is true for an LLM. Ask it to write an entire system versus a single, well-defined module. Which output is going to be better? When the knowledge required to implement a component is self-contained, it becomes easier to define its role and interactions—both for us and for AI. 

**Modularity used to be about future-proofing your codebase. Today, it’s also about making your code accessible to AI.**

But how do you design effective boundaries? Nothing new here. We already have techniques and methodologies for designing modular systems, and they’re more relevant than ever. For obvious reasons, my preferred approaches are [**domain-driven design**](https://amzn.to/4iMKeo2) and the [**balanced coupling model**](https://coupling.dev).

That brings us to a point of optimism. I believe software engineers are here to stay. We’ll just be working at a higher level of abstraction. Just as 100% of the bytecode we produce today isn’t written by us, soon, 100% of the boring code won’t be either. What will remain firmly in our hands is analyzing the problem domain and designing proper component boundaries.

<img src="/images/ai-boundaries.png" alt="Even AI has boundaries" />

## P.S.
This post reflects my experience and opinion today. The future might change everything—maybe in a few years, LLMs will be able to comprehend and evolve even the scariest monoliths. But today, if you want to build systems that are understandable, adaptable, and AI-friendly, my bet is on modular design.
