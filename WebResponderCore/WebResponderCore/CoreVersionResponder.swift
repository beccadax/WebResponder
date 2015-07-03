//
//  CoreVersionResponder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/24/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// A `WebResponderType` which responds with an HTML page giving information 
/// about WebResponderCore. Useful as a diagnostic tool.
public class CoreVersionResponder: WebResponderType {
    public init() {}
    
    public func respond(response: HTTPResponseType, toRequest request: HTTPRequestType) {
        var unameResult = utsname()
        uname(&unameResult)
        let platform = withUnsafePointer(&unameResult.version) { tuplePointer in
            String.fromCString(UnsafePointer<Int8>(tuplePointer))!
        } 

        let version = WebResponderCoreVersionNumber
        
        response.setStatus(.OK)
        response.setHeaders(["Content-Type": ["text/html; charset=UTF-8"]])
        response.setBody(HTTPBody(string: "<!DOCTYPE html><html><head><title>WebResponderCore</title><style>html { font-family: sans-serif; margin: 1ex 25%; background-color: #eee } body { padding: 1em; border: 1px solid #ddd; background-color: white; font-size: 1.2em/1.5em } h1 { margin-top: 0 } dl { margin: 0 } dt { font-weight: bold } dd { margin: 0; padding: 0; margin-bottom: 0.5em; }</style></head><body><h1>WebResponderCore</h1><dl><dt>Version</dt><dd>\(version)</dd><dt>Platform</dt><dd>\(platform)</dd><dt>Request Target</dt><dd>\(request.target)</dd></dl></body></html>", codec: UTF8.self))
        
        response.respond()
    }
}
