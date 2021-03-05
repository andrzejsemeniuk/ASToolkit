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

    func isEqual(to: Self, withPrecision precision: Self) -> Bool {
        abs(self - to) < precision
    }
    
}






extension Double
{
    var sign : Double {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }

    public var clampedTo01         : Double {
        return clamped(minimum:0, maximum:1)
    }
    public var clampedTo0255       : Double {
        return clamped(minimum:0, maximum:255)
    }
    
    public func crunched(into: Double) -> Double {
        var s = self
        while into < s {
            s -= into
        }
        while s < 0.0 {
            s += into
        }
        return s
    }
    
    @discardableResult
    mutating public func addAround01(_ add: Double) -> Double {
        self += add
        self = self.crunched(into: 1.0)
        return self
    }
    
    
    public func lerp                (from:Double, to:Double) -> Double {
//        return (1.0-self)*from + self*to
        return from + (to - from) * self
    }
    public static func lerp         (from:Double, to:Double, with:Double) -> Double {
        return with.lerp(from:from,to:to)
    }
    public func lerp01              (from:Double, to:Double) -> Double {
        return min(1.0,max(0.0,self.lerp(from:from,to:to)))
    }
    public static func lerp01       (from:Double, to:Double, with:Double) -> Double {
        return with.lerp01(from:from,to:to)
    }
    
    public func progress            (from f:Double, to t:Double) -> Double {
        return f < t ? (self-f)/(t-f) : (f-self)/(f-t)
    }
    public func progress01          () -> Double {
        return progress(from:0,to:1)
    }

}

extension Double {
    
    @discardableResult public mutating func assign(max v:Double) -> Double {
        self = Swift.max(self,v)
        return self
    }

    @discardableResult public mutating func assign(min v:Double) -> Double {
        self = Swift.min(self,v)
        return self
    }
    
}

public extension Double {
    
    static var   resolution      : UInt32     = 100000
    
    static var   random01        : Double { Double(arc4random() % resolution) / resolution.asDouble }
    static var   random          : Double { random01 }
    
    static func  random          (min: Double, max: Double) -> Double { Double.random * (max - min) + min }
    static func  random          (min: Double, max: Double, resolution: UInt32) -> Double {
        (Double(arc4random_uniform(resolution)) / resolution.asDouble) * (max - min) + min
    }
    static func  random01        (resolution: UInt32) -> Double { random(min: 0, max: 1, resolution: resolution) }

}

extension Double {

    public var asFloat : Float {
        return Float(self)
    }

    public var asCGFloat : CGFloat {
        return CGFloat(self)
    }

    public var asInt : Int {
        return Int(self)
    }
}






extension Float
{
    var sign : Float {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }
    
    public var clampedTo01         : Float {
        return clamped(minimum:0, maximum:1)
    }
    public var clampedTo0255       : Float {
        return clamped(minimum:0, maximum:255)
    }
    
    public func lerp                (from:Float, to:Float) -> Float {
        //        return (1.0-self)*from + self*to
        return from + (to - from) * self
    }
    public static func lerp         (from:Float, to:Float, with:Float) -> Float {
        return with.lerp(from:from,to:to)
    }
    public func lerp01              (from:Float, to:Float) -> Float {
        return min(1,max(0,self.lerp(from:from,to:to)))
    }
    public static func lerp01       (from:Float, to:Float, with:Float) -> Float {
        return with.lerp01(from:from,to:to)
    }
    
    public func progress            (from f:Float, to t:Float) -> Float {
        return f < t ? (self-f)/(t-f) : (f-self)/(f-t)
    }
    public func progress01          () -> Float {
        return progress(from:0,to:1)
    }
}

extension Float {
    
    public static var   random01        : Float { Double.random01.asFloat }
    public static var   random          : Float { random01 }
    public static func  random          (min: Float, max: Float) -> Float { Float.random * (max - min) + min }

    public static var   maximum         : Float { .greatestFiniteMagnitude }
    public static var   minimum         : Float { -maximum }

}

extension Float {

    public var asInt : Int {
        return Int(self)
    }

    public var asCGFloat : CGFloat {
        return CGFloat(self)
    }

    public var asDouble : Double {
        return Double(self)
    }
}





public extension Int
{
    var sign : Int {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }
    
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

    func loop(_ block: (Int)->()) {
        let limit = self
        for index in 1...limit {
            block(index)
        }
    }

    func counter(_ block: (Int)->()) {
        let limit = self
        for index in 0..<limit {
            block(index)
        }
    }
    
    @inlinable func map<T>(_ transform: (Int) throws -> T) rethrows -> [T] {
        try Array(0..<self).map { i in
            try transform(i)
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
        self = incremented(by: increment, modulo: modulo)
        return self
    }

    func incremented(by increment: Int = 1, modulo: Int) -> Int {
        let r = (self + increment) % modulo
        return r < 0 ? r + modulo : r
    }

}

public extension Int {

    var asFloat         : Float         { return Float(self) }
    var asCGFloat       : CGFloat       { return CGFloat(self) }
    var asDouble        : Double        { return Double(self) }
    
    var pick : Int {
        return Int.random(n: UInt32(self))
    }
    
    var random : Int {
        return Int.random(n: UInt32(self))
    }

}

public extension UInt {

    var asFloat         : Float         { Float(self) }
    var asCGFloat       : CGFloat       { CGFloat(self) }
    var asDouble        : Double        { Double(self) }
    var asInt           : Int           { Int(self) }

    func isInInterval   (_ l:UInt, _ u:UInt) -> Bool { return l <= self && self < u }
}

public extension UInt32 {

    var asFloat         : Float         { Float(self) }
    var asCGFloat       : CGFloat       { CGFloat(self) }
    var asDouble        : Double        { Double(self) }
    var asInt           : Int           { Int(self) }

    func isInInterval   (_ l: UInt32, _ u:UInt32) -> Bool { return l <= self && self < u }
}

public extension UInt64 {

    var asDouble        : Double        { Double(self) }
    var asInt64         : Int64         { Int64(self) }
    var asInt           : Int           { Int(self) }
    var asUInt          : UInt          { UInt(self) }

    func isInInterval(_ l:UInt64, _ u:UInt64) -> Bool { return l <= self && self < u }

}

public extension Int64 {
    
    var sign : Int64 {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }
    
    var asDouble        : Double        { Double(self) }
    var asUInt64        : UInt64        { UInt64(self) }
    var asInt           : Int           { Int(self) }
    var asUInt          : UInt          { UInt(self) }

}
