//
//  HTTPRequestType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents an HTTP request. Server adapters may want to make their server's 
/// request type conform to this protocol, rather than copying data from their 
/// server's request into a `SimpleHTTPRequest`.
/// 
/// Middleware may want to wrap requests in a request type of their own which adds 
/// additional data or alters existing data. Such wrapping requests should conform 
/// to `LayeredHTTPRequestType`, which has been extended with logic to make this 
/// easy.
public protocol HTTPRequestType {
    /// The path the request was sent to.
    /// 
    /// - Note: This may be replaced by a URL property in a future version.
    var path: String { get }
    
    /// The method used when sending the request.
    var method: HTTPMethod { get }
    
    /// HTTP headers included with the request.
    var headers: [String: [String]] { get }
    
    /// The body of the request. If there is no body, this should be a zero-length 
    /// body.
    var body: HTTPBodyType { get }
    
    /// When an HTTP request has been wrapped, possibly several times, this method 
    /// can locate a request of a particular type. Uses should usually be hidden
    /// in an extension; see `RequestIDMiddleware` for an example of this.
    func requestOfType<T: HTTPRequestType>(type: T.Type) -> T?
}

/// Used for an HTTP request type that wraps an underlying HTTP request in order to 
/// add new properties, methods, or logic. Middleware can use this to expose their 
/// services to responders further up the responder chain.
/// 
/// Typically, a `LayeredHTTPRequestType` should be private. Any additional 
/// properties or methods they expose should be declared as extensions on 
/// `HTTPRequestType`; these extensions should use `requestOfType(_:)` to locate 
/// your private HTTP request type and access the needed services with it. Any such 
/// extension methods should account for the possibility that they're being called on 
/// a request which hasn't passed through the middleware in question, and so 
/// `requestOfType(_:)` will return `nil`.
public protocol LayeredHTTPRequestType: HTTPRequestType {
    /// The underlying request being wrapped by this request.
    var previousRequest: HTTPRequestType { get }
}

public extension HTTPRequestType {
    func requestOfType<T: HTTPRequestType>(type: T.Type) -> T? {
        return self as? T
    }
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
