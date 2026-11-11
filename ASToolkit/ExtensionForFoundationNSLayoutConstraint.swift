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
    @discardableResult public func set(multiplier:CGFloat) -> NSLayoutConstraint {

		let active = isActive

		if active {
        	NSLayoutConstraint.deactivate([self])
		}
        
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

		if active {
        	NSLayoutConstraint.activate([newConstraint])
		}
		
        return newConstraint
    }
    
    @discardableResult public func activated         (_ value:Bool = true) -> NSLayoutConstraint {
        self.isActive=true
        return self
    }
    
    @discardableResult public func deactivated       () -> NSLayoutConstraint {
        self.isActive=false
        return self
    }
    
    @discardableResult public func prioritized       (priority:UILayoutPriority) -> NSLayoutConstraint {
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
    
	@discardableResult public func prioritized       (_ value:Double) -> NSLayoutConstraint {
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

    @discardableResult public func extended          (_ value:CGFloat) -> NSLayoutConstraint {
        self.constant = value
        return self
    }
    
    @discardableResult public func identified        (_ value:String?) -> NSLayoutConstraint {
        self.identifier = value
        return self
    }

	@discardableResult public func multiplied			(_ value:CGFloat) -> NSLayoutConstraint {
		return self.set(multiplier: value)
	}
    
}


extension Array where Element : NSLayoutConstraint {

	public func get(_ identifier:String) -> NSLayoutConstraint? {
		return self.first { constraint in
			return constraint.identifier == identifier
		}
	}

}



