---
comments: true
date: 2025-05-26T00:00:00Z
title: 'With AI, everything is so complicated... and this is great news!'
keywords: AI in software engineering, Cynefin framework, AI and complexity, LLM software development, software architecture, domain-driven design, clear complicated complex chaotic, AI-assisted coding, legacy code AI, AI software development tools, machine learning in engineering, generative AI coding, AI in DevOps, software complexity management, AI debugging tools
description: >
  How AI is reshaping software engineering through the lens of the Cynefin framework—clear, complicated, complex, and chaotic domains explained.
url: /2025/05/26/with-ai-everything-is-complicated/
draft: false
categories: [AI, Cynefin]
share_img: /images/f1-crash.png
---

<img src="/images/ai-everything-is-complicated.png" alt="With AI, everything is so complicated... and this is great news!" />

Lately I've been spending more and more time researching AI models and their effects on software engineering and architecture, so it's time to share my findings. 

First, let me explain what I mean by "complicated." I'm a huge fan of the Cynefin framework. If you are not familiar with it, here is the gist. 

## Cynefin
Say you need to decide on something. For example, let's assume you need to change the behavior of a software application and are contemplating how to do it.

Cynefin is a tool for guiding the decision-making process in different kinds of 
situations.  It says that first you need to understand what kind of situation you are in, and once you do, picking the optimal course of action is much easier. For that, the framework identifies four basic situations—domains:
<!--more-->
#### Clear
In the clear domain the outcomes of your decisions are obvious. For example, you know exactly what you need to do to implement the change, and you know exactly what's going to happen once you do.

#### Complicated
In this domain you no longer know what's going to happen as a result of your actions. Maybe the application will work, maybe it won't, or maybe some unexpected behaviors will pop up in the future. However, there is an external expert that does know, and you can ask her for help. For example, assume you are a new-hire in a company and you can consult someone who is more familiar than you are with the codebase.

#### Complex
As in the complicated domain, you do not know what the outcomes of your decisions will be. Unlike the complicated domain, however, in the complex domain you have no external expert to consult with. All you can do is conduct experiments and observe patterns in the resultant behavior. Only then can you use the identified patterns to make the decision. 

Example from the software engineering field? I bet almost everyone has experienced the pure joy of modifying a legacy codebase that nobody knows how it works or even why.

#### Chaotic
In the chaotic domain all hell breaks loose. Now, not only is there no expert to help you out, but there is no observable relationship between actions and their outcomes! Doing the same thing results in different outcomes. Since you can no longer conduct any experiments, all you can do is trust your instincts and do whatever your gut tells you will get you out of trouble.

That 🚨 slack alert 🚨 you receive in the middle of the night on a weekend from the production environment often puts you in the chaotic domain.

What can Cynefin tell us about modern software engineering and AI's role in it?

## Cynefin and Software Engineering
Any non-trivial system consists of multiple functionalities needed for the overarching system to succeed. These functional building blocks can be categorized into Cynefin domains:

#### Clear
Some functionalities you have to build are trivial. You know exactly how to model and implement them. For example, CRUD data entry screens or ETL processes. In Domain-Driven Design (DDD) lingo these are called supporting subdomains, in everyday language: the boring stuff.

#### Complicated
Other functionalities are not that obvious. Instead, they require careful specification, modeling, and implementation efforts. Luckily, there are external experts who can help: off-the-shelf products or open source implementations. You can just use them, instead of wasting time and effort by reinventing the wheel (generic subdomains in DDD).

#### Complex
What about the functionalities that are not trivial either for you, nor for external experts? Those are business opportunities. There are no shortcuts here: building such functionalities requires time, effort, and trial-and-error to find the optimal solution (core subdomains in DDD).

#### Chaotic
Unless you are working on a non-deterministic functionality, the chaotic domain usually corresponds to situations in which something is going wrong: you have to trust your instincts to resolve an issue as quickly as possible.

Now that we have categorized functionalities into Cynefin domains, where can AI help us?

## AI-Assisted Software Engineering
Turns out, in quite a lot of them. Let's go over the Cynefin domains again.
(Worry not, we are not getting replaced ...yet)

#### Clear
The trivial functionalities can be easily "outsourced" to an LLM. There are no technical or business challenges, just boring work that AI won't complain about.

#### Complicated
In the previous section about the complicated domain I focused on the solved problems: ready-made implementations that everyone can use. AI, however, broadens this category. Now it includes not only the off-the-shelf and open source solutions, but also functionalities that can be effectively implemented by AI. A mere five years ago these functionalities would have been considered complex!

#### Chaotic
Everything is on fire and you need to solve a production issue as quickly as possible? Instead of trusting instincts, now we can get insights from our GPU-hearted counterparts. It is worth trying feeding the codebase into an LLM and asking the model to provide an explanation for the problematic behavior. I've seen it work in some cases, and I'm sure it will improve even more in the near future.

But what about the complex domain? I left it to the end for a reason.

#### Complex
As I mentioned in the previous section, many non-trivial functionalities can be offloaded to an LLM model. That effectively turns them from complex to complicated. But it's not the case for all of them. Some functionalities are still novel and require considerable effort to be designed and built effectively. That's the responsibility of us, meat-and-bones software engineers.

As an experiment, I've tried asking LLMs to design and implement core functionalities I used to work on in the past. Often, the first version works. However, the modeling and design issues are quite evident, and future evolutions of the requirement resulted in extreme token usage and codebases that, at best, compile. And that makes total sense, as the models were not trained on such tasks.

Will future models be able to tackle complex functionalities as well? Probably yes, but until then, we can use the current generation of AI to help us in the clear, complicated, and (sometimes) chaotic domains. **AI can even be used to validate the business value that's driven by software: if it still needs your help—the business value is there.**

