//
//  UnicodeDecoderTests.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/22/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest
import WebResponderCore

func decode8<Seq: SequenceType where Seq.Generator.Element == UInt8>(bytes: Seq) -> UnicodeDecoder<UTF8, Seq> {
    return UnicodeDecoder(bytes, codec: UTF8.self)
}

func decodeL<Seq: SequenceType where Seq.Generator.Element == UInt8>(bytes: Seq) -> UnicodeDecoder<Latin1, Seq> {
    return UnicodeDecoder(bytes, codec: Latin1.self)
}

func decode16<Seq: SequenceType where Seq.Generator.Element == UInt8>(bytes: Seq) -> UnicodeDecoder<UTF16, Seq> {
    return UnicodeDecoder(bytes, codec: UTF16.self)
}

func decode32<Seq: SequenceType where Seq.Generator.Element == UInt8>(bytes: Seq) -> UnicodeDecoder<UTF32, Seq> {
    return UnicodeDecoder(bytes, codec: UTF32.self)
}

class UnicodeDecoderTests: XCTestCase {
    func testUTF8Encoding() {
        AssertElementsEqual(decode8("hello".utf8), "hello".unicodeScalars, "UTF8: ASCII")
        AssertElementsEqual(decode8([0xEF, 0xBB, 0xBF]), "\u{FEFF}".unicodeScalars, "UTF8: Byte order marker")
        AssertElementsEqual(decode8("κόσμε".utf8), "κόσμε".unicodeScalars, "UTF8: Basic multilingual plane")
        AssertElementsEqual(decode8("🜀🜁🜂🜃🜄".utf8), "🜀🜁🜂🜃🜄".unicodeScalars, "UTF8: Extraplanar symbols")
    }
    
    func testLatin1Encoding() {
        AssertElementsEqual(decodeL("hello".utf8), "hello".unicodeScalars, "Latin1: ASCII")
        AssertElementsEqual(decodeL("El Niño".unicodeScalars.map { UInt8($0.value) }), "El Niño".unicodeScalars, "Latin1: High characters")
    }
    
    func testUTF16Encoding() {
        AssertElementsEqual(decode16("hello".utf8.flatMap { [0, $0] }), "hello".unicodeScalars, "UTF16: ASCII")
        AssertElementsEqual(decode16([0xFE, 0xFF]), "\u{FEFF}".unicodeScalars, "UTF16: Byte order marker")
        AssertElementsEqual(decode16([0x03, 0xba, 0x1f, 0x79, 0x03, 0xc3, 0x03, 0xbc, 0x03, 0xb5]), "κόσμε".unicodeScalars, "UTF16: Basic multilingual plane")
        AssertElementsEqual(decode16([0xd8, 0x3d, 0xdf, 0x00, 0xd8, 0x3d, 0xdf, 0x01, 0xd8, 0x3d, 0xdf, 0x02, 0xd8, 0x3d, 0xdf, 0x03, 0xd8, 0x3d, 0xdf, 0x04]), "🜀🜁🜂🜃🜄".unicodeScalars, "UTF16: Extraplanar symbols")
    }
    
    func testUTF32Encoding() {
        AssertElementsEqual(decode32("hello".utf8.flatMap { [0, 0, 0, $0] }), "hello".unicodeScalars, "UTF32: ASCII")
        AssertElementsEqual(decode32([0x00, 0x00, 0xFE, 0xFF]), "\u{FEFF}".unicodeScalars, "UTF32: Byte order marker")
        AssertElementsEqual(decode32([0, 0, 0x03, 0xba, 0, 0, 0x1f, 0x79, 0, 0, 0x03, 0xc3, 0, 0, 0x03, 0xbc, 0, 0, 0x03, 0xb5]), "κόσμε".unicodeScalars, "UTF32: Basic multilingual plane")
        AssertElementsEqual(decode32([0x00, 0x01, 0xf7, 0x00, 0x00, 0x01, 0xf7, 0x01, 0x00, 0x01, 0xf7, 0x02, 0x00, 0x01, 0xf7, 0x03, 0x00, 0x01, 0xf7, 0x04]), "🜀🜁🜂🜃🜄".unicodeScalars, "UTF32: Extraplanar symbols")
    }
    
    func testEncodingError() {
        AssertElementsEqual(decode16([ 0xDC, 0x00 ]), "�".unicodeScalars, "Unpaired surrogate pairs emit errors")
        AssertElementsEqual(decode8([ 0xed, 0xa0, 0x80, 0xed, 0xb0, 0x80 ]), "������".unicodeScalars, "Surrogate pairs in UTF-8 emit errors")
        
        AssertElementsEqual(decode8([ 0xc0 ]), "�".unicodeScalars, "Stray UTF-8 first bytes emit errors")
        AssertElementsEqual(decode8([ 0x80 ]), "�".unicodeScalars, "Stray UTF-8 continuation bytes emit errors")
        AssertElementsEqual(decode8([ 0xc0, 0xaf ]), "��".unicodeScalars, "Overlong UTF-8 sequences emit errors")
    }
    
    func testUnderestimateCount() {
        XCTAssertEqual(decode8("hello".utf8).underestimateCount(), 2, "UTF-8 underestimateCount() accurate")
        XCTAssertEqual(decode16("hello".utf8.flatMap { [0, $0] }).underestimateCount(), 3, "UTF-16 underestimateCount() accurate")
        XCTAssertEqual(decode32("hello".utf8.flatMap { [0, 0, 0, $0] }).underestimateCount(), 5, "UTF-32 underestimateCount() accurate")
    }
}
