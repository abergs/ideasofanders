---
layout: post
title: Introduction To Project Orleans
headline: "Orleans will rock your world"
categories: development
tags: 
  - .net
  - orleans
  - Azure
comments: true
mathjax: null
featured: true
published: true
---
In this article I want to give you a short introduction to [Project Orleans](http://orleans.codeplex.com).

## What is Project Orleans?
Orleans is a product from the eXtreme Computing division at Microsoft Research. It aims to help developers to develop "Cloud Native" services and it is a combination of **theories** of how you build large distributed applications plus the **tooling and framework** to make it very simple in practice.

> "Orleans targets developers who are not distributed system experts, although our expert customers have found it attractive too" &mdash; Orleans Team

## What is it really?
Okay, so you *kind of* know what Orleans is now. It's some framework and methodology to create mongo bongulos huge systems, like the [Halo 4 Presence](http://channel9.msdn.com/Events/Build/2014/3-641).
But why should *I* care?

Think of almost every time you are processing data and you use a `SyncLock`. Or any time you are really thinking of the impact if this code/query would be executed conccurrent while it's still progressing. Or if you just have a ton of work that needs to run concurrent. Like say parsing incoming messages and in realtime notify other parts of your system.

## Say hello to Orleans.IGrain - your new best friend
It's also known as a .NET Class and Interface.

    public class PersonGrain : BaseGrain, IGrain { ... }

In the [theories presented by Orleans](http://orleans.codeplex.com/wikipage?title=Getting%20Started%20with%20Orleans&referringTitle=Orleans%20Documentation), you will read alot about the [Actor Model](http://orleans.codeplex.com/wikipage?title=Core%20Concepts&referringTitle=Getting%20Started%20with%20Orleans). The Actor model share some of it ideas with the object oriented, self encapsulated model.
> "The units of distribution, actors, encapsulating data and computation, are called grains."

So in Orleans, a grain is just a C# class. That you can fetch by:
 
	var person = await PersonGrainFactory.GetPerson(id);

And then you can call functions on that person:

	var report = await person.ComputeYourExpenseReportFromYourStoredData();
	await person.UpdateYourManagerWithNewExpenseReport(report);

Here is the interesting part. The Class Person - do not live where you write this code. This code might be in your MVC-Controller or WebForm BtnClick handler, but `ComputeYourExpenseReport` is actually running on another server. It could be running on 1 of your 100 servers. You wouldn't care. It's just running. **It's just ORLEANS**. You don't have to know where to execute this, or if it's already running if anyone else have already requested this. 

**A Grain is single threaded**. That means that even if multiple web requests asks to compute that report it will be done sequentially, avoiding concurrency lockings and other very problematic situations. 

## You still can't explain Orleans to your friend, right?
Think of it like this:
> A Grain is somewhat like a cache with behaviour, which is *always available* as if it would be in memory and you do not have to worry about concurrency

It looks liks it's just calling some funciton on some class that is already instantiated in managed memory with data &mdash; but in fact it's running code on another machine in a cluster which handles it's own state and concurrency.

So Why Orleans? Because if you are not a well faired distributed system expert, building a *distributed*, *scaleable* or *concurrent* system is quite hard. And it is *very* hard when you combine all three words at the same time. 

Follow the white rabbit.

* [Orleans Samples](http://orleans.codeplex.com/)
* [Orleans Samples Overview](http://orleans.codeplex.com/wikipage?title=Samples%20Overview&referringTitle=Documentation)
* [Getting Started With Orleans](http://orleans.codeplex.com/wikipage?title=Getting%20Started%20with%20Orleans&referringTitle=Orleans%20Documentation)
* [Build 2014 Presentation](https://channel9.msdn.com/Events/Build/2014/3-641)
* [Project Orleans explained by the Orleans team](http://channel9.msdn.com/Shows/Going+Deep/Project-Orleans-A-Cloud-Computing-Framework)
* [Orleans: A Framework for Cloud Computing](http://research.microsoft.com/pubs/141999/pldi%2011%20submission%20public.pdf)
* [More Articles about Orleans...](http://orleans.codeplex.com/wikipage?title=Articles&referringTitle=Documentation)  

Expect more articles on Orleans from me in the near future.
 
