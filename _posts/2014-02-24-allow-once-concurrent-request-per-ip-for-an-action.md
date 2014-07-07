---
redirect_from: /idea/2025/allow-one-concurrent-request-per-ip-for-an-action
layout: post
title: Allow one concurrent request per IP for an action
headline: "Hold your horses"
categories: development
tags: 
  - ASP.NET
  - WebApi
comments: true
mathjax: null
featured: false
published: true
---
We had a situation at work where we needed to throttle/limit file uploads so that the user only can upload one file simultaneously in our Web API.

So I wrote this Action Filter that will throttle requests by IP and only allow one concurrent request for that action. At work we edited the script to throttle per user (from session), instead of IP. We use the filter for our Web Api endpoint, but it should work the same for an MVC action.

Any feedback is greatly appreciated, here it is:

<script src="https://gist.github.com/abergs/9334586.js"></script>

