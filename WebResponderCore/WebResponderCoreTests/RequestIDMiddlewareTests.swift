//
//  RequestIDMiddlewareTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/1/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
@testable import WebResponderCore

private enum TestError: ErrorType {
    case SomeError
}

func ~=<T: ErrorType where T: Equatable> (pattern: T, value: ErrorType?) -> Bool {
    guard let value = value as? T else {
        return false
    }
    return pattern == value
}

class RequestIDMiddlewareTests: XCTestCase {
    func middlewareWithResponder(implementation: SimpleWebResponder.Implementation) -> RequestIDMiddleware {
        let middleware = RequestIDMiddleware()
        middleware.nextResponder = SimpleWebResponder(implementation: implementation)
        return middleware
    }
    
    func testRelaysRequest() {
        var ran = false
        let middleware = middlewareWithResponder { response, _, request, next in
            ran = true
        }
        middleware.respond(SimpleHTTPResponse(), toRequest: SimpleHTTPRequest())
        
        XCTAssertTrue(ran, "RequestIDMiddleware relays requests to responder")
    }
    
    func testRequestIDValid() {
        middlewareWithResponder { response, _, request, _ in
            XCTAssertNotNil(request.requestID, "requestID isn't nil")
            XCTAssertFalse(request.requestID?.isEmpty ?? false, "requestID isn't empty string")
        }.respond(SimpleHTTPResponse(), toRequest: SimpleHTTPRequest())
    }
    
    func testRequestIDUnique() {
        var lastRequestID: String?
        let middleware = middlewareWithResponder { response, _, request, _ in
            if let lastRequestID = lastRequestID {
                XCTAssertNotEqual(request.requestID ?? "", lastRequestID, "Different requests don't have the same request ID")
            }
            lastRequestID = request.requestID
        }
        
        for _ in 1...100 {
            middleware.respond(SimpleHTTPResponse(), toRequest: SimpleHTTPRequest())
        }
    }
    
    func testNoRequestIDMiddleware() {
        SimpleWebResponder { response, _, request, _ in
            XCTAssertNil(request.requestID, "Requests not processed by RequestIDMiddleware return nil request ID")
        }.respond(SimpleHTTPResponse(), toRequest: SimpleHTTPRequest())
    }
    
    func testDoubledMiddleware() {
        var upstreamRequestID: String?
        
        let middleware = SimpleWebResponder(helperResponders: [RequestIDMiddleware()]) { response, _, request, next in
            upstreamRequestID = request.requestID
            next.respond(response, toRequest: request)
        }
        let responder = SimpleWebResponder(helperResponders: [middleware, RequestIDMiddleware()]) { response, _, request, _ in
            XCTAssertEqual(request.requestID ?? "", upstreamRequestID ?? "", "Two RequestIDMiddlewares at different points in the responder chain don't produce different IDs")
            return
        }
        let chain = responder.withHelperResponders()
        
        chain.respond(SimpleHTTPResponse(), toRequest: SimpleHTTPRequest())
    }
    
    func testError() {
        middlewareWithResponder { response, error, request, _ in
            if let error = error {
                let ck = TestError.SomeError ~= error
                XCTAssertTrue(ck, "Error passed through")
            }
            else {
                XCTFail("Error didn't pass through RequestIDMiddleware")
            }
            XCTAssertNotNil(request.requestID, "requestID isn't nil with error")
            XCTAssertFalse(request.requestID?.isEmpty ?? false, "requestID isn't empty string with error")
        }.respond(SimpleHTTPResponse(), withError: TestError.SomeError, toRequest: SimpleHTTPRequest())
    }
    
    // This may not be fully covered by the other tests depending on the UUIDs they end up generating.
    func testPadLeft() {
        XCTAssertEqual("".padLeft("0", toLength: 2), "00", "padLeft() works with zero-length string")
        XCTAssertEqual("1".padLeft("0", toLength: 2), "01", "padLeft() works with too-short string")
        XCTAssertEqual("12".padLeft("0", toLength: 2), "12", "padLeft() works with correct-length string")
        XCTAssertEqual("123".padLeft("0", toLength: 2), "123", "padLeft() works with too-long string")
    }
}
