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






























public struct HSBAInfo : Codable, Equatable {
    
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
    
    public init(_ string: String) {
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
    
    func with(h: Double? = nil, s: Double? = nil, b: Double? = nil, a: Double? = nil) -> Self {
        .init(h: h ?? self.h, s: s ?? self.s, b: b ?? self.b, a: a ?? self.a)
    }

    var isHSB : Bool { a >= 1 }
    var asHSB : HSBAInfo { with(a: 1) }
    
    var asArrayOfHSB                : [Double] { [h,s,b] }
    var asArrayOfHSBA               : [Double] { [h,s,b,a] }
    
    var asStringOfHSB               : String { asArrayOfHSB.map { $0.format4 }.joinedByComma }
    var asStringOfHSBA              : String { asArrayOfHSBA.map { $0.format4 }.joinedByComma }
    
    func asStringOfHSBA(withAlpha: Bool) -> String {
        withAlpha ? asStringOfHSBA : asStringOfHSB
    }

    var asDescriptiveStringOfHSB    : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)" }
    var asDescriptiveStringOfHSBA   : String { "H \(h.format4)  S \(s.format4)  B \(b.format4)  A \(a.format4)" }

    var asSKColor                   : SKColor { .init(HSBA: self) }
    var asSwiftUIColor              : SwiftUI.Color { .init(HSBA: asArrayOfHSBA) }

    
    static let black    : Self = .init(0,0,0,1)
    static let red      : Self = .init(0,1,1,1)
    static let yellow   : Self = .init(0.13,1,1,1)
    static let white    : Self = .init(0,0,1,1)
    
    static func generate(count: Int, from: HSBAInfo, to: HSBAInfo) -> [HSBAInfo] {
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
    
    static func generate(count: Int, h0: CGFloat, h1: CGFloat? = nil, s0: CGFloat, s1: CGFloat? = nil, b0: CGFloat, b1: CGFloat? = nil, a0: CGFloat = 1, a1: CGFloat? = nil) -> [HSBAInfo] {
        generate(count: count, from: .init(h: h0, s: s0, b: b0, a: a0), to: .init(h: h1 ?? h0, s: s1 ?? s0, b: b1 ?? b0, a: a1 ?? a0))
    }
    
    static func generate(count: Int, h: CGFloat, H: CGFloat? = nil, s: CGFloat = 1, S: CGFloat? = nil, b: CGFloat = 1, B: CGFloat? = nil, a: CGFloat = 1, A: CGFloat? = nil) -> [HSBAInfo] {
        generate(count: count, from: .init(h: h, s: s, b: b, a: a), to: .init(h: H ?? h, s: S ?? s, b: B ?? b, a: A ?? a))
    }
    
    static func paletteDefault(columns count: Int) -> Palette {
        [
            Self.generate(grayscale: count),
            Self.generate(vivid: count),
            Self.generate(dark: count),
            Self.generate(pale: count),
        ].asPalette
    }
            
    static func paletteDefaultPale(columns count: Int) -> Palette {
        [
            Self.generate(pale: count)
        ].asPalette
    }
            
    static func paletteDefaultVivid(columns count: Int) -> Palette {
        [
            Self.generate(vivid: count),
        ].asPalette
    }
            
    static func paletteDefaultDark(columns count: Int) -> Palette {
        [
            Self.generate(dark: count)
        ].asPalette
    }
            
    static func paletteDefaultGrayscale(columns count: Int) -> Palette {
        [
            Self.generate(grayscale: count)
        ].asPalette
    }
            
    static func generate(grayscale count: Int) -> [HSBAInfo] {
        Self.generate(count: count, h: 0, s: 0, b: 0, B: 1)
    }
    
    static func generate(vivid count: Int) -> [HSBAInfo] {
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
    
    static func generate(dark count: Int) -> [HSBAInfo] {
        Self.generate(common: count, b: 0.55, B: 0.9)
    }

    static func generate(pale count: Int) -> [HSBAInfo] {
        Self.generate(common: count, s: 0.60, S: 0.1)
    }
    

    static let defaultHues : [CGFloat] = [0,0.08,0.12,0.27,0.45,0.55,0.6,0.7,0.8,0.9]
//    static let defaultHues : [CGFloat] = [0,0.08,0.115,0.14,0.24,0.33,0.48,0.55,0.6,0.67,0.74,0.82,0.9]
//    static let defaultHues : [CGFloat] = [0,0.08,0.11,0.12,0.13,0.24,0.3,0.45,0.5,0.55,0.62,0.7,0.8,0.9]
    
    static func generate(common count: Int, s: CGFloat = 1, S: CGFloat? = nil, b: CGFloat = 1, B: CGFloat? = nil) -> [HSBAInfo] {
        Self.generate(count: count, hues: Self.defaultHues, s: s, S: S, b: b, B: B)
    }
    
    static func generate(count: Int, hues: [CGFloat], s: CGFloat, S: CGFloat? = nil, b: CGFloat, B: CGFloat? = nil) -> [HSBAInfo] {
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
                tuple.split(",").map { Double($0) ?? 1.0 }.padded(with: 1.0, upto: 4)
            }
        }
        
        
        func contains(_ entry: HSBAInfo, withAlpha: Bool) -> Bool {
//            asEntriesOfString(withAlpha: withAlpha).contains(entry.asStringOfHSBA(withAlpha: withAlpha))
            let e = entry.asStringOfHSBA(withAlpha: withAlpha)
            return entries.contains(where: { $0.asStringOfHSBA(withAlpha: withAlpha) == e })
        }
        
        mutating func remove(_ entry: HSBAInfo, withAlpha: Bool) {
            let e = entry.asStringOfHSBA(withAlpha: withAlpha)
            return entries.removeAll(where: { $0.asStringOfHSBA(withAlpha: withAlpha) == e })
        }
        
        mutating func add(_ entry: HSBAInfo, withAlpha: Bool) {
            remove(entry, withAlpha: withAlpha)
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


extension HSBAInfo {

    struct GradientInfo : Codable, RawRepresentable, Equatable {

        typealias RawValue = String

        init?(rawValue: String) {
            let split = rawValue.split("/")
            guard split.count == 2, split[0].contains(","), split[1].contains(",") else { return nil }
            color0 = .init(split[0])
            color1 = .init(split[1])
        }
        
        var rawValue: String {
            "\(color0.asStringOfHSBA)/\(color1.asStringOfHSBA)"
        }

        
        static func == (lhs: Self, rhs: Self) -> Bool {
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
        
        typealias RawValue = String

        init?(rawValue: String) {
            self.entries = rawValue.split("|").filter { $0.contains("/") }.map { .init(rawValue: $0) }.compactMap { $0 }
        }
        
        var rawValue: String {
            entries.map {
                $0.rawValue
            }.joined(separator: "|")
        }

        
        init(entries: [GradientInfo] = []) {
            self.entries = entries
        }
        
        
        var entries : [GradientInfo] = []
        
        var entriesFilteredAsHSB : [GradientInfo] { entries.filter { $0.isHSB } }
        
    }
    
    
}

extension Array where Element == HSBAInfo {
    var asPalette : HSBAInfo.Palette {
        .init(entries: self)
    }
}

extension Array where Element == [HSBAInfo] {
    var asPalette : HSBAInfo.Palette {
        flatMap { $0 }.asPalette
    }
}




