//
//  HTTPParsing.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/2/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

private let HTTPTokenCharacters: Set<Character> = {
    var chars: Set<Character> = [ "!", "#", "$", "%", "&", "'", "*", "+", "-", ".", "^", "_", "`", "|", "~"]
    chars.unionInPlace("0123456789".characters)
    chars.unionInPlace("abcdefghijklmnopqrstuvwxyz".characters)
    chars.unionInPlace("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
    return chars
}()

private prefix func !<T> (function: T -> Bool)(value: T) -> Bool {
    return !function(value)
}

internal extension String {
    func isHTTPToken() -> Bool {
        guard !isEmpty else {
            return false
        }
        return !characters.contains(!HTTPTokenCharacters.contains)
    }
}
