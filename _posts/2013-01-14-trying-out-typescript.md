---
layout: post
title: Trying out Typescript
headline: This will be big.
categories: development
tags: 
 - Typescript
comments: true
mathjax: null
featured: false
published: true
---
I'm trying out the javascript superset language [TypeScript](http://www.typescriptlang.org/). A Typed language that compiles to Javascript. It was invetend by some pretty smart people over at Microsoft **but**, it is maintained Open Source. That - is a very good thing™. 

So let's get started.

### Why would you use typescript? ###

So, lets begin with some of the challenges with writing javascript applications. If you are sloppy with the code, not using the revealing module pattern, or reavling prototype pattern - the code tends to turn to spaghetti code, being impossible to maintain.

It's not impossible to write good, maintainable Javascript. But Typescript makes it easier.

######JS, The good:######

* Variables can hold any object
* Types determined on the fly
* Implicit type coercion (ex: string or number)

######JS, The bad:######

* Difficult to ensure proper types are passed
* Not all developers use === 
* Enterprise-scale apps can have 1000s of lines of code to maintain.

For developers, moving from server-side apps to client-side apps can be challenging. Depending on the language they come from, (PHP, .NET, Java) Typescript help to make that transition.

Typescript isn't the only alternative, but it's the one i will be trying out today. Others are [Dart](http://www.dartlang.org/), [Coffescript](http://coffeescript.org/).

#### Features ####
* It will work in any browser
* It will work in any host, browser or Node
* Any OS
* It is [Open Source](http://typescript.codeplex.com/)(!)
* Very good tooling support (eg: Visual Studio, Sublime, Node.js, Vi, Emacs)

Okey, that sounds good... so what more?

* Supports standard Javascript code
* Provides Static Typing
* Encapsulation through classes and modules
* Support for constructors, properties, functions.
* Define interfaces
* Compiler & Tooling captures violations of syntax, types or interfaces.
* Lambda support
* Intellisense and again, Syntax checking.

So that is some of the Typescript major features.

I will now indulge myself in the video [Typescript Fundamentals](http://pluralsight.com/training/courses/TableOfContents?courseName=typescript&highlight=dan-wahlin_typescript-m1*3,2,5,9!john-papa_typescript-m4!dan-wahlin_typescript-m3#typescript-m1) from Pluralsight. If you don't have access to Pluralsight, i suggest watching this [Introduction Video to TypeScript](http://channel9.msdn.com/posts/Anders-Hejlsberg-Introducing-TypeScript) by Anders Hejlsberg

I will write some really simple examples of Typescript during the week and post them here. If you want to get started with TypeScript yourself, I suggest you head over to [typescriptlang.org](http://www.typescriptlang.org/) and head to the Play section!