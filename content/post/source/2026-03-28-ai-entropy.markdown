---
comments: true
date: 2026-03-28T00:00:00Z
title: "AI and the Second Law of Thermodynamics"
keywords: "AI entropy, technical debt AI, AI code generation, software entropy, second law of thermodynamics software, AI accelerates technical debt, balanced coupling, modular design, software complexity, AI-assisted coding, vibe coding, big ball of mud"
description: >
  AI doesn't just fast-forward implementation — it fast-forwards entropy. Technical debt compounds superlinearly when changes happen at machine speed. The only countermeasure is deliberate investment in design, starting with the most volatile parts of your system.
url: /2026/03/28/ai-entropy/
draft: true
categories: [AI, Balanced Coupling]
share_img: /images/ai-entropy.png
---

The second law of thermodynamics states that entropy, the degree of disorder in a system, always increases. You can't negotiate with it, and you can't ignore it.

Software systems obey a version of this law too. Left to their own devices, codebases drift toward disorder. Every shortcut, every "we'll fix it later," every quick workaround adds a bit of entropy. Technical debt accumulates. The big ball of mud grows.

What's changing is how fast.

<!--more-->

## Fast-Forward

We celebrate AI's speed. Code that would have taken weeks to write now materializes in minutes. Features ship faster. Prototypes appear overnight. The productivity gains are real.

But here's what we're not talking about enough: AI doesn't just fast-forward implementation. It fast-forwards entropy.

Every change to a codebase with existing technical debt makes that debt more expensive. The shortcuts compound. Implicit dependencies multiply. The big ball of mud doesn't just grow, it grows *faster* with each change, because each change interacts with all the disorder that came before it.

When a human writes code at human speed, entropy accumulates at human speed. We have time to notice the mess, feel the friction, course-correct. When AI cranks out changes at machine speed, that feedback loop compresses. And the cost of technical debt doesn't grow linearly with the rate of changes. It grows superlinearly: more changes per unit of time means more interactions with existing disorder, and each interaction compounds the cost.

AI is an entropy accelerator.

## Fighting the Second Law

Is this unavoidable? Thermodynamics actually has an answer, and it's not "give up."

The second law says that entropy in a *closed* system always increases. The key word is "closed." You can decrease entropy locally by injecting energy into the system. That's how life itself works: you push disorder out by investing energy to create order.*

Software is no different. The only way to combat entropy in a codebase is to invest deliberate effort into restoring order. Refactoring. Redesigning boundaries. Repaying technical debt. This won't happen on its own, and it certainly won't happen while AI is busy generating the next feature. It has to be proactive.

The faster your codebase evolves, the more energy you need to invest in keeping it ordered. With AI accelerating the rate of change, investing in design is not optional. It's the only thing standing between you and thermodynamic inevitability.

## Where to Invest the Energy

Not all parts of a system need the same attention. Some components haven't been touched in years. Entropy doesn't care about things that don't change.

The volatile parts, the ones that change the most, that's where entropy hits hardest. That's where you should focus.

My preferred approach is balanced coupling. Start with the areas of your system that have the highest rate of change. Look at the components and how they're integrated. Ask three questions:

1. **What knowledge do they share?** The more knowledge components share about each other, the more likely a change in one triggers cascading changes in others.
2. **Can that shared knowledge be reduced?** Introduce contracts, encapsulate implementation details, eliminate duplication.
3. **If not, should the distance be adjusted?** Components that must share a lot of knowledge should be close together. Components that share little should be far apart. When knowledge and distance are balanced, the design is modular. When they're not, you get a big ball of mud, or worse, a distributed one.

That's the core of the balanced coupling model: modularity emerges when the knowledge components share and the distance between them counterbalance each other.

## Learn More

To go deeper into balanced coupling, check out [coupling.dev](https://coupling.dev) and the [Balancing Coupling in Software Design](https://amzn.to/4irApMt) book.

I've also published [modularity skills for Claude Code](https://github.com/vladikk/modularity) that put balanced coupling into practice: one reviews the modularity of an existing codebase, another designs a modular high-level architecture for new projects. If AI is going to accelerate entropy, it might as well help you fight it too.

## P.S.

*According to thermodynamics, entropy still increases globally. You just move it somewhere else. Your codebase gets cleaner, but the effort has to come from somewhere. I find that an acceptable trade-off.

## P.P.S.

If this resonated, share it. Entropy is easier to fight together.
