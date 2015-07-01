//
//  SimpleWebResponderTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class SimpleWebResponderTests: XCTestCase {
    func testRunsImplementation() {
        var ran = false
        let responder = SimpleWebResponder { response, request in
            ran = true
            response.respond()
        }
        
        responder.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        
        XCTAssert(ran, "Implementation is run when responder is asked to respond")
    }
}
