//
//  ExtensionForSwiftUInt64.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/7/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UInt64 {
    public func isInInterval(_ l:UInt64, _ u:UInt64) -> Bool { return l <= self && self < u }
}

