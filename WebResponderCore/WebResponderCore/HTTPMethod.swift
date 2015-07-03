//
//  HTTPMethod.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 6/16/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

/// Represents an HTTP method in a safe, bug-resistant manner. RFC 7231 
/// specifies that HTTP methods are case-sensitive, allow ASCII alphanumeric 
/// characters and certain punctuation marks, and can be extended arbitrarily. 
/// `HTTPMethod` is designed to support these traits.
/// 
/// `HTTPMethod` includes constants for all RFC 7231 methods, plus the `PATCH` 
/// method, which is drawn from WebDAV but is used by some web frameworks. For 
/// information on adding support for other methods, see the documentation on the 
/// `registerMethod(_:)` method.
/// 
/// - Note: If you know the method you intend to use when you're writing your code, 
///   use the corresponding static constant on `HTTPMethod` to refer to it, 
///   such as `.GET` or `.POST`. If you're creating an `HTTPMethod` from data 
///   acquired at runtime, use the `init(rawValue:)` initializer, which returns 
///   `nil` if the method is invalid or not registered.
public struct HTTPMethod: RawRepresentable {
    /// Returns a string representation of the method.
    public let rawValue: String
    
    /// Creates a method from a string. This initializer will return `nil` if the 
    /// method is not present in the `registeredMethods` property.
    public init?(rawValue: String) {
        guard rawValue.isHTTPToken() else {
            self.init(unregistered: "nil")
            return nil
        }
        self.init(unregistered: rawValue)
        guard HTTPMethod.registeredMethods.contains(self) else {
            return nil
        }
    }
    
    /// Creates a method from a given string, whether it's registered in the 
    /// `registeredMethods` set or not. This should only be used to register new 
    /// methods.
    /// 
    /// - Precondition: The string is a valid HTTP token according to RFC 7230.
    ///   (A valid token will not be empty, and will contain only ASCII alphanumeric 
    ///   or certain punctuation characters.) Fails an assertion if the string is 
    ///   invalid.
    public init(unregistered string: String) {
        precondition(string.isHTTPToken(), "\(string) is not a valid HTTP token")
        self.rawValue = string
    }
}

extension HTTPMethod: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

/// Compare two `HTTPMethod`s case-sensitively.
public func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public extension HTTPMethod {
    /// A set of all registered HTTP methods. By default, all RFC 7321 methods are 
    /// registered, plus the `PATCH` method from RFC 5789 (WebDAV). Additional 
    /// methods can be registered using the `registerMethod(_:)` method.
    private(set) static var registeredMethods: Set<HTTPMethod> = [ GET, HEAD, POST, PUT, DELETE, OPTIONS, TRACE, PATCH ]
    
    /// Adds a method to the `registeredMethods` set.
    /// 
    /// To extend `HTTPMethod` with your own custom methods, extend `HTTPMethod` 
    /// with constants for them constructed with the `init(unregistered:)` 
    /// initializer, then call `registerMethod(_:)` on them. This should be done 
    /// before the web server is started.
    static func registerMethod(method: HTTPMethod) {
        registeredMethods.insert(method)
    }
    
    static internal func unregisterMethod(method: HTTPMethod) {
        registeredMethods.remove(method)
    }
    
    static let GET = HTTPMethod(unregistered: "GET")
    static let HEAD = HTTPMethod(unregistered: "HEAD")
    static let POST = HTTPMethod(unregistered: "POST")
    static let PUT = HTTPMethod(unregistered: "PUT")
    static let DELETE = HTTPMethod(unregistered: "DELETE")
    static let OPTIONS = HTTPMethod(unregistered: "OPTIONS")
    static let TRACE = HTTPMethod(unregistered: "TRACE")
    
    static let PATCH = HTTPMethod(unregistered: "PATCH")
}

public extension HTTPMethod {
    /// - Note: The `CONNECT` method is not registered by default, as it is 
    ///    almost never used by web applications. Call `registerCONNECT()` to 
    ///    register it before use.
    static let CONNECT = HTTPMethod(unregistered: "CONNECT")
    
    /// Registers the `CONNECT` method so it can be used like any other method.
    static func registerCONNECT() {
        HTTPMethod.registerMethod(CONNECT)
    }
}
