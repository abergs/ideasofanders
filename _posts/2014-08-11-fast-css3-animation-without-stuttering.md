---
layout: post

title: Fast css3 animations without stuttering
headline: Get rid of those annoying ghost edges
categories: development
tags: css3 animation
  - 
published: true
---
I was tasked with a very simple task. Moving a ball from the left edge of the screen to the right edge. That's a simple task, and have been possible for ages using for example jQuery animations. However, the ball had to move  **smoothly** over the screen and back in 0.5 seconds. 

## The problem with smoothly
Obviously, it has to have a great performance. So I decided to instead of manipulating the DOM with javascript, I would use css3 animations to translate the position of a div. The thing is, the speed the ball was moving at is too high for the human eye to resolve smoothly. We experience a trace or shadow copies of the figure making the ball dizzy.

##  The solution
Add Motion blur. That is the way games do it and that is the way Hollywood does it. Adding motion blur to an object that is moving fast makis it look smoother to the human eye.

In my case, i could just add a box-shadow or a filter:blur to the balls css class.1