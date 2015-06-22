//
//  HTTPRequestType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public protocol HTTPRequestType {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: [String]] { get }
    
    var body: HTTPBodyType { get }
    
    func requestOfType<T: HTTPRequestType>(type: T.Type) -> T?
}

public extension HTTPRequestType {
    func requestOfType<T: HTTPRequestType>(type: T.Type) -> T? {
        return self as? T
    }
}

public protocol LayeredHTTPRequestType: HTTPRequestType {
    var previousRequest: HTTPRequestType { get }
}

public extension LayeredHTTPRequestType {
    var path: String {
        return previousRequest.path
    }
    var method: HTTPMethod {
        return previousRequest.method
    }
    var headers: [String: [String]] {
        return previousRequest.headers
    }
    var body: HTTPBodyType {
        get { return previousRequest.body }
    }
    
    func requestOfType<T: HTTPRequestType>(type: T.Type) -> T? {
        return self as? T ?? previousRequest.requestOfType(type)
    }
}

/*
public class CookieLayer: StackLayerType {
    public var nextHandler: StackHandlerType
    
    public init(nextHandler: StackHandlerType) {
        self.nextHandler = nextHandler
    }
    
    public func handleRequest(request: HTTPRequestType, response: HTTPResponseType, stack: Stack) {
        continueRequest(CookieRequest(previousRequest: request), response: response, stack: stack)
    }
}

public struct Cookie {
    // name, value, etc.
}

internal struct CookieRequest: LayeredHTTPRequestType {
    let previousRequest: HTTPRequestType
    var cookies: [Cookie]?
    
    init(previousRequest: HTTPRequestType) {
        self.previousRequest = previousRequest
        // XXX do cookie processing
        cookies = []
    }
}

public extension HTTPRequestType {
    var cookies: [Cookie]? {
        return requestOfType(CookieRequest)?.cookies
    }
}
*/
