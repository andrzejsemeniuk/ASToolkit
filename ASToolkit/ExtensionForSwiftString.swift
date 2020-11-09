//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

//import Foundation

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

extension String
{
    public subscript (safe i:Int) -> Substring? {
        return 0 <= i && i < self.count ? self[i] : nil
    }

    public subscript (i: Int) -> Substring {
        return self[i ..< i + 1]
    }
    
    public subscript (r: Range<Int>) -> Substring {
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[start..<end]
    }

    public func at(_ i: Int) -> String {
        let c = self[self.index(self.startIndex, offsetBy: i)]
        return String(c as Character)
    }

    public func character(at i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)] as Character
    }
    
    public func substring(from: Int) -> Substring {
        if from < 0 {
            return self[max(0, length + from) ..< length]
        }
        return self[min(from, length) ..< length]
    }
    
    public func substring(to: Int) -> Substring {
        if to < 0 {
            return self[0 ..< max(0, length + to)]
        }
        return self[0 ..< max(0, min(to, length))]
    }
    
    public func substring(from: UInt, to: UInt) -> Substring {
        return self[min(Int(from), length) ..< min(Int(to), length)]
    }

    public func substring(from:Int = 0, length:Int) -> Substring {
        if from < 0 {
            let f = max(0, length + from)
            let t = max(f,min(f + length, self.length))
            return self[f..<t]
        }
        return self[from..<max(from,from+length)]
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
    
    public func trimmedFromEndIfLongerThan(_ count:Int) -> Substring {
        if count < length {
            return substring(from:0,length:count)
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


extension String {

	public func matches(regex: String) -> Bool {
		return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	public func substring(regex: String) -> Substring? {
		if let range = self.range(of: regex, options: .regularExpression, range: nil, locale: nil) {
			return self[range]
			//			return self.substring(from: range.lowerBound.encodedOffset, to: range.upperBound.encodedOffset)
		}
		return nil
	}

	public func escaped() -> String {
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

extension Array where Element == String {
    
    public func split(span chars: Int) -> ([String],[String]) {
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

    public func lines(span chars: Int) -> [[String]] {
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
    
}

public extension String {

    func splitAndKeep(on: (Character)->Bool) -> [Substring] {
        var splits : [Substring] = []
        var i0 = 0
        for (index,c) in self.enumerated() {
            if on(c) && i0 < index {
                splits.append(self.substring(i0..<index))
                i0 = index
            }
        }
        if i0 < self.count-1 {
            splits.append(substring(i0..<count))
        }
        return splits
    }
    
}

public extension String {
    
    var asInt : Int? { Int(self) }
    
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
        asPhrase.splitAndKeep(on: { $0 == " "}).map {
            $0.capitalized
        }.joined(separator: " ")
    }
        
}



