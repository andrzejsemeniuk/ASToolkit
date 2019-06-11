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

	open func addTapIfSelected(named: String = "", deselect after: TimeInterval? = nil, action: @escaping () -> ()) {
		self.addAction(named: named, for: .touchUpInside, action: {
			if self.isSelected {
				action()
				if let after = after {
					DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
						self?.isSelected = false
					}
				}
			}
		})
	}

	open func addTapIfNotSelected(named: String = "", select: Bool = true, deselect after: TimeInterval? = nil, action: @escaping () -> ()) {
		self.addAction(named: named, for: .touchUpInside, action: {
			if !self.isSelected {
				action()
				if select {
					DispatchQueue.main.async {
						self.isSelected = true
					}
				}
				if let after = after {
					DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
						self?.isSelected = false
					}
				}
			}
		})
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

	open func setAttributedTitle(_ string: String, for state: UIControl.State) {
		self.setAttributedTitle(NSAttributedString(string:string), for: state)
	}

}
