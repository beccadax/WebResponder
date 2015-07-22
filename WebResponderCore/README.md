WebResponderCore
=============

(If you haven't read the README for the WebResponder project, go back and do that 
thing. It's in this folder's parent directory.)

WebResponderCore contains the core types for WebResponder:

* `HTTPRequestType` and `HTTPResponseType`: These types encapsulate the contents 
   of HTTP requests and responses, respectively.
* `HTTPMethod` and `HTTPStatus`: represent request methods and response statuses,
   including a large number of constants covering standard values for them.
* `HTTPBodyType`: Contains the contents of a request's or response's body. Each 
  `HTTPBodyType` can be read only once, and can be read lazily.
* `WebResponderType`: The fundamental type for a responder, an object that 
   participates in the handling of requests. `WebResponderType` is based on 
   two other protocols: `WebResponderChainable` and 
   `WebResponderRespondable`.
* `SimpleHTTPRequest`, `SimpleHTTPResponse`, and `SimpleWebResponder`: Basic, 
   sometimes block-based implementations of these protocols, useful for testing or 
   quick-and-dirty implementations.
* `RequestIDHelper`: Generates a unique UUID for each incoming request.
* `CoreVersionResponder`: Displays WebResponder version information.
* `UnicodeEncoder` and `UnicodeDecoder`: Lazily converts between streams of 
  Unicode bytes and Swift `UnicodeScalar`s.
* `Latin1`: A `UnicodeCodecType` for ISO-8859-1, to match the Swift standard 
  library's `UTF8`, `UTF16`, and `UTF32` types.

Each of these types includes documentation comments, so I won't waste time 
recapitulating all the gory details. Instead, I'll discuss some high-level 
conceptual things here.

Responders
--------

Any object that helps process a request is a responder and conforms to the 
`WebResponderType` protocol. This protocol requires that you implement two methods:

    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType)

A variant of this method adds a `withError:` parameter, indicating that an error 
has occurred.

In this method, `request` is an input, while `response` is essentially an output. 
You read information from `request` to determine what to do, and then write to 
`response` to send information back to the client.

Once you've finished, you call either `respond(_:toRequest:)` on your 
`nextResponder` to continue processing normally, or 
`respond(_:withError:toRequest:)` if processing failed. WebResponder is intended to
support asynchronous processing, so you can delay passing a response to the 
`nextResponder` until after you've returned.

You can directly set `nextResponder` to set up the responder chain, but unless 
you're initializing an object, you'll usually want to insert it between two existing
responders. The `insertNextResponder(_:)` method does that thing.

Helper Responders
-------------

A responder can specify "helper responders" which should be inserted before it in 
the responder chain. To do this, it should override the `helperResponders()` method 
to return an array of such responders. Calling `withHelperResponders()` on a 
responder will connect all of the helper responders to the original responder and 
return the first of them.

A helper responder is always inserted before the responder that requested it, but 
sometimes you want to add processing *after* the responder you're helping. You 
can do that by setting a `nextResponder` immediately in your initializer; then the 
responder you're helping will be inserted between the two.

Author
-----

Brent Royal-Gordon, Groundbreaking Software <brent@groundbreakingsoftware.com>

Copyright and License
---------------

© 2015 Groundbreaking Software, Inc. This library is licensed under the MIT 
License:

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

