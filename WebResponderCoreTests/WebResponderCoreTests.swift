//
//  WebResponderCoreTests.swift
//  WebResponderCoreTests
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class WebResponderCoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleHTTPResponse() {
        let response = SimpleHTTPResponse { response, error in
            XCTAssertNil(error, "SimpleHTTPResponse.respond() is not nil")
        }
        
        response.respond()
    }
}
