//
//  HTTPBodyWithBytes.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Returns an `HTTPBodyType` which generates the given array of bytes.
public func HTTPBody(bytes bytes: [UInt8]) -> HTTPBodyType {
    return HTTPBodyWithBytes(bytes)
}

private final class HTTPBodyWithBytes: HTTPBodyType {
    var bytes: [UInt8]?
    
    init(_ array: [UInt8]) {
        bytes = array
    }
    
    var read: Bool { return bytes == nil }
    
    func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>) {
        let array = readBytes()
        
        return (array.count, AnySequence(array))
    }
    
    func readBytes() -> [UInt8] {
        guard let array = bytes else {
            fatalError("Can't read the same body twice")
        }
        bytes = nil
        
        return array
    }
}
