//
//  SimpleWebMiddleware.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/28/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public final class SimpleWebMiddleware: WebMiddlewareType {
    public typealias Implementation = (HTTPResponseType, HTTPRequestType, (HTTPRequestType, HTTPResponseType) -> Void) -> Void
    
    public init(requiredMiddleware: [WebMiddlewareType] = [], implementation: Implementation) {
        self.requiredMiddleware = requiredMiddleware
        self.implementation = implementation
    }
    
    public var nextResponder: WebResponderType!
    public var requiredMiddleware: [WebMiddlewareType]
    private var implementation: Implementation
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        implementation(response, request, sendRequestToNextResponder)
    }
}
