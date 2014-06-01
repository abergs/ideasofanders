---
layout: post
title: Keep your Free Azure Website from idle (app pool timeout)
headline: "A helpful guide"
categories: development
tags: 
  - Azure
comments: true
mathjax: null
featured: false
published: true
---
Currently Windows Azure Free/Shared Websites will unload your application from memory after some inactivity. The reasons are quite easy to understand, since there are a lot of free websites getting no traffic, but still wasting system resources at the datacenter. 

In this free/shared mode, you cannot change this behaviour, so in order to keep your application in memory, you need to have some actual traffic.

##### But what if I don't have a visit every 20 minutes?

Not all websites have a visit every 20 minutes, but still wants their site to remain quick and responsive every 25'th minute for a visitor for example.

##### Let's fake that visitor

You can fake that visitor quite easily. Here is some ways:

* Use a pinging-service; e.g. http://www.uptimerobot.com/
* Create a very short powershell script, running `WebClient.DownloadString(url)` and set your Task Scheduler to run it (if you always have your computer on and the site is not for anything production-related)
* Run Azure Mobile Services and create your own pinging-service in under 15 minutes.

So, the option I opted for was running my own Azure Mobile Services, just to try it out. Can't hurt to get to know a new piece of tech, right? Right.

### Architecture of your custom pinging service
So, the task is to use Azure Mobile Serives (AMS), and to write as little custom code as possible.

This is the features we are gunning for: 

* Our pinging service will have a REST-API for managing which url's the service will ping.
* It will visit the registered urls every 15 minute.

Again, we are actively limiting us to only use features within AMS.
Let's begin with the first feature, setting up a rest-api for accessing the url-database.

#### REST API
Enter the Azure management portal and set up your Azure Mobile Service.
Once it have been created, head over to the data tab.

Click Create, enter a table name and change the permissions accordingly. Here is my setup:
![My settings for the data table](https://ktdnhg.dm1.livefilestore.com/y2ptxxWq1c3Rgxw2UxUyUmTIkT4wPY3mFQ83iuR_4yjSeHwEzVjo2MSAQ55qWTRSe8y1-1liSRFKB19k4rRnhhAQFsThpODBPhLXFekKk1tuhM/AMSdb.png?psid=1)

Once your table have been created, Enter the settings for that table and add the following script for the INSERT-action. It makes some length validations and a simple check if that url is not already added and adds a createdAt date to the database row.

    function insert(item, user, request) {
    	var sitesTable = tables.getTable('urls');
        item.createdAt = new Date();
        
        if (item.url.length > 100) {
            request.respond(statusCodes.BAD_REQUEST, 'Url length must be under 100');
        } else {
            sitesTable.where({
                    url: item.url
                }).read({
                    success: function (results) {insertIfUnique(results, request); }
                });        
        }
    }
    
    function insertIfUnique (existingItems, request) {
    	if(existingItems.length === 0) {
        	request.execute();
        }else {
        	request.respond(statusCodes.BAD_REQUEST, 'Url is aldready added');
        }
    }

You now have a fully functional REST-API, available at: 
`https://<service_name>.azure-mobile.net/tables/<table_name>`

Read more about the API here:
http://msdn.microsoft.com/en-us/library/windowsazure/jj677200.aspx

#### Setting up the Scheduled Task
Okey, so we are halfway there. You can add/manipulate urls by REST-api (or by management portal). Now we just need something to request the urls every 15 minute. *Azure Mobile Services Scheduler to the rescue!*

Setup a new Scheduled Script to run every 15 minute minute, by going to the Scheduler "tab" and clicking on create. You can then enter what script you want to perform. I use this one to iterate all the urls in the database and perform an request.

    function Refresh() {
        var sitesTable = tables.getTable('urls');
        var req = require('request');
        
        sitesTable.select('url')
        .read({ success: function(results) {
            results.forEach(function (siteObject) {	
                req.get({ url: siteObject.url});       
            });
        }});    
    }

#### How to use it
Your Free Azure Website will keep on rockin in memory with this setup.
If you prefer to use my pinging service, perform this post (just change the url to your site).
    
    POST https://dontidlemysite.azure-mobile.net/tables/urls HTTP/1.1
    User-Agent: Fiddler
    Content-type: application/json
    Host: dontidlemysite.azure-mobile.net
    Content-Length: 45
    
    {"url":"http://dotnetnews.azurewebsites.net"}

**You should follow me on twitter: [@BigCheeseAnders](https://twitter.com/BigCheeseAnders)**