//
//  EventRecorderMiddleware.swift
//  WebResponderGCDWebServer
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore

class EventRecorderMiddleware: WebResponderType {
    lazy var nextResponder: WebResponderRespondable! = Trailer(recorder: self)
    
    var events: [Event] = []
    func helperResponders() -> [WebResponderType] {
        return [ RequestIDMiddleware() ]
    }
    
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
        let target = request.target
        let id = request.requestID!
        
        addEvent(.Request(requestID: id, method: method, target: target))
        
        nextResponder.respond(response, toRequest: request)
    }
    
    class Trailer: WebResponderType {
        var nextResponder: WebResponderRespondable!
        let recorder: EventRecorderMiddleware
        
        init(recorder: EventRecorderMiddleware) {
            self.recorder = recorder
        }
        
        func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
            recorder.addEvent(.Response(requestID: request.requestID!, status: response.status))
            nextResponder.respond(response, toRequest: request)
        }
        
        func respond(response: HTTPResponseType, withError error: ErrorType, toRequest request: HTTPRequestType) {
            recorder.addEvent(.ErrorResponse(requestID: request.requestID!, error: error))
            nextResponder.respond(response, withError: error, toRequest: request)
        }
    }
}
