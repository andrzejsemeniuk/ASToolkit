//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation



public extension Numeric where Self : Comparable {
    
    func max(_ other: Self) -> Self { Swift.max(self,other) }
    func min(_ other: Self) -> Self { Swift.min(self,other) }
    
    func         clamped         (_ min: Self, _ max: Self) -> Self       { Swift.max(min,Swift.min(max,self)) }
    var          clamped01       : Self                                   { Swift.max(0,Swift.min(1,self)) }

}


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
    
    func lerp               (from:Self, to:Self) -> Self { from + (to - from) * self }
    func lerp01             (from:Self, to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    func lerp               (_ from:Self, _ to:Self) -> Self { from + (to - from) * self }
    func lerp01             (_ from:Self, _ to:Self) -> Self { Swift.min(1,Swift.max(0,self.lerp(from:from,to:to))) }
    static func lerp        (from:Self, to:Self, with:Self) -> Self { with.lerp(from:from,to:to) }
    static func lerp01      (from:Self, to:Self, with:Self) -> Self { with.lerp01(from:from,to:to) }
    
    
    func ratio              (from f:Self, to t:Self) -> Self { (self-f)/(t-f) }
    func ratio01            (from f:Self, to t:Self) -> Self { ratio(from: f, to: t).clamped01 }
    func progress           (from f:Self, to t:Self) -> Self { ratio(from: f, to: t) }

    
    
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
    
//    func progress01         () -> Self { self }
    
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

public extension Double {
    
    struct LERP01 {
        let MIN         : Double
        let MAX         : Double
        let DELTA       : Double
        
        init(from: [Double?]) throws {
            guard from.isNotEmpty else {
                throw AnError.invalidParameter("Empty array")
            }
            let FROM = from.compactMap { $0 }
            guard FROM.isNotEmpty else {
                throw AnError.invalidParameter("No values found")
            }
            if let (MIN,MAX) = FROM.minAndMax {
                self.MIN = MIN
                self.MAX = MAX
                self.DELTA = MAX - MIN
                guard DELTA != .zero else {
                    throw AnError.invalidParameter("DELTA is 0 (zero0")
                }
            } else {
                throw AnError.invalidParameter("No min/max values found")
            }
        }
        
        func lerp01(_ v: Double) -> Double {
            (v - MIN) / DELTA
        }
        func lerp01(_ v: Double?) -> Double? {
            v == nil ? nil : (v! - MIN) / DELTA
        }
    }
    
    
    struct MinMax {
        let minimum     : Double
        let maximum     : Double
        let d           : Double
        
        let logminimum  : Double
        let logmaximum  : Double
        let logd        : Double
        let logoffset   : Double
        
        init(minimum: Double = 0, maximum: Double = 1) {
            self.minimum = minimum
            self.maximum = maximum
            self.d = maximum - minimum
            // NOTE: minimum needs to be > 0
            self.logoffset  = minimum > 0.0 ? 0.0 : 1.0
            self.logminimum = log(logoffset + minimum)
            self.logmaximum = log(logoffset + maximum)
//                self.logminimum = log(minimum)
//                self.logmaximum = log(maximum)
            self.logd = logmaximum - logminimum
        }
        
        func lerp(_ v: Double, fallback: Double) -> Double {
            d > 0 ? (v - minimum) / d : fallback
        }
        func lerp01(_ v: Double, fallback: Double) -> Double {
            lerp(v, fallback: fallback).clampedTo01
        }
        func loglerp(_ v: Double, fallback: Double) -> Double {
//                log(v) - logminimum
            logd != 0 ? (log(logoffset + v) - logminimum) / logd : fallback
        }
        func loglerp01(_ v: Double, fallback: Double) -> Double {
            loglerp(v, fallback: fallback).clampedTo01
        }
        
        func lerp01(logarithmic: Bool, _ v: Double, fallback: Double) -> Double {
            logarithmic ? loglerp01(v, fallback: fallback) : lerp01(v, fallback: fallback)
        }

    }

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
    
    static let formatterAsInteger : NumberFormatter = {
        let r = NumberFormatter.init()
        r.usesGroupingSeparator = true
        r.groupingSeparator = ","
        r.groupingSize = 3
        r.maximumFractionDigits = 0
        return r
    }()
    
    var withAbbreviationAsString : String {
        self.asInt64.formatWithAbbrevationAsString
    }
        //    var withAbbreviationAsAttributedString : String {
        //        self.asInt64.formatWithAbbrevation
        //    }
    
    var format0 : String { self == 0 ? "0" : Self.formatterAsInteger.string(from: self.asUInt64 as NSNumber) ?? "?" } //NSString(format: "%U", self.asUInt64) as String }
    
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
    
    var formatDynamic : String {
        let ABS = self.abs
        return ABS.floor == ABS ? self.asInt.asString : ABS > 10 ? self.format2 : ABS > 1 ? self.format3 : self.formatted4
    }
    var percent0 : String { self == 0 ? "0%" : NSString(format: "%.0f%%", self * 100.0) as String }
    var percent1 : String { self == 0 ? "0.0%" : NSString(format: "%.1f%%", self * 100.0) as String }
    var percent2 : String { self == 0 ? "0.00%" : NSString(format: "%.2f%%", self * 100.0) as String }
    
    var formatted4 : String {
        guard isNormal else {
            return isNaN ? "NaN" : isInfinite ? "oo" : "?"
        }
        if asInt64.asDouble == self {
            if #available(iOS 15.0, *) {
                return asInt64.formatted()
            } else {
                    // Fallback on earlier versions
                return asInt64.asString
            }
        }
        let r = format4
        for i in 0..<r.count {
            let i = r.count - 1 - i
            if r[i] == "." {
                return r.substring(0..<i).asString
            } else if r[i] != "0" {
                return r.substring(0...i).asString
            }
        }
        return r
    }
    
}

public extension Double {

    func percent(of: Double, fallback: Double) -> Double {
        guard isNormal else { return fallback }
        guard of.isNormal else { return fallback }
        guard of != 0 else { return fallback }
        return ((self - of) / of) * 100.0
    }

    func percent(of: Double) -> Double? {
        guard isNormal else { return nil }
        guard of.isNormal else { return nil }
        guard of != 0 else { return nil }
        return ((self - of) / of) * 100.0
    }

    func percentInverted(of: Double, fallback: Double) -> Double {
        of.percent(of: self, fallback: fallback)
    }

    func percentInverted(of: Double) -> Double? {
        of.percent(of: self)
    }

    func ratio(of: Double, fallback: Double) -> Double {
        guard isNormal else { return fallback }
        guard of.isNormal else { return fallback }
        guard of != 0 else { return fallback }
        return self / of
    }
    
    func ratio(of: Double) -> Double? {
        guard isNormal else { return nil }
        guard of.isNormal else { return nil }
        guard of != 0 else { return nil }
        return self / of
    }

    func ratioInverted(of: Double, fallback: Double) -> Double {
        guard isNormal else { return fallback }
        guard of.isNormal else { return fallback }
        guard of != 0 else { return fallback }
        return 1.0 - (self / of)
    }
    
    func ratioInverted(of: Double) -> Double? {
        guard isNormal else { return nil }
        guard of.isNormal else { return nil }
        guard of != 0 else { return nil }
        return 1.0 - (self / of)
    }

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
    
    var percent1 : String { self == 0 ? "0.0%" : NSString(format: "%.1f%%", self * 100.0) as String }
    var percent2 : String { self == 0 ? "0.00%" : NSString(format: "%.2f%%", self * 100.0) as String }

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
    var asInt64         : Int64 { Int64(self) }
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
    
    var formatted4 : String {
        if asInt64.asFloat == self {
            if #available(iOS 15.0, *) {
                return asInt64.formatted()
            } else {
                    // Fallback on earlier versions
                return asInt64.asString
            }
        }
        let r = format4
        for i in 0..<r.count {
            let i = r.count - 1 - i
            if r[i] == "." {
                return r.substring(0..<i).asString
            } else if r[i] != "0" {
                return r.substring(0...i).asString
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
        if self > 0 {
            let limit = self
            for _ in 1...limit {
                block()
            }
        }
    }

    func loop(_ block: (Int)->()) {
        if self > 0 {
            let limit = self
            for index in 1...limit {
                block(index)
            }
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

    func fractionOfCount(n: Int, _ fallback: Double = 0) -> Double {
        self > 1 ? n.asDouble / (self - 1).asDouble : fallback
    }
    func fractionOf(n: Int, _ fallback: Double = 0) -> Double {
        self > 0 ? n.asDouble / self.asDouble : fallback
    }
    func fractionOf1(_ fallback: Double = 0) -> Double {
        fractionOf(n: 1, fallback)
    }
    
    var asEnumerationArray : [Int] {
        self > 0 ? .init(0..<self) : []
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
    
    var range : Range<Int> {
        0..<abs(self)
    }
    
    @discardableResult
    mutating func advance(by n:Int) -> Int {
        self = self + n
        return self
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
    
    var asFloat         : Float         { Float(self) }
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
public extension UInt {
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







class NumericInterval<NUMBER : Numeric & Comparable> {
    
    internal init(lowerbound: NUMBER, upperbound: NUMBER) {
        self.lowerbound = lowerbound
        self.upperbound = upperbound
    }
    
    internal init(_ lowerbound: NUMBER, _ upperbound: NUMBER) {
        self.lowerbound = lowerbound
        self.upperbound = upperbound
    }
    
    func contains(_ other: NUMBER) -> Bool { false }
    
    var lowerbound : NUMBER
    var upperbound : NUMBER
}

class NumericIntervalOpenOpen<NUMBER: Numeric & Comparable> : NumericInterval<NUMBER> {
    
    override func contains(_ other: NUMBER) -> Bool {
        lowerbound < other && other < upperbound
    }
    
}

class NumericIntervalOpenClosed<NUMBER: Numeric & Comparable> : NumericInterval<NUMBER> {
    
    override func contains(_ other: NUMBER) -> Bool {
        lowerbound < other && other <= upperbound
    }
    
}

class NumericIntervalClosedClosed<NUMBER: Numeric & Comparable> : NumericInterval<NUMBER> {
    
    override func contains(_ other: NUMBER) -> Bool {
        lowerbound <= other && other <= upperbound
    }
    
}

class NumericIntervalClosedOpen<NUMBER: Numeric & Comparable> : NumericInterval<NUMBER> {
    
    override func contains(_ other: NUMBER) -> Bool {
        lowerbound <= other && other < upperbound
    }
    
}






public func minmax<T: Comparable>(_ a: T, _ b: T) -> (min: T, max: T) {
    a < b ? (a,b) : (b,a)
}

public func minmaxOnOptionals<T: Comparable>(_ a: T?, _ b: T?) -> (min: T?, max: T?) {
    if let a {
        if let b {
            return a < b ? (a,b) : (b,a)
        }
        return (b,a)
    }
    return (a,b)
}

public func orderedUp<T: Comparable>(_ a: T, _ b: T) -> (min: T, max: T) {
    a < b ? (a,b) : (b,a)
}

public func orderedDown<T: Comparable>(_ a: T, _ b: T) -> (min: T, max: T) {
    a < b ? (b,a) : (a,b)
}






public extension Int {
    
    var roman : String
    {
        let decimals = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var result = ""
        var number = self
        
        while number > 0
        {
            for (index, decimal) in decimals.enumerated()
            {
                if number - decimal >= 0 {
                    number -= decimal
                    result += numerals[index]
                    break
                }
            }
        }
        
        return result
    }
}

