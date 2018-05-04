//
//  ExtensionForFoundationNSObject.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension NSObject {

	public class AssociationForClosure {
		public let closure	: () -> ()
		public let name		: String

		init(attachTo: AnyObject, named: String = "", closure: @escaping () -> ()) {
			self.closure = closure
			self.name = !named.isEmpty ? named : "[\(arc4random())]"
			objc_setAssociatedObject(attachTo, self.name, self, .OBJC_ASSOCIATION_RETAIN)
		}

		@objc func invoke() {
			closure()
		}
	}

}
