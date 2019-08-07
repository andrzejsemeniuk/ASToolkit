//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Comparable {

    public func clamped             (minimum:Self, maximum:Self) -> Self {
        return self < minimum ? minimum : maximum < self ? maximum : self
    }

}




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
