//
//  ExtensionForUIKitUIButton.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/15/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

#if false
public extension UIButton {

	func addTap(named: String = "", action: @escaping () -> ()) {
		self.addAction(named: named, for: .touchUpInside, action: action)
	}

	func addTapIfSelected(named: String = "", deselect after: TimeInterval? = nil, action: @escaping () -> ()) {
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

	func addTapIfNotSelected(named: String = "", select: Bool = true, deselect after: TimeInterval? = nil, action: @escaping () -> ()) {
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

public extension UIButton {
    
    func decorate(margin:CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(all:margin)
    }
    
    func decorate(borderWidth:CGFloat) {
        self.layer.borderWidth = borderWidth
    }
    
    func decorate(borderColor:UIColor) {
        self.layer.borderColor = borderColor.cgColor
    }
}

public extension UIButton {

	func setAttributedTitle(_ string: String, for state: UIControl.State) {
		self.setAttributedTitle(NSAttributedString(string:string), for: state)
	}

}
#endif
