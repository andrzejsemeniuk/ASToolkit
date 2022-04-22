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
