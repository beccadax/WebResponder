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
    public var body: AnySequence<UInt8> = AnySequence(EmptyCollection())
    
    public var completion: (SimpleHTTPResponse, ErrorType?) -> Void
    
    init(completion: (SimpleHTTPResponse, ErrorType?) -> Void) {
        self.completion = completion
    }
    
    public func respond() {
        completion(self, nil)
    }
    
    public func failWithError(error: ErrorType) {
        completion(self, error)
    }
}
