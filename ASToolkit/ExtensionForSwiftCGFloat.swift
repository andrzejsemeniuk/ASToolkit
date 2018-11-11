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
    public static func lerp         (from:CGFloat, to:CGFloat, with:CGFloat) -> CGFloat {
        return with.lerp(from:from,to:to)
    }
    public func lerp01              (from:CGFloat, to:CGFloat) -> CGFloat {
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

extension CGFloat {
    
    public static var randomSign:CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    public static var random:CGFloat {
        return CGFloat(Float.random)
    }
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
    
}

extension CGFloat {
    
    public init?(_ string:String) {
        if let n = NumberFormatter().number(from: string) {
            self.init(n)
        }
        else {
            return nil
        }
    }
    
}

