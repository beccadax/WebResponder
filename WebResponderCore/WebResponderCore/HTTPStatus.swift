//
//  HTTPStatus.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents the status of an HTTP response.
/// 
/// `HTTPStatus` includes an extensive collection of constants representing all 
/// IANA-assigned HTTP statuses. It also supports `IntegerLiteralConvertible`, so
/// you can type a number like `200` anywhere in your code that requires an 
/// `HTTPStatus`.
public struct HTTPStatus {
    /// The status code of this status, e.g. 200 or 404.
    /// 
    /// - Precondition: does not have to be allocated by IANA, but must be between
    ///    100 and 599, i.e. in one of the known classes of status codes.
    public var code: Int
    
    /// Constructs an `HTTPStatus` from its code.
    public init(code: Int) {
        precondition(isValid(code), "Invalid status code \(code)")
        self.code = code
    }
    
    /// Represents a class of statuses, e.g. 3xx Redirection or 5xx Server Error.
    public enum Classification: Int {
        case Informational = 1
        case Success = 2
        case Redirection = 3
        case ClientError = 4
        case ServerError = 5
    }
    
    /// The class of this status. If you don't recognize a specific status, you can 
    /// use this to figure out what general sort of condition it represents.
    public var classification: Classification {
        return Classification(rawValue: code / 100)!
    }
    
    /// The plain-text message used to explain this status code, e.g. `"OK"` or 
    /// `"Not Found"`.
    public var message: String {
        return HTTPStatus.messages[self] ?? "Unassigned"
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

/// Two `HTTPStatus`es are equal if their `code`s are equal.
public func == (lhs: HTTPStatus, rhs: HTTPStatus) -> Bool {
    return lhs.code == rhs.code
}

extension HTTPStatus: CustomStringConvertible {
    public var description: String {
        return "\(code) \(message)"
    }
}
