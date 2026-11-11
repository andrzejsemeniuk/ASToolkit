//
//  UIViewWithoutInteraction.swift
//  ASToolkit
//
//  Created by andrej on 5/19/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIViewWithoutInteraction : UIView {

	override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return subviews.contains(where: { view in
			let visible = view.isVisible
			let inside = view.point(inside: self.convert(point, to: view), with: event)
//			$0.isVisible && $0.point(inside: self.convert(point, to: $0), with: event)
			print("inside:\(inside) point:\(point), view:\(view)")
			return inside
		})
	}

}

