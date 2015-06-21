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
    
    /// Returns the last responder in the stack—typically the actual application.
    public var finalResponder: WebResponderType! {
        var cursor: WebRequestable = self
        while let next = cursor.nextResponder as? WebMiddlewareType {
            cursor = next
        }
        return cursor.nextResponder
    }
    
    /// Initializes a stack terminated by a given handler.
    init(responder: WebResponderType) {
        nextResponder = responder
        
        for middleware in responder.requiredMiddleware.reverse() {
            insertMiddleware(middleware, after: self)
        }
    }
    
    /// Call this to instruct a Web Responder Chain to respond to a particular request.
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        sendRequestToResponder(request, withResponse: response)
    }
    
    /// Adds a layer at the top of the layer stack.
    public func prependMiddleware(middleware: WebMiddlewareType) {
        insertMiddleware(middleware, after: self)
    }
    
    /// Adds a layer at the bottom of the layer stack, right before the final handler.
    public func appendMiddleware(middleware: WebMiddlewareType) {
        insertMiddleware(middleware, before: finalResponder)
    }
}
