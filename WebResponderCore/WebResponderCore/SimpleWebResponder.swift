//
//  SimpleWebResponder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// A `WebResponderType` with `respond(_:toRequest:)` implemented by a closure, 
/// `requiredMiddleware` passed to the initializer, and no other special logic.
public final class SimpleWebResponder: WebResponderType {
    /// An `Implementation` is called with the `response` and `request`. Like any 
    /// responder, it should arrange to call either `respond()` or `failWithError(_:)`
    /// on the `response`.
    public typealias Implementation = (HTTPResponseType, HTTPRequestType, WebResponderRespondable) -> Void
    
    public init(helperResponders: [WebResponderType] = [], implementation: Implementation) {
        _helperResponders = helperResponders
        self.implementation = implementation
    }
    
    private let implementation: Implementation
    private var _helperResponders: [WebResponderType]
    public var nextResponder: WebResponderRespondable!
    
    public func helperResponders() -> [WebResponderType] {
        let array = _helperResponders
        _helperResponders = []
        return array
    }
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        implementation(response, request, nextResponder)
    }
}
