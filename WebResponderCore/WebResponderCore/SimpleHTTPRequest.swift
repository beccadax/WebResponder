//
//  SimpleHTTPRequest.swift
//  WebResponder
//
//  Created by Brent Royal-Gordon on 6/20/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// An HTTPRequestType with all fields mutable and no other special logic.
public struct SimpleHTTPRequest: HTTPRequestType {
    public init() {}
    
    public var target: String = "/"
    public var method: HTTPMethod = .GET
    public var headers: [String: [String]] = [:]
    
    public var body: HTTPBodyType = EmptyHTTPBody()
}
