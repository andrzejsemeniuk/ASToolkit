//
//  ExtensionForSwiftDictionary.swift
//  ASToolkit
//
//  Created by andrej on 11/24/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {

	public func json(options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> String? {
//		guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else {
//			return nil
//		}
//		return String(data: jsonData, encoding: .utf8)
        
        guard let encoded = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: encoded, encoding: .utf8)
	}

	static public func from(json text: String, options: JSONSerialization.ReadingOptions = []) -> [String: String]? {
		if let data = text.data(using: .utf8) {
			do {
//				return try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any]
                return try JSONDecoder().decode(Dictionary<String,String>.self, from: data)
			}
			catch {

			}
		}
		return nil
	}
    
    

}

extension Dictionary {
    
    public var isNotEmpty : Bool {
        !isEmpty
    }
    
}

public extension Dictionary {
    
    mutating func forEachValue(_ block: (_ value: inout Value)->()) {
        self.keys.forEach { k in
            block(&self[k]!)
        }
    }
    
}

public func += <K,V>(lhs: inout Dictionary<K,V>, rhs: Dictionary<K,V>) {
    lhs = lhs.merging(rhs, uniquingKeysWith: { $1 })
}

public func + <K,V>(lhs: Dictionary<K,V>, rhs: Dictionary<K,V>) -> Dictionary<K,V> {
    return lhs.merging(rhs, uniquingKeysWith: { $1 })
}

public func asDictionary<K,V>(_ keys: [K], _ value: V) -> Dictionary<K,V> {
    keys.reduce([:], { dictionary,key in
        dictionary + [key : value]
    })
}

public extension Dictionary.Keys where Key : Equatable {
    @inlinable func missing(_ element: Key) -> Bool {
        !contains(element)
    }
}

public extension Dictionary where Key : Equatable {
    @inlinable func contains(key: Key) -> Bool {
        keys.contains(key)
    }
    @inlinable func missing(key: Key) -> Bool {
        keys.missing(key)
    }
}


public extension Dictionary {
    
    mutating func merge(from dictionary: Dictionary<Key, Value>?, override: Bool) {
        if dictionary != nil {
            self = self.merging(dictionary!, uniquingKeysWith: { override ? $1 : $0 })
        }
    }
    
    func merged(from dictionary: Dictionary<Key, Value>?, override: Bool) -> Self {
        if dictionary == nil {
            return self
        } else {
            return self.merging(dictionary!, uniquingKeysWith: { override ? $1 : $0 })
        }
    }
    
    func merged(into dictionary: Dictionary<Key, Value>?, override: Bool) -> Self? {
        if dictionary == nil {
            return nil
        } else {
            return dictionary!.merging(self, uniquingKeysWith: { override ? $1 : $0 })
        }
    }
}

