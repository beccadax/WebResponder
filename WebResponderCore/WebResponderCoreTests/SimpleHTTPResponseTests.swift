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
