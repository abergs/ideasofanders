---
redirect_from: /idea/9/net-mvc-4-model-binding-null-on-post/
layout: post
title: ASP.NET  MVC 4 Model binding null on post
headline: "Why is message null when message is message"
categories: development
tags: 
  - ASP.NET
comments: true
mathjax: null
featured: false
published: true
---
So you have your form in  MVC 4 and you want to post it to a Action on a controller.

The form represents a class, let's pretend this is a contact form and you have a a class that look like this:

    class ContactMessage
     {
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Message { get; set; }
    }

And your action, looks like this:

        [HttpPost]
        public ActionResult Kontakt( ContactModel message)
        {
            var mailer = new ContactMailer();
            var msg = mailer.ContactMessage(message);
            msg.Send();
       }

Well, that should work, right? Right? RIGHT?
Well - No.

Because, the Model Biner in .NET MVC 4 will doubt what you mean. Because - the post value looks like this:

     Name=Anders&Phone=123&Email=abc&***Message***=Hello!

You see that Message property name? That will fuck up the ModelBiner. Because... in your Action, you are waiting for the incoming  property **Message** (it will use the name of variable). But what you really want is the full, complex, model and just calling it *Message*.

### The solution
Do not name your incoming variables in the Action the same as you do in the model being posted. That will mess up the Model Binder.

Change your action to this:

        [HttpPost]
        public ActionResult Kontakt( ContactModel INCOMINGmessage)
        {
            var mailer = new ContactMailer();
            var msg = mailer.ContactMessage(INCOMINGmessage);
            msg.Send();
       }
