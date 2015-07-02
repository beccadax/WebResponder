//
//  UnicodeEncoder.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Encodes a sequence of `UnicodeScalar`s into a sequence of bytes using a
/// `UnicodeCodecType`. The encoding is done lazily as bytes are read from the 
/// encoder.
public struct UnicodeEncoder<UnicodeCodec: UnicodeCodecType, Sequence: SequenceType where UnicodeCodec.CodeUnit: UnsignedIntegerType, Sequence.Generator.Element == UnicodeScalar>: SequenceType, GeneratorType {
    private var estimatedScalars: Int
    private var unicodeScalarSequence: Sequence
    private var unicodeScalarGenerator: Sequence.Generator
    private var byteBuffer: [UInt8] = []
    
    public init(_ scalars: Sequence, codec: UnicodeCodec.Type) {
        // String.UnicodeScalarView.Generator may not hold a strong reference to 
        // the scalar view, and thus the buffer it's reading from. So we have to do 
        // it instead, even though we don't need a reference to the sequence after 
        // this. Sigh.
        unicodeScalarSequence = scalars
        
        unicodeScalarGenerator = unicodeScalarSequence.generate()
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
