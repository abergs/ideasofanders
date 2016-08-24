---
layout: post
title: "Mission: Build a drop dead simple CMS"
headline: "Simply simple, stupid"
categories: development
tags: 

comments: true
mathjax: null
featured: false
published: true
---
I'm on a mission. 

Actually, I have an itch. I need a drop dead simple CMS.
Not Wordpress, Not Umbraco.

I don't want to bend my frontend after how the CMS is architectured. I want to slam a backend on my frontend, if you know what I mean.

So - I will build one. 

The mission is to build a add on backend, using ASP.NET MVC4. I imagine it being a nuget package that you install and then you can just access the dynamic content by calling ` @CMS.RenderContent("WelcomeScreen") ` in your views.

