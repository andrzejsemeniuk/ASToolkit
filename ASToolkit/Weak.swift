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

open class WeakHashable<T: Hashable & AnyObject> : Hashable, Equatable {
    
    public weak var value : T?
    
    public init (_ value: T) {
        self.value = value
    }
    
    public var hashValue : Int {
        return value?.hashValue ?? 0
    }
    
    public static func ==(lhs: WeakHashable<T>, rhs: WeakHashable<T>) -> Bool {
        return lhs.value != nil && rhs.value != nil && lhs.value! == rhs.value!
    }

}
