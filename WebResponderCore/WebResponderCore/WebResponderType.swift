//
//  WebResponderType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/5/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Protocol for a responder: an object that assists in the processing of a request.
/// Each responder can receive a request and then pass its response to a next 
/// responder.
public protocol WebResponderType: WebResponderRespondable, WebResponderChainable {
    /// Responders that should be inserted before this responder. The last element 
    /// is inserted immediately before this responder, then the element before that
    /// is inserted before it, and so on. Each responder's own `helperResponders` 
    /// will be inserted before it is, recursively unto infinity.
    /// 
    /// Although a `helperResponder` is inserted before the responder that needs it,
    /// if it has a `nextResponder` set on it, that will go after the responder that 
    /// needs it.
    func helperResponders() -> [WebResponderType]
    
    // ---------------------------------------------------------
    // The following declarations are redundant, but are included here as a reminder.
    // ---------------------------------------------------------
    
    /// Process the `request` and `response`, updating them if necessary. If this 
    /// method is called, then previous responders have been successful. Generally, 
    /// a `WebResponderType`'s implementation of this method should pass the 
    /// request and response through to its `nextResponder`, perhaps after wrapping
    /// them in a type that adds needed properties or methods.
    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType)
    
    /// Process the `request` and `response`, updating them if necessary. If this 
    /// method is called, then previous responders have failed with `error`. Generally, 
    /// a `WebResponderType`'s implementation of this method should pass the 
    /// request and response through to its `nextResponder`, with or without the 
    /// `error`.
    /// 
    /// The default implementation of this method passes the `request`, `response`,
    /// and `error` through to the `nextResponder` unchanged. You may implement 
    /// this method yourself if you want to recover from the error, or avoid using 
    /// the web server's default presentation of it.
    func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType)
    
    /// The responder which this object should relay requests to once it's done.
    /// Although you can set this directly, you'll usually want to use 
    /// `insertNextResponder()` instead.
    var nextResponder: WebResponderRespondable! { get set }
}

extension WebResponderType {
    public func helperResponders() -> [WebResponderType] {
        return []
    }
    
    public func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType)
    {
        nextResponder.respond(response, withError: error, toRequest: request)
    }
}

/// Protocol for anything that can participate in responding to a request. Only an 
/// object meant to be the tail of a responder chain would conform directly to 
/// `WebResponderRespondable`; usually you'll want to conform to 
/// `WebResponderType`, which implies conformance to this type.
public protocol WebResponderRespondable: class {
    /// Process the `request` and `response`, updating them if necessary. If this 
    /// method is called, then previous responders have been successful.
    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType)
    
    /// Process the `request` and `response`, updating them if necessary. If this 
    /// method is called, then previous responders have failed with `error`.
    func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType)
}

/// Protocol for anything that sends responses and requests to a single, fixed 
/// responder. Only an object meant to be the head of a responder chain would 
/// conform directly to `WebResponderChainable`; usually you'll want to 
/// conform to `WebResponderType`, which implies conformance to this type.
public protocol WebResponderChainable: class {
    /// The responder which this object should relay requests to once it's done.
    /// Although you can set this directly, you'll usually want to use 
    /// `insertNextResponder()` instead.
    var nextResponder: WebResponderRespondable! { get set }
}
