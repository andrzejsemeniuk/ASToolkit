//
//  Weak.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/7/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation


open class Weak<T: AnyObject> {
    
    public weak var value : T?
    
    public init (_ value: T) {
        self.value = value
    }
}

public typealias WeakRef = Weak


open class WeakEquatable<T: AnyObject & Equatable> : Weak<T> {
    
    public static func == (lhs: WeakEquatable, rhs: WeakEquatable) -> Bool {
        return lhs.value != nil && rhs.value != nil && lhs.value! == rhs.value!
    }
}

public typealias WeakEquatableRef = WeakEquatable


open class WeakHashable<T: AnyObject & Hashable> : WeakEquatable<T>, Hashable {
    
    public var hashValue : Int {
        return value?.hashValue ?? 0
    }
    
    public static func == (lhs: WeakHashable<T>, rhs: WeakHashable<T>) -> Bool {
        return lhs.value != nil && rhs.value != nil && lhs.value! == rhs.value!
    }
    
}

public typealias WeakHashableRef = WeakHashable

