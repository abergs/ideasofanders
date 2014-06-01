---
layout: post
title: Azure Web Site 403 Forbidden css bundle
headline: "Want to post code in markdown easily?"
categories: development
tags: 
  - ASP.NET
  - IIS
comments: true
mathjax: null
featured: false
published: true
---
This recently happened to me:
![403 forbidden azure](https://w6szka.dm2301.livefilestore.com/y2pM_gLe8lmRE9tteKXfA1BOOLLn0D-l1Wq2M9OapeIIwFjWpi8pPXMoff3ZW2ONZrNyRHoSliwFgGY9urc68rpW5nOiuVS5YjKMME8YMhZ5-g/403forbidden.PNG?psid=1)

Well. What the..?
Why would this be forbidden? It's just a bundle? My project was very default, so it would not be authorization rules.

Turn out there is a simple keyword to remember:
###  Never use a path that physically exist in your project as virtual name for your bundle.
In my example I actually had a physical directory that matches *"/Content/Css"*, so Azure would pick that up instead, and naturally I didn't allow directory browsing, which triggered the 403 call.

Fix this issue by renaming the bundle. *"/Content/css"* -> *"/Content/**CssBundle**"*