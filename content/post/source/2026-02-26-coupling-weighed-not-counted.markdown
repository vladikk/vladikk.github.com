---
comments: true
date: 2026-02-26T00:00:00Z
title: "Coupling Should Be Weighed, Not Counted"
keywords: software coupling, balanced coupling, integration strength, afferent efferent coupling, software modularity, static code analysis, coupling metrics, software design, cascading changes, software dependencies
description: >
  Static analysis tools count dependencies, but counting misses what matters. A single dependency on implementation details can cause more cascading changes than a hundred contract-based ones. The Balanced Coupling model weighs dependencies by the knowledge they share, not the number of connections.
url: /2026/02/26/coupling-weighed/
draft: false
categories: [Software Design, Balanced Coupling, Coupling]
share_img: /images/weighed-not-counted.png
---

<img src="/images/weighed-not-counted.png" alt="A balance scale where a single heavy weight outweighs many smaller pieces — illustrating that one heavy dependency can matter more than many lightweight ones." />

> "Words should be weighed, not counted." — A Yiddish Saying

Static code analysis tools count dependencies, calculate ratios, and assign neat scores. Yet in my experience, chasing those metrics never really made the design more modular. It's so easy to game the scores without any improvement to the design itself. Let's see why, and what you can do instead.

## The Counting Approach

Most static analysis tools evaluate coupling by counting dependencies. Afferent coupling (Ca) counts how many components depend on yours. Efferent coupling (Ce) counts how many components yours depends on. A popular instability metric combines them into a neat formula:

```
I = Ce / (Ce + Ca)
```

The higher the ratio of outgoing to total dependencies, the more "unstable" a component is considered. Simple. Automatable. And deeply misleading.

<!--more-->

## The Blind Spot

Consider a component with just one outgoing dependency and 100 incoming dependencies. Its instability score is roughly 0.01. According to the metric, this is textbook stability. The kind you'd showcase in architecture reviews.

But what if that single outgoing dependency introduces a dependency on another component's implementation details? For example, its private interfaces, internal data structures, or undocumented behaviors. At the same time, all of the 100 incoming dependencies go through well-defined and stable API contracts.

That one outgoing dependency means any internal change in the other component can break yours. Say you have a microservice that uses another microservice's database directly. Any schema change, any column rename, any table restructuring can break your service. Meanwhile, those 100 contract-based dependencies shield you from internal changes through stable integration contracts.

The metric says: rock-solid stability. Reality says: ticking time bomb.

## Weighing Dependencies

Rather than counting dependencies, the Balanced Coupling model focuses on what matters: the practical implications of a dependency. What kinds of shared reasons for change does it introduce? The model defines the Integration Strength scale: four fundamental types of knowledge that can be shared across component boundaries. Each type results in considerably more cascading changes than the one below it:

**Intrusive coupling** is the heaviest. Components integrate through implementation details: direct database access, private object manipulation, undocumented internal APIs. At this level, you have to assume that *all* knowledge is shared. Any internal change, for any reason, can trigger a cascading change. The reasons for cascading changes are essentially unbounded.

**Functional coupling** switches from "how?" to "what": components implement closely related or identical business requirements. If a business rule changes, all components implementing that rule must change together. Think of the same validation logic duplicated in frontend and backend. A specification change that isn't reflected in both simultaneously leads to inconsistent behavior of the system.

**Model coupling** shifts from logic to structure: components share a domain model, but not the logic that implements it. Think entities, relationships, and concepts that describe the business. When the team's understanding of the domain evolves (new insights, restructured entities, refined concepts), all components sharing that model must adapt.

**Contract coupling** is the lightest. Components share only an integration contract: an API specification, an event contract, a data transfer object. The contract encapsulates everything behind it, making the public interface far more stable than the implementation. Restructure your internals? Rewrite your business logic? Evolve your domain model? No cascading changes. Only modifications to the contract itself propagate across boundaries.

That's the Integration Strength scale. Each level down removes an *entire category* of shared reasons for change. That's why a single intrusive dependency can cause more cascading changes than a hundred contract-based ones.

## Weigh, Don't Count

Back to the proverb. Counting dependencies tells you how many connections exist. Weighing them tells you how much knowledge flows through each one. And it's the knowledge, not the count, that determines whether a change in one component will cascade across your system.

Static analysis tools count because counting is easy to automate. But easy to automate and useful are not the same thing. A metric that treats use of reflection to modify a private field and an API call as equivalent is likely to point you in the wrong direction. Dependencies, like words, should be weighed, not counted.

## P.S.

Found this useful? Share it. Too many teams are still optimizing for the wrong numbers.

## Learn More

- [*Balancing Coupling in Software Design*](https://amzn.to/4irApMt) (Addison-Wesley) — The book covering the full Balanced Coupling model.
- [*Integration Strength*](https://coupling.dev/posts/dimensions-of-coupling/integration-strength/) on coupling.dev — A deep dive into the four levels of knowledge sharing between components.
- [*Afferent & Efferent Coupling*](https://coupling.dev/posts/related-topics/afferent-and-efferent-coupling/) on coupling.dev — How counting-based metrics relate to the balanced coupling model.
