---
layout: post
title: Launching&#58; TabsToSpaces.com. For your markdown code copy pastes
headline: "Want to post code in markdown easily?"
categories: development
tags: 
  - Powershell
comments: true
mathjax: null
featured: false
published: true
---
I'm launching a little tool that makes my life happier every time I use it.
### The problem I solve
Okay. So I paste code from my IDE to my blog when showing code examples and snippets. In order for markdown to get the code block formation, this required 4 spaces in the beginning.

Sometimes the code is intendented by tabs, sometimes not. But every time there are some rows that are not intendented at all (e.g. code at the base/root level scope).

### The solution
I searched for an fast and easy online converter but there wasn't any. No one covered the *IDE to markdown* scenario.
So I built a powershell script that was clumsy and "slow":

    (Get-Content f.txt) |  ForEach-Object {$_ -replace "^","    "} > t
    (Get-Content f.txt) |  ForEach-Object {$_ -replace "\t","    "} > t
    
That suckes. Who have time to create files when you just want to copy paste some code?
### The really nice solution that I'm sort of proud of
So I finally built a webpage that does everything in a extremely fast and convenient manner.  
**I introduce to you:**  
[Convert Tabs To Spaces Online](http://tabstospaces.com/)

Simply paste your code. Convert. Optionally add four spaces to the beginning for perfect markdown syntax :)

The [site source code](https://github.com/abergs/tabstospaces) is available on github and I use Github Pages to host the public version.

I also signed up for CloudFlare Free to try to squeeze the last milliseconds from the load time :)

Any feedback is appreciated.