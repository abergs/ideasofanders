---
redirect_from: /idea/17/i-dont-know-regex/
layout: post
title: I don't know Regex
headline: "Do you?"
categories: development
tags: 
  - regex
  - .net
comments: true
mathjax: null
featured: false
published: true
---
Do you?

I have used Regex for trivial tasks, validating some input data (never validate emails with Regex btw, that is a Bad Thing TM), some really simple parsing etc. But I do not *know* how to write it.

I Google. And I find some type of designer and then I pretty much bruteforce my way until i find the right combination of dots, questionmarks and brackets.

**NO MORE!!**  
I spent the day trying to learn a bit more about Regex. I did learn some, but instead of trying to become good at writing it, I built a library that gives you Regex in English.

**Behold:** [Github RegExpBuilder](https://github.com/abergs/RegExpBuilder)

This .NET library creates a way to build up your pattern similar to how the LINQ extensions methods work. There are a lot of examples in the Test-library included in the Repo.

I did pick up som skills in how Regex works, but seriousley: **Good Code is Simple Code**

Which one of these snippets would you like to encounter within your source code: 

`var regEx = {(?:^)[A-Za-z]([A-Za-z]+|(?:\d+))(@{1,1})[A-Za-z]+(.{1,1})[A-Za-z]+(?:$)}`

or

    var builder = new Builder.RegExpBuilder();
    var r = builder
         .StartOfInput()
         .Letter() // Must start with letter a-z
         .Letters() // any number of letters
         .Or() 
         .Digits() // any number of numbers
         .Exactly(1).Of("@")
         .Letters() // domain
         .Exactly(1).Of(".")
         .Letters() // top-level domain
         .EndOfInput()
    .ToRegExp();

Both validates an email adress (something you should **never do** with Regex, because you won't get it right, but anyway). Which one is the simplest? *I rest my case*.

If you like web development or .NET development, i'm on twitter and talks alot about development: [@BigCheeseAnders](https://twitter.com/BigCheeseAnders)
