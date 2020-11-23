---
layout: post

title: Sign in with fingerprint - asp.net
headline: Using the passwordless api
categories: development
tags: 
  - passwordless
  - webauthn
  - fido2
published: true
---

# Sign in with fingerprint - asp.net

Using the [Passwordless API](https://beta.passwordless.dev/) we can add secure and fast sign in to our existing asp.net apps. The API allows us to add sign in with FaceID, Fingerprint scan or other native methods like the android lock screen or Windows Hello. It's make it easy to consume the complex  browser standards WebAuthn and FIDO2. 


Example on iOS 14:  
![Sign in with FaceID - asp.net](https://user-images.githubusercontent.com/357283/100014365-8e627300-2dd6-11eb-8e3d-db7566adfacb.png)

Exampe of Windows 10:  
![Sign in with Windows Hello - asp.net](https://user-images.githubusercontent.com/357283/100014246-696e0000-2dd6-11eb-93c0-996ab963df42.png)


## Who is this guide for?

It's for you, a asp.net developer who want to add make your existing web app **more secure** and **faster** to sign in to. I assume you already have a existing user database, probably using username / password.

During this blog post we will implement passwordless sign in from start to finish, using the passwordless api.


## Overview

There are a couple of steps in implementing this. We will need to:

1. Get a free API key
2. Allow a existing user to enable passwordless sign in
3. Allow a user to sign in without a password

Both steps require both some client side code and some backend code, but it's not much.

## Getting your Passwordless API key

Start by [getting your free api key](https://beta.passwordless.dev/create-account). The free plan is perfect for getting started. There are paid plans for when you want to take things to the next level, but the free plan works well as a starting point.

**Make sure you copy these keys to a safe place, they can not be retrieved ever again.**. If you loose your API keys, you will need to create a new account.

## Allow existing users to enable passwordless sign in

Anywhere in your app, you want to add a button that allows a user to enable passwordless sign in. Perhaps you place this button under Account Settings. This could also be done during sign up, it's up to you. 

You need to add both some backend code and some client side code, let's start with the client side:

We will add a button and include the passwordless client library.

```html
<script src="https://cdn.passwordless.dev/dist/0.0.1/passwordlessclient.min.js" integrity="sha384-TPor6eIWM4IefSReNrio8zR0tr3LIHYNSwlSNKArZo42TEWTmByjkkJm/vvnUxxv" crossorigin="anonymous"></script>

<button id="passwordless-enable">Enable passswordless sign in</button>

<script>
    async function RegisterPasswordless(e) {
        e.preventDefault();

        var p = new Client({
            apiKey: "demo:public:xxx" // replace with your public api key
        });

        // call your backend to get a passwordless token
        var myToken = await fetch("/example-backend/passwordless/token").then(r => r.text());

        try {
            await p.register(myToken);
            // if no error is returned, the credential was successfully registered
            console.log("Finished registering, you can now sign in!");

        } catch (e) {
            console.error("Things went bad: ", e);
        }
    }

    document.getElementById('passwordless-enable').addEventListener('click', RegisterPasswordless);
</script>
```

New let's add some code to your backend to get that token.
It will be easier if we install the .net [PasswordlessClient](https://www.nuget.org/packages/PasswordlessClient/) via nuget:

* `Install-Package PasswordlessClient`
* or `dotnet add package PasswordlessClient` 

If you do not install the .net PasswordlessClient library, you can do the Rest API call [manually](https://github.com/passwordless/passwordless-client-js#register-a-webauthn-credential-to-user).

```csharp

// File: AccountController.cs (or other suitable controller)
// we're using GET for simplicity, for security reasons you might want to use POST and send a xsrf-token.
[HttpGet]
public async Task<string>  GetPasswordlesToken()
{
    // get the currently signed in user, perhaps via cookie or HttpContext.
    var username = Request.Cookies["User"];
    var apiSecret = "demo:secret:yyy";

    var client = new HttpClient();
    
    // get a token that allows registering a passwordless credential for this username
    var token = await client.GetPasswordlessRegisterToken(new PasswordlessTokenParameters(apiSecret, username));
    
    // return the token to the client side code
    return token;
}
```

## Try signing in using passwordless

Now that we can successfully register a passwordless credential, you might want to try using it as well. The procedure is very similar to registering.


```html
<script src="https://cdn.passwordless.dev/dist/0.0.1/passwordlessclient.min.js" integrity="sha384-TPor6eIWM4IefSReNrio8zR0tr3LIHYNSwlSNKArZo42TEWTmByjkkJm/vvnUxxv" crossorigin="anonymous"></script>

<input type="text" id="username" placeholder="Your username" />
<button id="passwordless-signin">Sign in passwordless</button>

<script>
    async function PasswordlessSignin(e) {
        e.preventDefault();

        var p = new Client({
            apiKey: "demo:public:xxx"
        });

        var username = document.getElementById("username").value;

        try {
            var token = await p.signin(username);
            var verifiedUser = await fetch("/example-backend/signin?token=" + token).then(r => r.json());

            // If no error is thrown, the sign in was successful!
            console.log("User", verifiedUser);
        } catch (e) {
            console.error("Things went really bad: ", e);
        }
    }

    document.getElementById('passwordless-signin').addEventListener('click', PasswordlessSignin);
</script>
```
Similar to when registering a client, we need to add some backend code to verify what user signed in.


```csharp
// File: AccountController.cs (or other suitable controller)
public async Task<IActionResult> TokenVerify(string token)
{
    var apiSecret = "demo:secret:yyy";

    var httpClient = new HttpClient();
    // use the Passwordless extension functions
    var result = await httpClient.VerifyPasswordlessToken(new VerifyTokenParameters(apiSecret, token));
    if (result.Success)
    {      
        // The sign in was successful, set any authentication cookies etc
        Response.Cookies.Append("User", result.Username);

        /* These are the values returned by the API:

            public string Username - The username of the signed in user
            DateTime ExpiresAt - When the Token expires/expired at            
            public DateTime Timestamp - When the sign in took place
            public string RPID - For what domain the user signed in to (example.com)
            public string Origin - The Origin that the user signed in to (https://auth.example.com)
            public bool Success - If the sign in was successful
            public string Device - What device was used , e.g. "Firefox, Windows 10"
            public string Country - What country the sign in came from, e.g. "US".
            public string Nickname - Nickname of the credential, can be supplied when registering it.

        */
    }

    return result;
}
```
That's it! You can now allow users to sign in using whatever security mechanism is available on there device (FaceID, TouchID, Windows Hello etc).