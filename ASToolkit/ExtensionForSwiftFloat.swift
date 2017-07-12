//
//  ASToolkitExtension+Float.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Float
{
    public func clamp(_ minimum:Float,_ maximum:Float) -> Float {
        return self < maximum ? (minimum < self ? self : minimum) : maximum
    }
    public func clamp01() -> Float {
        return clamp(0,1)
    }
    public func clamp0255() -> Float {
        return clamp(0,255)
    }
    public func lerp(_ from:Float, _ to:Float) -> Float {
        return (1.0-self)*from + self*to
        //        return from + (to - from) * self
    }
    public static func lerp(_ from:Float, _ to:Float, _ with:Float) -> Float {
        return with.lerp(from,to)
    }
    public func lerp01(_ from:Float, _ to:Float) -> Float {
        return min(1.0,max(0.0,self.lerp(from,to)))
    }
    public static func lerp01(_ from:Float, _ to:Float, _ with:Float) -> Float {
        return with.lerp01(from,to)
    }
}

extension Float {
    
    public static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
    
}
