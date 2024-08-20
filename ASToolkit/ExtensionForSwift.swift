//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation




// ex:
//  var a = 0.5
//	a ?= 0.41 // c0.a is assigned 0.41
//	a ?= nil // c0.a is unchanged

infix operator   ?= : AssignmentPrecedence

@discardableResult
public func ?= <T>(lhs: inout T, rhs: T?) -> T {
    if let rhs = rhs {
        lhs = rhs
    }
    return lhs
}

infix operator   ??= : AssignmentPrecedence

public func ??= <T: Equatable>(lhs: inout T, rhs: T) {
    if lhs != rhs {
        lhs = rhs
    }
}

public func ifTrueElseNil       <V>(_ flag: Bool, _ value: V) -> V?             { flag ? value : nil }
public func ifFalseElseNil      <V>(_ flag: Bool, _ value: V) -> V?             { flag ? nil : value }
public func nilOr               <V>(_ flag: Bool, _ value: V) -> V?             { flag ? value : nil }

public func printMirrorAttributesOf(_ any: Any, prefix: String = "", suffix: String = "") {
    for child in Mirror(reflecting: any).children {
        print("\(prefix)\(String(describing: child.label))               = \(child.value)\(suffix)")
    }
}

public func getMirrorAttributesOf(_ any: Any) -> [String] {
    Mirror(reflecting: any).children.map { child in
        String(describing: child.label)
    }
}

public extension Equatable {
    func `in`(_ parameters: Self...) -> Bool {
        for p in parameters {
            if self == p {
                return true
            }
        }
        return false
    }
    func `in`(_ parameters: [Self]) -> Bool {
        for p in parameters {
            if self == p {
                return true
            }
        }
        return false
    }
}

public extension Optional where Wrapped : Equatable {
    
    mutating func assignDifferent(_ a: Wrapped?, _ b: Wrapped? = nil) {
        self = self == a ? b : a
    }
    
    mutating func assignIfNil(_ a: Wrapped?) {
        if self == nil {
            self = a
        }
    }
    
}


public func assign<T>(value: T?, or block: () throws -> T) throws -> T {
    if let value { return value }
    return try block()
}

//public protocol JSONCodable : Codable {
//    
//    var encoded : Data! { get }
//    
//    mutating func decode(from: Data!) -> Bool
//    
//}
//
//public extension JSONCodable {
//    
//    var encoded : Data! {
//        try? JSONEncoder.init().encode(self)
//    }
//    
//    mutating func decode(from: Data!) -> Bool {
//        guard let from = from else {
//            return false
//        }
//        guard let new = try? JSONDecoder.init().decode(Self.self, from: from) else {
//            return false
//        }
//        self = new
//        return true
//    }
//    
//}
//

extension KeyedDecodingContainer {

    public func decode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    public func decode<T: Decodable>(_ key: KeyedDecodingContainer<K>.Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    public func decode<T: Decodable>(_ key: KeyedDecodingContainer<K>.Key, _ fallback: T) -> T {
        if let r = try? decode(T.self, forKey: key) {
            return r
        }
        return fallback
    }

}



public func swap<T>( _ a: inout T, _ b: inout T) {
    let t = a
    a = b
    b = t
}


public extension Equatable {
    mutating func toggle(_ a: Self, _ b: Self) {
        self = self == a ? b : a
    }
}




func PICK<T>(_ condition: Bool, _ first: T, _ second: T) -> T {
    condition ? first : second
}





    // https://forums.swift.org/t/rawrepresentable-conformance-leads-to-crash/51912/4

    struct RawRepresentableWrapper<Value: Codable> {
        var value: Value
    }

    extension RawRepresentableWrapper: RawRepresentable {
        
        typealias RawValue = String
        
        var rawValue: RawValue {
            guard
                let data = try? JSONEncoder().encode(value),
                let string = String(data: data, encoding: .utf8)
            else {
                // TODO: Track programmer error
                return ""
            }
            return string
        }
        
        init?(rawValue: RawValue) {
            guard
                let data = rawValue.data(using: .utf8),
                let decoded = try? JSONDecoder().decode(Value.self, from: data)
            else {
                // TODO: Track programmer error
                return nil
            }
            value = decoded
        }
    }








public struct EnabledValue<T: Codable & Equatable & Hashable> : Codable, Equatable, Hashable {
    public static func == (lhs: EnabledValue<T>, rhs: EnabledValue<T>) -> Bool {
        lhs.value == rhs.value
    }

    public enum CodingKeys : String, CodingKey {
        case value = "v"
        case enabled = "e"
    }
    
    public var value   : T
    public var enabled : Bool = true
    
    public var valueNilIfDisabled : T? {
        enabled ? value : nil
    }
    public func valueIfDisabled(_ value: T) -> T {
        enabled ? self.value : value
    }
    
    public var asDisabled : EnabledValue<T> {
        Self.disabled(value)
    }
    public var asEnabled : EnabledValue<T> {
        Self.enabled(value)
    }
    
    static public func enabled(_ value: T) -> EnabledValue<T> {
        .init(value: value, enabled: true)
    }
    
    static public func disabled(_ value: T) -> EnabledValue<T> {
        .init(value: value, enabled: false)
    }
}









public extension Task where Success == Never, Failure == Never {
    
    static func sleep(seconds: Double) async throws {
        guard seconds > 0 else { return }
        try await Task.sleep(nanoseconds: UInt64(Double(1_000_000_000) * seconds))
    }
}

public extension Mirror {
    static func printable(children: Mirror.Children, indent: String = "", multiline: Bool = true, type : Bool = false) -> String {
        var r : [String] = []
        for c in children {
            let label = c.label ?? "?"
            if let v = c.value as? String {
                r.append("\(label) : \(v) \(type ? "(String)" : "")")
            } else if let v = c.value as? Int {
                r.append("\(label) : \(v) \(type ? "(Int)" : "")")
            } else if let v = c.value as? UInt {
                r.append("\(label) : \(v) \(type ? "(UInt)" : "")")
            } else if let v = c.value as? Float {
                r.append("\(label) : \(v) \(type ? "(Float)" : "")")
            } else if let v = c.value as? Double {
                r.append("\(label) : \(v) \(type ? "(Double)" : "")")
            } else if let v = c.value as? CGFloat {
                r.append("\(label) : \(v) \(type ? "(CGFloat)" : "")")
            } else {
                r.append("\(label) : ??")
            }
        }
        return r.joined(separator: multiline ? "\n" : ",")
    }
    
//    static func assign<T: Any>(from: T, matching regex: String, to: inout T) {
//        let Mfrom = Mirror.init(reflecting: from)
//        var Mto   = Mirror.init(reflecting: to)
//
//        let Cfrom = Mfrom.children.asArray
//        let Cto   = Mto.children.asArray
//
//        for i in Cfrom.range {
//            if let LABEL = Cto[i].label {
//                if LABEL.matches(regex: regex) {
//                    to[LABEL] = Cfrom[i].value
//                }
//            }
//        }
//    }
}


