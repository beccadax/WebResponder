//
//  HTTPBodyType.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents the body of an HTTP request or response.
/// 
/// An `HTTPBodyType` offers several APIs to read its contents, but you can only 
/// one of these methods, and you can only call it once. You can check if a 
/// particular body has already been read with the `read` property. `HTTPBodyType` 
/// is always a reference type and there is no way to copy one.
public protocol HTTPBodyType: class {
    var read: Bool { get }
    
    func readByteSequence() -> (size: Int, sequence: AnySequence<UInt8>)
    
    func readBytes() -> [UInt8]
    func readUnicode<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> AnySequence<UnicodeScalar>
    func readString<UnicodeCodec: UnicodeCodecType where UnicodeCodec.CodeUnit: UnsignedIntegerType>(codec: UnicodeCodec.Type) -> String
}

public extension HTTPBodyType {
    func readBytes() -> [UInt8] {
        var (size, sequence) = readByteSequence()
        return sequence.read(estimatedSize: size)
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
    // XXX compiler bug 21500900: can't = underestimateCount()
    // mutating func read(estimatedSize size: Int = underestimateCount()) -> [Generator.Element] {
    mutating func read(estimatedSize size: Int? = nil) -> [Generator.Element] {
        var array: [Generator.Element] = []
        array.reserveCapacity(size ??  underestimateCount())
        array.extend(self)
        return array
    }
}
