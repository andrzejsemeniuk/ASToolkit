//
//  ExtensionForUIKitUIColor.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SwiftUI
import SpriteKit

public struct RGBAInfo : Codable, Equatable {
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(r red: Double, g green: Double, b blue: Double, a alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(_ red: Double, _ green: Double, _ blue: Double, _ alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(gray: Double, alpha: Double = 1) {
        self.red = gray
        self.green = gray
        self.blue = gray
        self.alpha = alpha
    }
    
    public init(g: Double, a: Double = 1) {
        self.init(gray: g, alpha: a)
    }
    
    public init(_ array: [Double], fallback: Double = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }

    public init(_ array: [CGFloat], fallback: CGFloat = 1) {
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
    
    func with(r: Double? = nil, g: Double? = nil, b: Double? = nil, a: Double? = nil) -> Self {
        .init(r: r ?? self.r, g: g ?? self.g, b: b ?? self.b, a: a ?? self.a)
    }

    var arrayOfRGB          : [Double] { [r,g,b] }
    var arrayOfRGBA         : [Double] { [r,g,b,a] }

    var asStringOfRGB       : String { arrayOfRGB.map { $0.format4 }.joinedByComma }
    var asStringOfRGBA      : String { arrayOfRGBA.map { $0.format4 }.joinedByComma }
    
    var asSKColor           : SKColor { .init(RGBA: self) }
    var asSwiftUIColor      : SwiftUI.Color { .init(RGBA: arrayOfRGBA) }

    static let black    : Self = .init(0,0,0,1)
    static let red      : Self = .init(1,0,0,1)
    static let white    : Self = .init(1,1,1,1)
}












public struct HSBAInfo : Codable, Equatable, Hashable, Comparable {
    
    public static func < (lhs: HSBAInfo, rhs: HSBAInfo) -> Bool {
        comparing4((lhs.h,rhs.h),(lhs.s,rhs.s),(lhs.b,rhs.b),(lhs.a,rhs.a))
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSBA == rhs.asStringOfHSBA
    }
    
    public static func equalHSBA(lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSBA == rhs.asStringOfHSBA
    }
    
    public static func equalHSB(lhs: Self, rhs: Self) -> Bool {
        lhs.asStringOfHSB == rhs.asStringOfHSB
    }
    
    
    
    public static func compareByH(lhs: Self, rhs: Self, up: Bool) -> Bool { up ? lhs.h < rhs.h : rhs.h < lhs.h }
    public static func compareByS(lhs: Self, rhs: Self, up: Bool) -> Bool { up ? lhs.s < rhs.s : rhs.s < lhs.s }
    public static func compareByB(lhs: Self, rhs: Self, up: Bool) -> Bool { up ? lhs.b < rhs.b : rhs.b < lhs.b }
    public static func compareByA(lhs: Self, rhs: Self, up: Bool) -> Bool { up ? lhs.a < rhs.a : rhs.a < lhs.a }
    
    
    
    
    public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    public init(h hue: Double, s saturation: Double, b brightness: Double, a alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    public init(_ hue: Double, _ saturation: Double, _ brightness: Double, _ alpha: Double = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
    
    public init(gray: Double, alpha: Double = 1) {
        self.hue = 0
        self.saturation = 0
        self.brightness = gray
        self.alpha = alpha
    }
    
    public init(g: Double, a: Double = 1) {
        self.hue = 0
        self.saturation = 0
        self.brightness = g
        self.alpha = a
    }
    
    public init(_ array: [Double], fallback: Double = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }

    public init(_ array: [CGFloat], fallback: CGFloat = 1) {
        self.init(array[safe: 0] ?? fallback, array[safe: 1] ?? fallback, array[safe: 2] ?? fallback, array[safe: 3] ?? fallback)
    }
    
    public init(_ string: String) {
        self.init(string.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, till: 4))
    }
    
    public init(_ string: String, alpha: Double) {
        self.init(string.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, till: 4).replaced(alpha, at: 3))
    }
    
    public var hue                 : Double
    public var saturation          : Double
    public var brightness          : Double
    public var alpha               : Double
    
    enum CodingKeys : String, CodingKey {
        case hue            = "h"
        case saturation     = "s"
        case brightness     = "b"
        case alpha          = "a"
    }
    
    public var h                   : Double { get { hue } set { hue = newValue }}
    public var s                   : Double { get { saturation } set { saturation = newValue }}
    public var b                   : Double { get { brightness } set { brightness = newValue }}
    public var a                   : Double { get { alpha } set { alpha = newValue }}
    
    public func with(h: Double? = nil, s: Double? = nil, b: Double? = nil, a: Double? = nil) -> Self {
        .init(h: h ?? self.h, s: s ?? self.s, b: b ?? self.b, a: a ?? self.a)
    }

    public var isHSB : Bool { a >= 1 }
    public var asHSB : HSBAInfo { with(a: 1) }
    
    public var isBright : Bool {
        s < 0.4 && b > 0.8
    }
    
    public var asArrayOfHSB                : [Double] { [h,s,b] }
    public var asArrayOfHSBA               : [Double] { [h,s,b,a] }
    
    public var asStringOfHSB               : String { asArrayOfHSB.map { $0.format4 }.joinedByComma }
    public var asStringOfHSBA              : String { asArrayOfHSBA.map { $0.format4 }.joinedByComma }
    
    public func asStringOfHSBA(withAlpha: Bool) -> String {
        withAlpha ? asStringOfHSBA : asStringOfHSB
    }

    public var asDescriptiveStringOfHSB    : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)" }
    public var asDescriptiveStringOfHSBA   : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)  A \(a.format4)" }

    public var asSKColor                   : SKColor { .init(HSBA: self) }
    public var asSwiftUIColor              : SwiftUI.Color { .init(HSBA: asArrayOfHSBA) }

    public func extreme(threshold: Double = 0.5, lowerbound l: Double = 0, upperbound u: Double = 1) -> Self {
        .init(hue < threshold ? l : u, saturation < threshold ? l : u, brightness < threshold ? l : u)
    }
    public func opposite(threshold: Double = 0.5, lowerbound l: Double = 0, upperbound u: Double = 1) -> Self {
        .init(hue < threshold ? u : l, saturation < threshold ? u : l, brightness < threshold ? u : l)
    }
    public func brighter(by delta: Double = 0.1) -> Self {
        .init((hue + delta).clampedTo01, (saturation + delta).clampedTo01, (brightness + delta).clampedTo01)
    }
    public func lighter(by delta: Double = 0.1) -> Self {
        .init((hue - delta).clampedTo01, (saturation - delta).clampedTo01, (brightness - delta).clampedTo01)
    }
    public func inverted(h: Bool = false, s: Bool = false, b: Bool = false, a: Bool = false) -> Self {
        .init(h ? 1 - hue : hue, s ? 1 - saturation : saturation, b ? 1 - brightness : brightness, a ? 1 - alpha : alpha)
    }
    
    public func gradient(to: HSBAInfo, ratio: CGFloat) -> HSBAInfo {
        let from = self
        let ratio = ratio.clampedTo01
        return .init(h: ratio.lerp(from.h, to.h), s: ratio.lerp(from.s, to.s), b: ratio.lerp(from.b, to.b), a: ratio.lerp(from.a, to.a))
    }
    
    public func gradient(to: HSBAInfo, index: Int, count: Int) -> HSBAInfo {
        guard count > 0 else {
            return self
        }
        return gradient(to: to, ratio: index.abs.asCGFloat / count.asCGFloat)
    }
    
    
    public static let black    : Self = .init(0,0,0,1)
    public static let gray     : Self = .init(0,0,0.5,1)
    public static let aqua     : Self = .init(0.50,0.90,1,1)
    public static let red      : Self = .init(0,1,1,1)
    public static let brown    : Self = .init(0.1,1,0.5,1)
    public static let orange   : Self = .init(0.1,1,1,1)
    public static let yellow   : Self = .init(0.13,1,1,1)
    public static let white    : Self = .init(0,0,1,1)
    public static let clear    : Self = .init(1,1,1,0)
    
    public static func generate(count: Int, from: HSBAInfo, to: HSBAInfo) -> [HSBAInfo] {
        let divisor : Double = max(1, count-1).asDouble
        let delta = HSBAInfo.init(h: (to.h - from.h)/divisor, s: (to.s - from.s)/divisor, b: (to.b - from.b)/divisor, a: (to.a - from.a)/divisor)
        var from = from
        var r : [HSBAInfo] = []
        count.loop {
            r.append(from)
            from.h += delta.h
            from.s += delta.s
            from.b += delta.b
            from.a += delta.a
        }
        return r
    }
    
    public static func generate(count: Int, h0: CGFloat, h1: CGFloat? = nil, s0: CGFloat, s1: CGFloat? = nil, b0: CGFloat, b1: CGFloat? = nil, a0: CGFloat = 1, a1: CGFloat? = nil) -> [HSBAInfo] {
        generate(count: count, from: .init(h: h0, s: s0, b: b0, a: a0), to: .init(h: h1 ?? h0, s: s1 ?? s0, b: b1 ?? b0, a: a1 ?? a0))
    }
    
    public static func generate(count: Int, h: CGFloat, H: CGFloat? = nil, s: CGFloat = 1, S: CGFloat? = nil, b: CGFloat = 1, B: CGFloat? = nil, a: CGFloat = 1, A: CGFloat? = nil) -> [HSBAInfo] {
        generate(count: count, from: .init(h: h, s: s, b: b, a: a), to: .init(h: H ?? h, s: S ?? s, b: B ?? b, a: A ?? a))
    }
    
    public static func paletteDefault(columns count: Int) -> Palette {
        [
            Self.generate(grayscale: count),
            Self.generate(pale: count),
            Self.generate(vivid: count),
            Self.generate(dark: count),
        ].asPalette
    }
            
    public static func paletteDefaultFaded(columns count: Int) -> Palette {
        [
            Self.generate(faded: count)
        ].asPalette
    }
            
    public static func paletteDefaultBright(columns count: Int) -> Palette {
        [
            Self.generate(bright: count)
        ].asPalette
    }
            
    public static func paletteDefaultPale(columns count: Int) -> Palette {
        [
            Self.generate(pale: count)
        ].asPalette
    }
            
    public static func paletteDefaultVivid(columns count: Int) -> Palette {
        [
            Self.generate(vivid: count),
        ].asPalette
    }
            
    public static func paletteDefaultDark(columns count: Int) -> Palette {
        [
            Self.generate(dark: count)
        ].asPalette
    }
            
    public static func paletteDefaultGrayscale(columns count: Int) -> Palette {
        [
            Self.generate(grayscale: count)
        ].asPalette
    }
            
    public static func generate(grayscale count: Int) -> [HSBAInfo] {
        Self.generate(count: count, h: 0, s: 0, b: 0, B: 1)
    }
    
    public static func generate(vivid count: Int) -> [HSBAInfo] {
//        Self.generate(common: count, s: 1, S: 0.65)
        var r : [HSBAInfo] = []
        var h : CGFloat = 0
        let dh : CGFloat = 0.1
        let upto : CGFloat = dh - dh/count.asCGFloat
        while h < (1-dh) {
            r += Self.generate(count: count, h: h, H: h + upto)
            h += dh
        }
        return r
    }
    
    public static func generate(dark count: Int) -> [HSBAInfo] {
        Self.generate(common: count, S: 0.7, b: 0.55, B: 0.8)
    }

    public static func generate(bright count: Int) -> [HSBAInfo] {
        Self.generate(common: count, s: 0.7, S: 0.4)
    }
    
    public static func generate(pale count: Int) -> [HSBAInfo] {
        Self.generate(common: count, s: 0.5, S: 0.2)
    }
    
    public static func generate(faded count: Int) -> [HSBAInfo] {
        Self.generate(common: count, s: 0.4, S: 0.3, b: 0.6, B: 0.8)
    }
    

    public static let defaultHues : [CGFloat] = [0,0.08,0.12,0.27,0.45,0.55,0.6,0.7,0.8,0.9]
//    static let defaultHues : [CGFloat] = [0,0.08,0.115,0.14,0.24,0.33,0.48,0.55,0.6,0.67,0.74,0.82,0.9]
//    static let defaultHues : [CGFloat] = [0,0.08,0.11,0.12,0.13,0.24,0.3,0.45,0.5,0.55,0.62,0.7,0.8,0.9]
    
    public static func generate(common count: Int, s: CGFloat = 1, S: CGFloat? = nil, b: CGFloat = 1, B: CGFloat? = nil) -> [HSBAInfo] {
        Self.generate(count: count, hues: Self.defaultHues, s: s, S: S, b: b, B: B)
    }
    
    public static func generate(count: Int, hues: [CGFloat], s: CGFloat, S: CGFloat? = nil, b: CGFloat, B: CGFloat? = nil) -> [HSBAInfo] {
        hues.map { Self.generate(count: count, h: $0, H: nil, s: s, S: S, b: b, B: B, a: 1, A: nil) }.reduce([], { $0 + $1 })
    }
            
//    static func palette(columns count: Int, h: CGFloat, s: CGFloat, S: CGFloat, b: CGFloat) -> String {
//        hues.map { Self.generate(count: count, h: h, H: nil, s: s, S: S, b: b, B: nil, a: 1, A: nil) }.reduce([], { $0 + $1 }).asPalette
//    }
            
    
    
    
}

extension HSBAInfo : RawRepresentable {
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        asStringOfHSBA
    }
    
    public init?(rawValue: RawValue) {
        let split = rawValue.split(",")
        guard split.count > 2 else { return nil }
        self.init(rawValue)
    }

    
}

public extension HSBAInfo {
    
    struct Palette : Codable, RawRepresentable, Equatable {
        
        public typealias RawValue = String

        public init?(rawValue: RawValue) {
            self.entries = rawValue.split("|").filter { $0.contains(",") }.map { HSBAInfo.init($0) }
        }
        
        public var rawValue: RawValue {
            asEntriesOfStringHSBA.joined(separator: "|")
        }

        
        init(entries: [HSBAInfo] = []) {
            self.entries = entries
        }
        
        
        var entries : [HSBAInfo] = []
        
        var entriesFilteredAsHSB : [HSBAInfo] { entries.filter { $0.isHSB } }
        
        var asEntriesOfStringHSBA : [String] { entries.map { $0.asStringOfHSBA } }
        var asEntriesOfStringHSB  : [String] { entries.map { $0.asStringOfHSB } }
        
        func asEntriesOfString(withAlpha: Bool) -> [String] {
            withAlpha ? asEntriesOfStringHSBA : asEntriesOfStringHSB
        }
        
        var asArrayOfString : [String] {
            entries.map { $0.asStringOfHSBA }
        }

        var asString : String {
            asArrayOfString.joined(separator: "|")
        }
        
        var asArrayOfDoubleTuples : [[Double]] {
            asArrayOfString.map { tuple in
                tuple.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, till: 4)
            }
        }
        
        
        func contains(entry: HSBAInfo) -> Bool {
            let e = entry.asStringOfHSBA
            return entries.contains(where: { $0.asStringOfHSBA == e })
        }
        
        mutating func remove(entry: HSBAInfo) {
            let e = entry.asStringOfHSBA
            return entries.removeAll(where: { $0.asStringOfHSBA == e })
        }
        
        mutating func add(entry: HSBAInfo) {
            remove(entry: entry)
            entries.prepend(entry)
        }
        
        
        
        enum Sorting : String, Codable, Equatable, CaseIterable {
            case h, s, b, a
        }
        
//        func sorted(by sorting: Sorting, up: Bool) -> Self {
//            switch sorting {
//                case .h: return palette.wrappedValue.asArrayOfHSBAValues.sorted(by: { lhs,rhs in HSBAInfo.compareByH(lhs: lhs, rhs: rhs, up: up) }).asPalette
//                case .s: return palette.wrappedValue.asArrayOfHSBAValues.sorted(by: { lhs,rhs in HSBAInfo.compareByS(lhs: lhs, rhs: rhs, up: up) }).asPalette
//                case .b: return palette.wrappedValue.asArrayOfHSBAValues.sorted(by: { lhs,rhs in HSBAInfo.compareByB(lhs: lhs, rhs: rhs, up: up) }).asPalette
//                case .a: return palette.wrappedValue.asArrayOfHSBAValues.sorted(by: { lhs,rhs in HSBAInfo.compareByA(lhs: lhs, rhs: rhs, up: up) }).asPalette
//            }
//        }

//        func with(sorting: Sorting, up: Bool) -> Self {
//            palette.wrappedValue = sorted(by: sorting, up: up)
//            return .init(title: title, palette: palette, editable: editable)
//        }

    }
    
    
}


public extension HSBAInfo {

    struct GradientInfo : Codable, RawRepresentable, Equatable {

        public typealias RawValue = String

        public init?(rawValue: String) {
            let split = rawValue.split("/")
            guard split.count == 2, split[0].contains(","), split[1].contains(",") else { return nil }
            color0 = .init(split[0])
            color1 = .init(split[1])
        }
        
        public var rawValue: String {
            "\(color0.asStringOfHSBA)/\(color1.asStringOfHSBA)"
        }

        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            (lhs.color0.asStringOfHSBA == rhs.color0.asStringOfHSBA &&
            lhs.color1.asStringOfHSBA == rhs.color1.asStringOfHSBA)
            ||
            (lhs.color0.asStringOfHSBA == rhs.color1.asStringOfHSBA &&
            lhs.color1.asStringOfHSBA == rhs.color0.asStringOfHSBA)
        }
        
        
        var color0  : HSBAInfo
        var color1  : HSBAInfo
        
        init(color0: HSBAInfo, color1: HSBAInfo) {
            self.color0 = color0
            self.color1 = color1
        }
        
        var isHSB : Bool { color0.isHSB && color1.isHSB }
    }
    
    struct GradientPalette : Codable, RawRepresentable, Equatable {
        
        public typealias RawValue = String

        public init?(rawValue: String) {
            self.entries = rawValue.split("|").filter { $0.contains("/") }.map { .init(rawValue: $0) }.compactMap { $0 }
        }
        
        public var rawValue: String {
            entries.map {
                $0.rawValue
            }.joined(separator: "|")
        }

        
        public init(entries: [GradientInfo] = []) {
            self.entries = entries
        }
        
        
        public var entries : [GradientInfo] = []
        
        public var entriesFilteredAsHSB : [GradientInfo] { entries.filter { $0.isHSB } }
        
    }
    
    
}

public extension Array where Element == HSBAInfo {
    var asPalette : HSBAInfo.Palette {
        .init(entries: self)
    }
}

public extension Array where Element == [HSBAInfo] {
    var asPalette : HSBAInfo.Palette {
        flatMap { $0 }.asPalette
    }
}



public extension SKColor {
    var asHSBAInfo : HSBAInfo {
        .init(self.arrayOfHSBA)
    }
    
    func extreme(threshold: Double = 0.5, lowerbound l: Double = 0, upperbound u: Double = 1) -> SKColor {
        asHSBAInfo.extreme(threshold: threshold, lowerbound: l, upperbound: u).asSKColor
    }
    func opposite(threshold: Double = 0.5, lowerbound l: Double = 0, upperbound u: Double = 1) -> SKColor {
        asHSBAInfo.opposite(threshold: threshold, lowerbound: l, upperbound: u).asSKColor
    }
    func brighter(by delta: Double = 0.1) -> SKColor {
        asHSBAInfo.brighter(by: delta).asSKColor
    }
    func lighter(by delta: Double = 0.1) -> SKColor {
        asHSBAInfo.lighter(by: delta).asSKColor
    }

}

public extension String {
    var asHSBAInfo : HSBAInfo {
        .init(self.asArrayOfDouble(delimiter: ",").padded(with: 1, till: 4), fallback: 1)
    }
}

public extension Color {
    var asBWExtreme : Color {
        .init(white: self.hsba[2] < 0.5 ? 0 : 1)
    }
    var asBWExtremeOpposite : Color {
        .init(white: self.hsba[2] > 0.5 ? 0 : 1)
    }
}


public extension Color {
    
    typealias RGB8  = (r: UInt8, g: UInt8, b: UInt8)
    typealias RGBA8 = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)
    typealias HSB8  = (h: UInt8, s: UInt8, b: UInt8)
    typealias HSBA8 = (h: UInt8, s: UInt8, b: UInt8, a: UInt8)
    
    // MARK: - RGB8 Properties
    
    var asRGB8: RGB8 {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        return (
            r: UInt8(components[0] * 255),
            g: UInt8(components[1] * 255),
            b: UInt8(components[2] * 255)
        )
    }
    
    var asRGBA8: RGBA8 {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        return (
            r: UInt8(components[0] * 255),
            g: UInt8(components[1] * 255),
            b: UInt8(components[2] * 255),
            a: UInt8(components[3] * 255)
        )
    }
    
    var asHSB8: HSB8 {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        return (
            h: UInt8(h * 255),
            s: UInt8(s * 255),
            b: UInt8(b * 255)
        )
    }
    
    var asHSBA8: HSBA8 {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (
            h: UInt8(h * 255),
            s: UInt8(s * 255),
            b: UInt8(b * 255),
            a: UInt8(a * 255)
        )
    }
    
    // MARK: - Static Factory Methods
    
    static func fromRGB8(_ rgb: RGB8) -> Color {
        Color(
            red: Double(rgb.r) / 255,
            green: Double(rgb.g) / 255,
            blue: Double(rgb.b) / 255
        )
    }
    
    static func fromRGBA8(_ rgba: RGBA8) -> Color {
        Color(
            red: Double(rgba.r) / 255,
            green: Double(rgba.g) / 255,
            blue: Double(rgba.b) / 255,
            opacity: Double(rgba.a) / 255
        )
    }
    
    static func fromHSB8(_ hsb: HSB8) -> Color {
        Color(
            hue: Double(hsb.h) / 255,
            saturation: Double(hsb.s) / 255,
            brightness: Double(hsb.b) / 255
        )
    }
    
    static func fromHSBA8(_ hsba: HSBA8) -> Color {
        Color(
            hue: Double(hsba.h) / 255,
            saturation: Double(hsba.s) / 255,
            brightness: Double(hsba.b) / 255,
            opacity: Double(hsba.a) / 255
        )
    }

    
    // MARK: - String Initialization
    
    static func fromRGB8String(_ string: String) -> Color {
        fromRGB8(string.toRGB8())
    }
    
    static func fromRGBA8String(_ string: String) -> Color {
        fromRGBA8(string.toRGBA8())
    }
    
    static func fromHSB8String(_ string: String) -> Color {
        fromHSB8(string.toHSB8())
    }
    
    static func fromHSBA8String(_ string: String) -> Color {
        fromHSBA8(string.toHSBA8())
    }
    
    // MARK: - String Conversion Properties
    
    var asRGB8String: String {
        String.fromRGB8(self.asRGB8)
    }
    
    var asRGBA8String: String {
        String.fromRGBA8(self.asRGBA8)
    }
    
    var asHSB8String: String {
        String.fromHSB8(self.asHSB8)
    }
    
    var asHSBA8String: String {
        String.fromHSBA8(self.asHSBA8)
    }
}

public extension String {
    
    static func fromRGB8    (_ c: Color.RGB8)   -> String { "\(c.r)/\(c.g)/\(c.b)" }
    static func fromRGBA8   (_ c: Color.RGBA8)  -> String { "\(c.r)/\(c.g)/\(c.b)/\(c.a)" }
    static func fromHSB8    (_ c: Color.HSB8)   -> String { "\(c.h)/\(c.s)/\(c.b)" }
    static func fromHSBA8   (_ c: Color.HSBA8)  -> String { "\(c.h)/\(c.s)/\(c.b)/\(c.a)" }
    
    func toRGB8(r: UInt8? = nil, g: UInt8? = nil, b: UInt8? = nil) -> Color.RGB8 {
        let SPLIT = splitBySlash
        return (r: SPLIT[0].asUInt8 ?? r ?? 0, g: SPLIT[safe: 1]?.asUInt8 ?? g ?? 0, b: SPLIT[safe: 2]?.asUInt8 ?? b ?? 0)
    }
    
    func toRGBA8(r: UInt8? = nil, g: UInt8? = nil, b: UInt8? = nil, a: UInt8? = nil) -> Color.RGBA8 {
        let SPLIT = splitBySlash
        return (r: SPLIT[0].asUInt8 ?? r ?? 0, 
                g: SPLIT[safe: 1]?.asUInt8 ?? g ?? 0, 
                b: SPLIT[safe: 2]?.asUInt8 ?? b ?? 0,
                a: SPLIT[safe: 3]?.asUInt8 ?? a ?? 0)
    }
    
    func toHSB8(h: UInt8? = nil, s: UInt8? = nil, b: UInt8? = nil) -> Color.HSB8 {
        let SPLIT = splitBySlash
        return (h: SPLIT[0].asUInt8 ?? h ?? 0, 
                s: SPLIT[safe: 1]?.asUInt8 ?? s ?? 0, 
                b: SPLIT[safe: 2]?.asUInt8 ?? b ?? 0)
    }
    
    func toHSBA8(h: UInt8? = nil, s: UInt8? = nil, b: UInt8? = nil, a: UInt8? = nil) -> Color.HSBA8 {
        let SPLIT = splitBySlash
        return (h: SPLIT[0].asUInt8 ?? h ?? 0, 
                s: SPLIT[safe: 1]?.asUInt8 ?? s ?? 0, 
                b: SPLIT[safe: 2]?.asUInt8 ?? b ?? 0,
                a: SPLIT[safe: 3]?.asUInt8 ?? a ?? 0)
    }
    
    func asColorFromRGB8(r: UInt8? = nil, g: UInt8? = nil, b: UInt8? = nil) -> Color {
        Color.fromRGB8(toRGB8(r: r, g: g, b: b))
    }
    
    func asColorFromRGBA8(r: UInt8? = nil, g: UInt8? = nil, b: UInt8? = nil, a: UInt8? = nil) -> Color {
        Color.fromRGBA8(toRGBA8(r: r, g: g, b: b, a: a))
    }
    
    func asColorFromHSB8(h: UInt8? = nil, s: UInt8? = nil, b: UInt8? = nil) -> Color {
        Color.fromHSB8(toHSB8(h: h, s: s, b: b))
    }
    
    func asColorFromHSBA8(h: UInt8? = nil, s: UInt8? = nil, b: UInt8? = nil, a: UInt8? = nil) -> Color {
        Color.fromHSBA8(toHSBA8(h: h, s: s, b: b, a: a))
    }
}

public extension String {
    var asUInt8 : UInt8? { UInt8(self) }
}
