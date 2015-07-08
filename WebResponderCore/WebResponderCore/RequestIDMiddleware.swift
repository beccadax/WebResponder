//
//  RequestIDMiddleware.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// A `WebResponderType` which assigns a hexadecimal UUID to each request.
/// Responders deeper in the responder chain can access this ID through the 
/// `requestID` property on `HTTPRequestType`.
public class RequestIDMiddleware: WebResponderType {
    public var nextResponder: WebResponderRespondable!
    
    public init() {}
    
    private func wrapRequest(request: HTTPRequestType) -> HTTPRequestType {
        let ID = request.requestID ?? String.hexadecimalUUIDString()
        return IdentifiedRequest(previousRequest: request, requestID: ID)
    }
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        nextResponder.respond(response, toRequest: wrapRequest(request))
    }
    
    public func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType) {
        nextResponder.respond(response, withError: error, toRequest: wrapRequest(request))
    }
}

// Internal for testing purposes.
internal extension String {
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
    /// A unique ID for the request. Available only if a `RequestIDMiddleware` is 
    /// installed earlier in the responder chain.
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
    /// A unique ID for the response's request. Available only if a 
    /// `RequestIDMiddleware` is installed earlier in the responder chain.
    var requestID: String? {
        return responseOfType(IdentifiedResponse.self)?.requestID
    }
}
