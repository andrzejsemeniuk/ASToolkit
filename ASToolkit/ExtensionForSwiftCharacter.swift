//
//  ASToolkitExtension+Double.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Character
{
    // http://stackoverflow.com/questions/24102044/how-can-i-get-the-unicode-code-points-of-a-character
    public var unicodeScalarCodePoint : UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
