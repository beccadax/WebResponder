//
//  SimpleHTTPResponseTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class SimpleHTTPResponseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRespond() {
        let response = SimpleHTTPResponse { response, error in
            XCTAssertNil(error as NSError?, "SimpleHTTPResponse.respond() is not nil")
            return
        }
        
        response.respond()
    }
    
    func testFail() {
        let response = SimpleHTTPResponse { response, error in
            XCTAssertNotNil(error as NSError?, "SimpleHTTPResponse.respond() is not nil")
            return
        }
        
        response.failWithError(NSCocoaError.FileReadNoSuchFileError)
    }
}
