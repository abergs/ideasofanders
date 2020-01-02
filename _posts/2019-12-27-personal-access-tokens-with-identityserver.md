---
layout: post

title: Personal Access Tokens with IdentityServer4
headline: Enable Personal Access Tokens using existing features in IdentityServer4
categories: development
tags: 
  - identityserver
  - .net
  - dotnet
published: true
---

In this post, I will describe how you can leverage existing IdentityServer features to generate and support PATs, as well as configuring your API Resources to accept them.

## Why Personal Access Tokens (PAT)?
A PAT is a alternative to your username/password for authentication when working with Automation scripts or curl'ing your API where oAuth might be inconvenient or hard to implement. 

## Reference Tokens
Identityserver has built-in support to generate both JWT (Self-contained) and [Reference Tokens](http://docs.identityserver.io/en/latest/topics/reference_tokens.html) (not self-contained). In contrast to JWTs, a reference token can easily be revoked which is a useful feature for a PAT. IdentityServer also expose introspection endpoints for oAuth API Resources to verify the validity of a Reference Token. We can therefore leverage long-lived reference tokens as PATs.

### Self-issue reference tokens in code
First we need an easy way for a user to generate a PAT. Luckily, IdentityServer already comes with tools to [self-issue tokens](http://docs.identityserver.io/en/latest/topics/tools.html). 
However, since those APIs generate JWTs I had to create my own tools. Easy enough since the original source code is available on github. Here is my customized version:


```csharp
    /// <summary>
    /// Class for useful helpers for interacting with IdentityServer
    /// </summary>
    public class TokenTools
    {
        private readonly ITokenService _tokenCreation;
        private readonly ISystemClock _clock;

        /// <summary>
        /// Initializes a new instance of the <see cref="IdentityServerTools" /> class.
        /// </summary>
        /// <param name="contextAccessor">The context accessor.</param>
        /// <param name="tokenCreation">The token creation service.</param>
        /// <param name="clock">The clock.</param>
        public TokenTools(ITokenService defaultTokenService, ISystemClock clock)
        {
            _tokenCreation = defaultTokenService;
            _clock = clock;
        }

        /// <summary>
        /// Issues a JWT.
        /// </summary>
        /// <param name="lifetime">The lifetime.</param>
        /// <param name="issuer">The issuer.</param>
        /// <param name="claims">The claims.</param>
        /// <returns></returns>
        /// <exception cref="System.ArgumentNullException">claims</exception>
        public virtual async Task<string> IssueReferenceToken(int lifetime, string issuer, IEnumerable<Claim> claims)
        {
            if (String.IsNullOrWhiteSpace(issuer)) throw new ArgumentNullException(nameof(issuer));
            if (claims == null) throw new ArgumentNullException(nameof(claims));

            var token = new Token
            {
                Audiences = new string[] { "my_api" },
                ClientId = "pat_client",
                CreationTime = _clock.UtcNow.UtcDateTime,
                Issuer = issuer,
                Lifetime = lifetime,
                Type = OidcConstants.TokenTypes.AccessToken,
                AccessTokenType = AccessTokenType.Reference,
                Claims = new HashSet<Claim>(claims, new ClaimComparer())
            };

            var handle = await _tokenCreation.CreateSecurityTokenAsync(token);

            return handle;
        }
    }
```

The method `IssueReferenceToken` accepts parameters to customize the lifetime, the issuer and the claims of the token and returns a string token back. While we could make Audiences and clientId to be customizeable it was not needed in my use case.

### Adding a PAT Client

Since the PAT might be used by a script/application that is not registered as a client in Identityserver I created a "default" client for PATs. Useful if you want to limit scopes etc.

```csharp
    new Client
                {
                    ClientId = "pat_client",
                    ClientName = "Personal Access Token Public Client",
                    AllowedScopes =
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        "my_api"
                    },
                    AccessTokenType = AccessTokenType.Reference
                 },
```

## List and Create PATs

I added a PATController with some very simple Views that allow the user to Create / List PATs.

```csharp
public async Task<IActionResult> Index()
        {
            string subject = HttpContext.User.GetSubjectId();
            // customized GrantStore method to get all PATs
            var pats = await referencetokenStore.GetGrantsAsync(subject);

            return View(pats);
        }

public async Task<IActionResult> Create(string shortName, DateTime expiration)
        {
            double PatExpires = (expiration - DateTime.UtcNow).TotalSeconds;
            if (PatExpires > int.MaxValue)
            {
                // correctly adjust for int overflow
                // int.MaxValue; // 68 years, maximum
                PatExpires = int.MaxValue;
            }

            // todo: Support multiple clients?
            var clientId = "pat_client";
            var scopes = "my_api";
            var issuer = "xxx";

            var tokenMeta = $"{shortName}-{DateTime.UtcNow.ToShortDateString()}-{DateTime.UtcNow.AddSeconds(PatExpires).ToShortDateString()}";

            IEnumerable<Claim> claims = new Claim[] {
                // user subject
                new Claim(JwtClaimTypes.Subject, HttpContext.User.GetSubjectId()),
                new Claim(JwtClaimTypes.Scope, scopes),
                // what auth was made? pat, custom value by anders
                new Claim("amr", "pat"),
                new Claim("token_meta", tokenMeta)
                // etc
            };
            var token = await _tools.IssueReferenceToken((int)PatExpires, issuer, claims);

            var msg = $@"This is your Personal Access Token (PAT). It will only be shown once: 
{tokenMeta}--{token}";
            return Content(msg);
        }

        public async Task<IActionResult> Remove() { // ommitted for brevity}
```

## Modify handles (optional)
When creating the reference token i add a token_meta claim and put that same meta information on the token i return to the user. I add this information to make the tokens more developer friendly, displaying a shortname and ceration/expiration in the token itself. I find that this makes them a lot more maintable when used in apps or scripts.

E.g. With meta info the token explains to any developer reading it that it was created by anders and it will expire 2020:  
`andersfullaccess-2019-12-01-2020-12-01--FaGsj3J0xdjVhafbNy4hL328Idjhasks82xq`  
compared to `FaGsj3J0xdjVhafbNy4hL328Idjhasks82xq`.

This is optional but I think a good thing todo.

In order to support the customized token handles (and to be able to list all tokens for a user) we have to customize the `DefaultReferencetokenStore`.

## Custom DefaultReferencetokenStore

Since the default implementation lacks methods to retrieve all tokens and support or meta info I needed to add my own implementation with extra methods.

```csharp
    /// <summary>
    /// Customized ReferenceTokenStore to handle
    /// </summary>
    public class CustomReferencetokenStore : DefaultReferenceTokenStore
    {
        private readonly IPersistedGrantStore store;

        public CustomReferencetokenStore(IPersistedGrantStore store, IPersistentGrantSerializer serializer, IHandleGenerationService handleGenerationService, ILogger<DefaultReferenceTokenStore> logger) : base(store, serializer, handleGenerationService, logger)
        {
            this.store = store;
        }

        /// <summary>
        /// Get all grants by subject
        /// </summary>
        /// <param name="subject"></param>
        /// <returns></returns>
        internal async Task<IEnumerable<PersistedGrant>> GetGrantsAsync(string subject)
        {
            var all = await store.GetAllAsync(subject);
            return all;
        }

        /// <summary>
        /// Gets a Token using the handle format but allow the "--" format
        /// </summary>
        /// <param name="handle"></param>
        /// <returns></returns>
        protected override Task<Token> GetItemAsync(string handle)
        {
            // clean up our metainfo
            if(handle.Contains("--"))
            {
                handle = handle.Split("--")[1]; // skip metadata before --
            }
            return base.GetItemAsync(handle);
        }

        // ommitted for brevity
```

## Adjusting TokenLength restrictions (optional)

Although not required, depending on how long your meta info is (and if it's user input) you might need to allow some extra length on token handles.

Just adjust the options like this when configuring IdentityServer in `Startup.cs`:

```csharp
services.AddIdentityServer(options => {
                // Allow extra space for descriptions in our custom reference token handles
                options.InputLengthRestrictions.TokenHandle = 150; // default is 100
            })
```

## IPersistedGrantStore
Since you probably want your PATs to be active after a restart of your IdentityServer you need to persist them. Luckily IdentityServer already persists your reference tokens using IPersistedGrantStore. However, by default it's only in memory. I implemented a IPersistedGrantStore to use SQL. You can read how to do that here: [identityserver4-without-entityframework](https://mcguirev10.com/2018/01/02/identityserver4-without-entity-framework.html)

## Registering your methods in the DI

Don't forget to register your new `CustomReferencetokenStore`, `IPersistedGrantStore` so that IdentityServer uses them:

```csharp
//config.cs
services.AddTransient<CustomReferencetokenStore>();
services.AddTransient<IReferenceTokenStore, CustomReferencetokenStore>();

// use our persistance of grants
services.AddTransient<IPersistedGrantStore, PersistedGrantStore>();
```



## Configure your API Resource to accept your new PAT tokens
Since the PATs are standard oauth reference_tokens, you just need to be sure you've configured your resource to have access to the identityserver [introspection endpoint](http://docs.identityserver.io/en/latest/endpoints/introspection.html).

Make sure you set up clientId, clientSecret and that you allow both JWTs and reference tokens:

```csharp
            app.UseIdentityServerBearerTokenAuthentication(new IdentityServerBearerTokenAuthenticationOptions
            {
                Authority = "yourserver.io"
                ClientId ="my_api",
                ClientSecret = "my_api_secret",
                ValidationMode = ValidationMode.Both // default value
            });
```

## Try it out

Your identityserver should now have a controller to issue and list long lived reference tokens and your API Resource should be configured to accept them. Try it out by calling your api with `Authorization: Bearer andersfullaccess-2019-12-01-2020-12-01--FaGsj3J0xdjVhafbNy4hL328Idjhasks82xq` or using the [introspection client directly](https://identitymodel.readthedocs.io/en/latest/client/introspection.html). The logging in IdentityServer is very good, if the tokens are invalid the logs should help you diagnose where the problem lies.

## Todo
By adding code to the controller and the CustomReferencetokenStore you can implement a feature to revoke/remove PATs.
Another thing I'd like to add, to help users managing their PATS is adding LastUsed timestamps to each PAT. This could be done in our custom store. 

Depending on your use case, allowing a user to customize what scopes are added to the token could be very powerful and I would encourage it. This would enable a user to issue read-only tokens, or to give a script access to only a certain feature instead of everything.

## Summary
We've now seen how IdentityServer features could be re-used to enable long lived Personal Access Tokens. PATs are a great *alternative* to oAuth flows when you need to authenticate in scripts or custom made automation where oAuth support is inconvenient.

The PATs we have generated are long lived and easy to revoke. They can contain custom claims and meta-info. Please reach out with any feedback or suggestions [@andersaberg](https://twitter.com/andersaberg)