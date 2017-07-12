//
//  ASToolkitExtension+Operators.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

//public func ^^(lhs:Bool,rhs:Bool) -> Bool { return lhs && rhs }

prefix operator ++

public prefix func ++<T: Integer>(rhs:inout T) -> T {
    rhs = rhs + 1
    return rhs
}
