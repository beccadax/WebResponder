//
//  GCDWebServerAdapterResponse.swift
//  WebResponderGCDWebServer
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation
import WebResponderCore
import GCDWebServers

class GCDWebServerAdapterResponse: HTTPResponseType {
    init(completion: GCDWebServerCompletionBlock) {
        self.completion = completion
    }
    
    let completion: GCDWebServerCompletionBlock
    
    var status: HTTPStatus = 200
    var headers: [String: [String]] = [:]
    var body: HTTPBodyType = EmptyHTTPBody()
    
    func setStatus(newValue: HTTPStatus) {
        status = newValue
    }
    func setHeaders(newValue: [String : [String]]) {
        headers = newValue
    }
    func setBody(newValue: HTTPBodyType) {
        body = newValue
    }
    
    func respond() {
        var bytes = body.readBytes()
        
        let response: GCDWebServerResponse
        if bytes.count == 0 {
            response = GCDWebServerResponse()
            response.contentLength = 0
        }
        else {
            let data = NSData(bytesNoCopy: &bytes, length: bytes.count, deallocator: { _, _ in bytes = [] })
            response = GCDWebServerDataResponse(data: data, contentType: "application/octet-stream")
            response.contentLength = UInt(bytes.count)
        }
        
        response.statusCode = status.code
        
        for (key, values) in headers {
            let value = ", ".join(values)
            
            switch key {
            case "Content-Type":
                response.contentType = value
            
            case "Content-Length":
                fatalError("Content-Length should be expressed through the body")
            
            case "Cache-Control":
                if value == "no-cache" {
                    response.cacheControlMaxAge = 0
                }
                else if value.hasPrefix("max-age") {
                    let parts = split(value.characters) { $0 == "=" }.map(String.init)
                    let secondsString = parts[1]
                    
                    if let seconds = UInt(secondsString) {
                        response.cacheControlMaxAge = seconds
                    }
                }
                else {
                    // Just can't do it.
                }
            
            case "Last-Modified":
                let date = GCDWebServerParseRFC822(value)
                response.lastModifiedDate = date
                
            case "ETag":
                response.eTag = value
                
            default:
                response.setValue(value, forAdditionalHeader: key)
            }
        }
        
        completion(response)
    }
}