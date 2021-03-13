//
//  ASToolkit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 3/13/21.
//  Copyright © 2021 Andrzej Semeniuk. All rights reserved.
//

import Foundation

final public class ASToolkit {
    
    static public private(set) var initialized = false
    
    static public func initalize() {
        guard !initialized else { return }
        initialized = true
        UIBezierPath.mx_prepare()
    }
    
}
