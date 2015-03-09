---
layout: post

title: Owin Friendly Exceptions from Web Api
headline: "Transform your exceptions to nice HTTP responses"
categories: development
tags: 
  - .net
  - Web Api
  - Owin
  - Nuget
  - HTTP
published: true
---

The team at Caspeco needed a way to translate exceptions to nice HTTP responses. The exceptions could be thrown by a custom middleware, within the Web Api framework or in our bussiness logic. 

So we built a thin Owin Middleware to translate all exceptions into nice HTTP responses that makes sense when you read them in the client consuming your api. The result is available as the nuget package `OwinFriendlyExceptions` and the source is available at Github: [abergs/OwinFriendlyExceptions](https://github.com/abergs/OwinFriendlyExceptions)
