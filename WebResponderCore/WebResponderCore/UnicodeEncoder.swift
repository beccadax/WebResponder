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
        // Workaround: In Swift 2.0b2, String.UnicodeScalarView.Generator may not 
        // hold a strong reference to the buffer it's reading from, so we keep a 
        // strong reference to the Sequence it shares a buffer with. This is 
        // unnecessary but harmless for other Sequences.
        // #21657933 https://twitter.com/jckarter/status/616768905457971200
        unicodeScalarSequence = scalars
        
        unicodeScalarGenerator = unicodeScalarSequence.generate()
        estimatedScalars = scalars.underestimateCount()
    }
    
    public mutating func next() -> UInt8? {
        while byteBuffer.isEmpty {
            guard let scalar = unicodeScalarGenerator.next() else {
                return nil
            }
            
            UnicodeCodec.encode(scalar) { codeUnit in
                self.byteBuffer.extend(codeUnit.bigEndianBytes)
                return
            }
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
