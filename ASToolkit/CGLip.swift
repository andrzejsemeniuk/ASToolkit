//
//  CGLip.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 4/28/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public struct CGLip {
    public let horizontal   : CGFloat
    public let vertical     : CGFloat
    
    public var h            : CGFloat           { return horizontal }
    public var v            : CGFloat           { return vertical }
    
    public init() {
        self.horizontal = 0
        self.vertical = 0
    }
    
    public init(h:CGFloat,v:CGFloat) {
        self.horizontal = h
        self.vertical = v
    }
    
    public init(v:CGFloat,h:CGFloat) {
        self.horizontal = h
        self.vertical = v
    }
    
    public init(all:CGFloat) {
        self.horizontal = all
        self.vertical = all
    }
}
