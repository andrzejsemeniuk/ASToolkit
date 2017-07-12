//
//  ASToolkitExtension+Numeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Integer {
    public mutating func increment(increment:Self) -> Self {
        self = self + increment
        return self
    }
}

extension FloatingPoint {
    public mutating func increment(increment:Self) -> Self {
        self = self + increment
        return self
    }
}
