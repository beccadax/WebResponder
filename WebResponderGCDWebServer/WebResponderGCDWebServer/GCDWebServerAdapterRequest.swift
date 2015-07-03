//
//  GCDWebServerAdapterRequest.swift
//  GCDWebServerWebResponderAdapter
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore
import GCDWebServers

struct GCDWebServerAdapterRequest: HTTPRequestType {
    typealias UnderlyingRequest = GCDWebServerDataRequest
    
    let underlyingRequest: UnderlyingRequest
    
    init(underlyingRequest: UnderlyingRequest) {
        self.underlyingRequest = underlyingRequest
    }
    
    var method: HTTPMethod {
        return HTTPMethod(rawValue: underlyingRequest.method)!
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
