//
//  ExtensionForSwiftUInt.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/7/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UInt {
}

extension UInt {
    public func isInInterval(_ l:UInt, _ u:UInt) -> Bool { return l <= self && self < u }
}

