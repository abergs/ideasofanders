---
redirect_from: /idea/12/typescript-09-generics-what-and-how-to-use-them/
layout: post
title: TypeScript 0.9 Generics: What? And How to use them
headline: "Generic type anyone?"
categories: development
tags: 
  - Typescript
comments: true
mathjax: null
featured: false
published: true
---
Typescript 0.9 was released today and it brings some great things to the Typescript language!

In this post i'd like to tell you about Generics and show you how to use them. Let's get started.

Generics is used to add types to functions that can give you different type of objects depending on what you put into them. If you are familiar with .NET or C# a very common Generic Class is the `List<>`. You can have a list of different type objects, for example: `List<int>` or `List<string>`, with the upside that you always get compile time type-safety.

A typical use case for Generics is in abstract classes, that can be reused throughout the application. For example: `DataStore<User>` and `DataStore<Post>`, or the KnockoutJS library observables: `var post = ko.observable<Post>()`.
(In the end of this post, i will show you more example of Knockoutobservables)

** Hint:* You can also read my previous TypeScript posts:   

* [Trying out Typescript](http://ideasof.andersaberg.com/idea/2/trying-out-typescript)
* [TypeScript and Knockout. Where did my this instance go?](http://ideasof.andersaberg.com/idea/11/typescript-and-knockout-where-did-my-this-instance-go)

Typescript uses a very similar syntax. Enough small talk; here is the code:

<script src="https://gist.github.com/abergs/5817818.js"></script>

## Knockout observable with generic type ##
First, download the types and interfaces for knockout here: [Github: DefinitelyTyped](https://github.com/borisyankov/DefinitelyTyped/blob/master/knockout/knockout.d.ts)


<script src="https://gist.github.com/abergs/5817971.js"></script>


**You should follow me on twitter: [@BigCheeseAnders](https://twitter.com/BigCheeseAnders)**
