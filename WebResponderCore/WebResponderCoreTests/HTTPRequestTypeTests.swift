//
//  HTTPRequestTypeTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/30/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

private class RootTestRequest: HTTPRequestType {
    let path = "/foo"
    let method = HTTPMethod.GET
    let headers = [:] as [String: [String]]
    let body = EmptyHTTPBody()
}

private class LayeredTestRequest: LayeredHTTPRequestType {
    let previousRequest: HTTPRequestType
    
    init(previousRequest: HTTPRequestType) {
        self.previousRequest = previousRequest
    }
}

class HTTPRequestTypeTests: XCTestCase {
    func testRootRequestOfType() {
        let rootTestRequest = RootTestRequest()
        
        XCTAssert(rootTestRequest.requestOfType(RootTestRequest) != nil, "On root request, requestOfType() returns self if own type")
        XCTAssert(rootTestRequest.requestOfType(SimpleHTTPRequest) == nil, "On root request, requestOfType() returns nil if not own type")
    }
    
    func testLayeredRequestOfType() {
        let rootTestRequest = RootTestRequest()
        let layeredTestRequest = LayeredTestRequest(previousRequest: rootTestRequest)
        
        XCTAssert(layeredTestRequest.requestOfType(LayeredTestRequest) != nil, "On layered request, requestOfType() returns self if own type")
        XCTAssert(layeredTestRequest.requestOfType(RootTestRequest) != nil, "On layered request, requestOfType() returns previous request if previous request type")
        XCTAssert(layeredTestRequest.requestOfType(SimpleHTTPRequest) == nil, "On layered request, requestOfType() returns nil if not own type")
    }
    
    func testLayeredRequestRelaying() {
        let rootTestRequest = RootTestRequest()
        let layeredTestRequest = LayeredTestRequest(previousRequest: rootTestRequest)
        
        XCTAssertEqual(layeredTestRequest.path, rootTestRequest.path, "Layered request passes through path by default")
        XCTAssertEqual(layeredTestRequest.method, rootTestRequest.method, "Layered request passes through method by default")
        XCTAssert(layeredTestRequest.body === rootTestRequest.body, "Layered request passes through body by default")
        XCTAssert(layeredTestRequest.headers.isEmpty, "Layered request pases through headers by default")
    }
}
