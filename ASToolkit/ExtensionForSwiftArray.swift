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

extension Array {
    static public func convertToInt(array:[Double]) -> [Int] {
        var result:[Int] = []
        array.forEach({ result.append(Int($0)) })
        return result
    }
    static public func convertToDouble(array:[Int]) -> [Double] {
        var result:[Double] = []
        array.forEach({ result.append(Double($0)) })
        return result
    }
    static public func convertToFloat(array:[Double]) -> [Float] {
        var result:[Float] = []
        array.forEach({ result.append(Float($0)) })
        return result
    }
    static public func convertToDouble(array:[Float]) -> [Double] {
        var result:[Double] = []
        array.forEach({ result.append(Double($0)) })
        return result
    }
    static public func convertToCGFloat(array:[Double]) -> [CGFloat] {
        var result:[CGFloat] = []
        array.forEach({ result.append(CGFloat($0)) })
        return result
    }
    static public func convertToDouble(array:[CGFloat]) -> [Double] {
        var result:[Double] = []
        array.forEach({ result.append(Double($0)) })
        return result
    }
    static public func convertToUInt32(array:[Character]) -> [UInt32] {
        var result:[UInt32] = []
        array.forEach({ result.append($0.unicodeScalarCodePoint) })
        return result
    }
}
