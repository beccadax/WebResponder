//
//  UnsignedIntegerBytes.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/21/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

extension UnsignedIntegerType {
    /// Constructs an integer of the indicated size from an array of bytes in 
    /// big-endian order.
    init(bigEndianBytes bytes: [UInt8]) {
        var int: UIntMax = 0
        
        for byte in bytes {
            int <<= 8
            int |= byte.toUIntMax()
        }
        
        self.init(int)
    }
    
    /// Returns the bytes of the integer in big-endian order.
    var bigEndianBytes: [UInt8] {
        var bytes: [UInt8] = []
        var bitPattern = self.toUIntMax()
        
        for _ in 0..<sizeof(self.dynamicType) {
            let byte = UInt8(truncatingBitPattern: bitPattern)
            bytes.insert(byte, atIndex: 0)
            bitPattern >>= 8
        }
        
        return bytes
    }
}
