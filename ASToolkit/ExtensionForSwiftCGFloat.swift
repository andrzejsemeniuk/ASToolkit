//
//  ExtensionForSwiftCGFloat.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension CGFloat
{
    public var clampedTo01         : CGFloat {
        return clamped(minimum:0, maximum:1)
    }
    public var clampedTo0255       : CGFloat {
        return clamped(minimum:0, maximum:255)
    }
    
    public func lerp                (from:CGFloat, to:CGFloat) -> CGFloat {
        //        return (1.0-self)*from + self*to
        return from + (to - from) * self
    }
    public func lerp                (_ from:CGFloat, _ to:CGFloat) -> CGFloat {
        //        return (1.0-self)*from + self*to
        return from + (to - from) * self
    }
    public static func lerp         (from:CGFloat, to:CGFloat, with:CGFloat) -> CGFloat {
        return with.lerp(from:from,to:to)
    }
    public func lerp01              (from:CGFloat, to:CGFloat) -> CGFloat {
        return Swift.min(1,Swift.max(0,self.lerp(from:from,to:to)))
    }
    public func lerp01              (_ from:CGFloat, _ to:CGFloat) -> CGFloat {
        return Swift.min(1,Swift.max(0,self.lerp(from:from,to:to)))
    }
    public static func lerp01       (from:CGFloat, to:CGFloat, with:CGFloat) -> CGFloat {
        return with.lerp01(from:from,to:to)
    }
    
    public func progress            (from f:CGFloat, to t:CGFloat) -> CGFloat {
        return f < t ? (self-f)/(t-f) : (f-self)/(f-t)
    }
    public func progress01          () -> CGFloat {
        return progress(from:0,to:1)
    }

	@discardableResult public mutating func assign(max v:CGFloat) -> CGFloat {
		self = Swift.max(self,v)
		return self
	}

	@discardableResult public mutating func assign(min v:CGFloat) -> CGFloat {
		self = Swift.min(self,v)
		return self
	}
}

public extension CGFloat {
    
    static var   randomSign      : CGFloat                                      { (arc4random_uniform(2) == 0) ? 1.0 : -1.0 }
    static var   random          : CGFloat                                      { CGFloat(Float.random) }
    static var   random01        : CGFloat                                      { random }
    static var   random11        : CGFloat                                      { random(min: -1, max: +1) }

    static func  random          (min: CGFloat, max: CGFloat) -> CGFloat        { CGFloat.random * (max - min) + min }
    static func  random          (_ min: CGFloat, _ max: CGFloat) -> CGFloat    { CGFloat.random * (max - min) + min }

    func         random          (factor: CGFloat) -> CGFloat                   {
        let f = self * factor
        return CGFloat.random(min: self-f, max: self+f)
    }
    func         random01        (factor: CGFloat) -> CGFloat                   {
        let f = self * factor
        return CGFloat.random(min: self-f, max: self+f).clamped01
    }
    func         random          (_ ball: CGFloat) -> CGFloat                   { CGFloat.random(min: self-ball, max: self+ball) }
    func         random01        (_ ball: CGFloat) -> CGFloat                   { CGFloat.random(min: self-ball, max: self+ball).clamped01 }
    
    var          clamped01       : CGFloat                                      { Swift.max(.zero,Swift.min(.one,self)) }
    func         clamped         (_ min: Self, _ max: CGFloat) -> CGFloat       { Swift.max(min,Swift.min(max,self)) }

    static let   zero            : CGFloat   = 0
    static let   one             : CGFloat   = 1
}

extension CGFloat {
    
    public init?(_ string:String) {
        if let n = NumberFormatter().number(from: string) {
            self.init(truncating: n)
        }
        else {
            return nil
        }
    }
    
}

public extension CGFloat {
    
    var asDouble : Double { Double(self) }
    var asInt : Int { Int(self) }
    var asFloat : Float { Float(self) }
    
}

public extension CGFloat {
    
    static let degreesToRadians     : CGFloat       = CGFloat.pi / 180.asCGFloat
    static let radiansToDegrees     : CGFloat       = 180.asCGFloat / CGFloat.pi
    static let d2r                  : CGFloat       = CGFloat.pi / 180.asCGFloat
    static let r2d                  : CGFloat       = 180.asCGFloat / CGFloat.pi

}

