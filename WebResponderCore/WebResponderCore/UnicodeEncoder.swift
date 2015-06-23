//
//  UnicodeEncoder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public struct UnicodeEncoder<UnicodeCodec: UnicodeCodecType, Sequence: SequenceType where UnicodeCodec.CodeUnit: UnsignedIntegerType, Sequence.Generator.Element == UnicodeScalar>: SequenceType, GeneratorType {
    private var estimatedScalars: Int
    private var unicodeScalarGenerator: Sequence.Generator
    private var byteBuffer: [UInt8] = []
    
    public init(_ scalars: Sequence, codec: UnicodeCodec.Type) {
        self.unicodeScalarGenerator = scalars.generate()
        estimatedScalars = scalars.underestimateCount()
    }
    
    public mutating func next() -> UInt8? {
        while byteBuffer.isEmpty {
            guard let scalar = unicodeScalarGenerator.next() else {
                return nil
            }
            
            var sink = SinkOf<UnicodeCodec.CodeUnit> { codeUnit in
                self.byteBuffer.extend(codeUnit.bigEndianBytes)
                return
            }
            UnicodeCodec.encode(scalar, output: &sink)
        }
        
        estimatedScalars--
        return byteBuffer.removeAtIndex(0)
    }
    
    public func generate() -> UnicodeEncoder {
        return self
    }
    
    public func underestimateCount() -> Int {
        return estimatedScalars * sizeof(UnicodeCodec.CodeUnit.self)
    }
}
