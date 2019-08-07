//
//  ExtensionForSwiftInt.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics

extension Int
{
    public var isEven:Bool {
        return self % 2 == 0
    }
    public var isOdd:Bool {
        return self % 2 == 1
    }

	public func loop(_ block: ()->()) {
		let limit = self
		for _ in 1...limit {
			block()
		}
	}

	public func counter(_ block: (Int)->()) {
		let limit = self
		for index in 0..<limit {
			block(index)
		}
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
    }
    public static func random(min: Int, upto: Int) -> Int {
        return Int.random(n:upto - min) + min
    }
}

extension Int {
    public mutating func advance(by n:Int) {
        self = self + n
    }

	@discardableResult public mutating func assign(max v:Int) -> Int {
		self = Swift.max(self,v)
		return self
	}

	@discardableResult public mutating func assign(min v:Int) -> Int {
		self = Swift.min(self,v)
		return self
	}

}

extension Int {
    public var degreesToRadians: Double { return Double(self) * .pi / 180 }
    public var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension Int {
    public func isInInterval(_ l:Int, _ u:Int) -> Bool { return l <= self && self < u }
}

extension Int {
	@discardableResult
	public mutating func increment(by increment: Int = 1, modulo: Int) -> Int {
		self = (self + increment) % modulo
		return self
	}
}

extension Int {

	public var asFloat : Float {
		return Float(self)
	}

	public var asCGFloat : CGFloat {
		return CGFloat(self)
	}

	public var asDouble : Double {
		return Double(self)
	}
}
