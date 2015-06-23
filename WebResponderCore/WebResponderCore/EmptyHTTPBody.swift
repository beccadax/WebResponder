//
//  EmptyHTTPBody.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public func EmptyHTTPBody() -> HTTPBodyType {
    return EmptyHTTPBodyImplementation()
}

private final class EmptyHTTPBodyImplementation: HTTPBodyType {
    init() {}
    
    var read = false
    func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>) {
        assert(!read, "Can't read the same body twice")
        read = true
        
        return (0, AnySequence(EmptyCollection()))
    }
}
