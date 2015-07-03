//
//  Event.swift
//  WebResponderGCDWebServer
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import AppKit
import WebResponderCore

enum Event {
    case Request (requestID: String, method: HTTPMethod, target: String)
    case Response (requestID: String, status: HTTPStatus)
    case ErrorResponse (requestID: String, error: ErrorType)
    
    var typeImage: NSImage {
        switch self {
        case .Request:
            return NSImage(named: NSImageNameGoRightTemplate)!
        case .Response:
            return NSImage(named: NSImageNameGoLeftTemplate)!
        case .ErrorResponse:
            return NSImage(named: NSImageNameStopProgressFreestandingTemplate)!
        }
    }
    
    var requestID: String {
        switch self {
        case let .Request (requestID, _, _):
            return requestID
        case let .Response (requestID, _):
            return requestID
        case let .ErrorResponse (requestID, _):
            return requestID
        }
        
    }
    
    var detailText: String {
        switch self {
        case let .Request (_, method, target):
            return "\(method.rawValue) \(target)"
        case let .Response (_, status):
            return status.description
        case let .ErrorResponse (_, error):
            return (error as NSError).description
        }
    }
}
