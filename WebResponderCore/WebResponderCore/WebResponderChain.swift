//
//  WebResponderChain.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents a chain of Web Middlewares (`WebMiddlewareType`), terminating with 
/// a Web Responder (`WebResponderType`). Basically, a chain manages an 
/// application and a set of middlewares used, collectively, to respond to HTTP 
/// requests.
public class WebResponderChain: WebRequestable, WebResponderType {
    public var nextResponder: WebResponderType!
    
    /// Returns the last responder in the chain—typically the actual application.
    public var finalResponder: WebResponderType! {
        var cursor: WebRequestable = self
        while let next = cursor.nextResponder as? WebMiddlewareType {
            cursor = next
        }
        return cursor.nextResponder
    }
    
    /// Initializes a chain terminated by a given responder.
    init(finalResponder: WebResponderType) {
        nextResponder = finalResponder
        
        for middleware in finalResponder.requiredMiddleware.reverse() {
            insertMiddleware(middleware, after: self)
        }
    }
    
    /// Call this to instruct a Web Responder Chain to respond to a particular request.
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        sendRequestToNextResponder(request, withResponse: response)
    }
    
    /// Adds a middleware at the top of the middleware chain.
    public func prependMiddleware(middleware: WebMiddlewareType) {
        insertMiddleware(middleware, after: self)
    }
    
    /// Adds a middleware at the bottom of the middleware chain, right before the final responder.
    public func appendMiddleware(middleware: WebMiddlewareType) {
        insertMiddleware(middleware, before: finalResponder)
    }
}
