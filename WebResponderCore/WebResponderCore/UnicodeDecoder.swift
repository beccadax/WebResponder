//
//  UnicodeDecoder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public extension SequenceType where Generator.Element == UnicodeScalar {
    public mutating func readString() -> String {
        var string = ""
        string.unicodeScalars.reserveCapacity(underestimateCount())
        string.unicodeScalars.extend(self)
        return string
    }
}

public struct UnicodeDecoder<UnicodeCodec: UnicodeCodecType, Sequence: SequenceType where UnicodeCodec.CodeUnit: UnsignedIntegerType, Sequence.Generator.Element == UInt8>: SequenceType, GeneratorType {
    private var codeUnitGenerator: UIntegerGenerator<UnicodeCodec.CodeUnit, Sequence.Generator>
    private var estimate: Int
    private var codec: UnicodeCodec
    
    public init(_ seq: Sequence, codec type: UnicodeCodec.Type) {
        self.codec = type()
        self.codeUnitGenerator = UIntegerGenerator(type: UnicodeCodec.CodeUnit.self, byteGenerator: seq.generate())
        
        let estimationFactor: Int
        if sizeof(UnicodeCodec.CodeUnit.self) == 1 {
            estimationFactor = 6        // Worst-case of UTF8
        }
        else {
            estimationFactor = 4        // Worst-case of UTF16, only case UTF32
        }
        
        self.estimate = seq.underestimateCount() / estimationFactor
    }
    
    public mutating func next() -> UnicodeScalar? {
        switch codec.decode(&codeUnitGenerator) {
        case .EmptyInput:
            return nil
            
        case .Error:
            estimate--
            return "�"
            
        case .Result(let scalar):
            estimate--
            return scalar
        }
    }
    
    public func generate() -> UnicodeDecoder {
        return self
    }
    
    public func underestimateCount() -> Int {
        return estimate
    }
}

private struct UIntegerGenerator<UInteger: UnsignedIntegerType, Generator: GeneratorType where Generator.Element == UInt8>: GeneratorType {
    var byteGenerator: Generator?
        
    init(type: UInteger.Type, byteGenerator: Generator) {
        self.byteGenerator = byteGenerator
    }
    
    mutating func next() -> UInteger? {
        var bytes: [UInt8] = []
        
        for _ in 0..<sizeof(UInteger.self) {
            if let byte = byteGenerator?.next() {
                bytes.append(byte)
            }
            else {
                byteGenerator = nil
                return nil
            }
        }
        
        return UInteger(bigEndianBytes: bytes)
    }
}
