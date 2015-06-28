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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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
