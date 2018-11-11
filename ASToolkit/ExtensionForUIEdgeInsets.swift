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
    
	public init(tlbr:[CGFloat]) {
		self.init(top:tlbr[0],left:tlbr[1],bottom:tlbr[2],right:tlbr[3])
	}

    public init(top:CGFloat, bottom:CGFloat) {
        self.init(top:top, left:0, bottom:bottom, right:0)
    }
    
    public init(top:CGFloat) {
        self.init(top:top, left:0, bottom:0, right:0)
    }
    
	public init(top:CGFloat,left:CGFloat) {
		self.init(top:top, left:left, bottom:0, right:0)
	}

    public init(bottom:CGFloat) {
        self.init(top:0, left:0, bottom:bottom, right:0)
    }
    
    public init(left:CGFloat, right:CGFloat) {
        self.init(top:0, left:left, bottom:0, right:right)
    }
    
    public init(left:CGFloat, bottom:CGFloat) {
        self.init(top:0, left:left, bottom:bottom, right:0)
    }
    
    public init(left:CGFloat) {
        self.init(top:0, left:left, bottom:0, right:0)
    }
    
    public init(right:CGFloat) {
        self.init(top:0, left:0, bottom:0, right:right)
    }

	public init(h:CGFloat) {
		self.init(top:0, left:h, bottom:0, right:h)
	}

	public init(lr h:CGFloat) {
		self.init(top:0, left:h, bottom:0, right:h)
	}

	public init(v:CGFloat) {
		self.init(top:v, left:0, bottom:v, right:0)
	}

	public init(tb v:CGFloat) {
		self.init(top:v, left:0, bottom:v, right:0)
	}

	public init(h:CGFloat, v:CGFloat) {
		self.init(top:v, left:h, bottom:v, right:h)
	}

	public init(v:CGFloat, h:CGFloat) {
		self.init(top:v, left:h, bottom:v, right:h)
	}
}

extension UIEdgeInsets {

	public mutating func clear() {
		left = 0
		right = 0
		top = 0
		bottom = 0
	}

}


public func * (lhs:UIEdgeInsets, rhs:CGFloat) -> UIEdgeInsets {
	return UIEdgeInsets(top		: lhs.top * rhs,
						left	: lhs.left * rhs,
						bottom	: lhs.bottom * rhs,
						right	: lhs.right * rhs)
}

public func / (lhs:UIEdgeInsets, rhs:CGFloat) -> UIEdgeInsets {
	return UIEdgeInsets(top		: lhs.top / rhs,
						left	: lhs.left / rhs,
						bottom	: lhs.bottom / rhs,
						right	: lhs.right / rhs)
}
