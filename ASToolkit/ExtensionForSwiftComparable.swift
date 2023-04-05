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
    return first.0 == first.1 && second.0 < second.1
}

func comparing3<A: Comparable, B: Comparable, C: Comparable>(_ first: (A,A), _ second: (B,B), _ third: (C,C)) -> Bool {
    if first.0 < first.1 { return true }
    if first.0 == first.1 {
        if second.0 < second.1 { return true }
        return second.0 == second.1 && third.0 < third.1
    }
    return false
}

func comparing4<A: Comparable, B: Comparable, C: Comparable, D: Comparable>(_ first: (A,A), _ second: (B,B), _ third: (C,C), _ fourth: (D,D)) -> Bool {
    if first.0 < first.1 { return true }
    if first.0 == first.1 {
        if second.0 < second.1 { return true }
        if second.0 == second.1 {
            if third.0 < third.1 { return true }
            return third.0 == third.1 && fourth.0 < fourth.1
        }
    }
    return false
}

func comparingUsingPaths<TYPE,FIRST: Comparable>(_ a: TYPE, _ b: TYPE, _ path1: KeyPath<TYPE,FIRST>) -> Bool {
    a[keyPath: path1] < b[keyPath: path1]
}

func comparingUsingPaths<TYPE,FIRST: Comparable,SECOND: Comparable>(_ a: TYPE, _ b: TYPE, _ path1: KeyPath<TYPE,FIRST>, _ path2: KeyPath<TYPE,SECOND>) -> Bool {
    if a[keyPath: path1] < b[keyPath: path1] { return true }
    return a[keyPath: path1] == b[keyPath: path1] && a[keyPath: path2] < b[keyPath: path2]
}

func comparingUsingPaths<TYPE,FIRST: Comparable, SECOND: Comparable, THIRD: Comparable>(_ a: TYPE, _ b: TYPE, _ path1: KeyPath<TYPE,FIRST>, _ path2: KeyPath<TYPE,SECOND>, _ path3: KeyPath<TYPE,THIRD>) -> Bool {
    if a[keyPath: path1] < b[keyPath: path1] { return true }
    if a[keyPath: path1] == b[keyPath: path1] {
        if a[keyPath: path2] < b[keyPath: path2] { return true }
        return a[keyPath: path2] == b[keyPath: path2] && a[keyPath: path3] < b[keyPath: path3]
    }
    return false
}

