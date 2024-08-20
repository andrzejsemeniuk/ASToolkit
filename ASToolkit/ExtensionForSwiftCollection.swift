//
//  ExtensionForSwiftCollection.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Collection {
    
    var isEmpty: Bool {
        count == 0
    }
    
    var isNotEmpty : Bool {
        !isEmpty
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


