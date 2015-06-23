//
//  HTTPBodyWithString.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation

public func HTTPBody<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(string string: String, codec: UnicodeCodec.Type) -> HTTPBodyType {
    return HTTPBodyWithString(string: string, codec: codec)
}

private final class HTTPBodyWithString<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>: HTTPBodyType {
    var string: String?
    
    init(string: String, codec: UnicodeCodec.Type) {
        self.string = string
    }
    
    var read: Bool { return string == nil }
    
    private func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>) {
        let bytes = readBytes()
        return (size: bytes.count, sequence: AnySequence(bytes))
    }
    
    private func readBytes() -> [UInt8] {
        let encoder = UnicodeEncoder(readUnicode(UnicodeCodec.self), codec: UnicodeCodec.self)
        return Array(encoder)
    }
    
    private func readUnicode<UnicodeCodec : UnicodeCodecType where UnicodeCodec.CodeUnit : UnsignedIntegerType>(codec: UnicodeCodec.Type) -> AnySequence<UnicodeScalar> {
        return AnySequence(readString(codec).unicodeScalars)
    }
    
    private func readString<UnicodeCodec : UnicodeCodecType where UnicodeCodec.CodeUnit : UnsignedIntegerType>(codec: UnicodeCodec.Type) -> String {
        guard let str = string else {
            fatalError("Can't read the same body twice")
        }

        string = nil
        return str
    }
}