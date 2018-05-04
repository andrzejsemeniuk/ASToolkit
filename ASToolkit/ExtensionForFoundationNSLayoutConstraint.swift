//
//  ExtensionforFoundationNSLayoutConstraint.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/12/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    open func set(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
			item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    open func activated         (_ value:Bool = true) -> NSLayoutConstraint {
        self.isActive=true
        return self
    }
    
    open func deactivated       () -> NSLayoutConstraint {
        self.isActive=false
        return self
    }
    
    open func prioritized       (_ value:UILayoutPriority) -> NSLayoutConstraint {
        self.priority = value
        return self
    }
    
    open func extended          (_ value:CGFloat) -> NSLayoutConstraint {
        self.constant = value
        return self
    }
    
    open func identified        (_ value:String?) -> NSLayoutConstraint {
        self.identifier = value
        return self
    }
    
}
