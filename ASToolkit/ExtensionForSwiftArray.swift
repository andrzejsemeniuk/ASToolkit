//
//  ExtensionForSwiftArray.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Array
{
    public mutating func trim(to:Int) -> Array {
        let to = Swift.min(to,count)
        let result = subarray(from:to, length:count-to)
        let range = startIndex.advanced(by: to)..<endIndex
        self.removeSubrange(range)
        return result
    }
    
    public func subarray(from:Int, to:Int) -> Array {
        var result = [Element]()
        for i in stride(from:Swift.max(0,Swift.min(count,from)), to:Swift.max(0,Swift.min(count, to)), by:1) {
            result.append(self[i])
        }
        return result
    }
    
    public func subarray(from:Int, length:Int) -> Array {
        return subarray(from:from, to:from+length)
    }
    
    public subscript (safe i:Int) -> Array.Element? {
        return 0 <= i && i < self.count ? self[i] : nil
    }
}


extension Array where Element == Character {
    
    public var asArrayOfUInt32      : [UInt32]      { return self.map { $0.unicodeScalarCodePoint } }
    
}


extension Array where Element == Int {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }

}


extension Array where Element == Float {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}


extension Array where Element == CGFloat {
    
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}


extension Array where Element == Double {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}
