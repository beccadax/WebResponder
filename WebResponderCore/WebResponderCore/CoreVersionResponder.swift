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
        let platform: String
        do {
            platform = try uname().version
        }
        catch let error as NSError {
            platform = "Error retrieving platform (\(error.localizedDescription))"
        }

        let version = WebResponderCoreVersionNumber
        
        response.setStatus(.OK)
        response.setHeaders(["Content-Type": ["text/html; charset=UTF-8"]])
        response.setBody(HTTPBody(string: "<!DOCTYPE html><html><head><title>WebResponderCore</title><style>html { font-family: sans-serif; margin: 1ex 25%; background-color: #eee } body { padding: 1em; border: 1px solid #ddd; background-color: white; font-size: 1.2em/1.5em } h1 { margin-top: 0 } dl { margin: 0 } dt { font-weight: bold } dd { margin: 0; padding: 0; margin-bottom: 0.5em; }</style></head><body><h1>WebResponderCore</h1><dl><dt>Version</dt><dd>\(version)</dd><dt>Platform</dt><dd>\(platform)</dd><dt>Request Target</dt><dd>\(aggressivelyEscapeHTML(request.target))</dd></dl></body></html>", codec: UTF8.self))
        
        response.respond()
    }
}

private func aggressivelyEscapeHTML(string: String) -> String {
    // Let's not try to figure out which characters are safe; just escape everything.
    return lazy(string.unicodeScalars).map { $0.value }.map { "&#\($0);" }.reduce("", combine: +)
}

private func uname() throws -> (sysname: String, nodename: String, release: String, version: String, machine: String) {
    func t2s<T>(var tuple: T) -> String {
        return withUnsafePointer(&tuple) { tuplePointer in
            String.fromCString(UnsafePointer<Int8>(tuplePointer))!
        }
    }
    
    var unameResult = utsname()
    if uname(&unameResult) == 0 {
        return (t2s(unameResult.sysname), t2s(unameResult.nodename), t2s(unameResult.release), t2s(unameResult.release), t2s(unameResult.machine))
    }
    else {
        throw NSError(domain: NSPOSIXErrorDomain, code: Int(errno), userInfo: [:])
    }
}
