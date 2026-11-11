//
//  ExtensionForSwiftBool.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

nonisolated
public extension Bool
{
    mutating func invert() {
        self = !self
    }

    func inverted(_ invert: Bool = true) -> Bool {
        invert ? !self : self
    }

    mutating func flip() {
        self = !self
    }
    
    func flipped(_ invert: Bool = true) -> Bool {
        inverted(invert)
    }

    func value<V>(on: V, off: V) -> V {
        self ? on : off
    }
    
    func value<V>(_ on: V, _ off: V) -> V {
        self ? on : off
    }
    
    static func compare(_ a: Bool, _ b: Bool) -> ComparisonResult {
        if !a && b { return .orderedAscending }
        if a && !b { return .orderedDescending }
        return .orderedSame
    }
    
    
//    static var random   : Bool { .random() }
    static var pick     : Bool { .random() }

    
    func XOR (_ rhs: Bool) -> Bool {
        self != rhs
    }

    func format(_ TRUE: String = "true", _ FALSE: String = "false") -> String {
        self ? TRUE : FALSE
    }

    var asString : String { self ? "true" : "false" }
    var asTorF : String { self ? "T" : "F" }
    
    var not : Bool { !self }

}

nonisolated
extension Bool : @retroactive Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs
    }
}

public extension Bool {
    
    @inlinable
    func choose<V>(_ a: V, _ b: V) -> V {
        self ? a : b
    }
    
}

