//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension BinaryInteger {
    mutating func increment(increment:Self) -> Self {
        self = self + increment
        return self
    }
    
    @discardableResult
    mutating func add(_ value: Self, min: Self, max: Self) -> Self {
        self = Swift.max(min, Swift.min(max, self + value))
        return self
    }
    
    func added(_ value: Self, min: Self, max: Self) -> Self {
        Swift.max(min, Swift.min(max, self + value))
    }
}

public extension FloatingPoint {
    mutating func increment(_ increment:Self) -> Self {
        self = self + increment
        return self
    }
}

public extension FloatingPoint {
    var twoPi: Self { return .pi * 2 }
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
    
    @discardableResult
    mutating func add(_ value: Self, min: Self, max: Self) -> Self {
        self = Swift.max(min, Swift.min(max, self + value))
        return self
    }
    
    func added(_ value: Self, min: Self, max: Self) -> Self {
        Swift.max(min, Swift.min(max, self + value))
    }

}
