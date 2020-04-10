---
comments: true
date: 2020-04-09T00:00:00Z
keywords: microservices, nanoservices, bbom, monolith, distributed systems, antipattern, anti-pattern, software architecture, design patterns, design principles, ddd, engineering, design, software, architecture
title: 'Untangling Microservices, or Balancing Complexity in Distributed Systems'
url: /2020/04/09/untangling-microservices/
draft: false
categories: [Microservices, Architecture]
share_img: /images/untangling-microservices/header.png
---

<img src="/images/untangling-microservices/header.png" alt="Untangling Microservices, or Balancing Complexity in Distributed Systems" />

The microservices-honeymoon period is over. Uber are refactoring thousands of microservices into a more manageable solution [1], according to Kelsey Hightower monoliths are the future [2], and even Sam Newman says that microservices should never be the default choice, but rather a last resort [3].

What is going on here? Why so many projects became unmaintainable, despite the microservices’ promise of simplicity and flexibility? Or maybe monoliths are better, after all? In this post, I want to address these questions. You will learn about common design issues that turn microservices into distributed big balls of mud, and of course, and how you can avoid them. 

<!--more-->

But first, let’s set the record straight on what is a monolith.

## Monolith
Microservices have always been positioned as a solution for monolithic codebases. But are monoliths necessarily a problem? According to Wikipedia’s definition [4], a monolithic application is self-contained and independent from other computing applications. Independence from other applications? Isn’t that what we are chasing, often to no avail, when designing microservices? David Heinemeier Hansson [5] called out the smearing of monoliths right away. He warned about the liabilities and challenges inherent to distributed systems, and used Basecamp to prove that a large system, serving millions of users, can be implemented and maintained in a monolithic codebase.

Hence, microservices do not “fix” monoliths. The real problem that microservices are supposed to solve is the inability to deliver business goals. Often teams fail to achieve business goals because of exponentially growing, or even worse — unpredictable, cost of making a change. In other words, the system is not able to keep up with the needs of the business. The uncontrollable cost of change is not a property of a monolith but rather of a big ball of mud [6]:

> A Big Ball of Mud is a haphazardly structured, sprawling, sloppy, duct-tape-and-baling-wire, spaghetti-code jungle. These systems show unmistakable signs of unregulated growth, and repeated, expedient repair. Information is shared promiscuously among distant elements of the system, often to the point where nearly all the important information becomes global or duplicated.

The complexity of changing and evolving a big ball of mud can be caused by multiple factors: coordinating the work of multiple teams, conflicting non-functional requirements, or intricacy of the business domain. Either way, we often seek to tackle this complexity by decomposing such clumsy solutions into microservices.

## Micro_what?_
The term “microservice” implies that some part of a service can be measured, and its value should be minimized. But what is it exactly? Let’s see a few common approaches.

### Micro_teams_
The first one is the size of the team that works on a service. And this metric should be measured in pizzas. Seriously. They say that if a team working on a service can be fed with two pizzas, then it’s a microservice. I find this heuristic anecdotal, as I’ve built projects with teams that could be fed with one pizza …and I dare someone to call those balls of mud microservices!

### Micro_codebases_
Another widespread approach is to design microservices based on the size of its codebase. Some take this notion to the extreme and try to limit service sizes to a certain number of lines of code. That said, the exact number of lines needed to constitute a microservice is yet to be found. Once this holy grail of software architecture is discovered, we will move on to the next question — what is the recommended editor width for building microservices?

On a serious note, a less extreme version of this approach is the prevalent one. The size of a codebase is often used as a heuristic for deciding whether it is a microservice or not. 

In some way, this approach makes sense. The smaller the codebase is, the lower its scope of the business domain, and thus it’s simpler to understand, to implement, and to evolve. Moreover, a smaller codebase has less chances of turning into a big ball of mud, and if it does happen, it is simpler to refactor.

Unfortunately, the aforementioned simplicity is just an **illusion**. When we evaluate a service’s design based on the service itself, we are missing a crucial part of system design. We are missing the **system** itself, the system that the service is a **component** of.

> "There are many useful and revealing heuristics for defining the boundaries of a service. Size is one of the least useful." ~ Nick Tune

### We Build Systems!
We build systems, not sets of services. We are using microservices-based architecture to optimize a system’s design, not the design of individual services. No matter what others may say, microservices cannot, and will never be neither completely decoupled, nor fully independent. **You cannot build a system out of independent components!** That would go against the very definition of the term “system” [7]:

>1. A set of **connected** things or devices that **operate together**
>2. A set of computer equipment and programs **used together for a particular purpose**

Services will always have to interact with each other to form a system. If you design a system by optimizing its services, but ignoring the interactions between them, this is what you may end up with:

<img src="/images/untangling-microservices/complex-system.png" alt="" />

Those “microservices” may be simple individually, but the system itself is a complexity hell!

So how do we design microservices that tackle the complexity not only of the services, but of the system as a whole?

That’s a tough question, but luckily for us, it had been answered more than 40 years ago…

## A System-Wide Perspective on Complexity
Forty years ago, there was no cloud computing, no global scale requirements, and no need to deploy a system every 11.7 seconds. But engineers still had to tame systems’ complexity. Even though the tools in those days were different, the challenges, and more importantly — the solution — are all relevant nowadays, and can be applied for designing microservices-based systems.

In his book, “Composite/Structured Design” [8], Glenford J. Myers discusses how to structure procedural code to reduce its complexity. On the very first page of the book he says:

> **There is much more to the subject of complexity than simply attempting to minimize the local complexity of each part of a program. A much more important type of complexity is global complexity: the complexity of the overall structure of a program or system (i.e., the degree of association or interdependence among the major pieces of a program).**

In our context, **local complexity is the complexity of each individual microservice**, whereas **global complexity is the complexity of the whole system**. Local complexity depends on the **implementation** of a service; global complexity is defined by the **interactions and dependencies** between the services.

So which complexity is more important — local or global? Let’s see what happens when only one of the complexities is taken care of.

It’s surprisingly easy to reduce the global complexity to its minimum. All we have to do is to eliminate any interactions between the system’s components. I.e., implement all functionality in one monolithic service. As we’ve seen earlier, this strategy may work in certain scenarios. In others, it may lead to the dreaded **big ball of mud — probably the highest possible local complexity**.

On the other hand, we know what happens when you optimize only the local complexity, but neglect the system's global complexity — the *even more dreaded* **distributed big ball of mud**.

<img src="/images/untangling-microservices/bboms.png" alt="" />

Hence, if we concentrate on only one type of complexity, it doesn't matter which one is chosen. In a fairly complex distributed system, the opposite complexity will skyrocket. Therefore, we can't optimize only one, insted we have to balance both local and global complexities. 

Interestingly, the means for balancing complexity described in the “Composite/Structured Design” book are not only relevant for distributed systems, but offer insight on how to design microservices.

## Microservices
Let’s start by defining what exactly are those services and microservices, that we are talking about.

### What is a Service
According to OASIS Standard [9], a service is:

> A mechanism to enable **access to one or more capabilities**, where the access is provided using a **prescribed interface**.

The prescribed interface part is crucial. A service’s interface defines the functionality it exposes to the world. According to Randy Shoup [10], a service’s public interface is simply any mechanism for getting data in or out of a service. It can be synchronous, such as a plain request/response model, or asynchronous — by producing and consuming events. Either way, synchronous or asynchronous, the public interface is just the means for getting data in our out of a service. Randy also calls the service’s public interfaces as its **front door**.

A service is defined by its public interface, and this definition is enough to define what makes service a *microservice*.

### What is a Microservice
If a service is defined by its public interface, then —

**A microservice is a service with a micro public interface — micro front door.**

This simple heuristic has been followed in the days of procedural programming, and it is more than relevant in the realm of distributed systems. The smaller the service you expose, the simpler its implementation, and thus its local complexity is lower. From the global complexity standpoint, smaller public interfaces produce fewer dependencies and connections between the services.

This heuristic also explains the widespread practice of microservices not exposing their databases. No microservice can access another microservice's database, but only through its public interface. Why is that? — *Well, a database would be a huge public interface!* Just consider how many different operations can you execute on a relational database.

Hence, to reiterate, in microservices-based systems, we balance local and global complexities by minimizing the services’ public interfaces — making them micro**services**.

#### WARNING
This heuristic may sound deceptively simple. If a microservice is just a service with a micro public interface, then we can just limit public interfaces to only one method. The front door can’t be any smaller than that, so those should be the perfect microservices, right? — *Not really.* To demonstrate why not, I’ll use the example from my another post [11] on this subject:

Let’s say we have the following backlog management service:

<img src="/images/untangling-microservices/backlog-service.png" alt="" />

Once we decompose it into 8 services, each having a single public method, we get services with perfect local complexities:

<img src="/images/untangling-microservices/naive.png" alt="" />

But can we connect them into the system that actually manages the backlog? — *Not really.* To form the system, the services have to interact with each other and to share changes to each service’s state. *They can’t.* The services’ public interfaces do not support that. 

Hence, we have to extend the *front doors* with public methods that *enable integration* between the services:

<img src="/images/untangling-microservices/interactions.png" alt="" />

Boom. As long as we were optimizing the complexity of each service individually, the naive decomposition worked great. However, when we tried to connect the services into a system, the global complexity kicked in. Not only the resulting system ended up being an entangled mess, but we also had to extend the public interfaces beyond our original intent — for the integration’s sake. And that brings us to an important point:

**A service having more integration-related than business-related methods is a strong heuristic for a growing distributed big ball of mud!**

Hence, the threshold upon which a service’s public interface can be minimized depends not only on the service itself but mainly on the system that the service is a part of. A proper decomposition to microservices should *balance* the system’s global complexity and the local complexities of its services.

### Designing Service Boundaries
> “Finding service boundaries is really damn hard… There is no flowchart!” - Udi Dahan

The above statement by Udi Dahan is especially true for microservices-based systems. Designing microservices’ boundaries is hard, and probably impossible to get right the first time. That makes designing a fairly complex microservices-based system an iterative process.

Hence, it is safer to start with wider boundaries, probably the boundaries of proper bounded contexts[12] and decompose them into microservices later, as more knowledge is gained about the system and its business domain. It is especially relevant for services encompassing core business domains[13].

### What About *Nano*-services?
The term “nanoservice” is often used to describe a service that is too small. One can say that those naive one-method-services in the previous example are nanoservices. However, I do not necessarily agree with this classification.

Nanoservices are used to describe individual services while ignoring the overarching system. In the above example, once we put the system into the equation, the services’ interfaces had to grow. In fact, if we compare the original single service implementation with the naive decomposition, we can see that once we connected the services into a system, the system went from overall 8 public methods to 38. Moreover, the average number of public methods per service went from the desired 1 all the way to 4.75.

Hence, if instead of codebases, we optimize services (public interfaces), the term *nano*-service doesn’t hold anymore, as the *service* is forced to grow back up to support its system’s use-cases.

### Is That All There Is To It?
No. Although minimizing services’ public interfaces is a good guiding principle for designing microservices, it’s still just a heuristic and doesn’t replace common sense. In fact, the micro-interface is just a kind of abstraction over the more fundamental, but much more complex design principles — coupling and cohesion.

For example, if two services have micro-public interfaces, but they have to be coordinated in a distributed transaction, they are still highly coupled to each other.

That said, aiming for micro-interfaces is still a strong heuristic that addresses different types of coupling, such as functional, development, and semantic. But that’s a topic for another blog. 

## Summary
I want to sum it all up with a quote by Eliyahu Goldratt. In his books, he often repeated these words:

> “Tell me how you measure me, and I will tell you how I will behave” ~ Eliyahu Goldratt

When designing microservices-based systems, it’s crucial to measure and optimize the right metric. Designing boundaries for micro*codebases*, and micro*teams* is definitely easier. However, to build a *system*, we have to take it into account. Microservices are about designing systems, not individual services.

And that brings us back to the title of the post — “Untangling Microservices, or Balancing Complexity in Distributed Systems”. **The only way to untangle microservices is to balance the local complexity of each service, and the global complexity of the whole system.**

## Bibliography

1. [Gergely Orosz's tweet on Uber](https://twitter.com/GergelyOrosz/status/1247132806041546754)
2. [Monoliths are the future](https://changelog.com/posts/monoliths-are-the-future)
3. [Microservices guru warns devs that trendy architecture shouldn't be the default for every app, but 'a last resort'](https://www.theregister.co.uk/2020/03/04/microservices_last_resort/)
4. [Monolithic Application(Wikipedia)](https://en.wikipedia.org/wiki/Monolithic_application)
5. [The Majestic Monolith - DHH](https://m.signalvnoise.com/the-majestic-monolith/)
6. [Big Ball of Mud(Wikipedia)](https://en.wikipedia.org/wiki/Big_ball_of_mud)
7. [Definition of a System](https://dictionary.cambridge.org/dictionary/english/system)
8. [Composite/Structures Design - book by Glenford J. Myers](https://www.amazon.com/Composite-Structured-Design-Glenford-Myers/dp/0442805845)
9. [Reference Model for Service Oriented Architecture](https://docs.oasis-open.org/soa-rm/v1.0/soa-rm.html)
10. [Managing Data in Microservices - talk by Randy Shoup](https://www.youtube.com/watch?v=E8-e-3fRHBw)
11. [Tackling Complexity in Microservices](https://vladikk.com/2018/02/28/microservices/)
12. [Bounded Contexts are NOT Microservices](https://vladikk.com/2018/01/21/bounded-contexts-vs-microservices/)
13. [Revisiting the Basics of Domain-Driven Design](https://vladikk.com/2018/01/26/revisiting-the-basics-of-ddd/)
14. [Modular Monolith: A Primer - Kamil Grzybek](http://www.kamilgrzybek.com/design/modular-monolith-primer/)
15. [A Design Methodology for Reliable Software Systems - Barbara Liskov](https://pdfs.semanticscholar.org/d420/c8b473a23b80241fd7c90757becb59b1136c.pdf)
16. [Designing Autonomous Teams and Services](https://learning.oreilly.com/library/view/designing-autonomous-teams/9781491994320/)
17. [Emergent Boundaries - a talk by Mathias Verraes](https://www.youtube.com/watch?v=ECM1rPYxvD4)
18. [Long Sad Story of Microservices - talk by Greg Young](https://www.youtube.com/watch?v=MjIfWe6bn40)
19. [Principles of Design - Tim Berners-Lee](https://www.w3.org/DesignIssues/Principles.html)