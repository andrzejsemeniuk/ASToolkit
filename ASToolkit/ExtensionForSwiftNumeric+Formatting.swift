//
//  ExtensionForSwiftNumeric+Formatting.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2026-01-04.
//  Copyright © 2026 Andrzej Semeniuk. All rights reserved.
//

import Foundation


nonisolated
public extension Double {
    
    var formatWithValueAbbrevation23WithoutSpaceAsString : String {
        formatAbbreviated(precisionAbbreviated: 2, precisionUnabbreviated: 3, space: "")
    }
    
    var formatWithValueAbbrevation23WithSpaceAsString : String {
        formatAbbreviated(precisionAbbreviated: 2, precisionUnabbreviated: 3, space: " ")
    }
    
    var formatWithValueAbbrevation13WithSpaceAsString : String {
        formatAbbreviated(precisionAbbreviated: 1, precisionUnabbreviated: 3, space: " ")
    }
    
        /// Abbreviate the double using K, M, B, T, P, E suffixes.
        /// - Parameters:
        ///   - precisionAbbreviated: Number of decimal places to keep when an abbreviation suffix is used.
        ///   - precisionUnabbreviated: Number of decimal places to keep when no abbreviation is used.
        ///   - thousand: The suffix for thousands (default "K").
        ///   - million: The suffix for millions (default "M").
        ///   - billion: The suffix for billions (default "B").
        ///   - trillion: The suffix for trillions (default "T").
        ///   - peta: The suffix for peta (default "P").
        ///   - exa: The suffix for exa (default "E").
        /// - Returns: A human-readable abbreviated string, e.g., 1234.56 -> "1.23K" when precisionAbbreviated is 2.
    func formatAbbreviated(
        precisionAbbreviated: Int,
        precisionUnabbreviated: Int,
        space: String = " ",
        thousand: String = "K",
        million: String = "M",
        billion: String = "B",
        trillion: String = "T",
        peta: String = "P",
        exa: String = "E"
    ) -> String {
        let rules: [AbbreviationRule] = [
            .init(threshold: 1_000, divisor: 1_000, suffix: thousand),
            .init(threshold: 1_000_000, divisor: 1_000_000, suffix: million),
            .init(threshold: 1_000_000_000, divisor: 1_000_000_000, suffix: billion),
            .init(threshold: 1_000_000_000_000, divisor: 1_000_000_000_000, suffix: trillion),
            .init(threshold: 1_000_000_000_000_000, divisor: 1_000_000_000_000_000, suffix: peta),
            .init(threshold: 1_000_000_000_000_000_000, divisor: 1_000_000_000_000_000_000, suffix: exa),
        ]
        let style = NumberAbbreviationStyle(
            abbreviatedFractionDigits: precisionAbbreviated,
            plainFractionDigits: precisionUnabbreviated,
            includeSpaceBeforeSuffix: !space.isEmpty,
            abbreviations: [.init(threshold: 0, divisor: 1, suffix: "")] + rules,
            locale: .current
        )
        return formatNumber(self, style: style)
    }
    
        /// Convenience alias similar to Int.formatAsBigNumber.
        /// Defaults to 2 decimal places for abbreviated and 2 for unabbreviated values.
    var formatAsBigNumber: String {
        formatAbbreviated(precisionAbbreviated: 2, precisionUnabbreviated: 2)
    }
    
    
    
        /// Returns only the abbreviation suffix (e.g., "k", "M", "B", "T") used by
        /// `formatWithFinancialValueAbbrevation`, or an empty string when no suffix applies.
    var financialValueAbbreviationSuffix: String {
        let absValue = self.abs
        if absValue >= 1_000_000_000_000 { // Trillion
            return "T"
        }
        if absValue >= 1_000_000_000 { // Billion
            return "B"
        }
        if absValue >= 1_000_000 { // Million
            return "M"
        }
        if absValue >= 1_000 { // Thousand
            return "k"
        }
        return ""
    }
    
    
}


nonisolated
public extension Double {
    
    static let formatterWithGrouping2: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.usesGroupingSeparator = true
        f.groupingSize = 3
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.locale = .current
        return f
    }()

    var format1g: String { self == 0 ? "0.0" : Self.formatterWithGrouping2.string(from: NSNumber(value: self)) ?? String(format: "%.1f", self) }
    var format2g: String { self == 0 ? "0.00" : Self.formatterWithGrouping2.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self) }
    var format3g: String { self == 0 ? "0.000" : Self.formatterWithGrouping2.string(from: NSNumber(value: self)) ?? String(format: "%.3f", self) }
    var format4g: String { self == 0 ? "0.0000" : Self.formatterWithGrouping2.string(from: NSNumber(value: self)) ?? String(format: "%.4f", self) }

    static let formatterAsInteger : NumberFormatter = {
        let r = NumberFormatter.init()
        r.usesGroupingSeparator = true
        r.groupingSeparator = ","
        r.groupingSize = 3
        r.maximumFractionDigits = 0
        return r
    }()
    
    var format0 : String { self == 0 ? "0" : NSString(format: "%.0f", self) as String }
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
    
    func format01234(_ zero: Double, _ one: Double, _ two: Double, _ three: Double) -> String {
        if self.abs > zero {
            return self.format0
        }
        if self.abs > one {
            return self.format1
        }
        if self.abs > two {
            return self.format2
        }
        if self.abs > three {
            return self.format3
        }
        return self.format4
    }
    
    var formatForStockPrice : String {
        format01234(1000, 1000, 1, 1)
    }
    
    var formatDynamic : String {
        let ABS = self.abs
        return ABS.floor == ABS ? self.asInt.asString : ABS > 10 ? self.format2 : ABS > 1 ? self.format3 : self.formatted4
    }
    var percent0 : String { self == 0 ? "0%" : NSString(format: "%.0f%%", self * 100.0) as String }
    var percent1 : String { self == 0 ? "0.0%" : NSString(format: "%.1f%%", self * 100.0) as String }
    var percent2 : String { self == 0 ? "0.00%" : NSString(format: "%.2f%%", self * 100.0) as String }
    
    var formatted4 : String {
        if self == 0 {
            return "0"
        }
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










nonisolated
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




public extension Float {
    
//    var format0 : String { self == 0 ? "0" : self.asInt.formatted() }
    var format0 : String { self == 0 ? "0" : NSString(format: "%.0f", self) as String }
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







nonisolated
public extension Int {
    
    var formatp         : String        { NSString(format: "%+d", self) as String }

    
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
        self.asDouble.formatWithValueAbbrevation23WithoutSpaceAsString
    }
    
    var formatWithAbbrevationWithSpaceAsString : String {
        self.asDouble.formatWithValueAbbrevation23WithSpaceAsString
    }
    
    var formatWithAbbrevationAsMarkdownString : String {
        let S = formatWithAbbrevationAsString
        if let last = S.last, last.isLetter {
            return S[0..<S.count-1] + "**\(last)**"
        }
        return S
    }
    
        /// Formats the integer as a financial value with abbreviation suffixes.
        /// - Parameter includeSpace: When true, inserts a single space before the suffix (e.g., "1.2 M"). When false, no space (e.g., "1.2M").
        /// - Returns: A formatted string.
    func formatWithFinancialValueAbbrevation(includeSpace: Bool) -> String {
        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let rules: [AbbreviationRule] = [
            .init(threshold: 0, divisor: 1, suffix: ""),
            .init(threshold: 1_000, divisor: 1_000, suffix: "k"),
            .init(threshold: 1_000_000, divisor: 1_000_000, suffix: "M"),
            .init(threshold: 1_000_000_000, divisor: 1_000_000_000, suffix: "B"),
            .init(threshold: 1_000_000_000_000, divisor: 1_000_000_000_000, suffix: "T"),
        ]
        let style = NumberAbbreviationStyle(
            abbreviatedFractionDigits   : 2,
            plainFractionDigits         : 0,
            includeSpaceBeforeSuffix    : includeSpace,
            abbreviations               : rules,
            locale                      : .current
        )
        return formatNumber(self.asDouble, style: style)
    }
    
    var formatWithFinancialValueAbbrevationAsString : String {
        formatWithFinancialValueAbbrevation(includeSpace: false)
    }
    
    var formatWithFinancialValueAbbrevationWithSpaceAsString : String {
        formatWithFinancialValueAbbrevation(includeSpace: true)
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





nonisolated
public extension Array where Element == Double {
    func asStringTuple(delimiter: String = ",") -> String { self.map { $0.format4 }.joined(separator: delimiter) }
    func asArrayOfString(_ delimiter: String = ",") -> String { asStringTuple(delimiter: delimiter) }
}


nonisolated
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








nonisolated
public extension Int {
    
    /// Abbreviate the integer using K, M, B, T, P, E suffixes.
    /// - Parameter precision: Number of decimal places to keep when abbreviated.
    /// - Parameter thousand: The suffix for thousands (default "K").
    /// - Parameter million: The suffix for millions (default "M").
    /// - Parameter billion: The suffix for billions (default "B").
    /// - Parameter trillion: The suffix for trillions (default "T").
    /// - Parameter peta: The suffix for peta (default "P").
    /// - Parameter exa: The suffix for exa (default "E").
    /// - Returns: A human-readable abbreviated string, e.g., 1_234 -> "1.23K" when precision is 2.
    func formatAbbreviated(
        precision: Int,
        space: String = " ",
        thousand: String = "K",
        million: String = "M",
        billion: String = "B",
        trillion: String = "T",
        peta: String = "P",
        exa: String = "E"
    ) -> String {
        // Handle zero quickly
        if self == 0 { return "0" }
        // Work with absolute value for magnitude and keep sign
        let sign = self < 0 ? "-" : ""
        let absValue = Double(Swift.abs(self))
        // Check thresholds from largest to smallest
        if absValue >= 1_000_000_000_000_000_000 { // Exa
            let value = absValue / 1_000_000_000_000_000_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + exa
        }
        if absValue >= 1_000_000_000_000_000 { // Peta
            let value = absValue / 1_000_000_000_000_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + peta
        }
        if absValue >= 1_000_000_000_000 { // Tera
            let value = absValue / 1_000_000_000_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + trillion
        }
        if absValue >= 1_000_000_000 { // Billion
            let value = absValue / 1_000_000_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + billion
        }
        if absValue >= 1_000_000 { // Million
            let value = absValue / 1_000_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + million
        }
        if absValue >= 1_000 { // Thousand
            let value = absValue / 1_000
            let formatted = value.formatted(.number.precision(.fractionLength(precision)))
            return sign + formatted + space + thousand
        }
        // No abbreviation needed
        return sign + Int(absValue).formatted()
    }

    /// Convenience alias used elsewhere in the codebase.
    /// Defaults to 2 decimal places when abbreviated.
    var formatAsBigNumber: String {
        formatAbbreviated(precision: 2)
    }
}

