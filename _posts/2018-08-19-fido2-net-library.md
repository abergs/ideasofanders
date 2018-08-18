---
layout: post

title: FIDO2 - Things I learned by building a FIDO2 server
headline: Some hard earned lessons
categories: development
tags: 
  - fido2
  - net
published: true
---

Over the last couple of months I've been building a [FIDO2 open source server](https://github.com/abergs/fido2-net-lib/).

I should probably do a larger write-up on the library and FIDO itself some day, but I wanted to write down some things I had to discover and learn.

**Disclosure:** I'm not an expert on FIDO. I implemented a library by reading the specs and asking a ton of questions. Before May 2018 I had never heard of Fido. I might get things wrong. 

## 1. FIDO2 is a separate but similiar standard from FIDO U2F and FIDO UAF.
FIDO2 is a new specification, complimenting (replacing) the older FIDO U2F (second factor) and FIDO UAF (paswordless) specs and usecases.

FIDO2 consists of two sub specifications:

* [CTAP](https://fidoalliance.org/specs/fido-v2.0-id-20180227/fido-client-to-authenticator-protocol-v2.0-id-20180227.pdf) - Client to Authenticator Protocol
* [WebAuthn](https://www.w3.org/TR/webauthn/) - Browser to Client (and kind of Browser to your FIDO Server, also called the *Relying party*)

If you have a FIDO2 U2F Security keys, they can still be used for WebAuthn because FIDO2 brings backwards compatability. FIDO2 allows you to do what UAF did, but the protocol is different.

## 2. Attestation vs Assertion
At first I had troubles separating these two. So here's to anyone else wondering:

* Attestation is the process for registering the public key credential at the Relying Party and verifying the authenticator (more on verifying the authenticator soon). 
* Assertion is the process of authenticating a user, utilizing the registered public key to verify a signature

Both of these processes have two separate stages, *Options* and *Result*. For both Attestation and Assertion the FIDO2 Server will first return *Options* to the client (client is for example a web browser). The client will then (after talking to the authenticator, using CTAP) return a *result* that the server can verify.

The options include things such as timeout, userID, a challenge (to be signed) etc. See [Attestation options](https://www.w3.org/TR/webauthn/#dictdef-publickeycredentialcreationoptions) and [Assertion options](https://www.w3.org/TR/webauthn/#dictdef-publickeycredentialrequestoptions).

## 2. None, Indirect or Direct - the attestation conveyance
This was confusing. Every FIDO2 example allowed me to pick either "none", "indirect" or "direct" but I never understood what I was picking or why. Let me try to break it down.

Basically the attestation process spends a lot of steps verifying that the authenticator used by the client can be trusted by the server/relying party. What kind of authenticator you believe is trustworthy depends on your security policies.

To quote [Adam Powers](https://twitter.com/apowers313/status/1026182636912304128):
> It’s really a matter of use cases and risk tolerance. If your risk tolerance is “anything FIDO is better than passwords” and you aren’t going to look at authenticator metadata “none” is fine. If you are a financial or government organization you may want attestation.

So if you are switching from username/password to FIDO2, "none" is perfectly valid. If you are switching from Smartcards or UAF, you might be interested in Indirect/Direct. But if you are using smartcards you are probably not reading this blog.

## 3. User Verification vs User Presence
FIDO2 by default always requires user presence. This is to stop silent logins where the User unknowingly logins / authenticate. For Security Keys it might include touching a button on the physical key to prove a (any) human is present.


However, a relying party can instead require User Verifcation. This means that the it's not enough for a human to be present but we want to verify that the expected human is present. For example the authenticator can require a pin code, fingerprint scan, iris scan etc.

## 4. User verification by PIN and lock out
This one might be a little out of scope but I was curious. How many retries are allowed for getting the PIN code right?
Turns out maxmium number of incorrect pin codes are 8. When the threshold is reached the authenticator [must be reset to a factory default state](https://fidoalliance.org/specs/fido-v2.0-rd-20180702/fido-client-to-authenticator-protocol-v2.0-rd-20180702.html#client-pin-support).

Curiously, after 3 failed attempts [a power cycling must be done](https://fidoalliance.org/specs/fido-v2.0-rd-20180702/fido-client-to-authenticator-protocol-v2.0-rd-20180702.html#gettingPinToken) to prevent malware from reseting the device without user interaction.

## 5. Conformance testing tools
The FIDO alliance has published some great testing tools that really helped in finding bugs in our verification alghortims. If you are building or contributing to a FIDO2 implementation, they are a necessity: [Get them here](https://fidoalliance.org/certification/conformance/).

## 6. The community is fantastic
While documentation outside of the RFC spec is a bit sparse and sometimes hard to find, the community is a great place to ask for guidance.

Special thanks to [Adam Powers](https://twitter.com/apowers313) and [Ackermann Yuriy](https://twitter.com/herrjemand) who has been very friendly and answering questions on twitter, helping me making progress on the library.

A couple of months in to the project, [Alex Seigler](https://twitter.com/alexseigler/) sent a pull request contributing lots of verification code for different attestation formats. I really wouldn't have made it this far without the many pull requests that followed from Alex. Thank you Alex and thank you [Open Source](https://github.com/abergs/fido2-net-lib/pulls?q=is%3Apr+is%3Aclosed).

## End notes
Before May 2018 I had no idea what FIDO was. I had never had to do bitwise operations before. I didn't know what Little-Endian was. I had only once before read a RFC spec. It was the OAuth spec and it left me with a headache. I had never worked with public key cryptography and I didn't know what Elliptic-curve was. **Now I do.**

It's been an adventure and I'm sure more are to come. My purpose with this project was to learn things and ideally play a small role in making the web more secure by creating a well designed, easy to use and well documented open source library for .NET developers.

Feedback is as always welcome.
