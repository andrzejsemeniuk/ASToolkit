//
//  ExtensionForSwiftBool.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Bool
{
    public mutating func invert() {
        self = !self
    }

    public func inverted() -> Bool {
        return !self
    }

    public mutating func flip() {
        self = !self
    }
    
    public func flipped() -> Bool {
        return !self
    }
}
