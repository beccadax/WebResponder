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
    func testEmpty() {
        XCTAssertFalse(EmptyHTTPBody().read, "Empty body .read returns false when unread")
        
        XCTAssertEqual(EmptyHTTPBody().readByteSequence().size, 0, "Empty body .readByteSequence() has zero size")
        AssertElementsEqual(EmptyHTTPBody().readByteSequence().sequence, [], "Empty body .readByteSequence() returns empty sequence")

        XCTAssertEqual(EmptyHTTPBody().readBytes(), [], "Empty body .readBytes() returns empty array")

        AssertElementsEqual(EmptyHTTPBody().readUnicode(UTF8.self), [], "Empty body .readUnicode() returns empty sequence")

        XCTAssertEqual(EmptyHTTPBody().readString(UTF8.self), "", "Empty body .readString() returns empty string")
    }
    
    func testBodyWithBytes() {
        XCTAssertFalse(HTTPBody(bytes: Array("hello".utf8)).read, "Byte body .read returns false when unread")
        
        XCTAssertEqual(HTTPBody(bytes: Array("hello".utf8)).readByteSequence().size, 5, "Byte body .readByteSequence() has zero size")
        AssertElementsEqual(HTTPBody(bytes: Array("hello".utf8)).readByteSequence().sequence, "hello".utf8, "Byte body .readByteSequence() returns correct bytes sequence")
        
        AssertElementsEqual(HTTPBody(bytes: Array("hello".utf8)).readBytes(), "hello".utf8, "Byte body .readBytes() returns correct byte array")
        
        AssertElementsEqual(HTTPBody(bytes: Array("hello".utf8)).readUnicode(UTF8.self), ["h", "e", "l", "l", "o"], "Byte body .readUnicode() returns correct UnicodeScalar sequence")
        
        XCTAssertEqual(HTTPBody(bytes: Array("hello".utf8)).readString(UTF8.self), "hello", "Byte body .readString() returns correct string")
    }
    
    func testBodyWithString() {
        XCTAssertFalse(HTTPBody(string: "hello", codec: UTF8.self).read, "Byte body .read returns false when unread")
        
        XCTAssertEqual(HTTPBody(string: "hello", codec: UTF8.self).readByteSequence().size, 5, "Byte body .readByteSequence() has zero size")
        AssertElementsEqual(HTTPBody(string: "hello", codec: UTF8.self).readByteSequence().sequence, "hello".utf8, "Byte body .readByteSequence() returns correct bytes sequence")
        
        AssertElementsEqual(HTTPBody(string: "hello", codec: UTF8.self).readBytes(), "hello".utf8, "Byte body .readBytes() returns correct byte array")
        
        AssertElementsEqual(HTTPBody(string: "hello", codec: UTF8.self).readUnicode(UTF8.self), ["h", "e", "l", "l", "o"], "Byte body .readUnicode() returns correct UnicodeScalar sequence")
        
        XCTAssertEqual(HTTPBody(string: "hello", codec: UTF8.self).readString(UTF8.self), "hello", "Byte body .readString() returns correct string")
    }
}
