//
//  Variable.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 7/13/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public protocol Variable {
    var value       : Double { get set }
}

public protocol VariableWithRange : Variable {
    var lowerbound  : Double { get }
    var upperbound  : Double { get }
    var range       : Double { get }
}



// enabled?
// fixed?
// priority?

public class VariableWithImmutableRange : VariableWithRange
{
    public let lowerbound   : Double
    public let upperbound   : Double
    public let range        : Double
    
    public var value        : Double {
        didSet {
            if value < lowerbound {
                value = lowerbound
            }
            else if upperbound < value {
                value = upperbound
            }
        }
    }
    
    public var lerp  : Double {
        return range != 0 ? value.lerp(from:lowerbound, to:upperbound) : 0
    }
    
    public var description  : String { return "[\(lowerbound),\(upperbound)=\(value)]" }
    
    public                  init (lowerbound l:Double,upperbound u:Double,value v:Double)
    {
        self.lowerbound    = l
        self.upperbound    = u
        self.range         = u-l
        self.value         = v
    }
    
    public convenience      init (_ lowerbound:Double,_ upperbound:Double,_ value:Double)
    {
        self.init(lowerbound:lowerbound,upperbound:upperbound,value:value)
    }
    
    public func setValueTo          (value:Double)                                                  { self.value = value }
    public func setValueFrom        (ratio:Double)                                                  { self.value = lowerbound+ratio*range }
    
    public func setValueToLowerbound()                                                              { self.value = lowerbound }
    public func setValueToUpperbound()                                                              { self.value = upperbound }
}




public class Variable01 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:1,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable02 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:2,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable03 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:3,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable010 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:10,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable0100 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:100,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable01000 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:1000,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable0n : VariableWithImmutableRange
{
    public              init(n:Double,value v:Double = 0) {
        super.init(lowerbound:0,upperbound:max(0,n),value:v)
    }
    public              init(upperbound n:Double,value v:Double = 0) {
        super.init(lowerbound:0,upperbound:max(0,n),value:v)
    }
}

typealias VariableZeroToUpperbound  = Variable0n
typealias VariableZeroToN           = Variable0n


public class Variable11 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:-1,upperbound:1,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class Variable22 : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:-2,upperbound:2,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}

public class VariableHH : VariableWithImmutableRange
{
    public              init(_ v:Double = 0)        { super.init(lowerbound:-0.5,upperbound:0.5,value:v) }
    public convenience  init(value:Double = 0)      { self.init(value) }
}







public class VariableWithMutableRange : VariableWithRange
{
    public var lowerbound   : Double
    public var upperbound   : Double
    public var range        : Double {
        return upperbound - lowerbound
    }
    
    public var value        : Double {
        didSet {
            if value < lowerbound {
                value = lowerbound
            }
            else if upperbound < value {
                value = upperbound
            }
        }
    }
    
    public var lerp  : Double {
        return range != 0 ? value.lerp(from:lowerbound, to:upperbound) : 0
    }
    
    public var description  : String { return "[\(lowerbound),\(upperbound)=\(value)]" }
    
    public                  init (lowerbound l:Double, upperbound u:Double, value v:Double)
    {
        self.lowerbound    = l
        self.upperbound    = u
        self.value         = v
    }
    
    public convenience      init (_ lowerbound:Double,_ upperbound:Double,_ value:Double)
    {
        self.init(lowerbound:lowerbound,upperbound:upperbound,value:value)
    }
    
    public func setValueTo          (value:Double)                                                  { self.value = value }
    public func setValueFrom        (ratio:Double)                                                  { self.value = lowerbound+ratio*range }
    
    public func setValueToLowerbound()                                                              { self.value = lowerbound }
    public func setValueToUpperbound()                                                              { self.value = upperbound }
    
    public func set                 (lowerbound l:Double,upperbound u:Double,value v:Double)        {
        self.lowerbound = l
        self.upperbound = u
        self.value = v
    }
    
}

public protocol VariableWithDefaultValue {
    var value0: Double { get }
}

public class VariableWithImmutableRangeAndDefaultValue : VariableWithImmutableRange, VariableWithDefaultValue {
    
    public let value0 : Double
    
    override public         init (lowerbound:Double, upperbound:Double, value:Double)
    {
        self.value0 = value
        
        super.init(lowerbound: lowerbound, upperbound: upperbound, value: value)
    }
    
    public                  init (lowerbound:Double, upperbound:Double, value0:Double, value:Double)
    {
        self.value0 = value0
        
        super.init(lowerbound: lowerbound, upperbound: upperbound, value: value)
    }
    
    public convenience      init (_ lowerbound:Double, _ upperbound:Double,_ value:Double)
    {
        self.init(lowerbound:lowerbound,upperbound:upperbound,value:value)
    }
    
    public convenience      init (_ lowerbound:Double, _ upperbound:Double, _ value0:Double, _ value:Double)
    {
        self.init(lowerbound:lowerbound, upperbound:upperbound, value0:value0, value:value)
    }
    
}

public class VariableWithMutableRangeAndDefaultValue : VariableWithMutableRange, VariableWithDefaultValue {
    
    public let value0 : Double
    
    override public         init (lowerbound:Double, upperbound:Double, value:Double)
    {
        self.value0 = value
        
        super.init(lowerbound: lowerbound, upperbound: upperbound, value: value)
    }
    
    public                  init (lowerbound:Double, upperbound:Double, value0:Double, value:Double)
    {
        self.value0 = value0
        
        super.init(lowerbound: lowerbound, upperbound: upperbound, value: value)
    }
    
    public convenience      init (_ lowerbound:Double, _ upperbound:Double,_ value:Double)
    {
        self.init(lowerbound:lowerbound,upperbound:upperbound,value:value)
    }
    
    public convenience      init (_ lowerbound:Double, _ upperbound:Double, _ value0:Double, _ value:Double)
    {
        self.init(lowerbound:lowerbound, upperbound:upperbound, value0:value0, value:value)
    }
    
}
