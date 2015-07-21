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
    var nextResponder: WebResponderRespondable!
    
    private func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        fatalError("respond(_:toRequest:) not needed for this test")
    }
}

class WebResponderTypeTests: XCTestCase {
    func testDefaultHelperResponders() {
        let testResponder = TestResponder()
        XCTAssert(testResponder.helperResponders().isEmpty, "Default helperResponders is empty")
    }
    
    func testDefaultErrorImplementation() {
        let intendedError = NSCocoaError.CoreDataError
        
        let testResponder = TestResponder()
        testResponder.nextResponder = SimpleWebResponder { response, error, request, next in
            XCTAssertTrue(intendedError ~= error, "Correct error passed through default implementation of respond(_:withError:toRequest:)")
        }
        
        testResponder.respond(SimpleHTTPResponse(), withError: intendedError as ErrorType, toRequest: SimpleHTTPRequest())
    }
}
