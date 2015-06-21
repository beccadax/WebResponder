//
//  WebResponderType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Protocol for an object that can respond to an HTTP request. If it then passes 
/// that HTTP request through to another responder, it should conform to 
/// WebMiddlewareType, which also implies conformance to this type.
public protocol WebResponderType: class {
    /// Performs the indicated request, responding through the indicated response 
    /// object. Handlers are asynchronous, so they may call the response's 
    /// `respond()` method (which completes the request) after this method returns.
    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType)
    
    /// Returns an array of layers which should be inserted before this responder 
    /// when it's inserted into a stack.
    var requiredMiddleware: [WebMiddlewareType] { get }
}

extension WebResponderType {
    public var requiredMiddleware: [WebMiddlewareType] {
        return []
    }
}
