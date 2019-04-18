---
comments: true
date: 2019-04-18T00:00:00Z
keywords: distributed systems, consistency, eventual consistency, NoSQL, transactions, antipattern, anti-pattern, software architecture, design patterns, design principles, ddd, cqrs, engineering, design, software, architecture
title: 'Anti-Pattern: Optimistic Consistency'
url: /2019/04/18/optimistic-consistency/
draft: false
categories: [Microservices, Architecture]
share_img: /images/zen/header.jpg
---

<img src="/images/optimistic-consistency/header.jpg" alt="Anti-Pattern: Optimistic Consistency" />

Ladies and Gentlemen, lo and behold a new consistency model - “Optimistic Consistency”. Implementation of this pattern is quite simple: commit as many transactions as you want, against as many storage mechanisms as you need. That’s all. Let’s see an example.

## Example
Say as the result of some user’s operation the system has to:

1. Modify data in MongoDB
2. Publish some events to Kafka
3. Update search model in Elasticsearch; and
4. Execute an operation on some remote system

You implement this logic by executing those operations one after another. Simple and elegant. After all, why over-engineer? Everything will be just fine, namely:

1. Servers will always be up
2. Network is the most reliable thing on earth
3. Your process will only be shut down gracefully …like, why would anyone stop it in the middle of execution, right?

In addition to simplicity of implementation, this approach brings multiple additional benefits.

## Advantages of Optimistic Consistency
The main advantage is that you can always promise strong consistency. Without the hassle of actually ensuring it. If someone will ever question the systems consistency, always use eventual consistency as an excuse. After all, we are living in the brave new world of distributed systems, right?

Optimistic consistency brings another huge benefit. In the *very unlikely * scenario of something indeed going wrong, you can always refer the extremely low percentage of such possible issues. Like, who will ever notice if the system looses a transaction or two???

## Ok, seriously now
Hope is not a strategy and optimistic consistency is nothing but negligence. Things will go wrong: systems will crash, network will be partitioned, and occasionally, servers’ plugs will be pulled.

Claiming that no one will ever notice such corruption just emphasizes how big of an issue this is - the system will be silently corrupting data, but “no one will ever notice”!

Please don't do it.

How to handle such scenarios? Read Jimmy Bogard’s awesome [“Life Beyond Distributed Transactions”](https://jimmybogard.com/life-beyond-transactions-implementation-primer/) series.