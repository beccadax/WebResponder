//
//  WebRequesterType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/20/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Protocol for an object that can pass HTTP requests through to a responder or 
/// chain of responders. If it contributes to the response before it passes them 
/// through, it should conform to `WebMiddlewareType`, which also conforms to this 
/// type.
public protocol WebRequestable: class {
    /// A reference to the responder that this object should send requests to.
    /// No forwarding should occur until `nextResponder` is set.
    var nextResponder: WebResponderType! { get set }
}

public extension WebRequestable {
    /// Passes the request through to the next responder. This should usually only 
    /// be called on `self`.
    func sendRequestToNextResponder(request: HTTPRequestType, withResponse response: HTTPResponseType) {
        nextResponder.respond(response, toRequest: request)
    }
}
