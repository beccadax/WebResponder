//
//  WebResponderChainTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/1/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

class WebResponderChainTests: XCTestCase {
    func testSimpleChain() {
        var ran = false
        let finalResponder = SimpleWebResponder { response, request in
            ran = true
        }
        let chain = WebResponderChain(finalResponder: finalResponder)
        
        XCTAssertTrue(chain.finalResponder === finalResponder, "Final responder is correct")
        XCTAssertTrue(chain.nextResponder === finalResponder, "Final responder with no requirements is also next responder")
        
        chain.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        XCTAssertTrue(ran, "Runs final responder")
    }
    
    func testRequiredMiddleware() {
        var ran = false
        let middleware = SimpleWebMiddleware { response, request, next in
            ran = true
            next(request, response)
        }
        let finalResponder = SimpleWebResponder(requiredMiddleware: [middleware]) { response, request in }
        let chain = WebResponderChain(finalResponder: finalResponder)
        
        XCTAssertTrue(chain.finalResponder === finalResponder, "Final responder is correct with middleware")
        XCTAssertTrue(chain.nextResponder === middleware, "Required middleware are inserted")
        
        chain.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        XCTAssertTrue(ran, "Runs middleware")
    }
    
    func testRequiredMiddlewareMultiple() {
        var requestID: String?
        let middleware = SimpleWebMiddleware { response, request, next in
            requestID = request.requestID
            next(request, response)
        }
        let finalResponder = SimpleWebResponder(requiredMiddleware: [RequestIDMiddleware(), middleware]) { response, request in }
        let chain = WebResponderChain(finalResponder: finalResponder)
        
        XCTAssertTrue(chain.finalResponder === finalResponder, "Final responder is correct with middleware")
        XCTAssertTrue(chain.nextResponder is RequestIDMiddleware, "Earlier required middleware inserted ahead of later required middleware")
        
        chain.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        XCTAssertTrue(requestID != nil, "Middleware runs in correct order")
    }
    
    func testRequiredMiddlewareNested() {
        var requestID: String?
        let middleware = SimpleWebMiddleware(requiredMiddleware: [RequestIDMiddleware()]) { response, request, next in
            requestID = request.requestID
            next(request, response)
        }
        let finalResponder = SimpleWebResponder(requiredMiddleware: [middleware]) { response, request in }
        let chain = WebResponderChain(finalResponder: finalResponder)
        
        XCTAssertTrue(chain.finalResponder === finalResponder, "Final responder is correct with middleware")
        XCTAssertTrue(chain.nextResponder is RequestIDMiddleware, "Nested required middleware inserted ahead of simple middleware")
        
        chain.respond(SimpleHTTPResponse { _, _ in }, toRequest: SimpleHTTPRequest())
        XCTAssertTrue(requestID != nil, "Middleware runs in correct order")
    }
    
    func testResponderChainMutation() {
        var finalResponderRequestID: String?
        var middlewareRequestID: String?
        
        let middleware = SimpleWebMiddleware { response, request, next in
            middlewareRequestID = request.requestID
            next(request, response)
        }
        let finalResponder = SimpleWebResponder(requiredMiddleware: [middleware]) { response, request in
            finalResponderRequestID = request.requestID
        }
        let chain = WebResponderChain(finalResponder: finalResponder)
        
        let requestIDMiddleware = RequestIDMiddleware()
        
        let rootRequest = SimpleHTTPRequest()
        let rootResponse = SimpleHTTPResponse { _, _ in }
        
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNil(middlewareRequestID, "No requestID in middleware without request ID middleware installed")
        XCTAssertNil(finalResponderRequestID, "No requestID in final without request ID midleware installed")
        
        chain.prependMiddleware(requestIDMiddleware)
        
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNotNil(middlewareRequestID, "Has requestID in middleware with request ID middleware prepended")
        XCTAssertNotNil(finalResponderRequestID, "Has requestID in final with request ID midleware prepended")
        
        chain.removeMiddleware(requestIDMiddleware)
        
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNil(middlewareRequestID, "No requestID in middleware with request ID middleware removed")
        XCTAssertNil(finalResponderRequestID, "No requestID in final with request ID midleware removed")
        
        chain.appendMiddleware(requestIDMiddleware)
        
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNil(middlewareRequestID, "No requestID in middleware with request ID middleware appended")
        XCTAssertNotNil(finalResponderRequestID, "Has requestID in final with request ID midleware appended")
        
        chain.removeMiddleware(requestIDMiddleware)
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNil(middlewareRequestID, "No requestID in middleware with request ID middleware removed near final responder")
        XCTAssertNil(finalResponderRequestID, "No requestID in final with request ID midleware removed near final responder")
        
        chain.insertMiddleware(requestIDMiddleware, after: middleware)
        
        chain.respond(rootResponse, toRequest: rootRequest)
        XCTAssertNil(middlewareRequestID, "No requestID in middleware with request ID middleware inserted after")
        XCTAssertNotNil(finalResponderRequestID, "Has requestID in final with request ID midleware inserted after")
    }
    
    func testResponderChainMutationFailures() {
        func makeChain() -> (WebResponderChain, WebMiddlewareType, WebResponderType) {
            let middleware = SimpleWebMiddleware { response, request, next in
                next(request, response)
            }
            let finalResponder = SimpleWebResponder(requiredMiddleware: [middleware]) { response, request in
            }
            return (WebResponderChain(finalResponder: finalResponder), middleware, finalResponder)
        }
        
        let (chain1, middleware1, _) = makeChain()
        let (chain2, middleware2, _) = makeChain()
        let otherMiddleware = RequestIDMiddleware()
        
        XCTAssertTrue(chain1.insertMiddleware(otherMiddleware, after: middleware1), "Valid insertMiddleware(_:after:) returns true")
        
        XCTAssertFalse(chain2.removeMiddleware(otherMiddleware), "Invalid removeMiddleware(_:) returns false")
        XCTAssertTrue(chain1.removeMiddleware(otherMiddleware), "Valid removeMiddleware(_:) returns true")
        
        XCTAssertTrue(chain1.insertMiddleware(otherMiddleware, before: middleware1), "Valid insertMiddleware(_:before:) returns true")
        XCTAssertTrue(chain1.removeMiddleware(otherMiddleware), "Valid removeMiddleware(_:) returns true")
        
        XCTAssertFalse(chain1.insertMiddleware(otherMiddleware, after: middleware2), "Invalid insertMiddleware(_:after:) returns false")
        XCTAssertFalse(chain1.insertMiddleware(otherMiddleware, before: middleware2), "Invalid insertMiddleware(_:before:) returns false")
    }
}
