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
    
}
