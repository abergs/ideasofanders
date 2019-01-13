---
layout: post

title: jQuery in three lines of code
headline: when you need something small
categories: development
tags: javascript
  - 
published: true
---

One code snippet I often return to when building something small and I need to select an element or add eventhandler is this:

```

const $ = (selector) => document.querySelector(selector)
const $$ = (selector) => document.querySelectorAll(selector)
const on = (elem, type, listener) => elem.addEventListener(type,listener)

```