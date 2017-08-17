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
        self.init(white:white, alpha:1)
    }
    
    public convenience init(gray:CGFloat,alpha:CGFloat = 1) {
        self.init(red:gray, green:gray, blue:gray, alpha:alpha)
    }
    
    public convenience init(red:CGFloat,green:CGFloat,blue:CGFloat) {
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    public convenience init(hue:CGFloat,saturation:CGFloat = 1,brightness:CGFloat = 1) {
        self.init(hue:hue, saturation:saturation, brightness:brightness, alpha:1)
    }
    
    public convenience init(hsb:[CGFloat],alpha:CGFloat = 1) {
        self.init(hue:hsb[0], saturation:hsb[1], brightness:hsb[2], alpha:alpha)
    }
    
    public convenience init(hsba:[CGFloat]) {
        self.init(hue:hsba[0], saturation:hsba[1], brightness:hsba[2], alpha:hsba[3])
    }
    
    public convenience init(rgb:[CGFloat],alpha:CGFloat = 1) {
        self.init(red:rgb[0], green:rgb[1], blue:rgb[2], alpha:alpha)
    }
    
    public convenience init(rgba:[CGFloat]) {
        self.init(red:rgba[0], green:rgba[1], blue:rgba[2], alpha:rgba[3])
    }
    
    public convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(red:r, green:g, blue:b, alpha:a)
    }
    
    public convenience init(h:CGFloat,s:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(hue:h, saturation:s, brightness:b, alpha:a)
    }
    
    
    public func components_RGBA_UInt8() -> (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8) {
        let components        = RGBA
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
    
    
    public typealias RGBATuple = (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat)
    
    public var RGBA : RGBATuple {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getRed(&r,green:&g,blue:&b,alpha:&a)
        
        return (r,g,b,a)
    }

    public var arrayOfRGBA : [CGFloat] {
        let v = RGBA
        return [v.red, v.green, v.blue, v.alpha]
    }

    public convenience init(RGBA:RGBATuple) {
        self.init(red:RGBA.red, green:RGBA.green, blue:RGBA.blue, alpha:RGBA.alpha)
    }
    
    
    public typealias HSBATuple = (hue:CGFloat,saturation:CGFloat,brightness:CGFloat,alpha:CGFloat)
    
    public var HSBA : HSBATuple {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
        
        return (h,s,b,a)
    }
    
    public var arrayOfHSBA : [CGFloat] {
        let v = HSBA
        return [v.hue, v.saturation, v.brightness, v.alpha]
    }
    
    public convenience init(HSBA:HSBATuple) {
        self.init(hue:HSBA.hue, saturation:HSBA.saturation, brightness:HSBA.brightness, alpha:HSBA.alpha)
    }
    

    public var red          :CGFloat    { return RGBA.red }
    public var green        :CGFloat    { return RGBA.green }
    public var blue         :CGFloat    { return RGBA.blue }
    public var alpha        :CGFloat    { return RGBA.alpha }
    
    public var hue          :CGFloat    { return HSBA.hue }
    public var saturation   :CGFloat    { return HSBA.saturation }
    public var brightness   :CGFloat    { return HSBA.brightness }
    
    open class func GRAY(_ v:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(white:CGFloat(v),alpha:CGFloat(a))
    }
    
    open class func RGBA(_ r:Float, _ g:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(red:CGFloat(r),green:CGFloat(g),blue:CGFloat(b),alpha:CGFloat(a))
    }
    
    open class func HSBA(_ h:Float, _ s:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(hue:CGFloat(h),saturation:CGFloat(s),brightness:CGFloat(b),alpha:CGFloat(a))
    }
    
    open func multiply     (byRatio ratio:CGFloat) -> UIColor {
        let RGBA = self.RGBA
        return UIColor(red      : CGFloat(ratio * RGBA.red).clampedTo01,
                       green    : CGFloat(ratio * RGBA.green).clampedTo01,
                       blue     : CGFloat(ratio * RGBA.blue).clampedTo01,
                       alpha    : RGBA.alpha)
    }
    
    open func higher        (byRatio ratio:CGFloat) -> UIColor {
        let RGBA = self.RGBA
        return UIColor(red      : CGFloat(RGBA.red + (1.0 - RGBA.red) * ratio).clampedTo01,
                       green    : CGFloat(RGBA.green + (1.0 - RGBA.green) * ratio).clampedTo01,
                       blue     : CGFloat(RGBA.blue + (1.0 - RGBA.blue) * ratio).clampedTo01,
                       alpha    : RGBA.alpha)
    }
    
    open func lower         (byRatio ratio:CGFloat) -> UIColor {
        let RGBA = self.RGBA
        return UIColor(red      : CGFloat(RGBA.red - RGBA.red * ratio).clampedTo01,
                       green    : CGFloat(RGBA.green - RGBA.green * ratio).clampedTo01,
                       blue     : CGFloat(RGBA.blue - RGBA.blue * ratio).clampedTo01,
                       alpha    : RGBA.alpha)
    }
    
}

extension UIColor {
    
    open class var aqua: UIColor { return UIColor(hsb:[0.51,1,1]) }
    
}


extension UIColor {
    // let colorSpaceCMYK = CGColorSpaceCreateDeviceCMYK()
    
    public typealias CMYKTuple  = (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat)
    public typealias CMYKATuple = (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat, alpha: CGFloat)
    
    public var CMYK:CMYKTuple {
        
        
//        function rgb2cmyk (r,g,b) {
//            var computedC = 0;
//            var computedM = 0;
//            var computedY = 0;
//            var computedK = 0;
//            
//            //remove spaces from input RGB values, convert to int
//            var r = parseInt( (''+r).replace(/\s/g,''),10 );
//            var g = parseInt( (''+g).replace(/\s/g,''),10 );
//            var b = parseInt( (''+b).replace(/\s/g,''),10 );
//            
//            if ( r==null || g==null || b==null ||
//                isNaN(r) || isNaN(g)|| isNaN(b) )
//            {
//                alert ('Please enter numeric RGB values!');
//                return;
//            }
//            if (r<0 || g<0 || b<0 || r>255 || g>255 || b>255) {
//                alert ('RGB values must be in the range 0 to 255.');
//                return;
//            }
//            
//            // BLACK
//            if (r==0 && g==0 && b==0) {
//                computedK = 1;
//                return [0,0,0,1];
//            }
//            

        let RGB = self.RGBA
        
        if RGB.red < 0.001 && RGB.green < 0.001 && RGB.blue < 0.001 {
            return (0,0,0,1)
        }
        
//            computedC = 1 - (r/255);
//            computedM = 1 - (g/255);
//            computedY = 1 - (b/255);
        
        let computedC = 1 - RGB.red.clampedTo01
        let computedM = 1 - RGB.green.clampedTo01
        let computedY = 1 - RGB.blue.clampedTo01
//            
//            var minCMY = Math.min(computedC,
//                                  Math.min(computedM,computedY));
        
        let minCMY          : CGFloat = min(computedC, computedM, computedY)
        
//            computedC = (computedC - minCMY) / (1 - minCMY) ;
//            computedM = (computedM - minCMY) / (1 - minCMY) ;
//            computedY = (computedY - minCMY) / (1 - minCMY) ;
//            computedK = minCMY;
//            
//            return [computedC,computedM,computedY,computedK];
//        }
        
        let denominator     : CGFloat = 1 - minCMY
        
        return (
            (computedC - minCMY) / denominator,
            (computedM - minCMY) / denominator,
            (computedY - minCMY) / denominator,
            minCMY
        )
    }
    
    public var CMYKA : CMYKATuple {
        let CMYK = self.CMYK
        return (CMYK.cyan, CMYK.magenta, CMYK.yellow, CMYK.key, alpha)
    }
    
    public convenience init(cyan:CGFloat, magenta:CGFloat, yellow:CGFloat, key:CGFloat, alpha:CGFloat = 1) {
        
//        unsigned char r = (unsigned char)(255 * (1 - cmyk.C) * (1 - cmyk.K));
//        unsigned char g = (unsigned char)(255 * (1 - cmyk.M) * (1 - cmyk.K));
//        unsigned char b = (unsigned char)(255 * (1 - cmyk.Y) * (1 - cmyk.K));

        let multiplier      : CGFloat = 1.0 - key.clampedTo01
        
        self.init(
            r: (1.0 - cyan.clampedTo01) * multiplier,
            g: (1.0 - magenta.clampedTo01) * multiplier,
            b: (1.0 - yellow.clampedTo01) * multiplier,
            a: alpha
        )
    }
    
    public convenience init(c:CGFloat, m:CGFloat, y:CGFloat, k:CGFloat, a:CGFloat = 1) {
        self.init(cyan:c, magenta:m, yellow:y, key:k, alpha:a)
    }
    
    public convenience init(cmyk:[CGFloat]) {
        self.init(cyan:cmyk[0], magenta:cmyk[1], yellow:cmyk[2], key:cmyk[3])
    }
    
    public convenience init(cmyka:[CGFloat]) {
        self.init(cyan:cmyka[0], magenta:cmyka[1], yellow:cmyka[2], key:cmyka[3], alpha:cmyka[4])
    }
    
    public convenience init(CMYK:CMYKTuple, alpha:CGFloat = 1) {
        self.init(cyan:CMYK.cyan, magenta:CMYK.magenta, yellow:CMYK.yellow, key:CMYK.key, alpha:alpha)
    }
    
    public convenience init(CMYKA:CMYKATuple) {
        self.init(cyan:CMYKA.cyan, magenta:CMYKA.magenta, yellow:CMYKA.yellow, key:CMYKA.key, alpha:CMYKA.alpha)
    }
    
}
