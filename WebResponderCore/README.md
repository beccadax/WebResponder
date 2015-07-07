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
* `WebRequestable`, `WebMiddlewareType`, and `WebResponderChain`: Types for 
  forming chains of middleware providing services to a final responder.
* `SimpleHTTPRequest`, `SimpleHTTPResponse`, `SimpleWebResponder`, and 
  `SimpleWebMiddleware`: Basic, usually block-based implementations of these 
  protocols, useful for testing or quick-and-dirty implementations.
* `RequestIDMiddleware`: Generates a unique UUID for each incoming request.
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
`WebResponderType` protocol. This protocol requires that you implement one method:

    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType)

In this method, `request` is an input, while `response` is essentially an output. 
You read information from `request` to determine what to do, and then write to 
`response` to send information back to the client.

Once you've finished, you can basically do three things: 

1. Tell the `response` to begin sending itself by calling its `respond()` method.
2. Signal that an error occurred while processing the request by calling the 
    `response`'s `failWithError(_:)` method.
3. Forward the request and response to another responder to do additional
    processing. If your responder does this in a simple linear way, it should be a 
    middleware, conforming to `WebMiddlewareType` and forwarding the request 
    through the `sendRequestToNextResponder(_:response:)` method.

The response is not sent until `respond()` or `failWithError(_:)` is called, so 
a responder can hold onto the request and response while it performs asynchronous 
calls and use them later.

A middleware's `respond(_:toRequest:)` method runs before the final responder's, 
so if a middleware wants to insert logic that's performed *after* it, it will need 
to wrap the `response` passed to its next responder in a custom type with a 
different implementation of `respond()`. Middleware may also replace the `request` 
or `response` with a custom type to make additional data or functionality 
accessible to responders later in the responder chain.

The `WebResponderChain` class manages a series of middleware terminating in a 
final responder, making it more convenient to build up and manipulate such a 
structure.

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

