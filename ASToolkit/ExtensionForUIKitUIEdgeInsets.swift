//
//  ExtensionForUIKitUIEdgeInsets.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/1/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UIEdgeInsets {
    
    /// Initializes all edges with same value
    ///
    /// - Parameter all: value for all edges
    public init(all:CGFloat) {
        self.init(top:all,left:all,bottom:all,right:all)
    }
}
