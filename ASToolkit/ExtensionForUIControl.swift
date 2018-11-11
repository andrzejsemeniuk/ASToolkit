//
//  ExtensionForUIControl.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UIControl {

	func addAction(named: String = "", for controlEvents: UIControlEvents, action: @escaping () -> ()) {
		let sleeve = AssociationForClosure(attachTo: self, named: named, closure: action)
		addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
	}

	func removeAction(named: String) {
		objc_setAssociatedObject(self, named, nil, .OBJC_ASSOCIATION_RETAIN)
	}

	func test1() {
		let button = UIButton()
		button.addAction(named: "tap", for: .touchUpInside) { [weak button] in
			button?.setImage(nil, for: .application)
		}
	}
}
