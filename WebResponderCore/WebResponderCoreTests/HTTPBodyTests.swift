//
//  HTTPBodyTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class HTTPBodyTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyRead() {
        XCTAssertFalse(EmptyHTTPBody().read, "Empty body .read returns false when unread")
    }
    
    func testEmptyReadByteSequence() {    
        XCTAssertEqual(EmptyHTTPBody().readByteSequence().size, 0, "Empty body .readByteSequence() has zero size")
        XCTAssertTrue(EmptyHTTPBody().readByteSequence().sequence.elementsEqual([]), "Empty body .readByteSequence() returns empty sequence")
    }
    
    func testEmptyReadBytes() {    
        XCTAssertEqual(EmptyHTTPBody().readBytes(), [], "Empty body .readBytes() returns empty array")
    }
    
    func testEmptyReadUnicodeScalars() {    
        XCTAssertTrue(EmptyHTTPBody().readUnicode(UTF8.self).elementsEqual([]), "Empty body .readByteSequence() returns empty sequence")
    }
    
    func testEmptyReadString() {    
        XCTAssertEqual(EmptyHTTPBody().readString(UTF8.self), "", "Empty body .readBytes() returns empty array")
    }
}
