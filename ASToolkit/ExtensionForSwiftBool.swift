//
//  ExtensionForSwiftBool.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Bool
{
    public mutating func invert() {
        self = !self
    }

    public func inverted(_ invert: Bool = true) -> Bool {
        invert ? !self : self
    }

    public mutating func flip() {
        self = !self
    }
    
    public func flipped(_ invert: Bool = true) -> Bool {
        inverted(invert)
    }
}

public extension Bool {
    
    static func compare(_ a: Bool, _ b: Bool) -> ComparisonResult {
        if !a && b { return .orderedAscending }
        if a && !b { return .orderedDescending }
        return .orderedSame
    }
    
}

public extension Bool {
    
//    static var random   : Bool { .random() }
    static var pick     : Bool { .random() }

}

public extension Bool {
    
    func XOR (_ rhs: Bool) -> Bool {
        self != rhs
    }
    
}
