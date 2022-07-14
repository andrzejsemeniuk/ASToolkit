//
//  Attributes.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 11/24/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif

public struct Attributes {
    
    
    public var title        : String?
    
    public var dictionary   : [String : String]                     = [:]
    
    
    public init(title: String? = nil, dictionary: [String : String] = [:]) {
        self.title = title
        self.dictionary = dictionary 
    }

    
    public func merged(from dictionary: [String : String]?) -> Attributes {
        dictionary == nil ? self : Attributes.init(dictionary: self.dictionary.merging(dictionary!, uniquingKeysWith: { s0, s1 in s1 }))
    }
    
    public func merged(into dictionary: [String : String]?) -> Attributes {
        dictionary == nil ? self : Attributes.init(dictionary: self.dictionary.merging(dictionary!, uniquingKeysWith: { s0, s1 in s0 }))
    }
    

    public func merged(from attributes: Attributes?) -> Attributes {
        attributes == nil ? self : merged(from: attributes!)
    }
    
    public func merged(into attributes: Attributes?) -> Attributes {
        attributes == nil ? self : merged(into: attributes!)
    }
    

    public func asColor(_ name: String) -> Color? {
        if let value = dictionary[name] {
            return Self.toColor(hsba: value)
        }
        return nil
    }
    
    
    public func asHSBAArrayOfDouble(_ name: String) -> [Double]? {
        if let hsba = dictionary[name] {
            return Self.toArrayOfDouble(hsba: hsba)
        }
        return nil
    }
    
    public func asHSBAArrayOfDouble(_ name: String, _ fallback: [Double]) -> [Double] {
        asHSBAArrayOfDouble(name) ?? fallback.padded(with: 1, upto: 4)
    }

    
    public func asColorHSBA(_ name: String) -> Color.HSBA? {
        if let hsba = asHSBAArrayOfDouble(name) {
            return .init(hsba: hsba)
        }
        return nil
    }
    public func asColorHSBA(_ name: String, _ fallback: Color.HSBA) -> Color.HSBA {
        asColorHSBA(name) ?? fallback
    }


    public func asColor(_ name: String, _ fallback: Color) -> Color {
        asColor(name) ?? fallback
    }
    
    public func asSKColor(_ name: String) -> SKColor? {
        if let value = dictionary[name] {
            return Self.toSKColor(hsba: value)
        }
        return nil
    }
    public func asSKColor(_ name: String, _ fallback: SKColor) -> SKColor {
        asSKColor(name) ?? fallback
    }
    
    
    public func asCGLineCap(_ name: String) -> CGLineCap? {
        if let value = asInt32(name) {
            return CGLineCap.init(rawValue: value)
        }
        return nil
    }
    public func asCGLineCap(_ name: String, _ fallback: CGLineCap) -> CGLineCap {
        asCGLineCap(name) ?? fallback
    }

    public func asCGLineJoin(_ name: String) -> CGLineJoin? {
        if let value = asInt32(name) {
            return CGLineJoin.init(rawValue: value)
        }
        return nil
    }
    public func asCGLineJoin(_ name: String, _ fallback: CGLineJoin) -> CGLineJoin {
        asCGLineJoin(name) ?? fallback
    }
    
    public func asCGPoint(_ name: String) -> CGPoint? {
        if let values = dictionary[name] {
            let xy = values.split(",")
            if xy.count > 1, let x = CGFloat(xy[0]), let y = CGFloat(xy[1]) {
                return CGPoint.init(x: x, y: y)
            }
        }
        return nil
    }
    public func asCGPoint(_ name: String, _ fallback: CGPoint) -> CGPoint {
        asCGPoint(name) ?? fallback
    }

    
    

    public func asString(_ key: String) -> String? {
        return dictionary[key]
    }
    public func asString(_ key: String, _ fallback: String) -> String {
        return asString(key) ?? fallback
    }

    
    
    public func asDouble(_ key: String) -> Double? {
        if let value = dictionary[key] {
            return Double(value)
        }
        return nil
    }
    public func asDouble(_ key: String, _ fallback: Double) -> Double {
        asDouble(key) ?? fallback
    }

    public func asCGFloat(_ key: String) -> CGFloat? {
        if let value = dictionary[key] {
            return CGFloat(value)
        }
        return nil
    }
    public func asCGFloat(_ key: String, _ fallback: CGFloat) -> CGFloat {
        asCGFloat(key) ?? fallback
    }
    
    public func asInt(_ key: String) -> Int? {
        if let value = dictionary[key] {
            return Int(value)
        }
        return nil
    }
    public func asInt(_ key: String, _ fallback: Int) -> Int {
        asInt(key) ?? fallback
    }
    
    public func asInt32(_ key: String) -> Int32? {
        if let value = dictionary[key] {
            return Int32(value)
        }
        return nil
    }
    public func asInt32(_ key: String, _ fallback: Int32) -> Int32 {
        asInt32(key) ?? fallback
    }
    

    
    
    public func asBool(_ key: String, _ fallback: Bool) -> Bool {
        if let value = dictionary[key] {
            return Bool(value) ?? fallback
        }
        return fallback
    }
    
    public func asArrayOfDouble(_ key: String) -> [Double]? {
        dictionary[key]?.split(",").map { Double($0)! }
    }
    public func asArrayOfDouble(_ key: String, _ fallback: [Double]) -> [Double] {
        asArrayOfDouble(key) ?? fallback
    }

    public func asArrayOfCGFloat(_ key: String) -> [CGFloat]? {
        dictionary[key]?.split(",").map { CGFloat($0)! }
    }
    public func asArrayOfCGFloat(_ key: String, _ fallback: [CGFloat]) -> [CGFloat] {
        asArrayOfCGFloat(key) ?? fallback
    }

    public func asArrayOfInt(_ key: String) -> [Int]? {
        dictionary[key]?.split(",").map { Int($0)! }
    }
    public func asArrayOfInt(_ key: String, _ fallback: [Int]) -> [Int] {
        asArrayOfInt(key) ?? fallback
    }

    #if os(iOS)
    public func asBlurEffectStyle(_ key: String, _ fallback: UIBlurEffect.Style) -> UIBlurEffect.Style {
        if let operand = dictionary[key], let int = Int(operand) {
            return UIBlurEffect.Style.init(rawValue: int) ?? fallback
        }
        return fallback
    }
    #endif
    

    
    
    

//    func value<T>(_ name: String, _ fallback: T) -> T {
//        if fallback is SKColor { return asSKColor(name, fallback as! SKColor) as! T }
////        if fallback is Color { return asColor(name, fallback as! Color) as! T }
//        if fallback is Int { return asInt(name, fallback as! Int) as! T }
//        return fallback
//    }

    
    public mutating func set(_ key: String, _ color: SKColor) {
        dictionary[key] = Self.stringForColor(from: color)
    }

    public mutating func set(_ key: String, _ color: Color) {
        dictionary[key] = Self.stringForColor(from: color)
    }

    public mutating func set(_ key: String, _ string: String?) {
        if let string = string {
            dictionary[key] = string
        }
    }

    public mutating func set(_ key: String, _ v: Double) {
        dictionary[key] = "\(v)"
    }

    public mutating func set(_ key: String, _ v: CGFloat) {
        dictionary[key] = "\(v)"
    }

    public mutating func set(_ key: String, _ v: CGPoint) {
        dictionary[key] = "\(v.x),\(v.y)"
    }

    public mutating func set(_ key: String, _ v: Int) {
        dictionary[key] = "\(v)"
    }
    
    public mutating func set(_ key: String, _ v: Bool) {
        dictionary[key] = "\(v)"
    }
    
    public mutating func set(_ key: String, _ v: [Double]) {
        dictionary[key] = v.map { "\($0)" }.joined(separator: ",")
    }

    public mutating func set(_ key: String, _ v: [CGFloat]) {
        dictionary[key] = v.map { "\($0)" }.joined(separator: ",")
    }

    public mutating func set(_ key: String, _ v: [Int]) {
        dictionary[key] = v.map { "\($0)" }.joined(separator: ",")
    }

    #if os(iOS)
    public mutating func set(_ key: String, _ v: UIBlurEffect.Style) {
        dictionary[key] = String(v.rawValue)
    }
    #endif



    static public func stringForColor(from color: SKColor) -> String {
        let hsba = color.HSBA
        return "\(hsba.hue),\(hsba.saturation),\(hsba.brightness),\(hsba.alpha)"
    }
    
    static public func stringForColor(from color: Color) -> String {
        let hsba = color.hsba
        return "\(hsba[0]),\(hsba[1]),\(hsba[2]),\(hsba[3])"
    }
    
    static public func stringForColor(from hsba: [Double]) -> String {
        return "\(hsba[0]),\(hsba[1]),\(hsba[2]),\(hsba[3])"
    }
        

    static public func toArrayOfDouble(hsba: String, v: Double = 1.0) -> [Double] {
        hsba.split(",").map { Double($0) ?? v }.padded(with: 1.0, upto: 4)
    }
    
    static public func toArrayOfCGFloat(hsba: String, v: CGFloat = 1.0) -> [CGFloat] {
        hsba.split(",").map { CGFloat($0) ?? v }.padded(with: 1.0, upto: 4)
    }
    

    static public func toColor(hsba: String) -> Color {
        return Color.hsba(toArrayOfDouble(hsba: hsba))
    }

    static public func toSKColor(hsba: String) -> SKColor {
        SKColor.init(hsba: toArrayOfCGFloat(hsba: hsba))
    }

}

extension Attributes : Codable {
    
    public var encoded : Data! {
        try? JSONEncoder.init().encode(self)
    }
    
    @discardableResult
    public mutating func decode(from: Data!) -> Bool {
        guard let from = from else {
            return false
        }
        guard let new = try? JSONDecoder.init().decode(Self.self, from: from) else {
            return false
        }
        self = new
        return true
    }

}
