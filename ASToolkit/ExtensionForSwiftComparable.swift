//
//  ExtensionForSwiftComparable.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/18/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Comparable {

    func clamped             (minimum:Self, maximum:Self) -> Self {
        self < minimum ? minimum : maximum < self ? maximum : self
    }

    mutating func clamp      (minimum:Self, maximum:Self) {
        self = clamped(minimum: minimum, maximum: maximum)
    }
}

public extension Comparable {
    
    static func compare<T>(_ a: T, _ b: T) -> ComparisonResult where T : Comparable {
        if a < b { return .orderedAscending }
        if b > a { return .orderedDescending }
        return .orderedSame
    }
    
    func compared(to: Self) -> ComparisonResult {
        Self.compare(self,to)
    }
    
}

func comparing2<A: Comparable, B: Comparable>(_ first: (A,A), _ second: (B,B)) -> Bool {
    if first.0 < first.1 { return true }
    if first.0 == first.1, second.0 < second.1 { return true }
    return false
}

func comparing3<A: Comparable, B: Comparable, C: Comparable>(_ first: (A,A), _ second: (B,B), _ third: (C,C)) -> Bool {
    comparing2(first,second) || third.0 < third.1
}

func comparing4<A: Comparable, B: Comparable, C: Comparable, D: Comparable>(_ first: (A,A), _ second: (B,B), _ third: (C,C), _ fourth: (D,D)) -> Bool {
    comparing3(first,second,third) || fourth.0 < fourth.1
}
