//
//  HTTPStatusTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class HTTPStatusTests: XCTestCase {
    func testConstruction() {
        let ok = HTTPStatus(code: 200)
        XCTAssertEqual(ok.code, 200, "Constructor properly stores code")
    }
    
    func testClassification() {
        let status204 = HTTPStatus(code: 204)
        XCTAssertEqual(status204.classification, .Success, "Classification is calculated from code")

        let status200 = HTTPStatus(code: 200)
        XCTAssertEqual(status200.classification, .Success, "Classification correct at lower bound")

        let status299 = HTTPStatus(code: 299)
        XCTAssertEqual(status299.classification, .Success, "Classification correct at higher bound")
    }
    
    func testEquality() {
        XCTAssertEqual(HTTPStatus(code: 200), HTTPStatus(code: 200), "Equal codes make equal statuses")
        XCTAssertNotEqual(HTTPStatus(code: 200), HTTPStatus(code: 204), "Unequal codes make unequal statuses")
    }
    
    func testRawValue() {
        XCTAssertTrue(HTTPStatus(rawValue: 200) != nil, "Constructing an HTTPStatus with a valid raw value doesn't return nil")
        XCTAssertEqual(HTTPStatus(rawValue: 200)!, HTTPStatus(code: 200), "Constructing an HTTPStatus with a valid raw value gives a status with that code")
        
        XCTAssertFalse(HTTPStatus(rawValue: 50) != nil, "Constructing an HTTPStatus with a too-low raw value returns nil")
        XCTAssertFalse(HTTPStatus(rawValue: 900) != nil, "Constructing an HTTPStatus with a too-high raw value returns nil")
        XCTAssertTrue(HTTPStatus(rawValue: 299) != nil, "Constructing an HTTPStatus with an unassigned raw value returns a status code")
        
        XCTAssertEqual(HTTPStatus(code: 200).rawValue, 200, "HTTPStatus rawValue equals code")
    }
    
    func testIntegerLiteral() {
        XCTAssertEqual(200, HTTPStatus(code: 200), "Integer literals construct HTTPStatus with same code")
    }
    
    func testHashing() {
        XCTAssertEqual(HTTPStatus(code: 200).hashValue, HTTPStatus(code: 200).hashValue, "Equal statuses have equal hashValues")
    }
    
    func testConstants() {
        XCTAssertEqual(.OK, HTTPStatus(code: 200), "HTTPStatus constants exist and work")
    }
    
    func testMessages() {
        XCTAssertEqual(HTTPStatus.OK.message, "OK", "HTTPStatus messages exist")
        XCTAssertEqual(HTTPStatus(code: 299).message, "Unassigned", "Status message for unassigned codes is Unassigned")
    }
    
    func testDescription() {
        XCTAssertEqual(String(HTTPStatus.OK), "200 OK", "HTTPStatus description includes code and message")
    }
}
