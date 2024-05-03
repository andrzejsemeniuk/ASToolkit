//
//  ExtensionForSwiftNumeric.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Substring
{
	var string : String {
		return String(self)
	}
}

public extension Substring {
    
    var  asDouble  :  Double?  { Double(self) }
    var  asCGFloat :  CGFloat? { CGFloat(self.asString) }
    var  asInt     :  Int?     { Int(self) }
    var  asUInt    :  UInt?    { UInt(self) }
    var  asUInt64  :  UInt64?  { UInt64(self.replacingOccurrences(of:  ",",  with:  "")) }
    var  asFloat   :  Float?   { Float(self.asString) }

    var asData     : Data      { asDataUTF8 }
    var asDataUTF8 : Data      { .init(utf8) }

}


public extension Substring {
    
    func matches(_ regex: Regex<Substring>) -> Bool {
        self.firstMatch(of: regex) != nil
    }
    
    func matches(_ regex: Regex<String>) -> Bool {
        self.firstMatch(of: regex) != nil
    }
}

