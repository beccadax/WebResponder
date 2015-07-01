//
//  WebResponderTypeTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/30/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

private class TestResponder: WebResponderType {
    private func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        fatalError("respond(_:toRequest:) not needed for this test")
    }
}

class WebResponderTypeTests: XCTestCase {
    func testDefaultRequiredMiddleware() {
        let testResponder = TestResponder()
        XCTAssert(testResponder.requiredMiddleware.isEmpty, "Default requiredMiddleware is empty")
    }
}
