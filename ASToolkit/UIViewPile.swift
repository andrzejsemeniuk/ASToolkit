//
//  UIViewPile.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/17/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class UIViewPile : UIView {
    
    public init(frame:CGRect, pile:[UIView]) {
        super.init(frame:CGRect(pile[0].frame.size))
        self.backgroundColor = .clear
        add(views:pile)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func add(views:[UIView]) {
        var top = self.top()
        for view in views {
            top.addSubview(view)
            view.constraintCenterToSuperview()
            top = view
        }
    }
    
    public func top() -> UIView {
        var result:UIView = self
        while let last = result.subviews.last {
            result = last
        }
        return result
    }
    
    public func nextUp() -> UIView? {
        return subviews.last
    }
    
    public func nextDown() -> UIView? {
        return superview
    }
}

open class UIViewPileCentered : UIViewPile {
    
    override public func add(views:[UIView]) {
        var top = self.top()
        for view in views {
            top.addSubview(view)
            view.constraintCenterToSuperview()
            top = view
        }
    }
    
}
