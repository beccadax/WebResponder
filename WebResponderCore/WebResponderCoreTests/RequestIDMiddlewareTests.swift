//
//  RequestIDMiddlewareTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/1/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
@testable import WebResponderCore

class RequestIDMiddlewareTests: XCTestCase {
    func middlewareWithResponder(implementation: SimpleWebResponder.Implementation) -> RequestIDMiddleware {
        let middleware = RequestIDMiddleware()
        middleware.nextResponder = SimpleWebResponder(implementation: implementation)
        return middleware
    }
    
    func testRelaysRequest() {
        var ran = false
        let middleware = middlewareWithResponder { response, request in
            ran = true
        }
        middleware.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        
        XCTAssertTrue(ran, "RequestIDMiddleware relays requests to responder")
    }
    
    func testRequestIDValid() {
        middlewareWithResponder { response, request in
            XCTAssertNotNil(request.requestID, "requestID isn't nil")
            XCTAssertFalse(request.requestID?.isEmpty ?? false, "requestID isn't empty string")
            
            XCTAssertEqual(request.requestID ?? "", response.requestID ?? "", "Request and response offer same requestID")
        }.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
    }
    
    func testRequestIDUnique() {
        var lastRequestID: String?
        let middleware = middlewareWithResponder { response, request in
            if let lastRequestID = lastRequestID {
                XCTAssertNotEqual(request.requestID ?? "", lastRequestID, "Different requests don't have the same request ID")
            }
            lastRequestID = request.requestID
        }
        
        for _ in 1...100 {
            middleware.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        }
    }
    
    func testNoRequestIDMiddleware() {
        SimpleWebResponder { response, request in
            XCTAssertNil(request.requestID, "Requests not processed by RequestIDMiddleware return nil request ID")
        }.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
    }
    
    func testDoubledMiddleware() {
        var upstreamRequestID: String?
        
        let middleware = SimpleWebMiddleware(requiredMiddleware: [RequestIDMiddleware()]) { response, request, next in
            upstreamRequestID = request.requestID
            next(request, response)
        }
        let responder = SimpleWebResponder(requiredMiddleware: [middleware, RequestIDMiddleware()]) { response, request in
            XCTAssertEqual(request.requestID ?? "", upstreamRequestID ?? "", "Two RequestIDMiddlewares at different points in the responder chain don't produce different IDs")
            return
        }
        let chain = WebResponderChain(finalResponder: responder)
        
        chain.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
    }
    
    // This may not be fully covered by the other tests depending on the UUIDs they end up generating.
    func testPadLeft() {
        XCTAssertEqual("".padLeft("0", toLength: 2), "00", "padLeft() works with zero-length string")
        XCTAssertEqual("1".padLeft("0", toLength: 2), "01", "padLeft() works with too-short string")
        XCTAssertEqual("12".padLeft("0", toLength: 2), "12", "padLeft() works with correct-length string")
        XCTAssertEqual("123".padLeft("0", toLength: 2), "123", "padLeft() works with too-long string")
    }
}
