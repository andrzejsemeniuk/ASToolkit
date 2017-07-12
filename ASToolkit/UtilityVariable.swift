//
//  ASToolkitUtilityVariable.swift
//  ASToolkitFrankenbots
//
//  Created by andrzej semeniuk on 4/24/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension TGF.Utility
{
    // enabled?
    // fixed?
    // priority?
    
    public class Variable
    {
        fileprivate var _lowerbound,_upperbound,_value,_range :Double
        
        public var lowerbound   :Double { return _lowerbound }
        public var upperbound   :Double { return _upperbound }
        public var range        :Double { return _range }
        
        public var value        :Double { return _value }
        
        public var lerp01       :Double { return range != 0 ? (value-lowerbound)/range : 0 }
        
        public var value0       :Double { return lowerbound }
        public var value1       :Double { return upperbound }
        
        public var description  :String { return "[\(lowerbound),\(upperbound)=\(value)]" }
        
        public                  init (lowerbound l:Double,upperbound u:Double,value v:Double)
        {
            self._lowerbound    = l
            self._upperbound    = u
            self._range         = self._upperbound - self._lowerbound
            self._value         = v
            self.normalize()
        }
        
        public convenience      init (_ lowerbound:Double,_ upperbound:Double,_ value:Double)
        {
            self.init(lowerbound:lowerbound,upperbound:upperbound,value:value)
        }
        
        public func normalize           ()
        {
            let l = self._lowerbound
            let u = self._upperbound
            
            self._lowerbound    = min(l,u);
            self._upperbound    = max(l,u);
            self._range         = self._upperbound - self._lowerbound
            set(self.value)
        }
        
        public func set                 (_ value:Double)                                                  { self._value = min(upperbound,max(lowerbound,value)) }
        public func set01               (_ value:Double)                                                  { set(lowerbound+value*range) }
        
        public func set0                ()                                                              { set(lowerbound) }
        public func set1                ()                                                              { set(upperbound) }
        
        public func setValueToLowerbound()                                                              { set0() }
        public func setValueToUpperbound()                                                              { set1() }
        
        public func lerp                (_ v:Double) -> Double                                            { return range != 0 ? lowerbound + (v-lowerbound)/range : 0 }
        public func lerp01              (_ v:Double) -> Double                                            { return lerp(min(1,max(0,v))) }
        
        
    }
    
    
    
    
    public class Variable01 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:1,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable02 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:2,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable03 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:3,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable010 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:10,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable0100 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:100,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable01000 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:0,upperbound:1000,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable0n : Variable
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
    
    
    public class Variable11 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:-1,upperbound:1,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class Variable22 : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:-2,upperbound:2,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    public class VariableHH : Variable
    {
        public              init(_ v:Double = 0)        { super.init(lowerbound:-0.5,upperbound:0.5,value:v) }
        public convenience  init(value:Double = 0)      { self.init(value) }
    }
    
    
    
    
    
    
    
    public class VariableWithModifiableRange : Variable
    {
        public func set                 (_ l:Double,_ u:Double)
        {
            self._lowerbound=l
            self._upperbound=u
            normalize()
        }
        public func set                 (lowerbound l:Double? = nil,upperbound u:Double? = nil)
        {
            if let l=l { self._lowerbound=l }
            if let u=u { self._upperbound=u }
            normalize()
        }
        public func set                 (_ l:Double,_ u:Double,_ v:Double)
        {
            self._lowerbound    = l
            self._upperbound    = u
            self._value         = v
            normalize()
        }
        public func set                 (lowerbound l:Double,upperbound u:Double,value v:Double)        { set(l,u,v); }
        
    }
    
    
}
