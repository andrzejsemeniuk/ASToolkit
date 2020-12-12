//
//  CGFloat01.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public class CGFloat01 {
    
    public var value: CGFloat {
        didSet {
            correct(value)
        }
    }

    private func correct(_ value: CGFloat) {
        if value < 0 {
            self.value = 0
        }
        else if 1 < value {
            self.value = 1
        }
    }
    
    public init(_ value: CGFloat = 0) {
        self.value = value
        correct(value)
    }
}


public func += (lhs:CGFloat01, rhs:CGFloat) {
    lhs.value += rhs
}

public func -= (lhs:CGFloat01, rhs:CGFloat) {
    lhs.value -= rhs
}

