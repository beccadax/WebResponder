//
//  HTTPResponseTypeTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/30/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

//
import XCTest
import WebResponderCore

private class RootTestResponse: HTTPResponseType {
    var status = HTTPStatus.OK
    var headers: [String: [String]] = [:]
    var body: HTTPBodyType = EmptyHTTPBody()
    
    func setStatus(newValue: HTTPStatus) {
        status = newValue
    }
    
    func setHeaders(newValue: [String: [String]]) {
        headers = newValue
    }
    
    func setBody(newValue: HTTPBodyType) {
        body = newValue
    }
}

private class LayeredTestResponse: LayeredHTTPResponseType {
    let nextResponse: HTTPResponseType
    
    init(nextResponse: HTTPResponseType) {
        self.nextResponse = nextResponse
    }
}

class HTTPResponseTypeTests: XCTestCase {
    private var rootTestResponse: RootTestResponse!
    private var layeredTestResponse: LayeredTestResponse!
    
    override func setUp() {
        rootTestResponse = RootTestResponse()
        layeredTestResponse = LayeredTestResponse(nextResponse: rootTestResponse)
        
        super.setUp()
    }
    
    func testRootResponseOfType() {
        XCTAssert(rootTestResponse.responseOfType(RootTestResponse) != nil, "On root response, responseOfType() returns self if own type")
        XCTAssert(rootTestResponse.responseOfType(SimpleHTTPResponse) == nil, "On root response, responseOfType() returns nil if not own type")
    }
    
    func testLayeredResponseOfType() {
        XCTAssert(layeredTestResponse.responseOfType(LayeredTestResponse) != nil, "On layered request, responseOfType() returns self if own type")
        XCTAssert(layeredTestResponse.responseOfType(RootTestResponse) != nil, "On layered request, responseOfType() returns previous request if previous request type")
        XCTAssert(layeredTestResponse.responseOfType(SimpleHTTPResponse) == nil, "On layered request, responseOfType() returns nil if not own type")
    }
    
    func testLayeredResponseRelaying() {
        XCTAssertEqual(layeredTestResponse.status, rootTestResponse.status, "Layered response passes through status by default")
        XCTAssert(layeredTestResponse.body === rootTestResponse.body, "Layered response passes through body by default")
        XCTAssert(layeredTestResponse.headers.isEmpty, "Layered response pases through headers by default")
    }
    
    func testLayeredResponseSetters() {
        layeredTestResponse.setStatus(.NotFound)
        XCTAssertEqual(rootTestResponse.status, .NotFound, "Layered response sets status on next response")
        
        layeredTestResponse.setHeaders(["Foo": ["Bar"]])
        AssertEqual(rootTestResponse.headers["Foo"], Optional(["Bar"]), "Layered response sets headers on next response")
        
        let body = EmptyHTTPBody()
        layeredTestResponse.setBody(body)
        XCTAssert(rootTestResponse.body === body, "Layered response sets body on next response")
    }
}

func AssertEqual<T : Equatable>(@autoclosure expression1: () -> T?, @autoclosure _ expression2: () -> T?, _ message: String = "Should be equal", file: String = __FILE__, line: UInt = __LINE__) {
    switch (expression1(), expression2()) {
    case (nil, nil):
        XCTAssert(true, message, file: file, line: line)
    case let (expr1?, expr2?):
        XCTAssertEqual(expr1, expr2, message, file: file, line: line)
    default:
        XCTFail(message, file: file, line: line)
    }
}

func AssertEqual<T : Equatable>(@autoclosure expression1: () -> [T]?, @autoclosure _ expression2: () -> [T]?, _ message: String = "Should be equal", file: String = __FILE__, line: UInt = __LINE__) {
    switch (expression1(), expression2()) {
    case (nil, nil):
        XCTAssert(true, message, file: file, line: line)
    case let (expr1?, expr2?):
        XCTAssertEqual(expr1, expr2, message, file: file, line: line)
    default:
        XCTFail(message, file: file, line: line)
    }
}
