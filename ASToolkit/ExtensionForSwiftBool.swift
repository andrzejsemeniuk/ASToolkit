//
//  ExtensionForSwiftBool.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

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
    
    var not : Bool { !self }

}

extension Bool : Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs
    }
}

