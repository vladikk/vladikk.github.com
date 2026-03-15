---
comments: true
date: 2026-03-15T00:00:00Z
title: "Machine Errors and Non-Deterministic Humans"
keywords: "LLM reliability, AI mistakes, non-deterministic LLM, AI error management, AI guardrails, AI feedback loops, Swiss Cheese Model AI, managing AI errors, vibe coding, AI-assisted software engineering, claude code, AI coding tools, cursor AI, software engineering with AI"
description: >
  LLMs are non-deterministic, but so are humans. We don't blame people for human error, we design systems that absorb it. The same playbook, from guardrails to feedback loops to the Swiss Cheese Model, can make AI reliable too.
url: /2026/03/15/machine-errors/
draft: false
categories: [AI, Software Design]
share_img: /images/machine-errors.png
---

<img src="/images/machine-errors.png" alt="A friendly robot holding onto a railing, illustrating the concept of designing systems that support variable components" />

"I can't rely on LLMs because they're not deterministic. How can I be sure what I'll get?" — I bet you've thought that yourself. I did for sure.

It's a fair point. LLMs can be unpredictable: the same input can produce different outputs. But here's the thing: neither are you deterministic, nor am I. A cup of coffee can dramatically improve our "inference." A bad night's sleep can tank it. We're so unpredictable that we have a term for when our variability wreaks havoc: *human error*.

And when human error happens, we've learned not to simply blame the person. Instead, we examine the environment. Why didn't the system prevent this? We expect systems to withstand human errors, or better yet, prevent them from happening in the first place.

LLMs are made in our likeness. They're trained on the code, books, and articles we've written. So why do we blame them for human errors? Sorry, I meant machine errors.

<!--more-->

## The Playbook

I believe the same strategies we've developed to help people do the right thing can also help us get more out of AI.

### Make Errors Impossible or Difficult to Commit

For humans, this means physical interlocks, confirmation dialogs, guards that prevent you from even attempting the wrong action. You can't start a car without pressing the brake. Prescription bottles have child-resistant caps.

For AI, one example is letting compilers, linters, type checkers, and tests do the heavy lifting. The model might generate code with a bug, but the system catches it long before it causes damage.

### Make It Easy to Do the Right Thing

Humans follow the path of least resistance. Good design makes the correct action the easiest one: sensible defaults, one-way gates, obvious signage.

For AI, this might look like prompt engineering. Be explicit about what you want. Provide clear examples. Preprocess requests to detect ambiguities and ask for clarifications before proceeding.

### Reduce Cognitive Load

Surgeons and pilots use checklists. Not because they're forgetful, but because checklists free up cognitive capacity for the work that actually requires judgment.

AI can benefit from the same approach. Break large tasks into smaller ones. As each step becomes simpler, the compound error rate drops.

### Enforce Recovery

Drivers have mandatory rest periods. Doctors have shift limits. Pilots have crew rest requirements. We know that fatigue degrades performance, so we enforce recovery.

For AI, one equivalent is context engineering. Long conversations accumulate noise. The larger the context, the less effective the model. Clearing and restructuring context is how you let AI have some rest.

### Feedback Loops

In medicine, you get a second opinion. In publishing, editors review before anything goes to print. In software, we have pair programming and pull requests.

For AI, feedback loops might involve using different prompts or entirely different models to review output. One model generates, another critiques. Together they iterate toward better results.

### Monitoring and Resilience

When a human error does cause an incident, we run post-mortems and use what we learn to stop the same mistake from happening again.

For AI, one approach is building knowledge bases that capture past issues. When the model gets something wrong, you don't just correct it. You update the context, the prompts, the examples, so the same failure is less likely next time. Resilience isn't about preventing all errors. It's about using the errors to make the system stronger.

## Swiss Cheese

The most robust approach treats humans as variable components operating within a system. Not as the weakest link, but as the last line of defense in a system designed to absorb their variability.

James Reason's Swiss Cheese Model captures this well: no single layer of defense is perfect. Each layer has holes. But stack enough imperfect layers, and the holes rarely align. Most errors get caught before they cause harm.

AI is no different. It's a variable component. It will make mistakes. The goal is to design systems that absorb its variability. We've been doing it for ourselves all along.

## P.S.

If this clicked, please share it.
