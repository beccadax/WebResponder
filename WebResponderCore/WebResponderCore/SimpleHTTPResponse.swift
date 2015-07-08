//
//  SimpleHTTPResponse.swift
//  WebResponder
//
//  Created by Brent Royal-Gordon on 6/20/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// An HTTP response with no special logic.
public class SimpleHTTPResponse: HTTPResponseType {
    public init() {}
    
    public var status: HTTPStatus = .OK
    public var headers: [String: [String]] = [:]
    public var body: HTTPBodyType = EmptyHTTPBody()
        
    // Workarounds for #21584801
    public func setStatus(newValue: HTTPStatus) {
        status = newValue
    }
    public func setHeaders(newValue: [String : [String]]) {
        headers = newValue
    }
    public func setBody(newValue: HTTPBodyType) {
        body = newValue
    }
}
