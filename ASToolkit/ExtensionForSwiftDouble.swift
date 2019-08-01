//
//  ExtensionForSwiftDouble.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Double
{
    public var clampedTo01         : Double {
        return clamped(minimum:0, maximum:1)
    }
    public var clampedTo0255       : Double {
        return clamped(minimum:0, maximum:255)
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
    
    public static var random:Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }

	@discardableResult public mutating func assign(max v:Double) -> Double {
		self = Swift.max(self,v)
		return self
	}

	@discardableResult public mutating func assign(min v:Double) -> Double {
		self = Swift.min(self,v)
		return self
	}
    
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
