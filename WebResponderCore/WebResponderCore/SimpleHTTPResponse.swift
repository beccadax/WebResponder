//
//  SimpleHTTPResponse.swift
//  WebResponder
//
//  Created by Brent Royal-Gordon on 6/20/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public class SimpleHTTPResponse: HTTPResponseType {
    public var status: HTTPStatus = .OK
    public var headers: [String: [String]] = [:]
    public var body: HTTPBodyType = EmptyHTTPBody()
    
    public var completion: (SimpleHTTPResponse, ErrorType?) -> Void
    
    public init(completion: (SimpleHTTPResponse, ErrorType?) -> Void) {
        self.completion = completion
    }
    
    public func respond() {
        completion(self, nil)
    }
    
    public func failWithError(error: ErrorType) {
        completion(self, error)
    }
    
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
