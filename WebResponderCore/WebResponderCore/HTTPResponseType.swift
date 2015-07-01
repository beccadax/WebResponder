//
//  HTTPResponseType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public protocol HTTPResponseType: class {
    var status: HTTPStatus { get /*set*/ }
    var headers: [String: [String]] { get /*set*/ }
    var body: HTTPBodyType { get /*set*/ }
    
    // These work around a LayeredHTTPResponseType linking bug in Swift 2 beta 2. 
    // #21584801 https://gist.github.com/brentdax/b590827afa757e8a9e3b
    func setStatus(newValue: HTTPStatus)
    func setHeaders(newValue: [String: [String]])
    func setBody(newValue: HTTPBodyType)
    
    func respond()
    func failWithError(error: ErrorType)
    
    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T?
}

public extension HTTPResponseType {
    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T
    }
}

public protocol LayeredHTTPResponseType: HTTPResponseType {
    var nextResponse: HTTPResponseType { get }
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
    
    func respond() {
        nextResponse.respond()
    }
    
    func failWithError(error: ErrorType) {
        nextResponse.failWithError(error)
    }
    
    func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T ?? nextResponse.responseOfType(type)
    }
}

