---
comments: true
date: 2018-01-26T00:00:00Z
keywords: Domain-Driven Design, DDD, Core Domain, Core Subdomain, Generic, Supporting Microservices, Architecture, Bounded Contexts, Decomposition
title: 'DDD: Subdomains Revisited'
url: /2018/01/26/ddd-subdomains-revisited/
draft: false
categories: [Domain-Driven Design]
share_img: /images/domains/title-img.jpg
---

<img src="/images/domains/title-img.jpg" alt="DDD: Subdomains Revisited" />

I have quite a few friends in the DDD community. Fortunately, or not, we always tend to disagree on the definitions of such basic terms as Domains and Subdomains. In this post, I want to think aloud and outline my thoughts on the subject.

## Disclaimer
As I just said, some of the things I’m about to write are my opinion only. Many of you might disagree with some of them. Hey – the last time we spoke about it, Eric and Vaughn were not fans of my theory. But, nevertheless, it is based on my 7-year long DDD journey at our company, and it works for me. Most importantly, I believe it might work for you as well.

<!--more-->

## Domains
The term “Domain” defines a company’s overall business area. For example, at Internovus, we manage marketing for our clients. We come up with marketing strategies, buy advertisement spaces, produce creatives, run advertising campaigns, contact leads and close sales. We bring new customers to our clients. Therefore, our Domain is Customer Acquisition. The Domain of Netflix is Entertainment. Of course, a company can work in different overarching domains. For example, Amazon started in Retail, but currently Cloud Computing is Amazon’s Domain as well.

## Subdomains
To achieve its goals, a company must work in multiple subdomains. They are called subdomains because by themselves they aren’t enough for the company to succeed; together, they add up the company’s business domain.

For example, Internovus must manage creative materials, purchase ad spaces, manage campaigns, optimize the campaigns, and manage our finances. We need to execute all those activities to achieve success in our business domain, which is Customer Acquisition.

<img src="/images/domains/subdomains.png" alt="Domain and its Subdomains" />

## Subdomain Types
Not all subdomains are created equal. They can be categorized into three types: Generic, Core, and Supporting.

### Generic Subdomains
Generic subdomains are those things that all companies do the same way. Those are considered “solved” problems.

There are known best practices on how to implement such subdomains. At Internovus, we have to implement identity and access management. Luckily, we don’t have to invent ways to implement it. Our industry has already solved this problem, and these solutions are more secure and battle-tested than whatever we can come up with in a reasonable time to market. 

Also, legal requirements might constrain us and prescribe a solution as well. For example, take our accounting subdomain. Legal and regulation requirements prescribe how our finances should be managed. All companies do it in the same way.

More than that, instead of implementing known solutions ourselves, they can be adopted as open-source projects, or purchased as existing off-the-shelf products.

### Core Subdomains
Core subdomains are the secret sauce of your organization. Those are the things no else does, or does in different ways. They bring competitive advantage to your company. 
Companies want competitive advantages with high barriers to entry. No one will invest in something that their competitors might quickly copy. Therefore, by their nature, Core subdomains are complex. Their business logic is complex, and usually it changes often, as it’s being optimized over time. 

Technical solutions should match the business complexity of Core subdomains. You want to implement the most sophisticated business logic modeling patterns here. You want to analyze and optimize your algorithms’ business performance. To do that, you’ll need to assign your best people to work on them. You don’t want to take chances with Core subdomains.
There might be solutions available on the market, but you don’t want to buy them. By definition, in Core subdomains you’re doing something different from your competitors. If you weren’t, then you’d have no competitive advantage.

For example, at Internovus, we make sure we optimize the heck out of our advertising campaigns. We want to spend the least, but yet acquire the most leads. And we have ways of doing that. Instead of implementing our own solution, we could by an off-the-shelf product. They exist. But that would miss the point. By definition, we manage and optimize those advertising campaigns differently than our competitors.

### Supporting Subdomains
Supporting subdomains, like Generic subdomains, do not offer any competitive edge for the company. On the other hand, there are no existing off-the-shelf solutions. Although Supporting subdomains do not provide a competitive edge, they are required for implementing a Core subdomain. Therefore, a company must roll out its own implementation of its Supporting subdomains. 

For example, Internovus has a Creatives Catalog. This system manages all the banners, landing pages, and other creative materials produced by our design studio. We don’t make any money from the way we catalog those files. But since there isn’t any existing product to answer our needs, we had to implement it ourselves.

Since Supporting subdomains don’t provide us with any competitive advantage, they shouldn’t be complex. Their business logic should be simple enough to be rolled out with some rapid application development framework, or outsourced altogether for offshore development.

But what if the business logic is complex, full of rules, algorithms and invariants? The business people might have gotten over-creative with their requirements. Since this subdomain provides no competitive advantage, this complexity is accidental and should be simplified.

But what if it can’t be simplified? That’s where things get interesting. If a supporting domain is complex, and there are reasons for its complexity, then it might be a Core subdomain in disguise. The business might gain an additional competitive edge from this subdomain.

### Sidenote: Domains Vs. Subdomains
In the Blue Book, the terms domain and subdomain are used interchangeably (for example, “Core Domain” and “Generic Subdomain”). In my opinion, this wording causes confusion; therefore, I prefer to use Domain to define a company’s frame of business, and Subdomains to define distinct business areas required to achieve success in the company’s Domain.

### Sidenote: Assessing Complexity
This way of categorizing subdomains relies heavily on the level of their business logic’s complexity. But where do you draw the line between simple and complex business logic? Unfortunately, I’m not aware of a scale that can provide an objective answer. However, these heuristics may help you sense the difference:

* Does the system resemble a CRUD interface, and is it described by the Domain Experts in CRUD terms? - Simple
* Does the business logic revolve around input validation? - Simple
* Do you have complex algorithms and calculations? - Complex
* Do you have business rules and invariants that should be enforced? - Complex
* What would be the cyclomatic complexity of the resulting code? Does it have many distinct execution scenarios? - Complex

And finally, as with effort, some things are easier to estimate in relative values. Once you have some Core and Supporting subdomains, other subdomains could be estimated in relation to their complexities.

It is also important to note that a subdomain's complexity is not an absolute value. It depends heavily on the given company's needs. For example, the aforementioned Creatives Catalog is quite simple for Internovus - we just need a way to catalog those files. But for another company, that would specialize in some smart way of managing and indexing creative materials, it would have been orders of magnitude more complex. Consequently, Creatives Catalog would be a Core subdomain of such company.

## Special Cases
Of course, a company may have multiple Core subdomains if it’s doing multiple things differently from its competitors. In the case of Internovus, Campaign Optimization, Lead Prioritization, Agents’ Commissions Management are only three of our Core subdomains.

There might be no Core subdomains to be implemented in the software. For example, in one of our side-businesses, we had only Supporting and Generic subdomains. The competitive edge of that venture lay in a completely different dimension - leveraging our existing relationships with other companies. Therefore, look carefully and identify those cases. Do not over-engineer the solution if it provides no business value.

## BUT THAT’S NOT WHAT THE BLUE BOOK SAYS!
<img src="/images/domains/damn.jpg" alt="Frankly me dear, I don't give a damn" />

“All models are wrong, but some are useful.” In the DDD community, we tend to repeat this quote like a mantra, but forget to apply it to our own problems and techniques. My view of Domains and Subdomains is not an absolute truth, just a model. Some say it’s wrong. Of course, all models are wrong! But I find it useful in many different ways.

### Easy Categorization
Putting the emphasis on the business logic’s complexity streamlines the process of categorizing subdomains. To do that categorization, ask yourself: 

Can you buy/adopt an off-the-shelf product without compromising the company’s competitive advantage? - Generic Subdomain.

Is the business logic simple? - Supporting Subdomain.

Finally, if you can’t buy a product, and the subdomains’ business logic is complex, then it’s a Core Subdomain.

<img src="/images/domains/flowchart.png" alt="Subdomain Categorization Flowchart" />


### Aligning Business and Technical Complexities
This way of categorizing Subdomains allows you to align the complexity of a technical solution with the complexity of the business subdomain.

For Core subdomains, use the heavy artillery. Implement the Domain Model or Event-Sourced Domain Model pattern. You need their ability to tackle complexity.

For Supporting subdomains, use simple solutions. Transaction Script or Active Record patterns are enough. Also, these are the subdomains you can outsource without jeopardizing the business.

And of course, Generic subdomains are cheaper to buy or adopt than to implement yourself.

### Dialog With the Business
You can describe this model to business people in no time. Once you do, you can help optimize the company’s efforts by simplifying extraneously complex Supporting Subdomains.

Also, you can help your business discover new competitive advantages. If a Supporting subdomain is complex, and there are valid reasons for this complexity, then by identifying those domains you help your organization to be more profitable.

## Summary
This way of identifying Subdomains has proved to be the most beneficial for me. It does differ from “what the Blue Book says” – but for the aforementioned reasons, I find this method to be very useful. Hence, I encourage you to give it a try and share your results.