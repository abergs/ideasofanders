---
layout: post
title: TypeScript and Knockout. Where did my this instance go?
headline: "Knock knock..."
categories: development
tags: 
  - Typescript
  - Javascript
  - KnockoutJS
comments: true
mathjax: null
featured: false
published: true
---
So, a problem we had at work was that in one of our TypeScript classes, we set up an class variable as a computed, as so: `myComputed = ko.computed( () => { return this.myClassFuntion();});`. The problem with this is that typescript will compile a prototype method, and Knockout will change in what context this is run. The result is that `this` will become `window` instead of the instance of our `class`.

The solution to this problem is to only create the function as a field in the class, as so: `public myComputed;`. And then, in the constructor, set the value of that field to a lambda function:

    class myClass {
         public myComputed;
         constructor() {
                  this.myComputed = () => { return this.MyInstanceFunction(); } 
         }
         
         MyInstanceFunction() {
                  return 1;         
         }
    }
The example is very stupid, but it demonstrates how you can set up functions (and in detail, observables) to keep the correct context.