//
//  ViewController.swift
//  GCDWebServerWebResponderDemo
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Cocoa
import WebResponderCore
import WebResponderGCDWebServer
import GCDWebServers

class ViewController: NSViewController, GCDWebServerDelegate, NSTableViewDataSource {
    let webServer = GCDWebServer()
    lazy var recorder: EventRecorderMiddleware = EventRecorderMiddleware(appendHandler: self.appendedEvent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chain = WebResponderChain(finalResponder: CoreVersionResponder())
        chain.prependMiddleware(recorder)
        
        webServer.makeFirstResponder(chain)
        
        webServer.delegate = self
        webServer.start()
    }
    
    func webServerDidCompleteBonjourRegistration(server: GCDWebServer!) {
        let url = server.bonjourServerURL
        
        linkField.attributedStringValue = NSAttributedString(string: url.absoluteString, attributes: [NSLinkAttributeName: url])
    }
    
    func appendedEvent(recorder: EventRecorderMiddleware, index: Int) {
        tableView.beginUpdates()
        tableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: .EffectFade)
        tableView.endUpdates()
    }
    
    @IBOutlet var linkField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return recorder.events.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let event = recorder.events[row]
        
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

