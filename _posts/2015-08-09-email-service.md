---
layout: post

title: Building the Email Service that provides value for Caspeco
headline: "There is no mail like email at Caspeco"
categories: development
tags: 
  - .net
  - Web Api
  - Email
  - Azure
  - Postmark
published: true
---

One of my last tasks at Caspeco were to build our email service for our new platform. Normally, this could be as simple as `Smtp.Send(email)` but I wanted to improve the value that it generated so, I really took a deeper approach. First, let me tell you have we do it in our old platform.

## How we used to do
We already make use of a third party emailservice, instead of our own SMTP service. This gives us the benefit of lower spam ratings, as well as some simple statistics, such as email sent, email bounced etc. But we sent the mails synchronous, causing long response times for sending many emails, especially since we often send attachments (payslip pdf's, schedule printouts etc).

## Value proposition for v2
When building the new service, the following were the goals and value propositions I took into account.

* **Faster**. Allow background processing for faster response times.
* **More resilient**. Do not fail completely if Postmark is down. Allow retries and corrections for historic emails.
* **Better Insights**. Ability to see who received their email and who didn't, for example when sending salary specifications. Ability to add custom tags.
* **Multi platform**. Ability to render Messages not only in the email client, but inside our apps.
* Support **large attachments** and, again, attachments for in-app purposes.
* **Better API** for developers, current API caused weirdness in some use cases.

## The design

1. IEmailer
Add an email to the IEmailLog, Upload and reference any attachments, schedule it for sending  
*Current implementation simply calls subsystems in the correct order and with the correct data.*

2. IEmailLog
Represents a log of all emails (pending, sent, failed) and their related events.  
*Current implementation stores information in SQL database.*

3. IFiles
Service to Store, Retrieve and reference stored/uploaded files.  
*Current implementation leverages azure BLOB storage.*

4. IEmailCommands
Commands that is used to trigger actions, such as sending an email from the emaillog.  
*Current implementation leverages azure storage Queues. This subsystem exist because we have multiple EmailWorkers and we need to make sure we have atomic processing of an email message (no concurrency/race conditions)*

5. EmailWorker
The background process that process Commands from IEmailCommands.
Responsible for:
* Acting upon Commands
* Parse Email messages to Text & Html layouts
* Delivery through either Postmark or other providers.
* Current implementation is a background process running on the api server itself. This implies that we have multiple email workers running at the same time, giving both resilience but also some side effects such as concurrency.

## Reflection
Although the new platform adds a certain complexity since it involves more components, every component is well defined and only responsible for one thing. Also the goals defined for version 2 puts certain requirements that cannot be worked around, such as attachment storage and rendering an email in the application.

The API for sending emails remain simple:

	_emailer.Send(new Email {
		to: "anders@example.se",
		title: "Hello!"
	});

On could argue that the biggest difference and sacrifice is the lack of a synchrounos result, but I would argue that isn't true, since the reply we receive from Postmark is not a definitive reply, just that everything checkouts on their end. If postmark returned OK and the email later bounced, we would be lying about the result.

How do you do Email? Would you do it differently? Tell me in the comments.