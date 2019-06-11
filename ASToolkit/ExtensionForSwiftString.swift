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
    public var substring : Substring {
        return Substring(self)
    }
    
    public var length: Int {
        return count
    }
    
    public var empty: Bool {
        return length < 1
    }
}

extension String
{
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    public var base64Encoded: String {
        let step1:NSString      = self as NSString
        let step2:Data        = step1.data(using: String.Encoding.utf8.rawValue)!
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
        return self[Range(i ..< i + 1)]
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
        return self[Range(min(from, length) ..< length)]
    }
    
    public func substring(to: Int) -> Substring {
        return self[Range(0 ..< min(to, length))]
    }
    
    public func substring(from: Int, to: Int) -> Substring {
        return self[Range(min(from, length) ..< min(to, length))]
    }

    public func substring(from:Int = 0, length:Int) -> Substring {
        return self[from..<max(from,from+length)]
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
        for c in characters {
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

}
