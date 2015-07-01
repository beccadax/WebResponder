//
//  RequestIDMiddleware.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public class RequestIDMiddleware: WebMiddlewareType {
    public var nextResponder: WebResponderType!
    
    public init() {}
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        let ID = String.hexadecimalUUIDString()
        
        let newRequest = IdentifiedRequest(previousRequest: request, requestID: ID)
        let newResponse = IdentifiedResponse(nextResponse: response, requestID: ID)
        
        sendRequestToResponder(newRequest, withResponse: newResponse)
    }
}

private extension String {
    static func hexadecimalUUIDString() -> String {
        var UUIDBytes = Array<UInt8>(count: 16, repeatedValue: 0)
        uuid_generate(&UUIDBytes)
        
        return UUIDBytes.map { String($0, radix: 16).padLeft("0", toLength: 2) }.reduce("", combine: +)
    }
    
    func padLeft(char: Character, toLength targetLength: Int) -> String {
        let length = self.characters.count
        guard length < targetLength else {
            return self
        }
        return String(count: targetLength - length, repeatedValue: char) + self
    }
}

struct IdentifiedRequest: LayeredHTTPRequestType {
    let previousRequest: HTTPRequestType
    let requestID: String?
    
    init(previousRequest: HTTPRequestType, requestID: String) {
        self.previousRequest = previousRequest
        self.requestID = requestID
    }
}

public extension HTTPRequestType {
    /// A unique ID for the request. Available only if the RequestIDMiddleware is 
    /// installed.
    var requestID: String? {
        return requestOfType(IdentifiedRequest.self)?.requestID
    }
}

class IdentifiedResponse: LayeredHTTPResponseType {
    let nextResponse: HTTPResponseType
    let requestID: String?
    
    init(nextResponse: HTTPResponseType, requestID: String) {
        self.nextResponse = nextResponse
        self.requestID = requestID
    }
}

public extension HTTPResponseType {
    /// A unique ID for the response's request. Available only if the 
    /// RequestIDMiddleware is installed.
    var requestID: String? {
        return responseOfType(IdentifiedResponse.self)?.requestID
    }
}
