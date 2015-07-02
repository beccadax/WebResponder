//
//  WebMiddlewareType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Protocol for an object which modifies an HTTP request or response before passing
/// it to another responder. Typically, a middleware might wrap the request and/or 
/// response objects with custom types, then call `sendRequestToNextResponder(_:withResponse:)` 
/// to pass these wrapped objects to the next responder. However, nothing prevents a 
/// middleware from diverting a request to a different responder, responding to the 
/// request itself, or passing the request and response objects through unchanged.
public protocol WebMiddlewareType: WebResponderType, WebRequestable {}

public extension WebRequestable {
    /// Insert a new middleware just after a given requestable in the chain. Pass 
    /// the chain itself to insert a middleware at the beginning of the chain.
    /// Returns `true` if `after` was found and `middleware` was inserted after it.
    /// 
    /// - Precondition: `middleware` must not be in a chain already.
    func insertMiddleware(middleware: WebMiddlewareType, after: WebRequestable) -> Bool {
        precondition(middleware.nextResponder == nil, "Middleware \(middleware) is already in a chain")
        
        if self === after {
            middleware.nextResponder = nextResponder
            nextResponder = middleware
            
            for requiredMiddleware in middleware.requiredMiddleware.reverse() {
                insertMiddleware(requiredMiddleware, after: self)
            }
            
            return true
        }
        else if let nextMiddleware = nextResponder as? WebMiddlewareType {
            return nextMiddleware.insertMiddleware(middleware, after: after)
        }
        else {
            return false
        }
    }
    
    /// Insert a new middleware just before a given responder in the chain. Pass 
    /// the chain's final responder to insert a middleware at the end of the chain. 
    /// Returns `true` if `before` was found and `middleware` was inserted before it.
    /// 
    /// - Precondition: `middleware` must not be in a chain already.
    /// - Precondition: `before` must not be `self`.
    func insertMiddleware(middleware: WebMiddlewareType, before: WebResponderType) -> Bool {
        precondition(middleware.nextResponder == nil, "Middleware \(middleware) is already in a chain")
        precondition(self !== before, "Cannot call \(self).insertMiddleware(_, before: \(self))")
        
        if nextResponder === before {
            insertMiddleware(middleware, after: self)
            return true
        }
        else if let nextMiddleware = nextResponder as? WebMiddlewareType {
            return nextMiddleware.insertMiddleware(middleware, before: before)
        }
        else {
            return false
        }
    }
    
    /// Remove a middleware from the chain. Returns `true` if `middleware` was 
    /// found in the chain and removed.
    /// 
    /// - Precondition: `middleware` must be in a chain already (but not necessarily this chain).
    /// - Precondition: `middleware` must not be `self`.
    func removeMiddleware(middleware: WebMiddlewareType) -> Bool {
        precondition(middleware.nextResponder != nil, "Middleware \(middleware) is not in a chain")
        precondition(self !== middleware, "Cannot call \(self).removeMiddleware(\(self))")
        
        if nextResponder === middleware {
            nextResponder = middleware.nextResponder
            middleware.nextResponder = nil
            return true
        }
        else if let nextMiddleware = nextResponder as? WebMiddlewareType {
            return nextMiddleware.removeMiddleware(middleware)
        }
        else {
            return false
        }
    }
}
