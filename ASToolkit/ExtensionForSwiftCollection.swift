//
//  ExtensionForSwiftCollection.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Collection {
    
    nonisolated
    var isEmpty: Bool {
        count == 0
    }
    
    nonisolated
    var isNotEmpty : Bool {
        !isEmpty
    }
    
    @discardableResult
    mutating func transform(_ f: (Self)->Self) -> Self {
        self = f(self)
        return self
    }
    
    func transformed(_ f: (Self)->Self) -> Self {
        f(self)
    }
    
    func transformedOptionally(_ f: (Self)->Self?) -> Self? {
        f(self)
    }
    
    @discardableResult
    mutating func transformSelf(_ f: (inout Self)->Void) -> Self {
        f(&self)
        return self
    }
    
    mutating func transformCopy(_ f: (inout Self)->Void) {
        var R = self
        f(&R)
        self = R
    }
    
    
    
    @discardableResult
    mutating func modify(_ f: (Self)->Self) -> Self {
        self = f(self)
        return self
    }
    
    func modified(_ f: (Self)->Self) -> Self {
        f(self)
    }
    
    func modifiedOptionally(_ f: (Self)->Self?) -> Self? {
        f(self)
    }
    
    @discardableResult
    mutating func modifySelf(_ f: (inout Self)->Void) -> Self {
        f(&self)
        return self
    }
    
    
    
    func filterUpTo(_ limit: Int, _ predicate: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        result.reserveCapacity(Swift.min(count, limit)) // Pre-allocate space for efficiency
        
        for element in self {
            if result.count >= limit {
                break
            }
            if predicate(element) {
                result.append(element)
            }
        }
        
        return result
    }
    
    
    func indices(of element: Element) -> [Index] where Element: Equatable {
        indices.filter { self[$0] == element }
    }

    
}

public enum OrderedCollectionSearchDirection {
    case lower
    case equal
    case higher
}

public extension Collection where Element: Comparable {
 
    func indexInSortedCollectionOf(_ element: Element) -> Index? {
        switch index(startIndex, offsetBy: distance(from: startIndex, to: endIndex) / 2) {
            case let i where i >= endIndex          : return nil
            case let i where self[i] == element     : return i
            case let i where self[i] > element      : return self[..<i].indexInSortedCollectionOf(element)
            case let i                              : return self[index(after: i)..<endIndex].indexInSortedCollectionOf(element)
        }
    }
    
    func indexInSortedCollectionWith(director: (Element)->OrderedCollectionSearchDirection) -> Index? {
        switch index(startIndex, offsetBy: distance(from: startIndex, to: endIndex) / 2) {
        case let i where i >= endIndex          : return nil
        case let i                              :
            switch director(self[i]) {
                case .lower:
                    return self[..<i].indexInSortedCollectionWith(director: director)
                case .equal:
                    return i
                case .higher:
                    return self[index(after: i)..<endIndex].indexInSortedCollectionWith(director: director)
            }
        }
        
    }
    
}

public extension Collection where Element: Hashable {
    
    var asSet : Set<Element> {
        .init(self)
    }
}






public extension Set where Element : Equatable {
    
    mutating func insert(_ array: [Element]) {
        array.forEach { insert($0) }
    }
    
    mutating func insert(_ array: [Element?]) {
        array.compactMap { $0 }.forEach { insert($0) }
    }
    
    mutating func remove(_ array: [Element]) {
        array.forEach { remove($0) }
    }
    
    func missing(_ element: Element) -> Bool {
        !contains(element)
    }
    
    mutating func toggle(_ array: [Element]) {
        array.forEach {
            toggle($0)
        }
    }

    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
    
    mutating func set(_ array: [Element], keepingCapacity: Bool = false) {
        removeAll(keepingCapacity: keepingCapacity)
        insert(array)
    }

    mutating func set(_ array: [Element?], keepingCapacity: Bool = false) {
        removeAll(keepingCapacity: keepingCapacity)
        insert(array)
    }
    
    mutating func set(_ element: Element, keepingCapacity: Bool = false) {
        removeAll(keepingCapacity: keepingCapacity)
        insert(element)
    }

    mutating func set(_ element: Element?, keepingCapacity: Bool = false) {
        removeAll(keepingCapacity: keepingCapacity)
        if let element {
            insert(element)
        }
    }
}

public extension Set {
    mutating func clear() {
        removeAll()
    }
}

public extension Collection where Element : Equatable {
    func intersected(with other: any Collection<Element>) -> [Element] {
        self.filter { other.contains($0) }
    }
}
//public extension Array where Element : Equatable {
//    func intersection(with other: Self) -> Self {
//        self.filter { other.contains($0) }
//    }
//}
