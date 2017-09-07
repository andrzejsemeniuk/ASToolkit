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
