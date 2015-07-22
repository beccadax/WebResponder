WebResponder
==========

WebResponder is an asynchronous web middleware stack for server-side Swift web 
applications.

Okay, what's a middleware stack?
-------------------------

A middleware stack is an abstraction layer between an in-process web server and a 
web framework; it also allows processing steps, called helper responders in 
WebResponder, to be shared between different frameworks.

If you're familiar with other open-source web app stacks, Ruby's 
[Rack](https://github.com/rack/rack) and Node.js's 
[Connect](https://github.com/senchalabs/connect) serve similar roles to 
WebResponder.

In plain English, please?
------------------

That means two things:

1. A web app framework built with WebResponder can be used with any server that 
    can be connected to WebResponder. You can mix-and-match them at will.
2. A web app framework built with WebResponder can rely on helper responders to 
    share logic with other frameworks. For instance, if there's a WebResponder 
    helper for parsing query strings, all frameworks could use that helper instead 
    of implementing their own parsing.

So this isn't Cocoa for web apps?
-------------------------

Nope, sorry. This is lower-level than that.

What's built for WebResponder so far?
----------------------------

Er, not much yet. This repository contains two frameworks:

1. `WebResponderCore`, which contains the core types, as well as a 
    `RequestIDHelper` (which generates a unique UUID for each request it 
    processes) and `CoreVersionResponder` (which generates an HTML page 
    identifying the version of WebResponder that's running). These are largely for 
    demoing and sample code, although `RequestIDHelper` is a genuinely useful 
    helper responder.
2. `WebResponderGCDWebServer` adapts the popular [GCDWebServer](https://github.com/swisspol/GCDWebServer)
    library for use with WebResponder. It also includes a demo Mac app which serves 
    `CoreVersionResponder` over Bonjour, and logs requests and responses in a 
    window.

What are WebResponder's requirements?
-----------------------------

WebResponder is written in Swift 2. `WebResponderCore` uses only Swift standard 
library and POSIX calls; `WebResponderGCDWebServer` also uses Foundation types, 
and `GCDWebServer` itself uses Foundation, Core Foundation, and UIKit on iOS.

How about Objective-C?
-----------------

Nope. WebResponder's core types use Swift features, and you can't write useful 
Objective-C code without Foundation, which may not be available when Swift moves 
to servers.

Of course, there's nothing preventing your Swift responder objects from using 
Objective-C libraries, or even wrapping request and response objects in 
Objective-C-compatible objects and forwarding requests into Objective-C.

Is GCDWebServer practical for web apps?
------------------------------

Probably not. The use of GCDWebServer is part proof-of-concept; it could be 
replaced with any asynchronous in-process web server that Swift can interact with.

On the other hand, GCDWebServer *is* a perfectly practical choice for native apps 
with an embedded web server. (Did I mention that there's nothing stopping web apps 
built for WebResponder from being embedded in a native app? Because there isn't, 
which is pretty cool.)

How stable is this project?
--------------------

![Picard cracking up](http://i.giphy.com/QgixZj4y3TwnS.gif)

Nothing is stable, so be prepared for changes in the future. About the only thing 
you can be sure of is that the final design will involve a `nextResponder` property.

Who wrote this?
------------

Brent Royal-Gordon, Groundbreaking Software <brent@groundbreakingsoftware.com>

Why?
---

Because I want to write web apps in Swift one day, and this seemed like a good 
starting point.

What's the license?
--------------

© 2015 Groundbreaking Software, Inc. This library is licensed under the MIT 
License:

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

GCDWebServer is included in this library as a submodule. It is © 2012-2014 
Pierre-Olivier Latour, and its use is governed by the terms of [its own BSD 
license](https://github.com/swisspol/GCDWebServer/blob/master/LICENSE).
