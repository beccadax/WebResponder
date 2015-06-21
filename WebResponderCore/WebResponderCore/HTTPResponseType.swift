//
//  HTTPResponseType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public protocol HTTPResponseType {
    var status: HTTPStatus { get set }
    var headers: [String: [String]] { get set }
    var body: AnySequence<UInt8> { get set }
    
    mutating func respond()
    mutating func failWithError(error: ErrorType)
    
    mutating func responseOfType<T: HTTPResponseType>(type: T.Type) -> T?
}

public extension HTTPResponseType {
    mutating func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T
    }
}

public protocol LayeredHTTPResponseType: HTTPResponseType {
    var nextResponse: HTTPResponseType { get set }
}

public extension LayeredHTTPResponseType {
    var status: HTTPStatus {
        get { return nextResponse.status }
        set { nextResponse.status = newValue }
    }
    var headers: [String: [String]] {
        get { return nextResponse.headers }
        set { nextResponse.headers = headers }
    }
    var body: AnySequence<UInt8> {
        get { return nextResponse.body }
        set { nextResponse.body = newValue }
    }
    
    mutating func respond() {
        nextResponse.respond()
    }
    
    mutating func failWithError(error: ErrorType) {
        nextResponse.failWithError(error)
    }
    
    mutating func responseOfType<T: HTTPResponseType>(type: T.Type) -> T? {
        return self as? T ?? nextResponse.responseOfType(type)
    }
}

