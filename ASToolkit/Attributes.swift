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

public struct Attributes : Codable {
    
    
    public var title : String?
    
    public var dictionary : [String : String] = [:]
    
    
    public init(title: String? = nil, dictionary: [String : String] = [:]) {
        self.title = title
        self.dictionary = dictionary 
    }
    
    public func with(_ dictionary: [String : String]) -> Attributes {
        Attributes.init(dictionary: self.dictionary.merging(dictionary, uniquingKeysWith: { s0, s1 in s1 }))
    }
    
    // attributes: Attributes
    //  mycolor = Attribute.color.asColor(attributes[Attribute.color.with("fg")], .white)
    //  mycolor = attributes.asColor(Attribute.color.with("fg"), .white)
    //  mycolor = attributes.asColor(.color, "fg", .white)
//        func asColor(_ name: String, _ fallback: Color) -> Color {
//            if let value = dictionary[name] {
//                let hsba : [Double] = value.split(",").map { Double($0) ?? 0 }
//                return Color.init(hsba: [hsba[safe: 0] ?? 0, hsba[safe: 1] ?? 1, hsba[safe: 2] ?? 1, hsba[safe: 3] ?? 1])
//            }
//            return fallback
//        }
    
    public func asSKColor(_ name: String) -> SKColor? {
        if let value = dictionary[name] {
            let hsba : [CGFloat] = value.split(",").map { CGFloat($0) ?? 0 }
            return SKColor.init(hsba: [hsba[safe: 0] ?? 0, hsba[safe: 1] ?? 1, hsba[safe: 2] ?? 1, hsba[safe: 3] ?? 1])
        }
        return nil
    }
    
    public func asSKColor(_ name: String, _ fallback: SKColor) -> SKColor {
        asSKColor(name) ?? fallback
    }
    
    
    public func asString(_ key: String, _ fallback: String) -> String {
        return dictionary[key] ?? fallback
    }
    public func asDouble(_ key: String, _ fallback: Double) -> Double {
        if let value = dictionary[key] {
            return Double(value) ?? fallback
        }
        return fallback
    }
    public func asCGFloat(_ key: String, _ fallback: CGFloat) -> CGFloat {
        if let value = dictionary[key] {
            return CGFloat(value) ?? fallback
        }
        return fallback
    }
    public func asInt(_ key: String, _ fallback: Int) -> Int {
        if let value = dictionary[key] {
            return Int(value) ?? fallback
        }
        return fallback
    }
    public func asBool(_ key: String, _ fallback: Bool) -> Bool {
        if let value = dictionary[key] {
            return Bool(value) ?? fallback
        }
        return fallback
    }
    
//    func value<T>(_ name: String, _ fallback: T) -> T {
//        if fallback is SKColor { return asSKColor(name, fallback as! SKColor) as! T }
////        if fallback is Color { return asColor(name, fallback as! Color) as! T }
//        if fallback is Int { return asInt(name, fallback as! Int) as! T }
//        return fallback
//    }
    
    static public func string(from color: SKColor) -> String {
        let hsba = color.HSBA
        return "\(hsba.hue),\(hsba.saturation),\(hsba.brightness),\(hsba.alpha)"
    }
}
