//
//  ExtensionForSwiftEnum.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 4/16/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension CaseIterable where Self: Equatable, Self.AllCases: BidirectionalCollection {
    
    var next: Self? {
        let index = Self.allCases.index(after: Self.allCases.firstIndex(of: self)!)
        guard index != Self.allCases.endIndex else {
            return nil
        }
        return Self.allCases[index]
    }
    
    var nextLooped: Self {
        let index = Self.allCases.index(after: Self.allCases.firstIndex(of: self)!)
        guard index != Self.allCases.endIndex else {
            return Self.allCases.first!
        }
        return Self.allCases[index]
    }
    
    func nextLooped(in array: [Self]) -> Self {
        var NEXT = nextLooped
        while array.missing(NEXT) {
            guard NEXT != self else {
                break
            }
            NEXT = NEXT.nextLooped
        }
        return NEXT
    }
    
    func next(in array: [Self], fallback: Self? = nil) -> Self {
        if let INDEX = array.firstIndex(of: self) {
            return array[safe: INDEX + 1] ?? fallback ?? self
        }
        return fallback ?? self
    }

    func nextOrFirst(in array: [Self]) -> Self {
        next(in: array, fallback: array.first ?? self)
    }

    var previousRemaining : [Self] {
        var r : [Self] = []
        var e = self
        while let n = e.previous {
            r.prepend(n)
            e = n
        }
        return r
    }
    
    var previousRemainingWithSelf : [Self] {
        var r : [Self] = [self]
        var e = self
        while let n = e.previous {
            r.prepend(n)
            e = n
        }
        return r
    }
    
    var nextRemaining: [Self] {
        var r : [Self] = []
        var e = self
        while let n = e.next {
            r.append(n)
            e = n
        }
        return r
    }

    var nextRemainingWithSelf: [Self] {
        var r : [Self] = [self]
        var e = self
        while let n = e.next {
            r.append(n)
            e = n
        }
        return r
    }
    

//    var previous : Self? {
//        let index = Self.allCases.index(before: Self.allCases.firstIndex(of: self)!)
//        guard index != Self.allCases.endIndex else {
//            return nil
//        }
//        return Self.allCases[index]
//    }
//
//    var previousLooped : Self {
//        previous ?? Self.allCases.last!
//    }
}

public extension CaseIterable where Self : Equatable {
    
    var previous : Self? {
        var r : Self?
        for e in Self.allCases {
            if e == self {
                break
            }
            r = e
        }
        return r
    }
    
    var previousLooped : Self {
        if let previous = previous {
            return previous
        }
        var index = Self.allCases.endIndex
        Self.allCases.formIndex(&index, offsetBy: -1)
        return Self.allCases[index]
    }
    
    func previous(in array: [Self], fallback: Self? = nil) -> Self {
        if let INDEX = array.firstIndex(of: self) {
            return INDEX > 0 ? array[INDEX - 1] : fallback ?? self
        }
        return fallback ?? self
    }
    
}

