//
//  BindingValue.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/5/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class BindingValue<T> {
    
    // MARK:- TYPES
    
    public typealias Listener   = (T?)->()
    
    // MARK:- DATA
    
    public var value            : T? {
        didSet {
            fire()
        }
    }
    
    public var listener         : Listener?
    
    // MARK:- INITIALIZERS
    
    public init                 (_ value:T? = nil) {
        self.value = value
    }
    
    public init                 (_ value:T? = nil, listener:@escaping Listener) {
        self.value = value
        self.listener = listener
    }
    
    // MARK:- METHODS
    
    public func fire            () {
        self.listener?(value)
    }
}
