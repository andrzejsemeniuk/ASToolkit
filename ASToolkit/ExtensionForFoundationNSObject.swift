//
//  ExtensionForFoundationNSObject.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

private let __dictionary = "__D"

public extension NSObject {

	class AssociationForClosure {
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

	func put(_ key:String, _ object:Any) {
		if let dictionary = objc_getAssociatedObject(self, __dictionary) as? NSDictionary {
			dictionary.setValue(object, forKey: key)
		}
		else {
			let dictionary = NSDictionary()
			dictionary.setValue(object, forKey: key)
			objc_setAssociatedObject(self, __dictionary, dictionary, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	func peek(_ key:String) -> Any? {
		if let dictionary = objc_getAssociatedObject(self, __dictionary) as? NSDictionary {
			return dictionary.object(forKey:key)
		}
		return nil
	}

	func get<T>(_ key:String, _ substitute: T) -> T {
		if let dictionary = objc_getAssociatedObject(self, __dictionary) as? NSDictionary {
			return (dictionary.object(forKey:key) as? T) ?? substitute
		}
		return substitute
	}

}

