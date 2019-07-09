//
//  ExtensionForSwiftFloat.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Float
{
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
    
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
    
}






