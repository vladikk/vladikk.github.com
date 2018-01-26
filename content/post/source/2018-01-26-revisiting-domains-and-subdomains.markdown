---
comments: true
date: 2018-01-26T00:00:00Z
keywords: Domain-Driven Design, DDD, Core Domain, Core Subdomain, Generic, Supporting Microservices, Architecture, Bounded Contexts, Decomposition
title: 'DDD: Revisiting Domains and Subdomains'
url: /2018/01/26/revisiting-domains-and-subdomains/
draft: true
categories: [Domain-Driven Design]
share_img: /images/domains/title-img.jpg
---

<img src="/images/domains/title-img.jpg" alt="DDD: Revisiting Domains and Subdomains" />

I have quite a few friends in the DDD community. Fortunately, or not, we always tend to disagree on the definitions of such basic terms as Domains and Subdomains. In this post I want to think aloud and outline my vision of the subject.

## Disclaimer
As I just said, some of the things I’m about to write are my opinion. Many might disagree with some of them. Hey, the last time we spoke about it, Eric and Vaughn were not fans of this theory. But, nevertheless, it is based on my 7-years long DDD journey at our company, and it works for me. Most importantly, I believe it might work for you as well.

<!--more-->

## Domains
Domain defines the overall business area of a company. For example, at Internovus we are managing marketing for our clients. We come up with marketing strategies, buying advertisement spaces, produce creatives, run advertising campaigns, contact the leads and close sales. We are bringing new customers to our clients. Therefore, our Domain is Customer Acquisition. The Domain of Netflix is Entertainment. Of course, a company can work in different overarching domains. For example Amazon started in Retail, but currently Cloud Computing is Amazon’s Domain as well.

## Subdomains
To achieve its goals, a company has to work in multiple subdomains. They are called subdomains, because none of them are enough for the company to succeed, but together they allow working in the company’s business domain.
For example, at Internovus we have to manage creative materials, purchase ad spaces, manage campaigns, optimize the campaigns, and definitely, manage our finances. We need to execute all those activities to achieve success in our business domain, which is Customer Acquisition.

<img src="/images/domains/subdomains.png" alt="Domain and its Subdomains" />

## Subdomain Types
Not all subdomains were made equal. They can be categorized into three types: Generic, Core, and Supporting.

### Generic Subdomains
Generic subdomains are all those things all companies are doing in the same way. Those are considered “solved” problems.
There are known best practices on how to implement such subdomains. At Internovus we have to implement identity and access management. Luckily, we don’t have to invent ways of implementing it. Our industry has already solved this problem, and these solutions are more secure and battle-tested, that whatever we can come-up with in a reasonable time to market. 

Also, legal requirements might constraint and prescribe a solution as well. For example, our accounting subdomain. Legal and regulation requirements prescribe how we should manage our finances should be managed. All companies are doing it in the same way.

More than that, instead of implementing those known solutions ourselves, they can be adopted as open source projects, or bought as existing solutions.

### Core Subdomains
Core subdomains are the secret sauce of your organization. Those are the things no else does, or does in different ways. They bring competitive advantage to your company. 

Companies want competitive advantages with high barriers to entry. No one will invest in something that could be copied by the competitors in no time. Therefore, by their nature, Core subdomains are complex. They business logic is complex, and usually it changes often, as it’s being optimized over time. 

Technical solutions should match the business complexity of Core subdomains. You want to implement the most sophisticated business logic modeling patterns here. You want to be able analyze and optimize the business performance of the algorithms.   To do that, you will need to assign your best people to work on them. You don’t want to take chances with Core subdomains.

There might be existing solutions available on the market, but you don’t want to buy them. By definition, in Core subdomains you’re doing something differently from the competitors. Otherwise, that would bring no competitive advantage.

For example, at Internovus, we making sure to optimize the heck out of our advertising campaigns. We want to spend the least, but acquire the most leads. And we have ways of doing that. Instead of implementing our own solution, we could by an off-the-shelve product. They exist. But that would miss the point. By definition, we’re managing and optimizing those advertising campaigns differently from our competitors.

### Supporting Subdomains
Supporting subdomains, like Generic subdomains, do not bring any competitive edge for the company. On the other hand, there are no existing off-the-shelve solutions. Although Supporting subdomains do not provide any competitive edge for the company, they are required for implementing a Core subdomain. Therefore, a company has to roll out its own implementation of its Supporting subdomains. 

For example, at Internovus we have Creatives Catalog. This system manages all the banners, landing pages, and other creative materials, produced by our design studio. We are not making any money out of the way we catalog those files. But since there isn’t any existing product that could answer our needs, we had to implement it ourselves.

Since Supporting subdomains do not provide any competitive advantage for the company, they shouldn’t be complex. Their business logic should be simple enough to be rolled out with some rapid application development framework, or outsourced altogether to off-shore development.

But what if the business logic is complex, and full of rules, algorithms and invariants? The business people might have got over creative with their requirements. Since this subdomain provides no competitive advantage, this complexity is accidental and should be simplified.

But what if they can’t be simplified? That’s were things get interesting. If a supporting domain is complex, and there are reasons its complexity, then it might be a Core subdomain in disguise. The business might gain additional competitive edge from this subdomain.

Financially wise, you’d always prefer Supporting subdomains to turn into Generic over time. I.e., an open source project or off-the-shelve product to come out and offer the same functionality.

### Sidenote: Domains Vs. Subdomains
In the Blue Book the terms domain and subdomain are used interchangeably. For example “Core Domain” and “Generic Subdomain”. In my opinion this wording causes confusion, therefore I prefer Domain to define a company’s frame of business, and Subdomains to define distinct business areas required to achieve success in the company’s Domain.

### Sidenote: Assessing Complexity
This way of categorizing subdomains relies heavily on level of their business logic’s complexity. But where do you draw the line between a simple and a complex business logic? Unfortunately, I’m not aware of a scale that can provide an objective answer. However, these heuristics may help you sense the difference:
* Does the system resembles a CRUD interface, and is described my the Domain Experts in CRUD terms? - Simple
* Does the business logic revolves around input validation? - Simple
* Do you have complex algorithms and calculations? - Complex
* Do you have business rules and invariants that should be enforced? - Complex
* What would be the cyclomatic-complexity of the resulting code? Does it have many distinct execution scenarios? - Complex

And finally, as with effort, some things are easier to estimate in relative values. Once you do have some Core and Supporting subdomains, other subdomains could be estimated in relation to their complexities.


## Special Cases
Of course a company may have multiple Core subdomains, if it’s doing multiple things differently from its competitors. In case of Internovus, Campaign Optimization, Lead Prioritization, Agents’ Commissions Management - are only three of our Core subdomains.

There are might be no Core subdomains to be implemented in software. For example, in one of our side-business we had only Supporting and Generic subdomains. The competitive edge of that venture lied in a completely different dimension - leveraging our existing relationships with other companies. Therefore, look carefully and identify those cases. Do not over-engineer the solution if it provides no business value.

## BUT THAT’S NOT WHAT THE BLUE BOOK SAYS!
<img src="/images/domains/damn.jpg" alt="Frankly me dear, I don't give a damn" />

“All models are wrong but some are useful” - in DDD community we tend to repeat this quote as a mantra, but forget to apply it to our own problems and techniques. My view of Domains and Subdomains is not an absolute truth, but just a model. Some say it’s wrong? Of course, all models are wrong. But I find it useful in many different ways.

### Easy Categorization
The emphasis on business logic’s complexity streamlines the process of categorizing subdomains:

Can you buy/adopt and off-the-shelve product without compromising the company’s competitive advantage? - Generic Subdomain.
Else, is the business logic simple? - Supporting Subdomain.
Finally, if you can’t buy, and the subdomains business logic is complex, then it’s a Core Subdomain.

<img src="/images/domains/flowchart.png" alt="Subdomain Categorization Flowchart" />

### Aligning Business and Technical Complexities
This way of categorizing Subdomains allows to align the complexity of a technical solution with the complexity of the business subdomain.

For Core subdomains use the heavy artillery. Implement the Domain Model or Event Sourced Domain Model pattern. You need their ability to tackle complexity.

For Supporting subdomains use simple solutions. Transaction Script or Active Record patterns are enough. Also, these are the subdomains that you can outsource without jeopardizing the business.

If you ignore the complexity consideration, than you might end up with Supporting subdomains so complex, that they couldn’t only be tackling with the Domain Model pattern. But according to DDD, you’ve got to use simple tools nevertheless. Or, on the other hand, you might end up building a domain model for a simple subdomain, that is nothing more than a CRUD interface. In both cases wasting effort and resources.

And of course, Generic subdomains are cheaper to buy or adopt, than to implement yourself.

### Dialog With the Business
You can describe this model to business people in no time. Once you do, you can help optimize the company’s efforts by simplifying extraneously complex Supporting Subdomains.

Also, you can help your business to discover new competitive advantages. If a Supporting subdomain is complex, and there are valid reasons for this complexity, then by identifying those domains, you are helping your organization to be more profitable.

## Summary
This way identifying Subdomains has proved to be the most beneficial for me. It does differ from “what the Blue Book says”, but for the aforementioned reasons, I find this model to be very useful, and I encourage you to give it a try and share results.
