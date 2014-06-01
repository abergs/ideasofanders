---
layout: post
title: I built Crowdspell -  a free service for correcting typos
headline: "Have you ever seen an typo in a blog?"
categories: development
tags: 
  - Javascript
  - Typescript
comments: true
mathjax: null
featured: false
published: true
---
I have a tradition where I develop something new every Christmas holiday. Last year I built a notepad clone with web technologies, still available at [http://notepad.azurewebsites.net](http://notepad.azurewebsites.net).

My goal with these *Christmas hacks* is to learn something new and to really **finish**  something. Last year I learned about [offline web applications](https://developer.mozilla.org/en-US/docs/HTML/Using_the_application_cache) and this year I learned about [CORS](https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS), Widget developing, [Typescript](http://www.typescriptlang.org/) and [VanillaJS](http://vanilla-js.com/).

This year, I built [Crowdspell.se](http://crowdspell.se), a free service that lets your visitors correct typos in your articles/pages by selecting the text. In fact, the service is active on this blog. Try selecting any text to try it out.

I have *longed* for a feature like this when reading blogs where I occasionally would find a typo or a coding error where I'd really like to help the author out by correcting it. It works only by requiring one script tag and one css link tag. If you blog or run a web site, you should totally [check it out](http://crowdspell.se).

I learned a lot by building Crowdspell. I published it to twitter and posted it on [/r/webdev](http://www.reddit.com/r/webdev) for some feedback. The feedback was great and I got a lot of good ideas and verification from the community.

The source code for the client scripts are available at the github [repository](http://github.com/abergs/crowdspell) and I will try to commit something from the issue list at least twice each month.

I would also like to give a huge thanks to [PostmarkApp](http://postmarkapp.com) for sponsoring the email sending at crowdspell. PostmarkApp is a great service which gives you a simple API for sending reliable emails at a very low price. The first 10 000 emails are free and the rest is super cheap. If your app will send email, you should check them out!