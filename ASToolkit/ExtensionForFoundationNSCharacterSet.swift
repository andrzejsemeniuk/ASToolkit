//
//  ExtensionforFoundationNSCharacterSet.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/12/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreText

extension NSCharacterSet {


    public var total : UInt32 {
        var count:UInt32 = 0
        let limit:UInt32 = 8192 * 32
        for i in 0..<limit {
            if self.characterIsMember(unichar(i)) {
                count += 1
            }
        }
        return count
    }
    
    public var highest : UInt32 {
        var highest:UInt32 = 0
        let limit:UInt32 = 8192 * 32
        for i in 0..<limit {
            if self.longCharacterIsMember(UTF32Char(i)) {
                highest = UInt32(i)
            }
        }
        return highest
    }
    
}
