---
layout: post
title: Typescript 101: Basics, Types and Functions
headline: "Todays lesson..."
categories: development
tags: 
	- Typescript
comments: true
mathjax: null
featured: false
published: true
---
*This is the second article about TypeScript, you can read the [first part here](http://ideasof.andersaberg.com/idea/2/trying-out-typescript)*

I've talked earlier about the Javascript superset language TypeScript. I want to share some of the basics with you.
Unlike javascript, Typescript is typed. **This is a huge deal.** It will give you compiletime syntax and type checking. 

Also - just in case you missed it - TypeScript is just an improved version of Javascript. (Thats what superset implies). Valid Javascript is also valid Typescript, so if you have JS code now, you can just drop it into typescript and continue. When you compile Typescript, you get normal JS. For more information I recommend my earlier post, [Trying out TypeScript](http://ideasof.andersaberg.com/idea/2/trying-out-typescript).

To get started, I recommend you install Visual Studio 2012 and the extension [Web Essentials 2012](http://visualstudiogallery.msdn.microsoft.com/07d54d12-7133-4e15-becb-6f451ea3bea6)
![Web Essentials 2012](https://w6szka.dm1.livefilestore.com/y1pSU9Z0Cb-yAkh7FoEoh9Ddr-c0tuSx_omqMUbAm77qDAyNlslRwFPmAlGRAVV002E5ukItCAGtK3KjYbdkfYMBG0aHK1jY618/web-essentials-2012.png?psid=1)

Fire up Visual Studio and create your first typescript file (myscript.ts). With Web Essentials 2012 extension installed, you will have a split screen with TypeScript on the left side and javascript to the right. This is useful since you can see how the compiler (it compiles on save) actually transforms your code. You can copy/paste the code below and play around with the syntax until you become comfortable.

### Types ###
So, this is what typescript look like:

    var age; // Type of Any (generic type)
    var age1 = 21; // inexplicit typed number
    var age2: number = 21; // explicit typed number

    var name; // Type of any
    var name1 = "Anders"; // inexplicit typed string
    var name2: string = "Anders"; // explicit typed string

    var isThisAwesome : bool = true;

You delcare a type by ` : Type`. Simple as that. You don't have to declare a type, but it is usually recommended since you get better intellisense och compile-time checking

### Functions ###
You can declare functions in two different ways. Since you will be mostly living inside a `class` (did i mention you can have classes and constructurs in typescript?) you will mostly use this syntax: `myFunc(inputValue : string) {  // do stuff  }`.

If your not inside a class, you can use the standard JavaScript way, `function doSomething() {}`

In the next article I will describe how you can use classes and interfaces to create complex types. If you want to continue by yourself, I suggest playing around at [TypeScriptlang.org](http://www.typescriptlang.org/)