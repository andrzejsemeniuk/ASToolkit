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
    public func subarray(_ index:Int = 0, length:Int) -> Array {
        if (length-index) < self.count {
            return Array(self[index..<length])
        }
        return self
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
