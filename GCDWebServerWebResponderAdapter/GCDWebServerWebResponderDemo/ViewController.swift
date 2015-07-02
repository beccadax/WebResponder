//
//  ViewController.swift
//  GCDWebServerWebResponderDemo
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Cocoa
import WebResponderCore
import GCDWebServerWebResponderAdapter
import GCDWebServers

enum Event {
    case Request (requestID: String, method: HTTPMethod, path: String)
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
        case let .Request (_, method, path):
            return "\(method.rawValue) \(path)"
        case let .Response (_, status):
            return status.description
        case let .ErrorResponse (_, error):
            return (error as NSError).description
        }
    }
}

class ViewController: NSViewController, GCDWebServerDelegate, NSTableViewDataSource {
    let webServer = GCDWebServer()
    
    @IBOutlet var linkField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    var events: [Event] = []
    
    func addEvent(event: Event) {
        dispatch_async(dispatch_get_main_queue()) {
            let index = self.events.count
            self.events.append(event)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: .EffectGap)
            self.tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chain = WebResponderChain(finalResponder: CoreVersionResponder())
        chain.appendMiddleware(SimpleWebMiddleware(requiredMiddleware: [RequestIDMiddleware()]) { response, request, next in
            self.addEvent(.Request(requestID: request.requestID!, method: request.method, path: request.path))
            
            let wrappedResponse = SimpleHTTPResponse { wrappedResponse, error in
                if let error = error {
                    self.addEvent(.ErrorResponse(requestID: response.requestID!, error: error))
                    response.failWithError(error)
                }
                else {
                    self.addEvent(.Response(requestID: response.requestID!, status: response.status))
                    
                    response.setStatus(wrappedResponse.status)
                    response.setHeaders(wrappedResponse.headers)
                    response.setBody(wrappedResponse.body)
                    
                    response.respond()
                }
            }
            
            next(request, wrappedResponse)
        })

        webServer.makeFirstResponder(chain)
        
        webServer.delegate = self
        webServer.start()
    }
    
    func webServerDidCompleteBonjourRegistration(server: GCDWebServer!) {
        let url = server.bonjourServerURL
        
        linkField.attributedStringValue = NSAttributedString(string: url.absoluteString, attributes: [NSLinkAttributeName: url])
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let event = events[row]
        
        switch tableColumn?.identifier {
        case "type"?:
            return event.typeImage
        case "id"?:
            return event.requestID
        case "text"?:
            return event.detailText
        case nil:
            return nil
        default:
            fatalError("Unknown table column \(tableColumn?.identifier)")
        }
    }
}

