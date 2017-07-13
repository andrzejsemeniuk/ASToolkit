//
//  ExtensionForSwiftInt.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Int
{
    public var isEven:Bool {
        return self % 2 == 0
    }
    public var isOdd:Bool {
        return self % 2 == 1
    }    
}

extension Int
{
    public static var random:Int {
        return Int.random(n:Int.max)
    }
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(n:max - min + 1) + min
        //Int(arc4random_uniform(UInt32(max - min + 1))) + min }
    }    
}

extension Int {
    public mutating func advance(by n:Int) {
        self = self + n
    }
}

extension Int {
    public var degreesToRadians: Double { return Double(self) * .pi / 180 }
    public var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}
