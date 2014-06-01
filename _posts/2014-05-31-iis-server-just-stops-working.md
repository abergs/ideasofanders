---
layout: post
title: If your IIS Express server just "stops working". Error Code 403.14 Forbidden
headline: "Why is nothing running?"
categories: development
tags: 
  - ASP.NET
  - IIS
comments: false
mathjax: null
featured: false
published: true
---
I've recently decided to update a webservice of mine. I added some business code and also added some startup code in `global.asax`. The work took a couple of hours and this was the first time in a month I touched the project. When I hit F5 to debug the browser just said `HTTP Error 403.14 - Forbidden`. Well - what is this? No Yellow Screen Of Death or anything, just a bad IIS response.

![403.14 Forbidden](https://w6szka.bn1304.livefilestore.com/y2p99PDRyqSkOwWg6pHj-ruoqQuCPSEOnyXyGE0O8evzb3S-O07hodXyJbN8JAk66lDSfffdvkaryB6R-x80wrLzMO9IxA23LLQCqGcY0ck9no/40314forbidden.PNG?psid=1)

I went through my code, tried to change ports on IIS Express and cleaned up my applicationhost.config. Nothing worked.

I started going back to older commits and everything worked. Turns out in the changes I made I introduced `async/await` in the global.asax `Application_start` and returned a `Task` instead of `void`.

Removed the `async/await` and everything worked again!

Hopefully someone will find this helpful while googling in despair!