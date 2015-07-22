//
//  GCDWebServerAdapter.swift
//  WebResponderGCDWebServer
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore
import GCDWebServers

/// A subclass of `GCDWebServer` that uses a WebResponder responder chain to 
/// process requests.
/// 
/// To use this class, insert a responder chain by using `insertNextResponder(_:)`, 
/// then call one of the superclass's `start()` methods to start the server.
/// 
/// - Warning: Do not use the various handler-adding methods inherited from 
///              `GCDWebServer`; these may route requests away from your responder 
///              chain.
public class WebResponderGCDWebServer: GCDWebServer, WebResponderChainable {
    public override init() {
        super.init()
        
        addHandlerWithMatchBlock(GCDWebServerAdapterRequest.UnderlyingRequest.init) { [unowned self] underlyingRequest, completion in
            let request = GCDWebServerAdapterRequest(underlyingRequest: underlyingRequest as! GCDWebServerAdapterRequest.UnderlyingRequest)
            let response = GCDWebServerAdapterResponse(completion: completion)
            
            self.nextResponder.respond(response, toRequest: request)
        }
    }
    
    lazy public var nextResponder: WebResponderRespondable! = Tail()
    
    private class Tail: WebResponderRespondable {
        private func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
            guard let response = response.responseOfType(GCDWebServerAdapterResponse.self) else {
                fatalError("Somehow lost the original response!")
            }
            
            response.respond()
        }
        
        private func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType) {
            let error = error as NSError
            
            response.setStatus(500)
            response.setHeaders(["Content-Type": [ "text/plain; charset=UTF-8" ]])
            response.setBody(HTTPBody(string: error.description, codec: UTF8.self))
            
            respond(response, toRequest: request)
        }
    }
}
