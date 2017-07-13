//
//  ExtensionForSwiftNumeric.swift
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
    public mutating func increment(_ increment:Self) -> Self {
        self = self + increment
        return self
    }
}

extension FloatingPoint {
    public var twoPi: Self { return .pi * 2 }
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}
