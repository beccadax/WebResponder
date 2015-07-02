//
//  EventRecorderMiddleware.swift
//  GCDWebServerWebResponderAdapter
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore

class EventRecorderMiddleware: WebMiddlewareType {
    var nextResponder: WebResponderType!
    
    var events: [Event] = []
    let requiredMiddleware = [ RequestIDMiddleware() ]
    
    typealias AppendHandler = (EventRecorderMiddleware, Int) -> Void
    var appendHandler: AppendHandler
    
    init(appendHandler: AppendHandler) {
        self.appendHandler = appendHandler
    }
    
    func addEvent(event: Event) {
        dispatch_async(dispatch_get_main_queue()) {
            let index = self.events.count
            self.events.append(event)
            
            self.appendHandler(self, index)
        }
    }
    
    func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        let method = request.method
        let path = request.path
        let id = request.requestID ?? ""
        
        addEvent(.Request(requestID: id, method: method, path: path))
        
        let wrappedResponse = Response(nextResponse: response, recorder: self)
        sendRequestToNextResponder(request, withResponse: wrappedResponse)
    }
    
    class Response: LayeredHTTPResponseType {
        var nextResponse: HTTPResponseType
        let recorder: EventRecorderMiddleware
        
        init(nextResponse: HTTPResponseType, recorder: EventRecorderMiddleware) {
            self.nextResponse = nextResponse
            self.recorder = recorder
        }
        
        func respond() {
            recorder.addEvent(.Response(requestID: requestID ?? "", status: status))
            nextResponse.respond()
        }
        
        func failWithError(error: ErrorType) {
            recorder.addEvent(.ErrorResponse(requestID: requestID ?? "", error: error))
            nextResponse.failWithError(error)
        }
    }
}
