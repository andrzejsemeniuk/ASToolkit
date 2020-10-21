//
//  ExtensionForSwiftComparable.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/18/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation


public extension Comparable {
    
    static func compare<T>(_ a: T, _ b: T) -> ComparisonResult where T : Comparable {
        if a < b { return .orderedAscending }
        if b > a { return .orderedDescending }
        return .orderedSame
    }
    
}
