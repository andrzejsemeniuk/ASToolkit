//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation




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

public func ifTrueElseNil       <V>(_ flag: Bool, _ value: V) -> V?             { flag ? value : nil }
public func ifFalseElseNil      <V>(_ flag: Bool, _ value: V) -> V?             { flag ? nil : value }
public func nilOr               <V>(_ flag: Bool, _ value: V) -> V?             { flag ? value : nil }

public func printMirrorAttributesOf(_ any: Any) {
    for child in Mirror(reflecting: any).children {
        print(" \(String(describing: child.label))               = \(child.value)")
    }
}

