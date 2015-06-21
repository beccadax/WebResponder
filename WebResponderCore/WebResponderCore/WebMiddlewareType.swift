//
//  WebMiddlewareType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Protocol for an object which modifies an HTTP request or response before passing
/// it to another handler. Typically, a stack layer might wrap the request and/or 
/// response objects with custom types, then call `continueRequest(_:response:)` 
/// to pass these wrapped objects to the next handler. However, nothing prevents a 
/// stack layer from diverting a request to a different handler, responding to the 
/// request itself, or passing the request and response objects through unchanged.
public protocol WebMiddlewareType: WebResponderType, WebRequestable {}

public extension WebRequestable {
    /// Insert a new middleware just after a given requestable in the chain. Pass 
    /// the chain itself to insert a middleware at the beginning of the chain.
    func insertMiddleware(middleware: WebMiddlewareType, after: WebRequestable) -> Bool {
        precondition(middleware.nextResponder == nil, "Layer \(middleware) is already in a stack")
        
        if self === after {
            middleware.nextResponder = nextResponder
            nextResponder = middleware
            
            for requiredMiddleware in middleware.requiredMiddleware.reverse() {
                insertMiddleware(requiredMiddleware, after: self)
            }
            
            return true
        }
        else if let nextLayer = nextResponder as? WebMiddlewareType {
            return nextLayer.insertMiddleware(middleware, after: after)
        }
        else {
            return false
        }
    }
    
    /// Insert a new middleware just before a given responder in the chain. Pass 
    /// the chain's final responder to insert a middleware at the end of the chain.
    func insertMiddleware(layer: WebMiddlewareType, before: WebResponderType) -> Bool {
        precondition(layer.nextResponder == nil, "Layer \(layer) is already in a chain")
        precondition(self !== before, "Cannot call \(self).insertLayer(_, before: \(self))")
        
        if nextResponder === before {
            insertMiddleware(layer, after: self)
            return true
        }
        else if let nextLayer = nextResponder as? WebMiddlewareType {
            return nextLayer.insertMiddleware(layer, before: before)
        }
        else {
            return false
        }
    }
    
    /// Remove a middleware from the chain.
    func removeMiddleware(layer: WebMiddlewareType) -> Bool {
        precondition(layer.nextResponder != nil, "Layer \(layer) is not in a chain")
        precondition(self !== layer, "Cannot call \(self).removeLayer(\(self))")
        
        if nextResponder === layer {
            nextResponder = layer.nextResponder
            layer.nextResponder = nil
            return true
        }
        else if let nextLayer = nextResponder as? WebMiddlewareType {
            return nextLayer.removeMiddleware(layer)
        }
        else {
            return false
        }
    }
}
