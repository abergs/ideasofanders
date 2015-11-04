---
layout: post

title: The fastlane to css hipster heaven  
headline: A story about styling your styles
categories: development
tags:
  - css
  - html
published: true
---

So there is a cool feature in HTML5 and it's called `contenteditable`. It's a attribute you can place on any element in your page and it will allow your users to change the text inside. This can be useful for a lot of things, but what is even more interesting is the silly things you can do with it.

# Show a styletag in the body

Before diving deeper into contenteditable, there is another weird thing you can do in css.
You can render your `<style>` tag as a normal element. Let me back up. Normally a style tag is located in the `<head>` with `display:none`. Although not recommended, there is nothing stopping you from changing this to something whackier:

    <body>
        <style class="hipster-style">
            .hipster-style {
                display:block;
            }
        </style>
    </body>
    
Yep, that's weird. You can actually render the style tag in the page. But that's not super helpful. Sure, you can see the styles that are applied. But wouldn't it be kind of cool if we could do live edits without using the F12 developer tools? 

## Let's abuse HTML

It's time to introduce the `contenteditable`-attribute again. Let's see what happens when you put contenteditable on your styletag.

    <body>
        <style class="hipster-style" contenteditable>
            .hipster-style {
                display:block;
            }
    
            body {
                background: honeydew;
            }
        </style>
    
        <h1>Go ahead - change the background color for this page..</h1>
    </body>

Well - you can live edit the css for your site.

## Time to style the styles

So I think you know where this is going. Thanks to the amazeballs of HTML5 you can live edit the styles of your styles.

    <body>
        <style class="hipster-style" contenteditable>
            .hipster-style {
                display:block;
                background: tomato;
                color:white;
            }
    
            body {
                background: honeydew;
            }
        </style>
    
        <h1>Go ahead - change the background color for this page..</h1>
    </body>

Try it out live: http://codepen.io/anon/pen/avjgzE

Yep, that's meta. HTML5 and CSS allows you style the CSS itself. Well, kind of - CSS allows you to style elments on your page, right? And the `<style>`-tag is an element in your page, as long as you put in the `<body>` instead of `<head>`.

## Is this useful?
No. And Yes. This is not something you would throw into your every-day site. But it's kind of cool things you could do with this. For example:

Great way to let the visitor edit the styles of an CSS example and see what makes what happen - without needing to use a third party sandbox such as JSFiddle or CodePen, or doing a lot of "onChange update this JS mess" etc.

Happy hipster hacking!