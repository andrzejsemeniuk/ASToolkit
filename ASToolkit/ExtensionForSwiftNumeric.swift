//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension BinaryInteger {
    mutating func increment(increment:Self) -> Self {
        self = self + increment
        return self
    }
    
    @discardableResult
    mutating func add(_ value: Self, min: Self, max: Self) -> Self {
        self = Swift.max(min, Swift.min(max, self + value))
        return self
    }
    
    func added(_ value: Self, min: Self, max: Self) -> Self {
        Swift.max(min, Swift.min(max, self + value))
    }
}

public extension FloatingPoint {
    mutating func increment(_ increment:Self) -> Self {
        self = self + increment
        return self
    }
    
}

public extension FloatingPoint {
    static var twoPi: Self { return .pi * 2 }
    
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }

    var radians: Self { return self * .pi / 180 }
    var degrees: Self { return self * 180 / .pi }

    @discardableResult
    mutating func add(_ value: Self, min: Self, max: Self) -> Self {
        self = Swift.max(min, Swift.min(max, self + value))
        return self
    }
    
    func added(_ value: Self, min: Self, max: Self) -> Self {
        Swift.max(min, Swift.min(max, self + value))
    }

    func isEqual(to: Self, withPrecision precision: Self) -> Bool {
        abs(self - to) < precision
    }
    
    static func generate(from: Self, to: Self, step: Self) -> [Self] {
        var r : [Self] = []
//        r.reserveCapacity(1+Int((upto-from)/step))
        var from = from
        while from <= to {
            r.append(from)
            from += step
        }
        return r
    }

    static func generate(from: Self, upto: Self, step: Self) -> [Self] {
        var r : [Self] = []
//        r.reserveCapacity(1+Int((upto-from)/step))
        var from = from
        while from < upto {
            r.append(from)
            from += step
        }
        return r
    }

}

public extension FloatingPoint {
    
//    var clampedTo01         : Self { clamped(minimum:0, maximum:1) }
//    var clampedTo11         : Self { clamped(minimum:-1, maximum:1) }
//    var clampedTo02         : Self { clamped(minimum:0, maximum:2) }
//    var clampedTo0255       : Self { clamped(minimum:0, maximum:255) }

    func lerp                (from: Self, for:Self) -> Self { from + `for` * self }

}





public extension Double
{
    var sign                : Self { self < 0 ? -1 : self > 0 ? 1 : 0 }
    
    var clampedTo01         : Self { clamped(minimum:0, maximum:1) }
    var clampedTo11         : Self { clamped(minimum:-1, maximum:1) }
    var clampedTo02         : Self { clamped(minimum:0, maximum:2) }
    var clampedTo0255       : Self { clamped(minimum:0, maximum:255) }
    
    func isInClosedInterval (_ l: Double, _ u: Double) -> Bool { l <= self && self <= u }
    func isInOpenInterval   (_ l: Double, _ u: Double) -> Bool { l < self && self < u }
    
    func lerp               (from:Self, to:Self) -> Self { from + (to - from) * self }
    func lerp01             (from:Self, to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    func lerp               (_ from:Self, _ to:Self) -> Self { from + (to - from) * self }
    func lerp01             (_ from:Self, _ to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    static func lerp        (from:Self, to:Self, with:Self) -> Self { with.lerp(from:from,to:to) }
    static func lerp01      (from:Self, to:Self, with:Self) -> Self { with.lerp01(from:from,to:to) }
    
    
    func progress           (from f:Self, to t:Self) -> Self { f < t ? (self-f)/(t-f) : (f-self)/(f-t) }
    func progress01         () -> Self { progress(from:0,to:1) }
    
    var fromFractionToPercent : Double {
            // fraction : 1 = 100%
            //  0.97 = -3%
            //  1.02 = +2%
        (self - 1.0) * 100.0
    }
    
    mutating func addedAround(_ lowerbound: Double, _ upperbound: Double, add: Double) -> Self {
        guard add != 0 else { return self }
        guard add.abs < (upperbound-lowerbound) else { return self }
        self += add
        if upperbound < self {
            self = lowerbound + (self - upperbound)
        }
        if add > 0 {
            if self < lowerbound {
                self += add
            }
        } else {
            if self < lowerbound {
                self = upperbound - (lowerbound - self)
            }
        }
        return self
    }
    
    mutating func addedAround01(_ add: Double) -> Self {
        addedAround(0,1,add: add)
    }
}

public extension Double {
    
    @discardableResult mutating func assign(max v:Double) -> Double {
        self = Swift.max(self,v)
        return self
    }

    @discardableResult mutating func assign(min v:Double) -> Double {
        self = Swift.min(self,v)
        return self
    }
    
    func max(_ v: Double) -> Double {
        Swift.max(self,v)
    }

    func min(_ v: Double) -> Double {
        Swift.min(self,v)
    }

}

//public func pick<T>(_ from: [T]) -> T {
//    from[.random(min: 0, upto: from.count)]
//}

public extension Double {
    
    static var   resolution      : UInt32     = 100000
    
    static var   random01        : Double { Double(arc4random() % resolution) / resolution.asDouble }
    static var   random          : Double { random01 }
    static var   random11        : Self                                      { random(min: -1, max: +1) }

    static func  random          (min: Double, max: Double) -> Double { Double.random * (max - min) + min }
    static func  random          (_ min: Double, _ max: Double) -> Double { Double.random * (max - min) + min }
    static func  random          (min: Double, max: Double, resolution: UInt32) -> Double {
        (Double(arc4random_uniform(resolution)) / resolution.asDouble) * (max - min) + min
    }
    static func  random01        (resolution: UInt32) -> Double { random(min: 0, max: 1, resolution: resolution) }

}

public extension Double {

    var asInt           : Int { Int(self) }
    var asInt64         : Int64 { Int64(self) }
    var asUInt64        : UInt64 { UInt64(self) }
//    var asIntRounded    : Int { self < 0.5 ? Int(self) : Int(self) + 1 }
//    var asInt64Rounded  : Int64 { self < 0.5 ? Int64(self) : Int64(self) + 1 }
    var asFloat         : Float { Float(self) }
    var asCGFloat       : CGFloat { CGFloat(self) }

    var from01to11      : Self { (self * 2 - 1) }
    var from11to01      : Self { ((self + 1) / 2) }
    
    var abs             : Self { Swift.abs(self) }
    var floor           : Self { Darwin.floor(self) }
    var ceil            : Self { Darwin.ceil(self) }

}

public extension Int64 {

    // https://stackoverflow.com/questions/18267211/ios-convert-large-numbers-to-smaller-format
    static fileprivate let formatterWithAbbreviation : NumberFormatter = {
        let numFormatter = NumberFormatter()
//        numFormatter.positiveSuffix = abbreviation.suffix
//        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 2
        numFormatter.locale = .current
        return numFormatter
    }()
    
    var formatWithAbbrevationAsString : String {

        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "K"),
            (999_999.0, 1_000_000.0, "M"),
            (999_999_999.0, 1_000_000_000.0, "G"),
            (999_999_999_999.0, 1_000_000_000_000.0, "T"),
            (999_999_999_999_999.0, 1_000_000_000_000_000.0, "P"),
            (999_999_999_999_999_999.0, 1_000_000_000_000_000_000.0, "E"),
        ]

        let startValue = Double(abs(self))
        
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor

        let formatter = Self.formatterWithAbbreviation
        
        formatter.positiveSuffix = abbreviation.suffix
        formatter.negativeSuffix = abbreviation.suffix
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(self)"
    }
    
    var formatWithAbbrevationAsMarkdownString : String {
        let S = formatWithAbbrevationAsString
        if let last = S.last, last.isLetter {
            return S[0..<S.count-1] + "**\(last)**"
        }
        return S
    }

    var formatWithFinancialValueAbbrevationAsString : String {
        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "k"),
            (999_999.0, 1_000_000.0, "M"),
            (999_999_999.0, 1_000_000_000.0, "B"),
            (999_999_999_999.0, 1_000_000_000_000.0, "T"),
//            (999_999_999_999_999.0, 1_000_000_000_000_000.0, "P"),
//            (999_999_999_999_999_999.0, 1_000_000_000_000_000_000.0, "E"),
        ]

        let startValue = Double(abs(self))
        
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor

        let formatter = Self.formatterWithAbbreviation
        
        formatter.positiveSuffix = abbreviation.suffix
        formatter.negativeSuffix = abbreviation.suffix
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(self)"
    }

    var formatWithFinancialValueAbbrevationAsMarkdownString : String {
        let S = formatWithFinancialValueAbbrevationAsString
        if let last = S.last, last.isLetter {
            return S[0..<S.count-1] + "**\(last)**"
        }
        return S
    }


//    var formatWithAbbrevationAsAttributedString : AttributedString {
//
//        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
//
//        let abbreviations: [Abbrevation] = [
//            (0, 1, ""),
//            (1000.0, 1000.0, "K"),
//            (999_999.0, 1_000_000.0, "M"),
//            (999_999_999.0, 1_000_000_000.0, "G"),
//            (999_999_999_999.0, 1_000_000_000_000.0, "T"),
//            (999_999_999_999_999.0, 1_000_000_000_000_000.0, "P"),
//            (999_999_999_999_999_999.0, 1_000_000_000_000_000_000.0, "E"),
//        ]
//
//        let startValue = Double(abs(self))
//
//        let abbreviation: Abbrevation = {
//            var prevAbbreviation = abbreviations[0]
//            for tmpAbbreviation in abbreviations {
//                if (startValue < tmpAbbreviation.threshold) {
//                    break
//                }
//                prevAbbreviation = tmpAbbreviation
//            }
//            return prevAbbreviation
//        }()
//
//        let value = Double(self) / abbreviation.divisor
//
//        let formatter = Self.formatterWithAbbreviation
//
//        formatter.positiveSuffix = abbreviation.suffix
//        formatter.negativeSuffix = abbreviation.suffix
//
//        return formatter.attributedString(for: NSNumber(value: value), withDefaultAttributes: )(from: NSNumber(value: value)) ?? "\(self)"
//    }
}

public extension Double {
    
    static let formatterAsUInt64 : NumberFormatter = {
        let r = NumberFormatter.init()
        r.numberStyle = .ordinal
        return r
    }()
    
    var withAbbreviationAsString : String {
        self.asInt64.formatWithAbbrevationAsString
    }
//    var withAbbreviationAsAttributedString : String {
//        self.asInt64.formatWithAbbrevation
//    }

    var format0 : String { self == 0 ? "0" : Self.formatterAsUInt64.string(from: self.asUInt64 as NSNumber) ?? "?" } //NSString(format: "%U", self.asUInt64) as String }
    
    var format1 : String { self == 0 ? "0.0" : NSString(format: "%.1f", self) as String }
    var format2 : String { self == 0 ? "0.00" : NSString(format: "%.2f", self) as String }
    var format3 : String { self == 0 ? "0.000" : NSString(format: "%.3f", self) as String }
    var format4 : String { self == 0 ? "0.0000" : NSString(format: "%.4f", self) as String }

    var format1p : String { self == 0 ? "0.0" : NSString(format: "%+.1f", self) as String }
    var format2p : String { self == 0 ? "0.00" : NSString(format: "%+.2f", self) as String }
    var format3p : String { self == 0 ? "0.000" : NSString(format: "%+.3f", self) as String }
    var format4p : String { self == 0 ? "0.0000" : NSString(format: "%+.4f", self) as String }

    var format4plus : String { self > 0.0 ? NSString(format: "+%.4f", self) as String : self == 0 ? " 0.0000" : self.format4 }

    var format22 : String { NSString(format: "%3.2f", self) as String }

    func format(digits: Int = 2) -> String { NSString(format: "%.\(digits)f" as NSString, self) as String }
    
    var percent0 : String { self == 0 ? "0%" : NSString(format: "%.0f%%", self * 100.0) as String }
    var percent1 : String { self == 0 ? "0.0%" : NSString(format: "%.1f%%", self * 100.0) as String }
    var percent2 : String { self == 0 ? "0.00%" : NSString(format: "%.2f%%", self * 100.0) as String }

}

public extension Double {
    static let twopi            : Self = Self.pi * 2.0
    static let degrees2radians  : Self = Self.pi / 180.0
    static let radians2degrees  : Self = 180.0 / Self.pi

    var radians                 : Self { self * .degrees2radians }
    var degrees                 : Self { self * .radians2degrees }
    var radiansFrom01           : Self { self * .twopi }
    var degreesFrom01           : Self { self * 360.0 }
    var radiansTo01             : Self { self / .twopi }
    var degreesTo01             : Self { self / 360.0 }
    var radiansFrom11           : Self { self * .pi }
    var degreesFrom11           : Self { self * 180.0 }
    var radiansTo11             : Self { self / .pi }
    var degreesTo11             : Self { self / 180.0 }

    var normalizedTo2Pi         : Self { (self.degrees.asInt % 360).asDouble.radians }
//    mutating func normalizeTo2Pi() { self = self.normalizedTo2Pi }
    var normalizedToPiPi        : Self { ((self.degrees.asInt % 360) - 180).asDouble.radians }
    func radians(shortestTo b: Self) -> Self {
        let a = self.normalizedToPiPi
        let b = b.normalizedToPiPi
        return Swift.min(a-b,b-a) // ??
    }

    var from11ToRadians         : Self { self * .twopi }
    var from11ToDegrees         : Self { self * 360 }

}









public extension CGFloat
{
    var sign                : Self { self < 0 ? -1 : self > 0 ? 1 : 0 }
    
    var clampedTo01         : Self { clamped(minimum:0, maximum:1) }
    var clampedTo11         : Self { clamped(minimum:-1, maximum:1) }
    var clampedTo0255       : Self { clamped(minimum:0, maximum:255) }
    
    func isInClosedInterval (_ l: CGFloat, _ u: CGFloat) -> Bool { l <= self && self <= u }
    func isInOpenInterval   (_ l: CGFloat, _ u: CGFloat) -> Bool { l < self && self < u }
    
    func lerp                (from:Self, to:Self) -> Self { from + (to - from) * self }
    func lerp01              (from:Self, to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    func lerp                (_ from:Self, _ to:Self) -> Self { from + (to - from) * self }
    func lerp01              (_ from:Self, _ to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    static func lerp         (from:Self, to:Self, with:Self) -> Self { with.lerp(from:from,to:to) }
    static func lerp01       (from:Self, to:Self, with:Self) -> Self { with.lerp01(from:from,to:to) }
    
    func progress            (from f:Self, to t:Self) -> Self { f < t ? (self-f)/(t-f) : (f-self)/(f-t) }
    func progress01          () -> Self { progress(from:0,to:1) }

    @discardableResult
    mutating func assign(max v:Self) -> Self {
        self = Swift.max(self,v)
        return self
    }

    @discardableResult
    mutating func assign(min v:Self) -> Self {
        self = Swift.min(self,v)
        return self
    }
    
    mutating func add(_ v: CGFloat, from: CGFloat = 0, to: CGFloat, loop: Bool = true) {
        let n = self + v
        if n > to {
            self = loop ? from : to
        } else if n < from {
            self = loop ? to : from
        } else {
            self = n
        }
    }
    
    var sqrt : CGFloat { Darwin.sqrt(self) }
}

public extension CGFloat {
    
    static var   randomSign      : Self                                      { (arc4random_uniform(2) == 0) ? 1.0 : -1.0 }
    static var   random          : Self                                      { Self(Double.random) }
    static var   random01        : Self                                      { random }
    static var   random11        : Self                                      { random(min: -1, max: +1) }

    static func  random          (min: Self, max: Self) -> Self        { Self.random * (max - min) + min }
    static func  random          (_ min: Self, _ max: Self) -> Self    { Self.random * (max - min) + min }

    func         random          (factor: Self) -> Self                   {
        let f = self * factor
        return Self.random(min: self-f, max: self+f)
    }
    func         random01        (factor: Self) -> Self                   {
        let f = self * factor
        return Self.random(min: self-f, max: self+f).clamped01
    }
    func         random          (_ ball: Self) -> Self                   { Self.random(min: self-ball, max: self+ball) }
    func         random01        (_ ball: Self) -> Self                   { Self.random(min: self-ball, max: self+ball).clamped01 }
    
    var          clamped01       : Self                                      { Swift.max(.zero,Swift.min(.one,self)) }
    func         clamped         (_ min: Self, _ max: Self) -> Self       { Swift.max(min,Swift.min(max,self)) }

    static let   zero            : Self   = 0
    static let   one             : Self   = 1
}

public extension CGFloat {
    
    init?(_ string:String) {
        if let n = NumberFormatter().number(from: string) {
            self.init(truncating: n)
        }
        else {
            return nil
        }
    }
    
}

public extension CGFloat {
    var format0 : String { self == 0 ? "0" : NSString(format: "%.0f", self) as String }
    var format1 : String { self == 0 ? "0.0" : NSString(format: "%.1f", self) as String }
    var format2 : String { self == 0 ? "0.00" : NSString(format: "%.2f", self) as String }
    var format3 : String { self == 0 ? "0.000" : NSString(format: "%.3f", self) as String }
    var format4 : String { self == 0 ? "0.0000" : NSString(format: "%.4f", self) as String }

    var format4plus : String { self > 0.0 ? NSString(format: "+%.4f", self) as String : self == 0 ? " 0.0000" : self.format4 }

    func format(digits: Int = 2) -> String { NSString(format: "%.\(digits)f" as NSString, self) as String }
    
    var percent1 : String { self == 0 ? "0.0" : NSString(format: "%.1f%%", self * 100.0) as String }
    var percent2 : String { self == 0 ? "0.00" : NSString(format: "%.2f%%", self * 100.0) as String }

}

extension CGFloat : RawRepresentable {
    
    public init?(rawValue: String) {
        if let v = CGFloat(rawValue) {
            self = v
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        NSString(format: "%f", self) as String
    }
    
    public typealias RawValue = String
    
    
}

public extension CGFloat {
    var asInt           : Int { Int(self) }
    var asIntRounded    : Int { self < 0.5 ? Int(self) : Int(self) + 1 }
    var asFloat         : Float { Float(self) }
    var asDouble        : Double { Double(self) }

    var from01to11      : CGFloat11 { (self * 2 - 1).asCGFloat }
    var from11to01      : CGFloat01 { ((self + 1) / 2).asCGFloat }
}

public extension CGFloat {
    static let d2r                  : CGFloat       = CGFloat.pi / 180.asCGFloat
    static let r2d                  : CGFloat       = 180.asCGFloat / CGFloat.pi
    static let twopi            : Self = Self.pi * 2.0
    static let degrees2radians  : Self = Self.pi / 180.0
    static let radians2degrees  : Self = 180.0 / Self.pi
    
    var radians             : Self { self * .degrees2radians }
    var degrees             : Self { self * .radians2degrees }
    var radiansFrom01       : Self { self * .twopi }
    var degreesFrom01       : Self { self * 360.0 }
    var radiansTo01         : Self { self / .twopi }
    var degreesTo01         : Self { self / 360.0 }
    var radiansFrom11       : Self { self * .pi }
    var degreesFrom11       : Self { self * 180.0 }
    var radiansTo11         : Self { self / .pi }
    var degreesTo11         : Self { self / 180.0 }

    var normalizedTo2Pi     : Self { (self.degrees.asInt % 360).asCGFloat.radians }
//    mutating func normalizeTo2Pi() { self = self.normalizedTo2Pi }
    var normalizedToPiPi    : Self { ((self.degrees.asInt % 360) - 180).asCGFloat.radians }
    func radians(shortestTo b: Self) -> Self {
        let a = self.normalizedToPiPi
        let b = b.normalizedToPiPi
        return Swift.min(a-b,b-a) // ??
    }

    var from11ToRadians : Self { self * .twopi }
    var from11ToDegrees : Self { self * 360 }

}






public extension Float
{
    var sign                : Self { self < 0 ? -1 : self > 0 ? 1 : 0 }
    
    var clampedTo01         : Self { clamped(minimum:0, maximum:1) }
    var clampedTo0255       : Self { clamped(minimum:0, maximum:255) }
    
    func isInClosedInterval (_ l: Float, _ u: Float) -> Bool { l <= self && self <= u }
    func isInOpenInterval   (_ l: Float, _ u: Float) -> Bool { l < self && self < u }

    func lerp                (from:Self, to:Self) -> Self { from + (to - from) * self }
    func lerp01              (from:Self, to:Self) -> Self { min(1,max(0,self.lerp(from:from,to:to))) }
    static func lerp         (from:Self, to:Self, with:Self) -> Self { with.lerp(from:from,to:to) }
    static func lerp01       (from:Self, to:Self, with:Self) -> Self { with.lerp01(from:from,to:to) }
    
    func progress            (from f:Self, to t:Self) -> Self { f < t ? (self-f)/(t-f) : (f-self)/(f-t) }
    func progress01          () -> Self { progress(from:0,to:1) }
}

public extension Float {
    static var   random01        : Self { Double.random01.asFloat }
    static var   random          : Self { random01 }
    static func  random          (min: Self, max: Self) -> Self { Float.random * (max - min) + min }
    static var   random11        : Self                                      { random(min: -1, max: +1) }

    static var   maximum         : Self { .greatestFiniteMagnitude }
    static var   minimum         : Self { -maximum }
}

public extension Float {

    var asInt           : Int { Int(self) }
    var asIntRounded    : Int { self < 0.5 ? Int(self) : Int(self) + 1 }
    var asCGFloat       : CGFloat { CGFloat(self) }
    var asDouble        : Double { Double(self) }
    
}

public extension Float {
    var format1 : String { self == 0 ? "0.0" : NSString(format: "%.1f", self) as String }
    var format2 : String { self == 0 ? "0.00" :  NSString(format: "%.2f", self) as String }
    var format3 : String { self == 0 ? "0.000" : NSString(format: "%.3f", self) as String }
    var format4 : String { self == 0 ? "0.0000" : NSString(format: "%.4f", self) as String }
    
    func format(digits: Int = 2) -> String { NSString(format: "%.\(digits)f" as NSString, self) as String }
    
    var formattedWithoutRightmostFractionalZeros : String {
        var r = self.asString
        if r.contains(where: { $0 == "." }) {
            var i = r.count-1
            while r[i] == "0" {
                i -= 1
            }
            if i < r.count {
                r = r[0...i]
            }
        }
        return r
    }
}

public extension Float {
    static let twopi            : Self = Float.pi * 2
    static let degrees2radians  : Self = Float.pi / 180.0
    static let radians2degrees  : Self = 180.0 / Float.pi
    
    var radians             : Self { self * .degrees2radians }
    var degrees             : Self { self * .radians2degrees }
    var radiansFrom01       : Self { self * .twopi }
    var degreesFrom01       : Self { self * 360.0 }
    var radiansTo01         : Self { self / .twopi }
    var degreesTo01         : Self { self / 360.0 }
    var radiansFrom11       : Self { self * .pi }
    var degreesFrom11       : Self { self * 180.0 }
    var radiansTo11         : Self { self / .pi }
    var degreesTo11         : Self { self / 180.0 }

    var normalizedTo2Pi     : Self { (self.degrees.asInt % 360).asFloat.radians }
//    mutating func normalizeTo2Pi() { self = self.normalizedTo2Pi }
    var normalizedToPiPi    : Self { ((self.degrees.asInt % 360) - 180).asFloat.radians }
    func radians(shortestTo b: Self) -> Self {
        let a = self.normalizedToPiPi
        let b = b.normalizedToPiPi
        return Swift.min(a-b,b-a) // ??
    }

    var from11ToRadians : Self { self * .twopi }
    var from11ToDegrees : Self { self * 360 }

}








public extension Int
{
    var sign : Int {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }
    
    var isEven:Bool {
        return self % 2 == 0
    }
    var isOdd:Bool {
        return self % 2 == 1
    }

    func loop(_ block: ()->()) {
        let limit = self
        for _ in 1...limit {
            block()
        }
    }

    func loop(_ block: (Int)->()) {
        let limit = self
        for index in 1...limit {
            block(index)
        }
    }

    func counter(_ block: (Int)->()) {
        let limit = self
        for index in 0..<limit {
            block(index)
        }
    }
    
    @inlinable func map<T>(_ transform: (Int) throws -> T) rethrows -> [T] {
        try Array(0..<self).map { i in
            try transform(i)
        }
    }


}

public extension Int
{
    static var random:Int {
        return Int.random(n:UInt32.max)
    }
    static func random(n: UInt32) -> Int {
        return Int(arc4random_uniform(n))
    }
    static func random(min: Int, max: Int) -> Int {
        return Int.random(n:UInt32(max - min + 1)) + min
    }
    static func random(_ min: Int, _ max: Int) -> Int {
        return Int.random(n:UInt32(max - min + 1)) + min
    }
    static func random(min: Int, upto: Int) -> Int {
        return Int.random(n:UInt32(upto - min)) + min
    }
}

public extension Int {
    mutating func advance(by n:Int) {
        self = self + n
    }

    @discardableResult
    mutating func increment(by increment: Int = 1, modulo: Int) -> Int {
        self = incremented(by: increment, modulo: modulo)
        return self
    }

    func incremented(by increment: Int = 1, modulo: Int) -> Int {
        let r = (self + increment) % modulo
        return r < 0 ? r + modulo : r
    }

    @discardableResult mutating func assign(max v:Int) -> Int {
        self = Swift.max(self,v)
        return self
    }

    @discardableResult mutating func assign(min v:Int) -> Int {
        self = Swift.min(self,v)
        return self
    }

}

public extension Int {
    
    
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
    
    var radians: Double { return Double(self) * .pi / 180 }
    var degrees: Double { return Double(self) * 180 / .pi }

}

public extension Int {

    func isInInterval(_ l:Int, _ u:Int) -> Bool { return l <= self && self < u }
    
    @discardableResult
    mutating func clamp(from: Int, to: Int) -> Int {
        if self < from {
            self = from
        } else if self > to {
            self = to
        }
        return self
    }

    @discardableResult
    func clamped(from: Int, to: Int) -> Int {
        Swift.min(to,Swift.max(from,self))
    }

    var stringWithSign : String {
        self < 0 ? "\(self)" : "+\(self)"
    }
    var stringWithPositiveSign : String {
        self < 0 ? "\(self)" : self > 0 ? "+\(self)" : "\(self)"
    }
}


public func pick(_ n: Int) -> Int { n.pick }

public extension Int {

    var asFloat         : Float         { Float(self) }
    var asCGFloat       : CGFloat       { CGFloat(self) }
    var asDouble        : Double        { Double(self) }
    var asUInt          : UInt          { UInt(self) }
    var asUInt32        : UInt32        { UInt32(self) }
    var asUInt64        : UInt64        { UInt64(self) }
    var asInt32         : Int32         { Int32(self) }

    var pick            : Int           { self < 0 ? .random(in: self..<0) : self > 0 ? .random(in: 0..<self) : 0 }

    var formatp         : String        { NSString(format: "%+d", self) as String }

}

public extension UInt {

    var asFloat         : Float         { Float(self) }
    var asCGFloat       : CGFloat       { CGFloat(self) }
    var asDouble        : Double        { Double(self) }
    var asInt           : Int           { Int(self) }

    func isInInterval   (_ l:UInt, _ u:UInt) -> Bool { return l <= self && self < u }
    
}

public extension UInt32 {

    var asFloat         : Float         { Float(self) }
    var asCGFloat       : CGFloat       { CGFloat(self) }
    var asDouble        : Double        { Double(self) }
    var asInt           : Int           { Int(self) }

    func isInInterval   (_ l: UInt32, _ u:UInt32) -> Bool { return l <= self && self < u }
}

public extension UInt64 {

    var asDouble        : Double        { Double(self) }
    var asInt64         : Int64         { Int64(self) }
    var asInt           : Int           { Int(self) }
    var asUInt          : UInt          { UInt(self) }

    func isInInterval(_ l:UInt64, _ u:UInt64) -> Bool { return l <= self && self < u }

    
    static var timestampYYYYMMDD                    : UInt64 { UInt64(Date().timeIntervalSince1970) / 1000000 }
    static var timestampYYYYMMDDhhmmss              : UInt64 { UInt64(Date().timeIntervalSince1970) }
    static var timestampYYYYMMDDhhmmssms            : UInt64 { UInt64(Date().timeIntervalSince1970 * 1000.0) }
}

public extension Int64 {
    
    var sign : Int64 {
        self < 0 ? -1 : self > 0 ? 1 : 0
    }
    
    var asDouble        : Double        { Double(self) }
    var asUInt64        : UInt64        { UInt64(self) }
    var asInt           : Int           { Int(self) }
    var asUInt          : UInt          { UInt(self) }

}







extension Int : Stringable {
    public static func from(string: String) -> Int? {
        Int(string)
    }
}

extension CGFloat : Stringable {
    public static func from(string: String) -> CGFloat? {
        if let v = Double(string) {
            return v
        }
        return nil
    }
}

extension Double : Stringable {
    public static func from(string: String) -> Double? {
        Double(string)
    }
}

public extension Int16 {
    var asString : String { String(self) }
}

public extension Int {
    var asString : String { String(self) }
}
public extension Int32 {
    var asString : String { String(self) }
}
public extension Int64 {
    var asString : String { String(self) }
}
public extension UInt32 {
    var asString : String { String(self) }
}
public extension UInt64 {
    var asString : String { String(self) }
}
public extension Float {
    var asString : String { String(self) }
}
public extension Double {
    var asString : String { String(self) }
}

public extension Array where Element == Double {
    func asStringTuple(delimiter: String = ",") -> String { self.map { $0.format4 }.joined(separator: delimiter) }
    func asArrayOfString(_ delimiter: String = ",") -> String { asStringTuple(delimiter: delimiter) }
}

public extension Array where Element == CGFloat {
    func asStringTuple(delimiter: String = ",") -> String { self.map { $0.format4 }.joined(separator: delimiter) }
    func asArrayOfString(_ delimiter: String = ",") -> String { asStringTuple(delimiter: delimiter) }
    var asStringHSBA : String { [
        self[safe: 0] ?? 0.0,
        self[safe: 1] ?? 0.0,
        self[safe: 2] ?? 1.0,
        self[safe: 3] ?? 1.0,
    ].map { $0.format4 }.joinedByComma }
//        Array(0...3).map { i in self[safe: Int(i)] ?? 1.0 }.map { $0.format4 }.joinedByComma }
}

public extension Array where Element == Int {
    func asStringTuple(delimiter: String = ",") -> String { self.map { "\($0)" }.joined(separator: delimiter) }
    func asArrayOfString(_ delimiter: String = ",") -> String { asStringTuple(delimiter: delimiter) }
}
