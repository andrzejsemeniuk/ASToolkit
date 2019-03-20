//
//  ExtensionForSWXML.swift
//  ASFin
//
//  Created by andrzej semeniuk on 8/5/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public typealias XMLParser = SWXMLHash

extension XMLIndexer {
    public func attribute           (_ name:String)                 -> String?      { return self.element?.attribute(by: name)?.text }
}

public func > (lhs:XMLIndexer,rhs:String) -> String? {
    return lhs.attribute(rhs)
}

public func > (lhs:XMLElement,rhs:String) -> String? {
	return lhs.attribute(by: rhs)?.text
}

extension XMLElement {
    
    public func attribute           (_ name:String)                 -> String?      { return self.attribute(by: name)?.text }

    public func attribute           (asString name:String)          -> String       { return self.attribute(name)! }
    public func attribute           (asDouble name:String)          -> Double       { return Double(self.attribute(name)!)! }
    public func attribute           (asFloat name:String)           -> Float        { return Float(self.attribute(name)!)! }
    public func attribute           (asInt64 name:String)           -> Int64        { return Int64(self.attribute(name)!)! }
    public func attribute           (asUInt64 name:String)          -> UInt64       { return UInt64(self.attribute(name)!)! }
    public func attribute           (asInt name:String)             -> Int          { return Int(self.attribute(name)!)! }
    public func attribute           (asUInt name:String)            -> UInt         { return UInt(self.attribute(name)!)! }
    public func attribute           (asBool name:String)            -> Bool         { return self.attribute(name)!.lowercased() == "true" }
    
    public func attribute           (asString name:String, or:String)   -> String   { return self.attribute(name) ?? or }
    public func attribute           (asDouble name:String, or:Double)   -> Double   { return Double(self.attribute(name) ?? String(or)) ?? or }
    public func attribute           (asFloat name:String, or:Float)     -> Float    { return Float(self.attribute(name) ?? String(or)) ?? or }
    public func attribute           (asInt64 name:String, or:Int64)     -> Int64    { return Int64(self.attribute(name) ?? String(or)) ?? or }
    public func attribute           (asUInt64 name:String, or:UInt64)   -> UInt64   { return UInt64(self.attribute(name) ?? String(or)) ?? or }
    public func attribute           (asInt name:String, or:Int)         -> Int      { return Int(self.attribute(name) ?? String(or)) ?? or }
    public func attribute           (asUInt name:String, or:UInt)       -> UInt     { return UInt(self.attribute(name) ?? String(or)) ?? or }
	public func attribute           (asBool name:String, or:Bool)       -> Bool     { return Bool(self.attribute(name) ?? String(or)) ?? or }

}

extension XMLElement {
    
    open var xmlElements:[XMLElement] {
		return children.map { $0 as? XMLElement }.compactMap { $0 }
    }
    
}
