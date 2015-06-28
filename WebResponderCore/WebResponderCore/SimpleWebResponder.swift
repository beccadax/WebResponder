//
//  SimpleWebResponder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public class SimpleWebResponder: WebResponderType {
    public init(requiredMiddleware: [WebMiddlewareType] = [], implementation: (HTTPResponseType, HTTPRequestType) -> Void) {
        self.requiredMiddleware = requiredMiddleware
        self.implementation = implementation
    }
    
    private let implementation: (HTTPResponseType, HTTPRequestType) -> Void
    public let requiredMiddleware: [WebMiddlewareType]
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        implementation(response, request)
    }
}
