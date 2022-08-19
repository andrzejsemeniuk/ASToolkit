//
//  ExtensionForUIKitUIColor.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit

public typealias UIColor = NSColor
#endif

public struct RGBAValues : Codable, Equatable {
    init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(r red: Double, g green: Double, b blue: Double, a alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(_ red: Double, _ green: Double, _ blue: Double, _ alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(_ array: [Double], fallback: Double = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }

    init(_ array: [CGFloat], fallback: CGFloat = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }
    
 
    var red     : Double
    var green   : Double
    var blue    : Double
    var alpha   : Double
    
    enum CodingKeys : String, CodingKey {
        case red        = "r"
        case green      = "g"
        case blue       = "b"
        case alpha      = "a"
    }
    

    var r : Double { get { red } set { red = newValue }}
    var g : Double { get { green } set { green = newValue }}
    var b : Double { get { blue } set { blue = newValue }}
    var a : Double { get { alpha } set { alpha = newValue }}
    
    var arrayOfRGB      : [Double] { [r,g,b] }
    var arrayOfRGBA     : [Double] { [r,g,b,a] }

    var asStringOfRGB     : String { arrayOfRGB.map { $0.format4 }.joinedByComma }
    var asStringOfRGBA    : String { arrayOfRGBA.map { $0.format4 }.joinedByComma }
    
    func with(r: Double? = nil, g: Double? = nil, b: Double? = nil, a: Double? = nil) -> Self {
        .init(r: r ?? self.r, g: g ?? self.g, b: b ?? self.b, a: a ?? self.a)
    }

    static let black    : Self = .init(0,0,0,1)
    static let red      : Self = .init(1,0,0,1)
    static let white    : Self = .init(1,1,1,1)
}

public struct HSBAValues : Codable, Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSBA == rhs.asStringOfHSBA
    }
    
    public static func equalHSBA(lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSBA == rhs.asStringOfHSBA
    }
    
    public static func equalHSB(lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSB == rhs.asStringOfHSB
    }
    
    init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    init(h hue: Double, s saturation: Double, b brightness: Double, a alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    init(_ hue: Double, _ saturation: Double, _ brightness: Double, _ alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    init(_ array: [Double], fallback: Double = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }

    init(_ array: [CGFloat], fallback: CGFloat = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }
    
    init(_ string: String) {
        self.init(string.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, upto: 4))
    }
    
    var hue         : Double
    var saturation  : Double
    var brightness  : Double
    var alpha       : Double
    
    enum CodingKeys : String, CodingKey {
        case hue        = "h"
        case saturation = "s"
        case brightness = "b"
        case alpha      = "a"
    }
    
    var h : Double { get { hue } set { hue = newValue }}
    var s : Double { get { saturation } set { saturation = newValue }}
    var b : Double { get { brightness } set { brightness = newValue }}
    var a : Double { get { alpha } set { alpha = newValue }}
    
    var arrayOfHSB                  : [Double] { [h,s,b] }
    var arrayOfHSBA                 : [Double] { [h,s,b,a] }
    
    var asStringOfHSB               : String { arrayOfHSB.map { $0.format4 }.joinedByComma }
    var asStringOfHSBA              : String { arrayOfHSBA.map { $0.format4 }.joinedByComma }

    var asDescriptiveStringOfHSB    : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)" }
    var asDescriptiveStringOfHSBA   : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)  A \(a.format4)" }

    func with(h: Double? = nil, s: Double? = nil, b: Double? = nil, a: Double? = nil) -> Self {
        .init(h: h ?? self.h, s: s ?? self.s, b: b ?? self.b, a: a ?? self.a)
    }
    
    static let black    : Self = .init(0,0,0,1)
    static let red      : Self = .init(0,1,1,1)
    static let yellow   : Self = .init(0.13,1,1,1)
    static let white    : Self = .init(0,0,1,1)
    
    static func generate(count: Int, from: HSBAValues, to: HSBAValues) -> [HSBAValues] {
        let divisor : Double = count.asDouble
        let delta = HSBAValues.init(h: (to.h - from.h)/divisor, s: (to.s - from.s)/divisor, b: (to.b - from.b)/divisor, a: (to.a - from.a)/divisor)
        var from = from
        var r : [HSBAValues] = []
        count.loop {
            r.append(from)
            from.h += delta.h
            from.s += delta.s
            from.b += delta.b
            from.a += delta.a
        }
        return r
    }
    
    static func generate(count: Int, h0: CGFloat, h1: CGFloat? = nil, s0: CGFloat, s1: CGFloat? = nil, b0: CGFloat, b1: CGFloat? = nil, a0: CGFloat = 1, a1: CGFloat? = nil) -> [HSBAValues] {
        generate(count: count, from: .init(h: h0, s: s0, b: b0, a: a0), to: .init(h: h1 ?? h0, s: s1 ?? s0, b: b1 ?? b0, a: a1 ?? a0))
    }
    
    static func generate(count: Int, h: CGFloat, H: CGFloat? = nil, s: CGFloat = 1, S: CGFloat? = nil, b: CGFloat = 1, B: CGFloat? = nil, a: CGFloat = 1, A: CGFloat? = nil) -> [HSBAValues] {
        generate(count: count, from: .init(h: h, s: s, b: b, a: a), to: .init(h: H ?? h, s: S ?? s, b: B ?? b, a: A ?? a))
    }
    
    static func paletteCommon(columns count: Int) -> String {
        [
            Self.generate(count: count, h: 0, s: 0, b: 0, B: 1),
            Self.generate(count: count, hues: [0,0.08,0.11,0.12,0.13,0.24,0.3,0.45,0.5,0.55,0.62,0.7,0.8,0.9], s: 1, S: 0.3, b: 1),
        ].asPalette
    }
            
    static func generate(count: Int, hues: [CGFloat], s: CGFloat, S: CGFloat? = nil, b: CGFloat, B: CGFloat? = nil) -> [HSBAValues] {
        hues.map { Self.generate(count: count, h: $0, H: nil, s: s, S: S, b: b, B: B, a: 1, A: nil) }.reduce([], { $0 + $1 })
    }
            
//    static func palette(columns count: Int, h: CGFloat, s: CGFloat, S: CGFloat, b: CGFloat) -> String {
//        hues.map { Self.generate(count: count, h: h, H: nil, s: s, S: S, b: b, B: nil, a: 1, A: nil) }.reduce([], { $0 + $1 }).asPalette
//    }
            
    struct Palette : Codable {
        var entries : [HSBAValues] = []
        
        var asArrayOfString : [String] {
            entries.map { $0.asStringOfHSBA }
        }

        var asString : String {
            asArrayOfString.joined(separator: "|")
        }
        
        var asArrayOfDoubleTuples : [[Double]] {
            asArrayOfString.map { tuple in
                tuple.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, upto: 4)
            }
        }
        
        static func create(from string: String) -> Self {
            .init(entries: string.asArrayOfHSBAValues)
        }
    }
    
}

extension Array where Element == HSBAValues {
    var asPalette : String {
        isEmpty ? "" : self.map {
            $0.asStringOfHSBA
        }.joined(separator: "|")
    }
}

extension Array where Element == [HSBAValues] {
    var asPalette : String {
        flatMap { $0 }.asPalette
    }
}

extension String {
    var asArrayOfHSBAValues : [HSBAValues] {
        isEmpty ? [] : split("|").map { tuple in
            HSBAValues.init(tuple.split(",").map { Double($0) ?? 1.0 })
        }
    }
}

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



	public typealias WATuple = (white: CGFloat, alpha: CGFloat)

	public var WA : WATuple {
		let RGBA = self.RGBA
		return (white: (RGBA.red + RGBA.green + RGBA.blue) / 3.0, alpha: RGBA.alpha)
	}

	public var arrayOfWA : [CGFloat] {
		let WA = self.WA
		return [WA.white, WA.alpha]
	}

//	public var white : CGFloat { return WA.white }
//	public var alpha : CGFloat { return WA.alpha }



    
    public var RGBA : RGBAValues {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
//        NSColor(self).usingColorSpace(.deviceRGB)!
        #if os(macOS)
        self.usingColorSpace(.deviceRGB)!.getRed(&r,green:&g,blue:&b,alpha:&a)
        #endif
        #if os(iOS)
        self.getRed(&r,green:&g,blue:&b,alpha:&a)
        #endif
        
        return .init(r,g,b,a)
    }

    public var arrayOfRGBA : [CGFloat] {
        let v = RGBA
        return [v.red, v.green, v.blue, v.alpha]
    }

    public convenience init(RGBA:RGBAValues) {
        self.init(red:RGBA.red, green:RGBA.green, blue:RGBA.blue, alpha:RGBA.alpha)
    }
    
    
    
    public var HSBA : HSBAValues {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
#if os(macOS)
        self.usingColorSpace(.deviceRGB)!.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
#endif
#if os(iOS)
        self.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
#endif
        
        return .init(h,s,b,a)
    }
    
    public var arrayOfHSBA : [CGFloat] {
        let v = HSBA
        return [v.hue, v.saturation, v.brightness, v.alpha]
    }
    
    public convenience init(HSBA:HSBAValues) {
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
    
    static public func generateListOfDefaultColors() -> [UIColor]
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
    
    
    
    static public func generateMatrixOfColors(columns    : Int = 7,
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
    
    public convenience init?(RGBA:String) {
//        print(RGBA)
        
        guard 8 <= RGBA.length else {
            return nil
        }
        
        let R = RGBA.substring(from: 0, to: 2)
        let G = RGBA.substring(from: 2, to: 4)
        let B = RGBA.substring(from: 4, to: 6)
        let A = RGBA.substring(from: 6, to: 8)
        
        guard
            let R256 = UInt8(R,radix:16),
            let G256 = UInt8(G,radix:16),
            let B256 = UInt8(B,radix:16),
            let A256 = UInt8(A,radix:16)
            else {
                return nil
        }
        
        let rgba : [CGFloat] = [
            CGFloat(R256)/255,
            CGFloat(G256)/255,
            CGFloat(B256)/255,
            CGFloat(A256)/255
        ]
        
        self.init(rgba:rgba)
        
//        print([R,G,B,A])
//        print([R256,G256,B256,A256])
//        print(rgba)
//        print(self.representationOfRGBAasHexadecimal)
        
    }
}


extension UIColor {
    
    open func withHue(_ value:CGFloat) -> UIColor {
        var HSBA = self.HSBA
        HSBA.hue = value
        return UIColor(HSBA:HSBA)
    }
    
    open func withSaturation(_ value:CGFloat) -> UIColor {
        var HSBA = self.HSBA
        HSBA.saturation = value
        return UIColor(HSBA:HSBA)
    }
    
    open func withBrightness(_ value:CGFloat) -> UIColor {
        var HSBA = self.HSBA
        HSBA.brightness = value
        return UIColor(HSBA:HSBA)
    }
    
    open func withRed(_ value:CGFloat) -> UIColor {
        var RGBA = self.RGBA
        RGBA.red = value
        return UIColor(RGBA:RGBA)
    }
    
    open func withGreen(_ value:CGFloat) -> UIColor {
        var RGBA = self.RGBA
        RGBA.green = value
        return UIColor(RGBA:RGBA)
    }
    
    open func withBlue(_ value:CGFloat) -> UIColor {
        var RGBA = self.RGBA
        RGBA.blue = value
        return UIColor(RGBA:RGBA)
    }
    
    open func withCyan(_ value:CGFloat) -> UIColor {
        var CMYKA = self.CMYKA
        CMYKA.cyan = value
        return UIColor(CMYKA:CMYKA)
    }
    
    open func withMagenta(_ value:CGFloat) -> UIColor {
        var CMYKA = self.CMYKA
        CMYKA.magenta = value
        return UIColor(CMYKA:CMYKA)
    }
    
    open func withYellow(_ value:CGFloat) -> UIColor {
        var CMYKA = self.CMYKA
        CMYKA.yellow = value
        return UIColor(CMYKA:CMYKA)
    }
    
    open func withKey(_ value:CGFloat) -> UIColor {
        var CMYKA = self.CMYKA
        CMYKA.key = value
        return UIColor(CMYKA:CMYKA)
    }
    

}



extension UIColor {
    
    open class var aqua     : UIColor { return UIColor(hsb:[0.51,1,1]) }
    
    open class var pink     : UIColor { return UIColor(rgb:[1,0.80,0.90]) }
    
}


