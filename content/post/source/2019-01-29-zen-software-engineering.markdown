---
comments: true
date: 2019-01-29T00:00:00Z
keywords: software engineering, software design, software architecture, design patterns, design principles, ddd, cqrs, engineering, design, software, architecture
title: 'The Zen of Software Engineering'
url: /2019/01/29/zen-software-engineering/
draft: false
share_img: /images/zen/header.jpg
---

<img src="/images/zen/header.jpg" alt="The Zen of Software Engineering" />

There is a pet peeve of mine, that lately I’m encountering way too often: the condition I call __Silverbulletitis__. This virus spreads among developers on many levels — juniors, seniors, and even architects. In this post I’d like talk about why this condition is dangerous, and how it can be treated.

## Symptoms
All too often you can hear statements that some tool or technique is bad, but another one is the greatest thing since sliced bread. E.g.:

* Procedural code is for dinosaurs
* Functional programming is the way
* MongoDB is “the sh*t”
* All relational databases are evil
* Dynamic languages make you fast
* Static typing is just never ending ceremonies
* TDD all the things
* TDD is dead
* SOLID is a cargo cult
* etc.

But, the truth is, **no tool is necessarily good or bad**. _(Okay, okay, Sharepoint should be avoided at all costs, but you’ve got my point.)_ Each tool has its context, costs, and the problem it is supposed to solve. **As engineers, it is our job to know and recognize cases in which each tool can be used or should be avoided**. Challenging? — Hell yeah. Requires experience? — Lots of it. But hey, it was never meant to be easy. And by the way, that’s almost literally the definition of engineering, according to ECPD (The American Engineers' Council for Professional Development):

> The creative application of scientific principles to design or develop structures, machines, apparatus, or manufacturing processes, or works utilizing them singly or in combination; or **to construct or operate the same with full cognizance of their design; or to forecast their behavior under specific operating conditions; all as respects an intended function, economics of operation and safety to life and property.**

## Treatment
Hence, limiting yourself to one solution for all problems is not engineering — it’s hacking. And don’t get me wrong here, hacking is not necessarily bad! It’s just a tool, and as such, it can be useful — for example, when you have to deliver fast and you know that the project is not going to evolve. But that’s not *"the way"*. **There is no "the way" and don’t waste your time looking for it**. Instead:

* Gain experience with different programming paradigms: object oriented, functional, and even procedural programming — all are useful in some cases, but wasteful in others
* Embrace the brave new world of NoSQL. Today we have myriads of database families to choose from — document stores, key/value stores, search indexes, graphs, columnar stores, relational databases. Unfortunately, none of them is perfect. Each has its strengths and weaknesses. Or, as Greg Young put it, each database sucks in its own way. Therefore, learn to apply various types of databases effectively.
* Learn what problems the different architectural patterns are intended to solve: Layers, Hexagonal, CQRS, DCI. When applied correctly, they manage and abstract complexity at different levels; when applied incorrectly they only lead to accidental complexities.
* Last but not least, learn the different ways of modeling business domains and business logic: active record, domain model(ddd), event sourced domain model, and transaction script. Each of those patterns addresses different levels of complexity. Use of the correct pattern will reduce the overall costs of development, and costs of introducing changes in the future.
* etc.

Learn where each tool shines. Learn from your experience. Learn from others’ experience, such as published case studies, conference talks, etc.

Once you gain enough experience, you will get a sense in which projects each tool should be used. However, don’t follow those hunches blindly. Instead, understand from where, and from what experiences, those hunches are coming from. Those are **your design heuristics**.

## Prevention
Ultimately, don’t fall in love with your design heuristics either! They can be subjective as well, and their use may depend on additional project related factors:

* Don’t ignore the dimension of time. Various practices can produce different results at different stages of project development. For example, best practices for a mature product maybe an overkill for a greenfield project.
* What works for one company, may fail miserably for another. Startups and enterprises companies often different requirements, limitations, and values. What may be good for a startup, might get a big ball of mud rolling in an enterprise company. Furthermore, the same technique may produce different results for different teams in the same company.

## P.S.
...Did I already mention that software engineering is not a walk in the park?