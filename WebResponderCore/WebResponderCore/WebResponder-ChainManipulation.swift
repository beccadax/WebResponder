//
//  WebResponder-ChainManipulation.swift
//  WebResponderCore
//
//  Created by Brent Royal-Gordon on 7/6/15.
//  Copyright © 2015 Groundbreaking Software. All rights reserved.
//

extension WebResponderType {
    // XXX Can this somehow be folded into insertNextResponder(_:)?
    
    /// Constructs a responder chain with `self` and any of its `helperResponders`, 
    /// recursively, returning the first responder in the chain.
    /// 
    /// - Warning: Calling `withHelperResponders()` on a responder more than once 
    ///              is a great way to make yourself very sad.
    public func withHelperResponders() -> WebResponderType {
        return helperResponders().reverse().reduce(self as WebResponderType) { responder, helper in
            helper.insertNextResponder(responder)
            return helper.withHelperResponders()
        }
    }
}

extension WebResponderChainable {
    /// Inserts a portion of a responder chain, starting with `newNextResponder` 
    /// and including all of its `nextResponder`s recursively, between this responder 
    /// and the next.
    /// 
    /// Suppose you have the following responder chain:
    /// 
    ///     A -> B -> C -> D
    /// 
    /// and you call `insertNextResponder` on `B`, passing this chain:
    /// 
    ///     X -> Y
    /// 
    /// The resulting chain will look like:
    /// 
    ///     A -> B -> X -> Y -> C -> D
    /// 
    /// - Returns: `true` if insertion was successful, `false` if insertion failed
    ///              because `newNextResponder` already terminates with a non-full 
    ///              responder (e.g. `Y` conforms to `WebResponderRespondable`, 
    ///              but not `WebResponderType`.)
    /// 
    /// - Precondition: `newNextResponder` is *not* already in `self`'s responder 
    ///                   chain.
    public func insertNextResponder(newNextResponder: WebResponderType) -> Bool {
        guard let lastResponderForNewResponder = newNextResponder.lastResponder as? WebResponderType else {
            return false
        }
        
        assert(lastResponderForNewResponder !== lastResponder, "insertNextResponder(_:) called with responder already in this responder chain")
        
        lastResponderForNewResponder.nextResponder = nextResponder
        nextResponder = newNextResponder
        
        return true
    }
    
    private var lastResponder: WebResponderRespondable? {
        if let nextResponder = nextResponder {
            if let nextResponder = nextResponder as? WebResponderType, tail = nextResponder.lastResponder {
                return tail
            }
            return nextResponder
        }
        return self as? WebResponderType
    }
}
