//
//  SimpleWebMiddleware.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/28/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

// A `WebMiddlewareType` with `respond(_:toRequest:)` implemented by a closure, 
/// `requiredMiddleware` passed to the initializer, and no other special logic.
public final class SimpleWebMiddleware: WebMiddlewareType {
    /// An `Implementation` is called with the `response`, `request`, and a closure 
    /// that will call through to the `nextResponder`. Like any middleware, it should 
    /// pass through a (possibly modified or wrapped) `request` and `response` to 
    /// the next responder.
    public typealias Implementation = (HTTPResponseType, HTTPRequestType, (HTTPRequestType, HTTPResponseType) -> Void) -> Void
    
    public init(requiredMiddleware: [WebMiddlewareType] = [], implementation: Implementation) {
        self.requiredMiddleware = requiredMiddleware
        self.implementation = implementation
    }
    
    public var nextResponder: WebResponderType!

    private var implementation: Implementation
    public var requiredMiddleware: [WebMiddlewareType]
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        implementation(response, request, sendRequestToNextResponder)
    }
}
