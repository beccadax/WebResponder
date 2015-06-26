//
//  Latin1.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/24/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public struct Latin1: UnicodeCodecType {
    public static var unknownCharacterHandler = { (_: UnicodeScalar) -> [UInt8] in Array("?".utf8) }
    
    typealias CodeUnit = UInt8
    public init() {}
    
    public mutating func decode<G : GeneratorType where G.Element == UInt8>(inout generator: G) -> UnicodeDecodingResult {
        if let scalar = generator.next().map(UnicodeScalar.init) {
            return .Result(scalar)
        }
        else {
            return .EmptyInput
        }
    }
    
    public static func encode<S : SinkType where S.Element == UInt8>(input: UnicodeScalar, inout output: S) {
        switch input.value {
        case 0xFEFF:
            // Unicode byte order marker (or pointless space); ignore
            break
            
        case UInt8.range():
            output.put(UInt8(input.value))
            
        default:
            for byte in unknownCharacterHandler(input) {
                output.put(byte)
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
