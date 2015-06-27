//
//  HTTPStatus.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

public struct HTTPStatus {
    public var code: Int
    
    public init(code: Int) {
        precondition(isValid(code), "Invalid status code \(code)")
        self.code = code
    }
    
    enum Classification: Int {
        case Informational = 1
        case Success = 2
        case Redirection = 3
        case ClientError = 4
        case ServerError = 5
    }
    
    var classification: Classification {
        return Classification(rawValue: code / 100)!
    }
}

private func isValid(code: Int) -> Bool {
    return (100...599).contains(code)
}

extension HTTPStatus: RawRepresentable {
    public var rawValue: Int { return code }
    
    public init?(rawValue: Int) {
        if isValid(rawValue) {
            self.init(code: rawValue)
        }
        else {
            return nil
        }
    }
    
    var message: String {
        return HTTPStatus.messages[self] ?? "Unassigned"
    }
}

extension HTTPStatus: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self.init(code: value)
    }
}

extension HTTPStatus: Hashable {
    public var hashValue: Int {
        return code.hashValue
    }
}

public func == (lhs: HTTPStatus, rhs: HTTPStatus) -> Bool {
    return lhs.code == rhs.code
}

extension HTTPStatus: CustomStringConvertible {
    public var description: String {
        return "\(code) \(message)"
    }
}
