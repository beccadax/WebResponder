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
        let responder = SimpleWebResponder { response, request in
            ran = true
            response.respond()
        }
        
        responder.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        
        XCTAssert(ran, "Implementation is run when responder is asked to respond")
    }
}
