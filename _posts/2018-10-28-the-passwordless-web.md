---
layout: post

title: The passwordless web is coming
headline: 
categories: development
tags: fido2 .net
  - 
published: true
---

I have been working on a very exciting [side project](https://github.com/abergs/fido2-net-lib) the last couple of months that will allow you - as a user of a website or app - to signup and login without passwords.

![Fido2 register](/images/fido2/fido2.gif)

This technology is called *FIDO2* (Fast IDentity Online) and was designed by the FIDO Alliance together with large tech companies such as Microsoft, Google, Paypal etc.

# Why it's cool and you will like it

**You never have to use passwords again. Seriously.**  Instead you will have a key - you can think of it like a house key; *but digital and on steroids*. This digital house key can look like a usb stick (shown below) and is usable over NFC and bluetooth, but it can also be directly  built into your device so you don't need to carry something extra with you. 

While I could say that your passwords live in this key, it's not really true. The key uses public/private key cryptography instead of shared secrets (passwords) and your private key never leaves the device. There's a lot more technical things to say here, but we will skip it for now.

Never using passwords is one of the main value propositions behind FIDO2. While that makes life a lot easier (a lot less tech support calls from the family?) it also makes you and your company a lot more secure since the majority of IT breaches and hacks are casued by leaked passwords or phising attacks, something FIDO2 eliminates.

It can look like this:

On screen:
![Fido2 on-screen UI](/images/fido2/fido2-onscreen.gif)

Off screen:  
![Fido2 off-screen UI](/images/fido2/fido2-offscreen.gif)

While the example above uses a USB stick, it can also be directly built into your phone or laptop and secured by fingerprint scanning or facial recognitnion.

# My work
I started working on my [FIDO2 project](https://github.com/abergs/fido2-net-lib) in the spring of 2018 after seing a presentation on the concept  because I was very excited about the possibility of making a complex digital life easier. Shortly after I began working on the open source project a security engineer from EA joined me and together we created the first implementation of FIDO2 in .NET CORE, enabling developers to make their websites, apps and systems FIDO2 ready and compliant. We're now launching version 1.0.0 and I couldn't be more proud of the work we've done together.

If you are curious the project is open source and released under the MIT license here: [WebAuthn .net core FIDO2](https://github.com/abergs/fido2-net-lib)


