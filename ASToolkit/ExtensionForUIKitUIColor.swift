//
//  ExtensionForUIKitUIColor.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    public convenience init(white:CGFloat) {
        self.init(white:white,alpha:1)
    }
    
    public convenience init(gray:CGFloat,alpha:CGFloat = 1) {
        self.init(red:gray,green:gray,blue:gray,alpha:alpha)
    }
    
    public convenience init(red:CGFloat,green:CGFloat,blue:CGFloat) {
        self.init(red:red,green:green,blue:blue,alpha:1)
    }
    
    public convenience init(hue:CGFloat,saturation:CGFloat = 1,brightness:CGFloat = 1) {
        self.init(hue:hue,saturation:saturation,brightness:brightness,alpha:1)
    }
    
    public convenience init(hsb:[CGFloat],alpha:CGFloat = 1) {
        self.init(hue:hsb[0],saturation:hsb[1],brightness:hsb[2],alpha:alpha)
    }
    
    public convenience init(hsba:[CGFloat]) {
        self.init(hue:hsba[0],saturation:hsba[1],brightness:hsba[2],alpha:hsba[3])
    }
    
    public convenience init(rgb:[CGFloat],alpha:CGFloat = 1) {
        self.init(red:rgb[0],green:rgb[1],blue:rgb[2],alpha:alpha)
    }
    
    public convenience init(rgba:[CGFloat]) {
        self.init(red:rgba[0],green:rgba[1],blue:rgba[2],alpha:rgba[3])
    }
    
    public func components_RGBA_UInt8() -> (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8) {
        let components      = RGBA()
        let maximum:CGFloat   = 256
        
        let r = Float(components.red*maximum).clampedTo0255
        let g = Float(components.green*maximum).clampedTo0255
        let b = Float(components.blue*maximum).clampedTo0255
        let a = Float(components.alpha*maximum).clampedTo0255
        
        let result = (
            UInt8(r),
            UInt8(g),
            UInt8(b),
            UInt8(a)
        )
        
        return result
    }
    
    public func components_RGBA_UInt8_equals(_ another:UIColor) -> Bool {
        let a = components_RGBA_UInt8()
        let b = another.components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue && a.alpha==b.alpha
    }
    
    public func components_RGB_UInt8_equals(_ another:UIColor) -> Bool {
        let a = components_RGBA_UInt8()
        let b = another.components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue
    }
    
    public func RGBA() -> (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getRed(&r,green:&g,blue:&b,alpha:&a)
        
        return (r,g,b,a)
    }
    
    public func HSBA() -> (hue:CGFloat,saturation:CGFloat,brightness:CGFloat,alpha:CGFloat) {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
        
        return (h,s,b,a)
    }
    
    public var red          :CGFloat    { return RGBA().red }
    public var green        :CGFloat    { return RGBA().green }
    public var blue         :CGFloat    { return RGBA().blue }
    public var alpha        :CGFloat    { return RGBA().alpha }
    
    public var hue          :CGFloat    { return HSBA().hue }
    public var saturation   :CGFloat    { return HSBA().saturation }
    public var brightness   :CGFloat    { return HSBA().brightness }
    
    public class func GRAY(_ v:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(white:CGFloat(v),alpha:CGFloat(a))
    }
    
    public class func RGBA(_ r:Float, _ g:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(red:CGFloat(r),green:CGFloat(g),blue:CGFloat(b),alpha:CGFloat(a))
    }
    
    public class func HSBA(_ h:Float, _ s:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(hue:CGFloat(h),saturation:CGFloat(s),brightness:CGFloat(b),alpha:CGFloat(a))
    }
    
}

extension UIColor {
    
    public convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(red:r,green:g,blue:b,alpha:a)
    }
    
}
