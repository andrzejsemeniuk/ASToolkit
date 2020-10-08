//
//  ExtensionForSwiftInt.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics

public extension Int
{
    var isEven:Bool {
        return self % 2 == 0
    }
    var isOdd:Bool {
        return self % 2 == 1
    }

	func loop(_ block: ()->()) {
		let limit = self
		for _ in 1...limit {
			block()
		}
	}

	func counter(_ block: (Int)->()) {
		let limit = self
		for index in 0..<limit {
			block(index)
		}
	}

}

public extension Int
{
    static var random:Int {
        return Int.random(n:UInt32.max)
    }
    static func random(n: UInt32) -> Int {
        return Int(arc4random_uniform(n))
    }
    static func random(min: Int, max: Int) -> Int {
        return Int.random(n:UInt32(max - min + 1)) + min
    }
    static func random(min: Int, upto: Int) -> Int {
        return Int.random(n:UInt32(upto - min)) + min
    }
}

public extension Int {
    mutating func advance(by n:Int) {
        self = self + n
    }

	@discardableResult mutating func assign(max v:Int) -> Int {
		self = Swift.max(self,v)
		return self
	}

	@discardableResult mutating func assign(min v:Int) -> Int {
		self = Swift.min(self,v)
		return self
	}

}

public extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

public extension Int {

    func isInInterval(_ l:Int, _ u:Int) -> Bool { return l <= self && self < u }
    
    @discardableResult
    mutating func clamp(from: Int, to: Int) -> Int {
        if self < from {
            self = from
        } else if self > to {
            self = to
        }
        return self
    }

    @discardableResult
    func clamped(from: Int, to: Int) -> Int {
        Swift.min(to,Swift.max(from,self))
    }

}

public extension Int {
	@discardableResult
	mutating func increment(by increment: Int = 1, modulo: Int) -> Int {
		self = (self + increment) % modulo
		return self
	}
}

public extension Int {

	var asFloat : Float {
		return Float(self)
	}

	var asCGFloat : CGFloat {
		return CGFloat(self)
	}

	var asDouble : Double {
		return Double(self)
	}
    
    var pick : Int {
        return Int.random(n: UInt32(self))
    }
    
    var random : Int {
        return Int.random(n: UInt32(self))
    }

}


