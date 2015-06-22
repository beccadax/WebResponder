//
//  HTTPBodyType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public protocol HTTPBodyType: class {
    var read: Bool { get }
    
    func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>)
    
    func readBytes() -> [UInt8]
    func readUnicode<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> AnySequence<UnicodeScalar>
    func readString<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> String
}

public extension HTTPBodyType {
    func readBytes() -> [UInt8] {
        let (size, sequence) = readByteSequence()
        
        var array: [UInt8] = []
        array.reserveCapacity(size)
        array.extend(sequence)
        return array
    }
    
    func readUnicode<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> AnySequence<UnicodeScalar> {
        let (_, sequence) = readByteSequence()
        return AnySequence(UnicodeDecoder(sequence, codec: codec))
    }
    
    func readString<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> String {
        var decoder = readUnicode(codec)
        return decoder.readString()
    }
}

public extension SequenceType {
    mutating func read() -> [Generator.Element] {
        var array: [Generator.Element] = []
        array.reserveCapacity(underestimateCount())
        array.extend(self)
        return array
    }
}
