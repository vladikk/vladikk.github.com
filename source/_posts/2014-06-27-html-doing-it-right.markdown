---
layout: post
title: "HTML: Doing it Right"
date: 2014-06-27 12:13
comments: true
categories: [Web Design, HTML]
keywords: web design, html, javascript, css, separation of concerns, architecture, web
description: 
---

I've learned HTML way back in 1998, when tables ruled the world and only the cool kids knew that you can put an image inside of a marquee. There's been a lot of water under the bridge since then: divs defeated layers, rise and fall of IE, javascript became cool, but one annoying thing is still the same. When people learn web design they are taught HTML, CSS and JavaScript, but almost nothing on separation of concerts: what role each of those technologies play and when it should be used. In this post I'd like to fill that gap and to share what I've learned since 1998.

Concerns
--------
A typical web page presents information. A good one does it an aesthetic way. Some pages interact with the user. Those are the 3 concerns a page should take care of: content, how to show it, and how to interact with the user. The languages HTML, JavaScript and CSS are fulfilling those tasks, but it each of them should take care of one concern only: HTML - content, CSS -  design, JavaScript - interaction.

HTML: Content
-------------
Each page has a structured content: title, subtitle, author, date, body, paragraph, etc. The page itself has a structure also: header, menu, footer, article. The content and its structure is the domain of HTML. HTML should tags should be used to describe a page's content and its structure and nothing else. The common sin is to use HTML tags to define how the content should be rendered.