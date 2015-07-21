//
//  Latin1.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/24/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Encodes and decodes between ISO-8859-1 (Latin-1) bytes and Swift 
/// `UnicodeScalar`s. Note that not all `UnicodeScalar`s can be represented in 
/// Latin-1.
public struct Latin1: UnicodeCodecType {
    /// Called when encoding a `UnicodeScalar` which cannot be represented in 
    /// Latin-1. The default handler simply returns a "?", but more sophisticated
    /// algorithms can be substituted by replacing this closure.
    public static var unknownCharacterHandler = { (_: UnicodeScalar) -> [UInt8] in Array("?".utf8) }
    
    public typealias CodeUnit = UInt8
    public init() {}
    
    /// Decodes a Latin-1 byte into a `UnicodeScalar`. Latin-1 decoding cannot fail.
    public mutating func decode<G : GeneratorType where G.Element == UInt8>(inout generator: G) -> UnicodeDecodingResult {
        if let scalar = generator.next().map(UnicodeScalar.init) {
            return .Result(scalar)
        }
        else {
            return .EmptyInput
        }
    }
    
    /// Encodes a `UnicodeScalar` as one or more Latin-1 bytes. May call 
    /// `Latin1.unknownCharacterHandler` if the character cannot be represented in 
    /// Latin-1.
    public static func encode(input: UnicodeScalar, output: UInt8 -> Void) {
        switch input.value {
        case 0xFEFF:
            // Unicode byte order marker (or pointless space); ignore
            break
            
        case UInt8.range():
            output(UInt8(input.value))
            
        default:
            for byte in unknownCharacterHandler(input) {
                output(byte)
            }
        }
    }
}

protocol RangedType {
    static var min: Self { get }
    static var max: Self { get }
}

extension RangedType where Self: UnsignedIntegerType {
    static func range<UInteger: UnsignedIntegerType>() -> ClosedInterval<UInteger> {
        return UInteger(min.toUIntMax())...UInteger(max.toUIntMax())
    }
}

extension UInt8: RangedType {}
extension UInt16: RangedType {}
extension UInt32: RangedType {}
extension UInt64: RangedType {}
extension UInt: RangedType {}
