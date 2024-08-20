//
//  Logic.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/1/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

// and, or, not, xor, nand, nor, etc


public func not(_ A:Bool) -> Bool
{
    return !A
}

public func and    (_ p: Bool...)      -> Bool             { p.all { $0 } }
public func or     (_ p: Bool...)      -> Bool             { p.any { $0 } }

public func nand(_ A:Bool,_ B:Bool) -> Bool
{
    return not(and(A,B))
}

public func nor(_ A:Bool,_ B:Bool) -> Bool
{
    return not(or(A,B))
}

public func xor(_ A:Bool,_ B:Bool) -> Bool
{
    return (A && !B) || (!A && B)
}

