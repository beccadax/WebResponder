//
//  AssertElementsEqual.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/23/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import XCTest

func AssertElementsEqual<Seq1: SequenceType, Seq2: SequenceType where Seq1.Generator.Element == Seq2.Generator.Element, Seq1.Generator.Element: Equatable>(@autoclosure seq1: Void -> Seq1, @autoclosure _ seq2: Void -> Seq2, _ message: String = "Elements are not equal", file: String = __FILE__, line: UInt = __LINE__) {
    AssertElementsEqual(seq1(), Array(seq2()), message, file: file, line: line)
}

// This variant simply speeds up some slow type inference
func AssertElementsEqual<Seq1: SequenceType where Seq1.Generator.Element: Equatable>(@autoclosure seq1: Void -> Seq1, @autoclosure _ seq2: Void -> [Seq1.Generator.Element], _ message: String = "Elements are not equal", file: String = __FILE__, line: UInt = __LINE__) {
    XCTAssertEqual(Array(seq1()), seq2(), message, file: file, line: line)
}
