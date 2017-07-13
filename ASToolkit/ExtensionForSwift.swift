//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Comparable {

    public func clamped             (minimum:Self, maximum:Self) -> Self {
        return self < minimum ? minimum : maximum < self ? maximum : self
    }

}
