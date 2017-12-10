---
categories:
- Web Design
- HTML
comments: true
date: 2014-06-27T00:00:00Z
description: null
keywords: web design, html, javascript, css, separation of concerns, architecture,
  web
published: false
title: 'Clean HTML: Doing it Right'
url: /2014/06/27/html-doing-it-right/
---

I've learned HTML way back in 1998, when tables ruled the world and only the cool kids knew that you can put an image inside of a marquee. There's been a lot of water under the bridge since then: divs defeated layers, rise and fall of IE, javascript became cool, but one annoying thing is still the same. When people learn web design they are taught HTML, CSS and JavaScript, but almost nothing on separation of concerts: what role each of those technologies play and when it should be used. In this post I'd like to fill that gap and to share what I've learned since 1998.

Concerns
--------
A typical web page presents information. A good one does it an aesthetic way. Some pages interact with the user. Those are the 3 concerns a page should take care of: content, how to show it, and how to interact with the user. The languages HTML, JavaScript and CSS are fulfilling those tasks, but it each of them should take care of one concern only: HTML - content, CSS -  design, JavaScript - interaction.

HTML: Content
-------------
Each page has a structured content: title, subtitle, author, date, body, paragraph, etc. The page itself has a structure also: header, menu, footer, article. The content and its structure is the domain of HTML. HTML should tags should be used to describe a page's content and its structure and nothing else.

Unfortunately, some HTML tags make it too easy to break that rule. I'd like to talk about the most abused tags: BR, TABLE, IMG, SPAN and DIV.

### BR
Line breaks (&lt;BR /&gt;) are often used to define spacing between elements or between lines of text:
	<div id="header">...</div>
	<br />
	<br />
	<br />
	<div id="menu">...</div>

The line break should only be used to denote the beginning of a new line *inside* of a paragraph. It should be used as rarely, as you use shift+enter in your favorite word processor. Instead a text should be divided into paragraphs using the &lt;P&gt; tag:
	<p>
		Paragraph 1
		...
		...
		...
	</p>
	<p>
		Paragrpah 2
		...
		...
		...
	</p>

### TABLE
There two misconceptions about tables. The first one is to use table for defining page layouts. This mistake was much more popular in the past, but still, there are developers that use approach. Using tables that way merges the page design deep into its content, causing a rigid, very hard to change design.

The second misconception about the table, is the opposite extreme - not using them at all. At some point it became clear that tables are evil for defining a layout and other layout techniques should be used. Unfortunately, that led to some developers not using tables at all. Even if their page's content contains a table. They struggle with DIVs to make them look like a table, only because they believe that tables are a thing of the past and shouldn't be used at all. That's not true. When you should display tabular data, use TABLE tag to describe it. It is still possible to control how its rendered from a CSS.

### IMG
Seriously? Can you really abuse images? Yes, you can. There are two types of images: the images that are a part of the page's content, and the images that are a part of the page's design, e.g. your website's logo. The second type is the problematic one. Since it's not a part of the page's content, its HTML should denote its placeholder only. How it should be rendered is the domain of CSS. Let's see an example:
	<div id="header">
		<img src="images/logo.jpg" />
	</div>
What's wrong with this code? - It is rigid. If a month from now you'll need to make this page responsive, i.e. mobile devices friendly, you'll need to display a smaller one logo. To do it, you'll have to either modify the HTML, or control its content using JavaScript. Now let's see a better way to do it:
``` html page.html
<div id="header">
	<img id="logo" />
</div>
```

``` css desktop.css
#header #logo {
	content:url("images/logo.jpg");
}
```

This way the image is fully controlled from the CSS.

*This example uses CSS3 which is still not fully supported in all browsers. There are [other methods](http://css-tricks.com/replace-the-image-in-an-img-with-css/) to achieve the same result in CSS2.*

### DIV and SPAN
todo

CSS: Design
-----------
Webpages display information and strive to do it in an aesthetic way. That's the job of CSS - controlling how the page should be rendered. Writing clean HTML allows you to completely control how the page is rendered just by editing the CSS file. The [CSS Zen Garden](http://www.csszengarden.com) is a great example.

CSS3 has lots of improvements that allow not only control of the visual design, but also of the page's content. Of course, the content I'm talking about here is one that is a part of the page's look and feel. In the previous section we've already seen an example of images, but using CSS3 you can inject text also. This can be great for internationalization: you can define a CSS file for each language.

### Leakages
When the design concern is leaking from the CSS the maintenance of the page becomes much an thus should be avoided. Let's see how the design can leak into the HTML:
	<table bgcolor="red">...</table>
	<div style="color: blue">...</div>
In this example two elements get their background color set inside the HTML file. The first one is set using an HTML attribute, and the second one is using a style attribute, which contains CSS as its value

### Common mistakes

A common mistake is to use HTML to define how the content should be rendered.
Marquee - a crime against humanity.
Table - 
<BR> to specify spacing between elements
Image tags: 2 types: page design, page content. Content only. Design should be controlled via CSS. CSS3 allows setting the image url in style sheets.


Is it really that important?
----------------------------
Yes it is, especially nowadays, when a single page should be displayed on a plethora of devices. Actually, clean HTML is a prerequisite to a responsive design. 

HTML should describe what things are, but not how they should be rendered.
