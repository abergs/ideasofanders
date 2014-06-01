---
layout: post
title: quick-fix-iis-woff-font-file-404-not-found-in-aspnet-mvc
headline: "Who's there?"
categories: development
tags: 
  - ASP.NET
  - IIS
comments: true
mathjax: null
featured: false
published: true
---
This is just a very quick "bugfix" I found.  
When using Twitter Bootstrap Glyphicons the font comes in a lot of flavors, including .ttf and woff. Somehow it seems that IIS will return a 404 not found when requesting the .woff file -- even though the file definitely exists and the URL is correct. The problem lies within the MIME-types that IIS use.

You'll have to add this MIME:

    <system.webServer>
        <staticContent>
          <remove fileExtension=".woff" />
          <mimeMap fileExtension=".woff" mimeType="application/x-font-woff" />
        </staticContent>    
      </system.webServer>

If you don't want to add this to the web.config, you can also configure the IIS server in the UI.  
Vóila!