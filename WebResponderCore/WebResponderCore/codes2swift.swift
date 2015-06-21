#!/usr/bin/swift
//
//  codes2swift.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gdon on 6/20/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

import Foundation

extension String {
    init<Sequence: SequenceType where Sequence.Generator.Element == UnicodeScalar>(unicodeScalars: Sequence) {
        self.init()
        self.unicodeScalars.extend(unicodeScalars)
    }
}

extension UnicodeScalar {
    func isIdentifier() -> Bool {
        switch self {
        case "A"..."Z", "a"..."z", "_", "\u{00A8}", "\u{00AA}", "\u{00AD}", "\u{00AF}", "\u{00B2}"..."\u{00B5}", "\u{00B7}"..."\u{00BA}", "\u{00BC}"..."\u{00BE}", "\u{00C0}"..."\u{00D6}", "\u{00D8}"..."\u{00F6}", "\u{00F8}"..."\u{00FF}", "\u{0100}"..."\u{02FF}", "\u{0370}"..."\u{167F}", "\u{1681}"..."\u{180D}",  "\u{180F}"..."\u{1DBF}", "\u{1E00}"..."\u{1FFF}", "\u{200B}"..."\u{200D}", "\u{202A}"..."\u{202E}", "\u{203F}"..."\u{2040}", "\u{2054}", "\u{2060}"..."\u{206F}", "\u{2070}"..."\u{20CF}", "\u{2100}"..."\u{218F}", "\u{2460}"..."\u{24FF}",  "\u{2776}"..."\u{2793}", "\u{2C00}"..."\u{2DFF}", "\u{2E80}"..."\u{2FFF}", "\u{3004}"..."\u{3007}", "\u{3021}"..."\u{302F}", "\u{3031}"..."\u{303F}",  "\u{3040}"..."\u{D7FF}", "\u{F900}"..."\u{FD3D}", "\u{FD40}"..."\u{FDCF}", "\u{FDF0}"..."\u{FE1F}", "\u{FE30}"..."\u{FE44}", "\u{FE47}"..."\u{FFFD}", "\u{10000}"..."\u{1FFFD}", "\u{20000}"..."\u{2FFFD}", "\u{30000}"..."\u{3FFFD}",  "\u{40000}"..."\u{4FFFD}", "\u{50000}"..."\u{5FFFD}", "\u{60000}"..."\u{6FFFD}", "\u{70000}"..."\u{7FFFD}", "\u{80000}"..."\u{8FFFD}", "\u{90000}"..."\u{9FFFD}", "\u{A0000}"..."\u{AFFFD}", "\u{B0000}"..."\u{BFFFD}", "\u{C0000}"..."\u{CFFFD}", "\u{D0000}"..."\u{DFFFD}", "\u{E0000}"..."\u{EFFFD}":
            return true
            
        case "0"..."9", "\u{0300}"..."\u{036F}", "\u{1DC0}"..."\u{1DFF}", "\u{20D0}"..."\u{20FF}",  "\u{FE20}"..."\u{FE2F}":
            return true
            
        default:
            return false
        }
    }
}

struct StatusLine: RawRepresentable {
    var code: Int
    var message: String
    
    init?(rawValue: String) {
        let fields = rawValue.componentsSeparatedByString(",")
        
        guard fields.count > 2 else {
            return nil
        }
        
        guard let code = Int(fields[0]) else {
            return nil
        }
        
        self.code = code
        self.message = fields[1]
        
        guard message != "Unassigned" else {
            return nil
        }
    }
    
    var rawValue: String {
        return "\(code),\(message),"
    }
    
    var messageSymbol: String {
        return String(unicodeScalars: message.unicodeScalars.filter { $0.isIdentifier() })
    }
    
    var constant: String {
        return "static let \(messageSymbol) = HTTPStatus(code: \(code))"
    }
    
    var switchCase: String {
        return "case \(code): return \"\(message.unicodeScalars.map { $0.escape(asASCII: true) }.reduce(String(), combine: +))\""
    }
}

var statusLines: [StatusLine] = []

let executableFile = Process.arguments[0]
let inFile = Process.arguments[1]
let outFile = Process.arguments[2]

do {
    let lines = try NSString(contentsOfFile: inFile, usedEncoding: nil)
    
    for line in lines.componentsSeparatedByString("\n") where line != "" {
        if let statusLine = StatusLine(rawValue: line) {
            statusLines.append(statusLine)
        }
    }
}
catch {
    NSLog("%@", "Can't process codes in \(inFile): \(error)")
}

var code = "// Generated from \(inFile) by \(executableFile)\n\npublic extension HTTPStatus {\n"

for statusLine in statusLines {
    code += "    " + statusLine.constant + "\n"
}

code += "    \n    var message: String {\n        switch self {\n"

for statusLine in statusLines {
    code += "            " + statusLine.switchCase + "\n"
}

code += "            default: return \"Unassigned\"\n        }\n    }\n}\n"

do {
    if outFile == "-" {
        print(code, appendNewline: false)
    }
    else {
        try code.writeToFile(outFile, atomically: true, encoding: NSUTF8StringEncoding)
    }
}
catch {
    NSLog("%@", "Can't write code in \(outFile): \(error)")
}
