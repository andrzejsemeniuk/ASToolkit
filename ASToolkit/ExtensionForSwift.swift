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



