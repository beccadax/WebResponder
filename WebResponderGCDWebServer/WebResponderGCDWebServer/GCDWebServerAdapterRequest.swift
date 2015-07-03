//
//  GCDWebServerAdapterRequest.swift
//  WebResponderGCDWebServer
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore
import GCDWebServers

struct GCDWebServerAdapterRequest: HTTPRequestType {
    class UnderlyingRequest: GCDWebServerDataRequest {
        var webResponderMethod: HTTPMethod
        
        override init!(method: String!, url: NSURL!, headers: [NSObject : AnyObject]!, path: String!, query: [NSObject : AnyObject]!) {
            guard let webResponderMethod = HTTPMethod(rawValue: method) else {
                self.webResponderMethod = HTTPMethod(unregistered: "uninitialized")
                super.init(method: method, url: url, headers: headers, path: path, query: query)
                return nil
            }
            
            self.webResponderMethod = webResponderMethod
            super.init(method: method, url: url, headers: headers, path: path, query: query)
        }
    }
    
    let underlyingRequest: UnderlyingRequest
    
    init(underlyingRequest: UnderlyingRequest) {
        self.underlyingRequest = underlyingRequest
    }
    
    var method: HTTPMethod {
        return underlyingRequest.webResponderMethod
    }
    
    var path: String {
        return underlyingRequest.path
    }
    
    var headers: [String: [String]] {
        var headers: [String: [String]] = [:]
        
        for (key, value) in self.underlyingRequest.headers as! [String: String] {
            headers[key] = [ value ]                // XXX multiple header handling?
        }
        
        return headers
    }
    
    var body: HTTPBodyType {
        return HTTPBodyWithNSData(data: underlyingRequest.data)
    }
}

private class HTTPBodyWithNSData: HTTPBodyType {
    var data: NSData?
    
    init(data: NSData) {
        self.data = data
    }
    
    var read: Bool {
        return data == nil
    }
    
    private func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>) {
        let array = readBytes()
        
        return (array.count, AnySequence(array))
    }
    
    private func readBytes() -> [UInt8] {
        guard let dataValue = data else {
            fatalError("Can't read HTTP body twice")
        }
        
        let buffer = UnsafeBufferPointer(start: UnsafePointer<UInt8>(dataValue.bytes), count: dataValue.length)
        let array = Array(buffer)
        
        data = nil
        
        return array
    }
}
