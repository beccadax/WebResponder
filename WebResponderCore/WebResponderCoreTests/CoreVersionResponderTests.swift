//
//  CoreVersionResponderTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/27/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
@testable import WebResponderCore

class CoreVersionResponderTests: XCTestCase {
    func responderTest(completion: (HTTPResponseType, ErrorType?) -> Void) {
        let responder = CoreVersionResponder()
        responder.insertNextResponder(SimpleWebResponder { response, error, _, _ in
            completion(response, error)
        })
        
        let request = SimpleHTTPRequest()
        let response = SimpleHTTPResponse()
        
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
    
    func testErrnoThrowing() {
        func errnoFunc(fail: Bool) -> Int {
            if fail {
                errno = ENOENT
                return -1
            }
            else {
                return 1
            }
        }
        let throwingErrnoFunc = errnoThrowing(errnoFunc, errorValue: -1)
        
        AssertDoesNotThrow(try throwingErrnoFunc(false), "Successful call doesn't throw")
        AssertThrows(try throwingErrnoFunc(true), expectedError: NSError(domain: NSPOSIXErrorDomain, code: Int(ENOENT), userInfo: [:]), "Failing call throws appropriate error")
    }
}

private func AssertDoesNotThrow<T>(@autoclosure expr: () throws -> T, _ message: String, file: String = __FILE__, line: UInt = __LINE__) {
    XCTAssertNil(thrown(expr) as NSError?, message, file: file, line: line)
}

private func AssertThrows<T>(@autoclosure expr: () throws -> T, expectedError: ErrorType, _ message: String, file: String = __FILE__, line: UInt = __LINE__) {
    let error = thrown(expr) as NSError?
    if let error = error {
        XCTAssertEqual(error, expectedError as NSError, message, file: file, line: line)
    }
    else {
        XCTFail(message, file: file, line: line)
    }
}

private func thrown<T>(@noescape fn: () throws -> T) -> ErrorType? {
    do {
        try fn()
        return nil
    }
    catch {
        return error
    }
}

