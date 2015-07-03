//
//  HTTPMethodTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/3/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
@testable import WebResponderCore

class HTTPMethodTests: XCTestCase {
    func testIsHTTPToken() {
        // We can't test `HTTPMethod(unregistered:)`'s failure case directly, but 
        // this tests its implementation.
        XCTAssertTrue("FOOBAR".isHTTPToken(), "Method-style string is a token")
        XCTAssertTrue("Foo-Bar".isHTTPToken(), "Header-style string is a token")
        XCTAssertTrue("+3.14~iDeAs-4_$'&'*dom".isHTTPToken(), "Weird but legal string is a token")
        
        XCTAssertFalse("Foo Bar".isHTTPToken(), "String with space is not a token")
        XCTAssertFalse("Foo:Bar".isHTTPToken(), "String with colon is not a token")
        XCTAssertFalse("Foo;Bar".isHTTPToken(), "String with semicolon is not a token")
        XCTAssertFalse("Foo,Bar".isHTTPToken(), "String with comma is not a token")
        XCTAssertFalse("".isHTTPToken(), "Empty string is not a token")
    }
    
    func testInitUnregistered() {
        XCTAssertEqual(HTTPMethod(unregistered: "Foo").rawValue, "Foo", "init(unregistered:) sets rawValue appropriately")
    }
    
    func testInitRawValue() {
        if let get = HTTPMethod(rawValue: "GET") {
            XCTAssertEqual(get.rawValue, "GET", "init(rawValue:) returns appropriate object for registered method")
        }
        else {
            XCTFail("init(rawValue:) returns appropriate object for registered method")
        }
        
        XCTAssertFalse(HTTPMethod(rawValue: "GET ") != nil, "init(rawValue:) returns nil for syntactically invalid string")
        XCTAssertFalse(HTTPMethod(rawValue: "GIT") != nil, "init(rawValue:) returns nil for unregistered string")
        XCTAssertFalse(HTTPMethod(rawValue: "Get") != nil, "init(rawValue:) returns nil for improperly cased string")
    }
    
    func testRegistration() {
        let myMethod = HTTPMethod(unregistered: "MyMethod")
        XCTAssertFalse(HTTPMethod(rawValue: "MyMethod") != nil, "Unregistered method returns nil")
        
        HTTPMethod.registerMethod(myMethod)
        XCTAssertTrue(HTTPMethod(rawValue: "MyMethod") != nil, "After registering, getting method returns method")
        
        HTTPMethod.unregisterMethod(myMethod)
    }
    
    func testRegisterConnect() {
        XCTAssertFalse(HTTPMethod(rawValue: HTTPMethod.CONNECT.rawValue) != nil, "Unregistered CONNECT method returns nil")
        
        HTTPMethod.registerCONNECT()
        XCTAssertTrue(HTTPMethod(rawValue: HTTPMethod.CONNECT.rawValue) != nil, "After registering, getting CONNECT method returns method")
        
        HTTPMethod.unregisterMethod(HTTPMethod.CONNECT)
    }
}
