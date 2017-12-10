---
categories:
- Architecture
comments: true
date: 2014-12-02T00:00:00Z
description: null
keywords: architecture, patterns, software, distributed systems, soa, microservices,
  design
published: false
title: 'Idempotence: What it is, and why you need it'
url: /2014/12/02/what-is-idempotence/
---

Idempotence: The secret sauce for distributed systems

Distributed systems present numerous challenges to developers, and today they are everywhere. Even a simple website that displays and stores data is a distributed system and should be treated as such. In this post I'll talk about idempotence. This is an age-old concept from mathematics that can heal various headaches that distributed systems can cause you. So what the heck is it?

Idempotence
-----------
The idea is simple. An operation is considered idempotent, if it leads to the same results, no matter how many times it was executed. For example:

* "a = 1" is idempotent. If you execute this code once, or a 1000 times, "a" will still hold the value of 1.
* "a = a + 1" isn't idempotent. Each execution will lead to a different result.

Cool, but what it has to do with distributed systems? - First, let's see an example of what might go wrong.


When the "bytes" hit the fan
----------------------------
Suppose we have a website, that allows customers to submit orders. The orders are written to a database. We've got a system that is distributed across three tiers: client, webserver, database. To analyze what can go wrong, when a user submits an order, let's take a look how the information flows across the tiers:

client =\> webserver =\> database =\> webserver =\> client

As you can see, the information flows across 4 boundaries:

1. Client's request is sent to the webserver
2. Webserver sends the new order details to the database
3. Database informs the webserver that the data was written successfully
4. Webserver sends a response to the client, stating that the operation was executed successfully





Today, distributed systems are everywhere. They present numerous challenges to developers, and you don't need to do SOA. Even a simple website, that is used to display and persist some data is a distributed system.


Idempotence is an age old concept from mathematics. Its value in design of distributed systems can hardly be overemphasized.

The notion of idempotent operations comes from mathematics. An operation is idempotent if it leads to the same results, no matter how many times it was executed.
For example, “a = 1” is idempotent. If you execute it once, or 1000 times, “a” will still have the value of 1.
On the other hand, “a = a + 1” is not idempotent. Each execution will change the value of “a”.

## So, why should I care?
Idempotency is crucial for distributed systems. Nowadays, you don’t have to do microservices, SOA, or any other fancy buzzwords, to get your hands dirty with distributed systems. They are everywhere. Consider this utterly simple architecture for a website:
As you see, the webserver accesses the database directly. No services, no layers, just a lot of monolithic mess. Guess what? You’ve got a distributed system right there, with a pretty nasty distributed transactions! Let me explain.
Say, the website allows users to buy things. The user selects a product, fills his payment information, and submits the order. Schematically it looks like this:
client =\> webserver =\> database =\> webserver =\> client

## When It Hits the Fan
Let’s analyze this flow. What will happen, if someone will pulls the plug on the server during any of these steps?
1. The client’s request didn’t make it to the server. Nothing changed.
2. The application couldn’t commit changes to the database. Again, nothing changed.
3. The database didn’t acknowledge to the application transaction completion, but transaction was committed, and a new order was written.
4. The webserver couldn’t send a repsponse to the client, stating that his order was submitted successfully. But again, the new order was written to the DB.
What the user is likely to do in the case of failure #3 or #4? Try to submit the order again. And of course, it will result in creating the same order twice. Usually, these things do not make your customers happy.
The architecture seemed simple, but still we have a distributed transaction that involves 3 parties: client, webserver, database. Doing it all in an atomic transaction is very hard, if not impossible. But there is a much simpler solution - doing the writing as an idempotent operation.

## To Be Continued..
In my next post, “Idempotency Patterns”, I’ll show how you can make common tasks idempotently.
