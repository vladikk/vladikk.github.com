---
comments: true
date: 2020-04-09T00:00:00Z
keywords: microservices, nanoservices, bbom, monolith, distributed systems, antipattern, anti-pattern, software architecture, design patterns, design principles, ddd, engineering, design, software, architecture
title: 'Untangling Microservices, or Balancing Complexity in Distributed Systems'
url: /2020/04/09/untangling-microservices/
draft: false
categories: [Microservices, Architecture]
share_img: /images/untangling-microservcies/header.jpg
---

<img src="/images/untangling-microservcies/header.jpg" alt="Untangling Microservices, or Balancing Complexity in Distributed Systems" />

The microservices-honeymoon period is over. Uber are refactoring their thousands of microservices into a more manageable solution [1], Kelsey Hightower says that monoliths are the future [2], and even Sam Newman maintains that microservices should never be the default choice, but rather a last resort [3].

What is going on here? Why so many projects became unmaintainable, despite the microservices’ promise of simplicity and flexibility? So are monoliths better? In this post, I want to address these questions. You will learn about common design issues that turn microservices into distributed big balls of mud, and of course, how you can avoid them.

But first, let’s set the record straight on what is a monolith.

## Monolith
Microservices have always been positioned as a solution for monolithic codebases. But are monoliths necessarily a problem? According to [Wikipedia’s definition [4]], a monolithic application is self-contained and independent from other computing applications. Independence from other applications? Isn’t that what we are chasing, often to no avail, when designing microservices?

[David Heinemeier Hansson [5]] called out the smearing of monoliths right away, warning about the liabilities and challenges inherent to distributed systems. Further, he uses Basecamp to prove that a large system, that serves millions of users, can be implemented and maintained as a monolithic codebase.

Hence, microservices do not “fix” monoliths. The real problem that microservices are supposed to solve is the inability to deliver business goals. The impediment to achieving business goals is often exponentially growing, or even worse — unpredictable, cost of change. In other words, the system is not able to keep up with the needs of the business. A fair way to call such a system would be not a monolith, but rather a [big ball of mud [6]].

The uncontrollable cost of change is not a property of a monolith — a monolith can be— but rather of a [Big Ball of Mud [7]]:
> A Big Ball of Mud is a haphazardly structured, sprawling, sloppy, duct-tape-and-baling-wire, spaghetti-code jungle. These systems show unmistakable signs of unregulated growth, and repeated, expedient repair. Information is shared promiscuously among distant elements of the system, often to the point where nearly all the important information becomes global or duplicated.

The complexity of changing and evolving big balls of mud can be caused by multiple factors: coordinating the work of multiple teams, conflicting non-functional requirements, or intricacy of the business domain. Either way, we often seek to tackle this complexity by decomposing big balls of mud into microservices.

## Micro_what?_
The term “microservice” implies that some part of a service can be measured, and its size better be minimized. But what is it exactly? Let’s see a few approaches.

### Micro_teams_
The first one is the size of the team that works on a service. And this metric should be measured in pizzas. Seriously. They say that if a team working on a service can be fed with two pizzas, then it’s a microservice. I find this heuristic anecdotal, as I’ve built projects with teams that could be fed with one pizza …and I dare someone to call those balls of mad microservices…

### Micro_codebases_
The more widespread approach is to design microservices based on the size of a codebase. Some take this notion to the extreme and try to limit service sizes to a certain number of lines of code. That said, the exact number of lines needed to constitute a microservice is yet to be found. Once this holy grail of software architecture is discovered, we will move on to the next question of the recommended screen width for writing code.

On a serious note, this the less extreme version of this approach is the prevalent one. The size of a service’s codebase is often used as a heuristic for deciding whether it is a microservice or not. 

In some way, this approach makes sense. The smaller the codebase is, the lower its scope of the business domain, and thus it’s simpler to understand, to implement, and to evolve. Moreover, a smaller codebase has less chances of turning into a big ball of mud, and if it does happen, it is simpler to refactor than a larger project.

Unfortunately, the aforementioned simplicity is just an *illusion*.

We are missing a crucial part of system design when we evaluate a service’s design based on the service itself. We are missing the system itself, the system that the service is a component of.

<img src="/images/untangling-microservcies/nick.png" alt="There are many useful and revealing heuristics for defining the boundaries of a service. Size is one of the least useful. Nick Tune" />

### We Build Systems!
We build systems, not sets of services. We are using microservices-based architecture to optimize a system’s design, not its individual services. No matter what others may say, microservices cannot, and will never be neither completely decoupled, nor full independent. You cannot build a *system* out of independent components! That would go against the very definition of the term [“system” [7]]:

>>A set of connected things or devices that operate *together*
>>A set of computer equipment and programs used *together* for a particular purpose

Services will always have to interact with each other to form a system. If you optimize a system’s design by inspecting its services, but ignoring the interactions between them, this is what you will end up with:
(img)

Those “microservices” may be simple individually, but the system itself is a complexity hell!

So how do we design microservices that tackle the complexity not only of the services, but of the system as a whole?

That’s a tough question, but luckily for us, it had been answered more than 40 years ago…

## A System-Wide Perspective on Complexity
Forty years ago, there were no cloud computing, no global scale requirements, and no need to deploy a system every 11.7 seconds. But systems complexity was there. Even those the tools in those days were different, the challenges, and more importantly — the solution — are all the same as nowadays, and can be applied for designing microservices-based systems.

In his book, “Composite/Structured Design”, Glenford J. Myers discusses how to structure procedural code to reduce its complexity. On the very first page he says:
>> There is much more to the subject of complexity than simply attempting to minimize the local complexity of each part of a program. A much more important type of complexity is global complexity: the complexity of the overall structure of a program or system (i.e., the degree of association or interdependence among the major pieces of a program).

In our context, local complexity is the complexity of each individual microservice, whereas global complexity is the complexity of the whole system. Local complexity depends on the implementation of a service; the global complexity is defined by the interactions and dependencies between the services.

So which complexity is more important — local or global? Let’s see what happens when each complexity is tackled individually.

It’s surprisingly easy to reduce the global complexity to a minimum. All we have to do is to eliminate any interactions between the system’s components, i.e., implement all functionality in one monolithic service. As we’ve seen earlier, this strategy may work in certain scenarios. In others, it may lead to the dreaded big ball of mud — probably the highest possible local complexity.

On the other hand, we know what happens when you optimize local complexities of the system’s services, but neglect its global complexity — the even more dreaded distributed big ball of mud.

Hence, optimizing only one type of complexity of a distributed system will cause the second one to skyrocket. Instead, we have to balance both complexities. 

Interestingly, the means for balancing complexity described in the “Composite/Structured Design” book are not only relevant for distributed systems but offer insight on how to design microservices.

## Microservices
Let’s start by defining what exactly are those services and microservices, that we are talking about.

### What is a Service
According to [OASIS Standard], a service is:
>> A mechanism to enable access to one or more capabilities, where the access is provided using a *prescribed interface*.

The prescribed interface part is crucial. A service’s interface defines the functionality that is exposed to the world. According to [Randy Shoup], a service’s public interface is simply any mechanism for getting data in or out of the service. It can be synchronous, such as a plain request/response model, or asynchronous — by producing and consuming events. Either way, synchronous or asynchronous, the public interface is just the means for getting data in our out of a service. 

A service is defined by its public interface, or as Randy also calls it, the service’s front door.

This definition is enough to define what makes a service a *microservice*.

### What is a Microservice
If a service is defined by its public interface, then:
*A microservice is a service with a micro public interface — micro front door.*

This simple heuristic has been followed in the days of procedural programming, and it is more than relevant in the realm of distributed systems. The smaller the service you expose, the simpler its implementation, and thus its local complexity is lower. From the global complexity standpoint, services with smaller public interfaces produce systems with fewer dependencies and connections between the services.

This heuristic also explains the widespread practice of microservices not exposing their databases. No microservice can access other microservices’ databases, but only through their public interfaces. Why is that? — A database would be a huge public interface! For example, how many different operations can you execute on a relational database?

Hence, to reiterate, in microservices-based systems, we balance local and global complexities by minimizing the services’ public interfaces — making them micro*services*.

#### WARNING
This heuristic may sound deceptively simple. If a microservice is just a service with a micro public interface, then we can just limit each service’s public interface to only one method. The front door can’t be any smaller, so those should be the perfect microservices, right? — Not really. To demonstrate why not, I’ll use the example from my [previous post] on this subject:

Let’s say we have the following backlog management service:
(img)

Once we decompose the system into 8 services, each having a single public method, we get services with perfect local complexity:
(img)

But can we connect them into the system that actually manages the backlog? — Not really. To form the system, the services have to interact with each other and to share changes’ to each service’s state. They can’t. The services’ public interfaces do not support that. 

Hence, we have to extend the front doors with public methods that enable integration between the services:
(img)

Let’s see what happened here. As long as we were optimizing each service’s complexity individually, the naive decomposition worked great. However, when we tried to connect the services into a system, the global complexity kicked in. Not only the resulting system ended up being an entangled mess, but we also had to extend the public interfaces beyond our original intent — for the integration’s sake. And that brings us to an important point:

*A service having more integration-related than business-related methods is a strong heuristic for a growing distributed big ball of mud!*

Hence, the threshold upon which a service’s public interface can be minimized depends not only on the service itself but mainly on the system that the service is a part of. A proper decomposition to microservices balances the system’s global complexity and the local complexities of its services.

### Designing Service Boundaries
>> “Finding service boundaries is really damn hard… There is no flowchart!” - Udi Dahan
That statement by Udi Dahan is still relevant. Designing microservices’ boundaries is hard, and probably impossible to get right the first time. That makes designing a fairly complex microservices-based system an iterative process.

Hence, as the general guiding principle, I always prefer to start with wider boundaries and decompose them later into microservices as more knowledge is gained about the system and its business domain. It is especially relevant for services encompassing [core business domains].

### What About *Nano*services?
The term “nanoservice” is often used to describe a service that is too small. One can say that those naive one-method-services in the backlog example are nanoservices.

However, I do not necessarily agree with this classification: it is used to describe an individual service, ignoring the overarching system. In the above example, once we put the system into the equation, the services’ interfaces had to grow. In fact, if we compare the original single service implementation with the naive decomposition, we can see that the system went from overall 8 public methods to 38. Moreover, once we connected the services into a system, the average number of public methods per service went from 1 all the way to 4.75.

Hence, if instead of codebases, we optimize services(public interfaces), the term _nano_service doesn’t hold anymore, as it forced to grow back up to support the system’s use-cases.

### Is That All There Is To It?
No. Although minimizing services’ public interfaces is a strong heuristic for designing interfaces, it’s still just a heuristic and doesn’t replace common sense. In fact, the micro-interface is just a kind of abstraction over the more fundamental, but much more complex design principles — coupling and cohesion.

For example, if two services have micro-public interfaces, but they have to be coordinated in a distributed transaction, they are still highly coupled to each other.

That said, aiming for micro-interfaces is still a strong heuristic that addresses different types of coupling, such as functional, development, and semantic. But that’s a topic for another blog. 

## Summary
I want to sum it all up with a quote by Eliyahu Goldratt. In his books, he often repeated the words “tell me how you measure me, and I will tell you how I will behave”. When designing microservices-based systems, it’s crucial to measure and optimize the right metric. Designing boundaries for micro*codebases*, and micro*teams* is definitely easier. However, to build a *system*, we have to take it into accounts. Microservices are about designing systems, not individual services.

And that brings us back to the title of the post — 
“Untangling Microservices, or Balancing Complexity in Distributed Systems”
The only way to untangle microservices is to balance the local complexity of each service and the global complexity of the whole system.