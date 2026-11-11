//
//  ExtensionForSwiftCharacter.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Character
{
    // http://stackoverflow.com/questions/24102044/how-can-i-get-the-unicode-code-points-of-a-character
    var unicodeScalarCodePoint : UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
    
    var asString : String {
        String(self)
    }
}

public extension Array where Element == Character {
    
    var asArrayOfUInt32      : [UInt32]      { self.map { $0.unicodeScalarCodePoint } }
    
    var asString             : String        { self.map { String($0) }.joinedByNothing }
}


