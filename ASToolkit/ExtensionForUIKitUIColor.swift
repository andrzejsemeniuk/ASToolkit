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
        self.init(hue:hsb[safe:0] ?? 0, saturation:hsb[safe:1] ?? 0, brightness:hsb[safe:2] ?? 0, alpha:alpha)
    }
    
    public convenience init(hsba:[CGFloat]) {
        self.init(hue:hsba[safe:0] ?? 0, saturation:hsba[safe:1] ?? 0, brightness:hsba[safe:2] ?? 0, alpha:hsba[safe:3] ?? 0)
    }
    
    public convenience init(rgb:[CGFloat],alpha:CGFloat = 1) {
        self.init(red:rgb[safe:0] ?? 0, green:rgb[safe:1] ?? 0, blue:rgb[safe:2] ?? 0, alpha:alpha)
    }
    
    public convenience init(rgba:[CGFloat]) {
        self.init(red:rgba[safe:0] ?? 0, green:rgba[safe:1] ?? 0, blue:rgba[safe:2] ?? 0, alpha:rgba[safe:3] ?? 0)
    }
    
    public convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(red:r, green:g, blue:b, alpha:a)
    }
    
    public convenience init(h:CGFloat,s:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(hue:h, saturation:s, brightness:b, alpha:a)
    }
    
    public typealias Components_RGBA_UInt8 = (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8)
    public func components_RGBA_UInt8() -> Components_RGBA_UInt8 {
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
    
    public func components_RGBA_UInt8_equals(_ b:Components_RGBA_UInt8) -> Bool {
        let a = components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue && a.alpha==b.alpha
    }
    
    public func components_RGBA_UInt8_equals(_ another:UIColor) -> Bool {
        return components_RGBA_UInt8_equals(another.components_RGBA_UInt8())
    }
    
    public func components_RGB_UInt8_equals(_ b:Components_RGBA_UInt8) -> Bool {
        let a = components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue
    }
    
    public func components_RGB_UInt8_equals(_ another:UIColor) -> Bool {
        return components_RGB_UInt8_equals(another.components_RGBA_UInt8())
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
    

    public var RGBAred          :CGFloat    { return RGBA.red }
    public var RGBAgreen        :CGFloat    { return RGBA.green }
    public var RGBAblue         :CGFloat    { return RGBA.blue }
    public var RGBAalpha        :CGFloat    { return RGBA.alpha }
    
    public var HSBAhue          :CGFloat    { return HSBA.hue }
    public var HSBAsaturation   :CGFloat    { return HSBA.saturation }
    public var HSBAbrightness   :CGFloat    { return HSBA.brightness }
    
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
    
    public typealias CMYKTuple  = (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat)
    public typealias CMYKATuple = (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat, alpha: CGFloat)
    
    public var CMYK:CMYKTuple {
        
        // r = (1-c)(1-k) ??
        // c = 1-r/(1-k) ??
        
        let RGB = self.RGBA
        
        if RGB.red < 0.001 && RGB.green < 0.001 && RGB.blue < 0.001 {
            return (0,0,0,1)
        }
        
        let computedC = 1 - RGB.red.clampedTo01
        let computedM = 1 - RGB.green.clampedTo01
        let computedY = 1 - RGB.blue.clampedTo01
        
        let minCMY          : CGFloat = min(computedC, computedM, computedY)
        
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
        return (CMYK.cyan, CMYK.magenta, CMYK.yellow, CMYK.key, RGBAalpha)
    }
    
    public convenience init(cyan:CGFloat, magenta:CGFloat, yellow:CGFloat, key:CGFloat, alpha:CGFloat = 1) {
        
        // r = (1 - c) * (1 - k)
        
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

extension UIColor {
    
    static open func generateListOfDefaultColors() -> [UIColor]
    {

        var colors = [
            UIColor.GRAY(1.00,1),
            UIColor.GRAY(0.90,1),
            UIColor.GRAY(0.80,1),
            UIColor.GRAY(0.70,1),
            UIColor.GRAY(0.60,1),
            UIColor.GRAY(0.50,1),
            UIColor.GRAY(0.40,1),
            UIColor.GRAY(0.30,1),
            UIColor.GRAY(0.20,1),
            UIColor.GRAY(0.10,1),
            UIColor.GRAY(0.00,1),
            ]
        
        let hues        : [Float]   = [0,0.06,0.1,0.14,0.2,0.3,0.4,0.53,0.6,0.7,0.8,0.9]
        let saturations : [Float]   = [0.4,0.6,0.8,1]
        let values      : [Float]   = [1]
        
        for h in hues {
            for v in values {
                for s in saturations {
                    colors.append(UIColor.HSBA(h,s,v,1))
                }
            }
        }
        
        return colors
    }
    
    
    
    static open func generateMatrixOfColors(columns    : Int = 7,
                                            rowsOfGray : Int = 2,
                                            rowsOfHues : Int = 20) -> [[UIColor]]
    {
        var delta:Double
        
        var colors:[[UIColor]] = []
        
        if 0 < rowsOfGray {
            delta = 1.0/Double(columns * rowsOfGray - 1)
            colors = stride(from:1.0,to:delta-0.001,by:-delta).asArray.asArrayOfCGFloat.map { UIColor(white:$0) }.appended(.black).split(by:columns)
        }
        
        if 0 < rowsOfHues {
            delta = 1.0/Double(rowsOfHues)
            let hues        : [Float]   = stride(from:0.0,to:1.0001-delta,by:delta).asArray.asArrayOfFloat
            
            delta = 1.0/Double(columns+1)
            let saturations : [Float]   = stride(from:delta,to:1.0,by:delta).asArray.asArrayOfFloat
            
            let values      : [Float]   = [1]
            
            for h in hues {
                var row:[UIColor] = []
                for v in values {
                    for s in saturations {
                        row.append(UIColor.HSBA(h,s,v,1))
                    }
                }
                colors.append(row)
            }
        }
        
        return colors
    }

    
}


extension UIColor {

    open var descriptionAsRGB : String {
        let v = RGBA
        return "UIColor(rgb:[\(v.red),\(v.green),\(v.blue)])"
    }
    
    open var descriptionAsRGBA : String {
        let v = RGBA
        return "UIColor(rgba:[\(v.red),\(v.green),\(v.blue),\(v.alpha)])"
    }
    
    open var descriptionAsHSB : String {
        let v = HSBA
        return "UIColor(hsb:[\(v.hue),\(v.saturation),\(v.brightness)])"
    }
    
    open var descriptionAsHSBA : String {
        let v = HSBA
        return "UIColor(hsba:[\(v.hue),\(v.saturation),\(v.brightness),\(v.alpha)])"
    }

    open var representationOfRGBAasHexadecimal : [String] {
        let v = components_RGBA_UInt8()
        return [
            String(format:"%02X",v.red),
            String(format:"%02X",v.green),
            String(format:"%02X",v.blue),
            String(format:"%02X",v.alpha),
        ]
//        return String(format:"0x%02X%02X%02X%02X", v.red, v.green, v.blue, v.alpha)
    }
}



extension UIColor {
    
    open class var aqua     : UIColor { return UIColor(hsb:[0.51,1,1]) }
    
    open class var pink     : UIColor { return UIColor(rgb:[1,0.80,0.90]) }
    
}


