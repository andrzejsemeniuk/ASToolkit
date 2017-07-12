//
//  ASToolkitExtension+CGFloat.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension CGFloat
{
    public func clamp(_ minimum:CGFloat,_ maximum:CGFloat) -> CGFloat {
        return self < maximum ? (minimum < self ? self : minimum) : maximum
    }
    public func clamp01() -> CGFloat {
        return clamp(0,1)
    }
    public func clamp0255() -> CGFloat {
        return clamp(0,255)
    }
    public func lerp(_ from:CGFloat, _ to:CGFloat) -> CGFloat {
        return (1.0-self)*from + self*to
        //        return from + (to - from) * self
    }
    public static func lerp(_ from:CGFloat, _ to:CGFloat, _ with:CGFloat) -> CGFloat {
        return with.lerp(from,to)
    }
    public func lerp01(_ from:CGFloat, _ to:CGFloat) -> CGFloat {
        return CGFloat(Float(self.lerp(from,to)).clamp01())
    }
    public static func lerp01(_ from:CGFloat, _ to:CGFloat, _ with:CGFloat) -> CGFloat {
        return with.lerp01(from,to)
    }
}

extension CGFloat {
    
    public static var randomSign:CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    public static var random:CGFloat {
        get {
            return CGFloat(Float.random)
        }
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

