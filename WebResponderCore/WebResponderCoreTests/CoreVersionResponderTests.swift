//
//  CoreVersionResponderTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class CoreVersionResponderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func responderTest(completion: (SimpleHTTPResponse, ErrorType?) -> Void) {
        let responder = CoreVersionResponder()
        
        let request = SimpleHTTPRequest()
        let response = SimpleHTTPResponse(completion: completion)
        
        responder.respond(response, toRequest: request)
    }

    func testResponse() {
        responderTest { response, error in
            XCTAssertTrue(error == nil, "Does not fail")
            XCTAssertEqual(response.status, .OK, "Gives 200 status code")
        }
    }
    
    func testHeaders() {
        responderTest { response, error in
            guard let contentType = response.headers["Content-Type"]?.first else {
                XCTFail("No content-type header")
                return
            }
            
            XCTAssertTrue(contentType.hasPrefix("text/html"), "Identifies as HTML")
            XCTAssertTrue(contentType.hasSuffix("charset=UTF-8"), "Includes UTF-8 indicator")
        }
    }
    
    func testBody() {
        responderTest { response, error in
            let text = response.body.readString(UTF8.self)
            
            XCTAssertFalse(text.isEmpty, "Generated text")
            XCTAssertTrue(text.hasPrefix("<!DOCTYPE html><html"), "Looks like HTML")
            
            // XXX would be nice to test that the version number and stuff are in there
            // but this is actually pretty hard without Foundation.
        }
    }
}
