//
//  ExtensionForUIKitUIButton.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/15/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UIButton {

	open func addTap(named: String = "", action: @escaping () -> ()) {
		self.addAction(named: named, for: .touchUpInside, action: action)
	}

}

extension UIButton {
    
    open func decorate(margin:CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(all:margin)
    }
    
    open func decorate(borderWidth:CGFloat) {
        self.layer.borderWidth = borderWidth
    }
    
    open func decorate(borderColor:UIColor) {
        self.layer.borderColor = borderColor.cgColor
    }
}

extension UIButton {

	open func setAttributedTitle(_ string: String, for state: UIControlState) {
		self.setAttributedTitle(NSAttributedString(string:string), for: state)
	}

}
