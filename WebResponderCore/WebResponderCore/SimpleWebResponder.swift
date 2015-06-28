//
//  SimpleWebResponder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public final class SimpleWebResponder: WebResponderType {
    public typealias Implementation = (HTTPResponseType, HTTPRequestType) -> Void
    
    public init(requiredMiddleware: [WebMiddlewareType] = [], implementation: Implementation) {
        self.requiredMiddleware = requiredMiddleware
        self.implementation = implementation
    }
    
    private let implementation: Implementation
    public let requiredMiddleware: [WebMiddlewareType]
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        implementation(response, request)
    }
}
