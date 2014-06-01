---
layout: post
title: Installing Touchpad driver on Apple Macbook Pro running Windows 8.1
headline: "A helpful guide"
categories: personal
tags: 
  - Apple
  - Windows
comments: true
mathjax: null
featured: false
published: true
---
I stopped using my Macbook Pro about 1,5 years ago, since I wanted to run a "real" PC for my .NET developing.

My MacBook Pro have been in a box since then, and last night I decided to install Windows 8.1 RT on it and use it as a second PC since my main machine is quite large and heavy to bring around. Also, the keyboard on this macbook is way better than on my main laptop.

After a couple of hours installing Windows 8.1 yesterday, everything spun up, but i was in for a suprise:

### Touchpad not working
So, for a laptop this is a big deal. I googled alot and I finally found a way to repair this:

* Open the Device Mangaer (Cmd + X, M)
* Tab once, then go down with the arrow keys to the list of unknown devices. It should say Touchpad on atleast one item.
* Open up the properties for the Touchpad device, and try to install a driver from **local disk** (do not search online, that won't help).
* Choose **USB input device** as the driver, do not use the apple driver just yet. After the installation is finished, your touchpad will work.
* After installing the USB driver you can perform the same steps, but pick the Apple driver. After the installation is complete, your touchpad will work as expected.

I haven't got the scrolling to work perfectly just yet, but atleast the computer is usuable.
