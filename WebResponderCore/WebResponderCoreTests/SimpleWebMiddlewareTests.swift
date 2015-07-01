//
//  SimpleWebMiddlewareTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/28/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class SimpleWebMiddlewareTests: XCTestCase {
    func testRunsImplementation() {
        var ran = false
        let middleware = SimpleWebMiddleware { response, request, next in
            ran = true
            next(request, response)
        }
        middleware.nextResponder = SimpleWebResponder { response, _ in response.respond() }
        middleware.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        
        XCTAssert(ran, "Middleware implementation runs when asked to respond")
    }
    
    func testPassesThrough() {
        var ran = false
        let middleware = SimpleWebMiddleware { response, request, next in
            next(request, response)
        }
        middleware.nextResponder = SimpleWebResponder { response, _ in
            ran = true
            response.respond()
        }
        middleware.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        
        XCTAssert(ran, "Middleware implementation passes response to next responder")
    }
}
