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
}

