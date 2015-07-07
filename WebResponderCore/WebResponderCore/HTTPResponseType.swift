//
//  HTTPResponseType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents the response that will be sent to the request. An `HTTPResponseType` 
/// object contains the data that will be sent with the response, including its 
/// status, headers, and body. Though WebResponderCore includes a 
/// `SimpleHTTPResponse`, most server adapters will want to implement their own 
/// class conforming to this protocol.
/// 
/// Middleware may want to wrap responses in a response type of their own which 
/// adds additional data or alters existing data. Such wrapping responses should 
/// conform to `LayeredHTTPResponseType`, which has been extended with logic to 
/// make this easy.
public protocol HTTPResponseType: class {
    /// The status that should be sent with the response.
    var status: HTTPStatus { get /*set*/ }
    
    /// HTTP headers to be sent with the response.
    var headers: [String: [String]] { get /*set*/ }
    
    /// Body to be sent with the response.
    var body: HTTPBodyType { get /*set*/ }
    
    // These work around a LayeredHTTPResponseType linking bug in Swift 2 beta 2. 
    // #21584801 https://gist.github.com/brentdax/b590827afa757e8a9e3b
    func setStatus(newValue: HTTPStatus)
    func setHeaders(newValue: [String: [String]])
    func setBody(newValue: HTTPBodyType)
    
    /// When an HTTP response has been wrapped, possibly several times, this method 
    /// can locate a response of a particular type. Uses should usually be hidden
    /// in an extension; see `RequestIDMiddleware` for an example of this.
    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T?
}

/// Used for an HTTP response type that wraps an underlying response in order to 
/// add new properties, methods, or logic. Middleware can use this to provide 
/// response-related services to responders further up the responder chain.
/// 
/// Typically, a `LayeredHTTPResponseType` should be private. Any additional 
/// properties or methods they expose should be declared as extensions on 
/// `HTTPResponseType`; these extensions should use `responseOfType(_:)` to locate 
/// your private HTTP response type and access the needed services with it. Any such 
/// extension methods should account for the possibility that they're being called on 
/// a response which hasn't passed through the middleware in question, and so 
/// `responseOfType(_:)` will return `nil`.
/// 
/// See `RequestIDMiddleware` for an example of this in action with the `request`
/// object; `response` would be similar.
public protocol LayeredHTTPResponseType: HTTPResponseType {
    /// The underlying response being wrapped by this response.
    var nextResponse: HTTPResponseType { get }
}

public extension HTTPResponseType {
    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T
    }
}

public extension LayeredHTTPResponseType {
    var status: HTTPStatus {
        get { return nextResponse.status }
//        set { nextResponse.status = newValue }
    }
    var headers: [String: [String]] {
        get { return nextResponse.headers }
//        set { nextResponse.headers = headers }
    }
    var body: HTTPBodyType {
        get { return nextResponse.body }
//        set { nextResponse.body = newValue }
    }
    
    // Workarounds for #21584801
    func setStatus(newValue: HTTPStatus) {
        nextResponse.setStatus(newValue)
    }
    func setHeaders(newValue: [String: [String]]) {
        nextResponse.setHeaders(newValue)
    }
    func setBody(newValue: HTTPBodyType) {
        nextResponse.setBody(newValue)
    }

    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T ?? nextResponse.responseOfType(type)
    }
}

