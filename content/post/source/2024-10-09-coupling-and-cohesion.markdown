---
comments: true
date: 2024-10-09T00:00:00Z
keywords: coupling, cohesion, software design, software architecture, microservices, software engineering, modularity, complexity, balancing coupling, balancing coupling in software design
title: "The Essence of Coupling and Cohesion in Under 500 Words"
url: /2024/10/09/coupling-and-cohesion/
draft: false
categories: [Books, Architecture, Coupling]
share_img: /images/tug-of-war.png
---

<img src="/images/strength-and-distance.png" alt="Integration Strength and Distance" />

When you couple two components, they need to share some form of knowledge: public interfaces, functional behavior, implementation details, or other types of information. Let’s call it the integration strength. The more knowledge is shared, the stronger the integration. The stronger the integration, the more both components will have to change together. Therefore, you should always look to minimize the integration strength. That said, minimizing integration strength isn’t always possible—sometimes, extensive shared knowledge is necessary. For example, when the components implement closely related business functionalities.

Another important property of integrated components is the distance between them. For example, objects in a module are located closer to each other than the source code of two microservices. The greater the distance, the higher the induced cognitive load and coordination challenges, and the more effort is needed to change the integrated components simultaneously.

Now let’s examine four extreme combinations of the two dimensions:
<!--more-->
**Low integration strength, high distance**: High effort is needed to change the components simultaneously. On the other hand, the low integration strength minimizes the chances of such cascading changes. That’s loose coupling.

**High integration strength, low distance**: The components will have to co-evolve frequently because of the high knowledge they share. On the other hand, changing them simultaneously won’t require too much effort because of the low distance. We call this high cohesion.

**High integration strength, high distance**: Lots of cascading changes because of the high integration strength, and lots of effort is needed to take care of them. That’s tight coupling, and it’s no fun.

**Low integration strength, low distance**: In this scenario, the effort to make changes is low, but since the components don’t share much knowledge, cascading changes are rare. Unrelated components are packaged together, or in other words, that’s low cohesion.

<img src="/images/strength-distance-combinations.png" alt="Combinations of Integration Strength and Distance" />

As you can see, both coupling and cohesion are driven by the same underlying phenomena: the knowledge components share and the distance between them. That’s the essence. If you understand one, you also understand the other. That’s why in my new book *Balancing Coupling in Software Design* I limited the discussion of cohesion and instead focused on modularity, complexity, and the underlying dimensions of coupling: integration strength, distance, and volatility.

If you want to learn more about the levels and degrees of integration strength, technical and social factors affecting distance, and how volatility can trespass components’ boundaries—*Balancing Coupling in Software Design* is available in both print and digital formats on [Amazon](https://amzn.to/3BIIPyk), [InformIT](https://click.linksynergy.com/deeplink?id=XLXvHJZS*qY&mid=24808&murl=https%3A%2F%2Fwww.informit.com%2Fstore%2Fbalancing-coupling-in-software-design-universal-design-9780137353484), and other major book stores.