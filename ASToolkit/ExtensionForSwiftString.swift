//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension String
{
    public var asSubstring : Substring {
        return Substring(self)
    }
    
    public var length: Int {
        return count
    }
    
    public var empty: Bool {
        return length < 1
    }
    
    public var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension String
{
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    public var base64Encoded: String {
        let step1:NSString      = self as NSString
        let step2:Data          = step1.data(using: String.Encoding.utf8.rawValue)!
        let options             = Data.Base64EncodingOptions(rawValue: 0)
        let result:String       = step2.base64EncodedString(options: options)
        
        return result
    }
}

public extension String
{
    subscript (safe i:Int) -> Substring? {
        0 <= i && i < self.count ? self[i] : nil
    }

    subscript (i: Int) -> Substring {
        self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> Substring {
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[start..<end]
    }
    
        //    subscript(_ range: CountableRange<Int>) -> String {
        //        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        //        let end = index(start, offsetBy: min(self.count - range.lowerBound,
        //                                             range.upperBound - range.lowerBound))
        //        return String(self[start..<end])
        //    }

            subscript(_ range: CountablePartialRangeFrom<Int>) -> Substring {
                let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        //         return String(self[start...])
                return self[start...]
            }


    func at(_ i: Int) -> String {
        let c = self[self.index(self.startIndex, offsetBy: i)]
        return String(c as Character)
    }

    func character(at i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)] as Character
    }
    
    func substring(from: Int) -> Substring {
        if from < 0 {
            return self[max(0, length + from) ..< length]
        }
        return self[min(from, length) ..< length]
    }
    
    func substring(to: Int) -> Substring {
        if to < 0 {
            return self[0 ..< max(0, length + to)]
        }
        return self[0 ..< max(0, min(to, length))]
    }
    
    func substring(from: UInt, to: UInt) -> Substring {
        return self[min(Int(from), length) ..< min(Int(to), length)]
    }

    func substring(from:Int = 0, length:Int) -> Substring {
        if from < 0 {
            let f = max(0, length + from)
            let t = max(f,min(f + length, self.length))
            return self[f..<t]
        }
        return self[from..<max(from,from+length)]
    }
    
}

public extension StringProtocol {
    var asBits : [Bool] {
        self.map { $0 == "0" ? false : true }
    }
    var asString : String {
        String(self)
    }
}



public protocol Stringable {
    static func from(string: String) -> Self?
}


public extension String {
    
    func parse<Type0: Stringable>(_ pattern: String) -> Type0? {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: []) else {
            return nil
        }
        let result = regex.matches(in: self, options: [], range: NSMakeRange(0,count))
        guard let a = result[safe:0] else { return nil }
        let b = self[a.range.lowerBound..<a.range.upperBound]
        return Type0.from(string: String(b))
    }
    
    func parse<Type0: Stringable, Type1: Stringable>(_ pattern: String) -> (Type0?,Type1?) {
        var r : (Type0?,Type1?) = (nil,nil)
        if let regex = try? NSRegularExpression.init(pattern: pattern, options: []) {
            let result = regex.matches(in: self, options: [], range: NSMakeRange(0,count))
            if let a = result[safe:0] {
                let b = self[a.range.lowerBound..<a.range.upperBound]
                r.0 = Type0.from(string: String(b))
            }
            if let a = result[safe:1] {
                let b = self[a.range.lowerBound..<a.range.upperBound]
                r.1 = Type1.from(string: String(b))
            }
        }
        return r
    }
    
    func parse<Type0: Stringable, Type1: Stringable, Type2: Stringable>(_ pattern: String) -> (Type0?,Type1?,Type2?) {
        var r : (Type0?,Type1?,Type2?) = (nil,nil,nil)
        if let regex = try? NSRegularExpression.init(pattern: pattern, options: []) {
            let result = regex.matches(in: self, options: [], range: NSMakeRange(0,count))
            if let a = result[safe:0] {
                let b = self[a.range.lowerBound..<a.range.upperBound]
                r.0 = Type0.from(string: String(b))
            }
            if let a = result[safe:1] {
                let b = self[a.range.lowerBound..<a.range.upperBound]
                r.1 = Type1.from(string: String(b))
            }
            if let a = result[safe:2] {
                let b = self[a.range.lowerBound..<a.range.upperBound]
                r.2 = Type2.from(string: String(b))
            }
        }
        return r
    }
    
    func parse<Type0: Stringable, Type1: Stringable, Type2: Stringable>(_ pattern: String, _ out0: inout  Type0?, _ out1: inout Type1?, _ out2: inout Type2?) -> Bool {
        var r = false
        if let regex = try? NSRegularExpression.init(pattern: pattern, options: []) {
            guard let result = regex.matches(in: self, options: [], range: NSMakeRange(0,count)).first else { return r }
            var got = 0
            let found : [String] = Array(0...result.numberOfRanges-1).map {
                let range = result.range(at: $0)
                return self[range.lowerBound..<range.upperBound].asString
            }
            print("\(self) -> |\(result.numberOfRanges)| \(found)")
            if result.numberOfRanges > 1 {
                let a = result.range(at: 1)
                let b = self[a.lowerBound..<a.upperBound]
//                print(" found \(b)")
                out0 = Type0.from(string: String(b))
                got += out0 != nil ? 1 : 0
            }
            if result.numberOfRanges > 2 {
                let a = result.range(at: 2)
                let b = self[a.lowerBound..<a.upperBound]
//                print(" found \(b)")
                out1 = Type1.from(string: String(b))
                got += out1 != nil ? 1 : 0
            }
            if result.numberOfRanges > 3 {
                let a = result.range(at: 3)
                let b = self[a.lowerBound..<a.upperBound]
//                print(" found \(b)")
                out2 = Type2.from(string: String(b))
                got += out2 != nil ? 1 : 0
            }
            r = got == 3
        }
        return r
    }

}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
     }

     func appendToURL(fileURL: URL) throws {
         let data = self.data(using: String.Encoding.utf8)!
         try data.append(fileURL: fileURL)
     }
 }

public extension String {
    
    func substring(_ i: Int) -> Substring {
      let idx1 = index(startIndex, offsetBy: i)
      let idx2 = index(idx1, offsetBy: 1)
      return self[idx1..<idx2]
    }

    func substring(_ r: Range<Int>) -> Substring {
      let start = index(startIndex, offsetBy: r.lowerBound)
      let end = index(startIndex, offsetBy: r.upperBound)
      return self[start ..< end]
    }

    func substring(_ r: CountableClosedRange<Int>) -> Substring {
      let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
      let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
      return self[startIndex...endIndex]
    }
    
    func substring(_ r: PartialRangeFrom<Int>) -> Substring {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        return self[startIndex..<self.endIndex]
    }

}


extension String
{
    public func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func trimIfBeyondDigitCount(_ count:Int) -> Substring {
        var count = count
        let digits:Set<Character> = ["0","1","2","3","4","5","6","7","8","9"]
        var i = 0
        for c in self {
            i = i+1
            if digits.contains(c) {
                count = count-1
                if count <= 0 {
                    return substring(from:0,length:i)
                }
            }
        }
        return Substring(self)
    }
    
    public func prefixWithPlusIfPositive() -> String
    {
        if 0 < length && self[0] != "-" {
            return "+" + self
        }
        return self
    }
    
    public func trimmedFromEndIfLongerThan(_ count:Int, withSuffix: String = "") -> Substring {
        if count < length {
            return substring(from:0,length:count) + withSuffix
        }
        return Substring(self)
    }
    
}

extension String {
    
    static public func pad<T:CustomStringConvertible>(_ value:T,eat:String) -> String {
        let r = String(describing: value)
        if r.length < eat.length {
            return eat.substring(to: eat.length - r.length) + r
        }
        return r
    }
    
    static public func pad<T:CustomStringConvertible>(_ value:T,_ spaces:Int) -> String {
        return pad(value,eat:String(repeating:" ",count:spaces))
    }
    
}

extension String {
    
    public func split(_ delimiter:String) -> [String] {
        return self.components(separatedBy: delimiter)
    }
 
    public func countOf(substring:String) -> Int {
        return split(substring).count-1
    }
    
    public func countOf0(substring:String) -> Int {
        var r = 0
        var i = 0
        let limit = self.length - substring.length + 1
        while i < limit {
            var j = i
            var match = true
            while j < substring.length {
                if self[i+j] != substring[j] {
                    match = false
                    break
                }
                j += 1
            }
            if match {
                r += 1
                i = j + 1
            }
            else {
                i += 1
            }
        }
        return r
    }
    
    public func countOf(character: Character) -> Int {
        self.reduce(0, { $0 + ($1 == character ? 1 : 0) })
    }
}

extension String {
    
    public func capitalized() -> String {
        if 0 < length {
            return self[0].uppercased() + self.substring(from: 1)
        }
        return self
    }
    
    public func tweened(with:String = " ") -> Substring {
        var result = self.substring(to: 1)
        for i in stride(from:1,to:length,by:1) {
            result += with + self[i]
        }
        return result
    }
}

extension String {
    
    public func appended(with:String, delimiter:String) -> String {
        if isEmpty {
            return with
        }
        else if with.isEmpty {
            return self
        }
        else {
            return "\(self)\(delimiter)\(with)"
        }
    }

}

//public extension Range {
//
//    var distance : Int {
//        self.endIndex - self.startIndex
//    }
//}

public extension String {

    func index(at: Int) -> Index {
        index(startIndex, offsetBy: at)
    }
    
    func indexDistance(to: Index) -> Int {
        distance(from: startIndex, to: to)
    }
    
    func matches(regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

	func matches(regex: String?) -> Bool {
        regex == nil ? true : matches(regex: regex!)
	}

	func substring(regex: String) -> Substring? {
		if let range = self.range(of: regex, options: .regularExpression, range: nil, locale: nil) {
			return self[range]
			//			return self.substring(from: range.lowerBound.encodedOffset, to: range.upperBound.encodedOffset)
		}
		return nil
	}

    func replacing(regex: String, with: (Substring)->String) -> String {
        var r = ""
        var i = 0
        while let range = self.range(of: regex, options: .regularExpression, range: index(at: i)..<endIndex, locale: nil) {
            r += self.substring(from: UInt(i), to: indexDistance(to: range.lowerBound).magnitude)
            i = indexDistance(to: range.upperBound)
            r += with(self[range])
        }
        if index(at: i) < endIndex {
            r += self.substring(from: i)
        }
        return r
    }

	func escaped() -> String {
		var r = ""
		for (_,char) in self.enumerated() {
			r += "\\\(char)"
		}
		return r
	}
}

//extension String {
//
//	public func ends(with: String) -> Bool {
//		return matches(regex: ".*\(with.escaped())$")
//	}
//
//}

extension String {
    
    public func mismatches(with: String, upto: Int = 0) -> [Int] {
        
        let limit = upto > 0 ? max(0,min(upto,min(length,with.length))) : max(0,min(length,with.length))
        
        var r : [Int] = []
        
        for i in 0..<limit {
            if self[i] != with[i] {
                r.append(i)
            }
        }
        
        return r
    }
    
}


extension String {
    
    public func partitioned(by: (Int,Character)->Bool) -> [Substring] {
        var r : [Substring] = []
        var i = 0
        for (j,c) in self.enumerated() {
            if by(j,c) {
                if i < j {
                    r.append(self[i..<j])
                    i = j
                }
            }
        }
        if i < count {
            r.append(self[i..<count])
        }
        return r
    }
}

extension String {
    
    public func uniqued() -> String {
        String(Set<Character>(self))
    }
    
}

public extension Array where Element == String {
    
    func split(span chars: Int) -> ([String],[String]) {
        var length = 0
        for (index,word) in self.enumerated() {
            if word.length + length <= chars {
                length += word.length
            } else if index == 0 {
                return ([word], (index+1) < self.count ? Array(self[index+1..<self.count]) : [])
            } else {
                return (Array(self[0..<index]), index < self.count ? Array(self[index..<self.count]) : [])
            }
        }
        return (self,[])
    }

    func lines(span chars: Int) -> [[String]] {
        var words = self
        var r : [[String]] = []
        while true {
            let (a,b) = words.split(span: chars)
            if a.isEmpty {
                break
            }
            r.append(a)
            if b.isEmpty {
                break
            }
            words = b
        }
        return r
    }
    
    func joined(_ transform: (String)->String, separator: String = ",") -> String {
        map { transform($0) }.joined(separator: separator)
    }
    var cqq : String {
        joined({ $0.qq })
    }
    
    var joinedByNothing : String {
        self.joined(separator: "")
    }
    var joinedByComma : String {
        self.joined(separator: ",")
    }
    var joinedBySpace : String {
        self.joined(separator: " ")
    }
    var joinedByPipe : String {
        self.joined(separator: "|")
    }
    var joinedByNewline : String {
        self.joined(separator: "\n")
    }

}

public extension String {

    func split(on: (Character)->Bool) -> [Substring] {
        var indexes : [Int] = [0]
        for (index,c) in self.enumerated() {
            if on(c) {
                indexes.append(index)
            }
        }
        indexes.append(count)
        
        if indexes[safe: 1] == 0 {
            indexes.removeFirst()
        }

        var splits : [Substring] = []

        indexes.forEachAdjacent() { from,to in
            splits.append(self.substring(from: from.asUInt, to: to.asUInt))
        }
        
        return splits
    }
    
    var splitByComma : [String] {
        split(",")
    }
    var splitByDash : [String] {
        split("-")
    }
    var splitByColon : [String] {
        split(":")
    }
    var splitByPipe : [String] {
        split("|")
    }
    var splitBySlash : [String] {
        split("/")
    }
    var splitByNewline : [String] {
        split("\n")
    }
}

public extension String {
    
    var  asFloat   :  Float?   { Float(self) }
    var  asDouble  :  Double?  { Double(self) }
    var  asCGFloat :  CGFloat? { CGFloat(self) }
    var  asInt     :  Int?     { Int(self) }
    var  asUInt    :  UInt?    { UInt(self) }
    var  asUInt64  :  UInt64?  { UInt64(self.replacingOccurrences(of:  ",",  with:  "")) }
    
    var asPhrase : String {
//        self.splitAndKeep(on: { $0.isUppercase || $0.isWhitespace })
        var r : String = ""
        var spaces = 0
        for c in self {
            if c.isUppercase {
                if r.isNotEmpty {
                    r.append(" ")
                }
                r.append(c)
                continue
            } else if c.isWhitespace {
                spaces += 1
                continue
            } else if spaces > 0 {
                spaces = 0
                r.append(" ")
            }
            r.append(c)
        }
        return r
    }
    
    var asCapitalizedWords : String {
        asPhrase.split(on: { $0 == " "}).map {
            $0.capitalized
        }.joined(separator: " ")
    }
    
    func surrounded(by: String) -> Self {
        "\(by)\(self)\(by)"
    }
        
    var doublequoted : Self {
        surrounded(by: "\"")
    }
    var dquoted : Self { doublequoted }
    var dq : Self { doublequoted }
    var qq : Self { doublequoted }

    var singlequoted : Self {
        surrounded(by: "'")
    }
    var squoted : Self { singlequoted }
    var sq : Self { singlequoted }

    var bracketed : Self {
        "[\(self)]"
    }

    var sp1 : Self { surrounded(by: " ")}
    var sp2 : Self { surrounded(by: "  ")}
    var sp3 : Self { surrounded(by: "   ")}
}


public extension String {
    
    func acronym(delimiter: String = " ", join: String = "") -> String {
        split(delimiter).map { String($0).trimmed()[safe: 0] }.compactMap { $0 }.joined(separator: join)
    }
    
}

public extension String {
    
    func repeating(_ count: Int) -> Self {
        Array<String>.init(repeating: self, count: count).joined()
    }
    
}

public extension String {
    
    var asBytes     : [UInt8]   { .init(self.utf8) }
    var asData      : Data      { asDataUTF8 }
    var asDataUTF8  : Data      { .init(utf8) }

}

public extension String {
    
    var formatterForDate : DateFormatter {
        let r = DateFormatter()
        r.dateFormat = self //format //"yyyy.MM.dd"
        return r
    }

}

public extension String {
    mutating func assignIf(_ condition0: Bool, _ value0: String, _ condition1: Bool? = nil, _ value1: String? = nil, _ otherwise: String) {
        if condition0 {
            self = value0
        } else if let condition1, let value1, condition1 {
            self = value1
        } else {
            self = otherwise
        }
    }
}

public extension String {

    func removingCharacters(in forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removingCharacters(in string: String) -> String {
        return removingCharacters(in: CharacterSet(charactersIn: string))
    }
}

public extension String {
    
    var characters : [Character] {
        map { $0 }
    }
    
}


// https://forums.swift.org/t/string-extension-with-full-subscript-support/35498
public extension String {
    
    /**
     Enables passing in negative indices to access characters
     starting from the end and going backwards.
     if num is negative, then it is added to the
     length of the string to retrieve the true index.
     */
    func negativeIndex(_ num: Int) -> Int {
        return num < 0 ? num + self.count : num
    }
    
    func strOpenRange(index i: Int) -> Range<String.Index> {
        let j = negativeIndex(i)
        return strOpenRange(j..<(j + 1), checkNegative: false)
    }
    
    func strOpenRange(
        _ range: Range<Int>, checkNegative: Bool = true
    ) -> Range<String.Index> {

        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let idx1 = index(self.startIndex, offsetBy: lower)
        let idx2 = index(self.startIndex, offsetBy: upper)
        
        return idx1..<idx2
    }
    
    func strClosedRange(
        _ range: CountableClosedRange<Int>, checkNegative: Bool = true
    ) -> ClosedRange<String.Index> {
        
        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let start = self.index(self.startIndex, offsetBy: lower)
        let end = self.index(start, offsetBy: upper - lower)
        
        return start...end
    }
    
    // MARK: - Subscripts
    
    /**
     Gets and sets a character at a given index.
     Negative indices are added to the length so that
     characters can be accessed from the end backwards
     
     Usage: `string[n]`
     */
//    subscript(_ i: Int) -> String {
//        get {
//            return String(self[strOpenRange(index: i)])
//        }
//        set {
//            let range = strOpenRange(index: i)
//            replaceSubrange(range, with: newValue)
//        }
//    }
    
    
    /**
     Gets and sets characters in an open range.
     Supports negative indexing.
     
     Usage: `string[n..<n]`
     */
//    subscript(_ r: Range<Int>) -> String {
//        get {
//            return String(self[strOpenRange(r)])
//        }
//        set {
//            replaceSubrange(strOpenRange(r), with: newValue)
//        }
//    }

    /**
     Gets and sets characters in a closed range.
     Supports negative indexing
     
     Usage: `string[n...n]`
     */
    subscript(_ r: CountableClosedRange<Int>) -> String {
        get {
            return String(self[strClosedRange(r)])
        }
        set {
            replaceSubrange(strClosedRange(r), with: newValue)
        }
    }
    
    /// `string[n...]`. See PartialRangeFrom
    subscript(r: PartialRangeFrom<Int>) -> String {
        
        get {
            return String(self[strOpenRange(r.lowerBound..<self.count)])
        }
        set {
            replaceSubrange(strOpenRange(r.lowerBound..<self.count), with: newValue)
        }
    }
    
    /// `string[...n]`. See PartialRangeThrough
    subscript(r: PartialRangeThrough<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strClosedRange(0...upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strClosedRange(0...upper, checkNegative: false), with: newValue
            )
        }
    }
    
    /// `string[...<n]`. See PartialRangeUpTo
    subscript(r: PartialRangeUpTo<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[strOpenRange(0..<upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            replaceSubrange(
                strOpenRange(0..<upper, checkNegative: false), with: newValue
            )
        }
    }


}

public extension String {    
    
    var last8characters : String {
        last(characters: 8)
    }
    
    var last12characters : String {
        last(characters: 12)
    }
    
    var last16characters : String {
        last(characters: 16)
    }
    
    func last(characters limit: Int) -> String {
        length < (limit + 1) ? self : String(self.characters.trimmed(to: length - limit))
    }

}

public extension String {
    
    func asArrayOfInt(delimiter: String = ",") -> [Int] {
        split(delimiter).compactMap { Int($0) }
    }
    func asArrayOfDouble(delimiter: String = ",") -> [Double] {
        split(delimiter).compactMap { Double($0) }
    }

}

