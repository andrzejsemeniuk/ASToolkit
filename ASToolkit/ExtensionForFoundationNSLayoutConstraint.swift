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
    @discardableResult open func set(multiplier:CGFloat) -> NSLayoutConstraint {
        
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
    
    @discardableResult open func activated         (_ value:Bool = true) -> NSLayoutConstraint {
        self.isActive=true
        return self
    }
    
    @discardableResult open func deactivated       () -> NSLayoutConstraint {
        self.isActive=false
        return self
    }
    
    @discardableResult open func prioritized       (priority:UILayoutPriority) -> NSLayoutConstraint {
		if false {
		if isActive {
			isActive=false
			self.priority = priority
			isActive=true
		}
		else {
        	self.priority = priority
		}
		}
        return self
    }
    
	@discardableResult open func prioritized       (_ value:Double) -> NSLayoutConstraint {
		if false {
		if isActive {
			isActive=false
			self.priority = UILayoutPriority.init(Float(value))
			isActive=true
		}
		else {
			self.priority = UILayoutPriority.init(Float(value))
		}
		}
		return self
	}

    @discardableResult open func extended          (_ value:CGFloat) -> NSLayoutConstraint {
        self.constant = value
        return self
    }
    
    @discardableResult open func identified        (_ value:String?) -> NSLayoutConstraint {
        self.identifier = value
        return self
    }
    
}


extension Array where Element : NSLayoutConstraint {

	public func get(_ identifier:String) -> NSLayoutConstraint? {
		return self.find { constraint in
			return constraint.identifier == identifier
		}
	}

}



