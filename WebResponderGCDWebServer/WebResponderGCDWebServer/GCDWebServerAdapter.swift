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

public extension GCDWebServer {
    func makeFirstResponder(firstResponder: WebResponderType?) {
        removeAllHandlers()
        guard let firstResponder = firstResponder else {
            return
        }
        
        addHandlerWithMatchBlock(GCDWebServerAdapterRequest.UnderlyingRequest.init) { underlyingRequest, completion in
            let request = GCDWebServerAdapterRequest(underlyingRequest: underlyingRequest as! GCDWebServerAdapterRequest.UnderlyingRequest)
            let response = GCDWebServerAdapterResponse(completion: completion)
            
            firstResponder.respond(response, toRequest: request)
        }
    }
}
