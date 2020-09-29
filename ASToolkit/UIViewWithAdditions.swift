//
//  UIViewWithAdditions.swift
//  ASToolkit
//
//  Created by andrej on 5/19/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIViewWithAdditions : UIViewWithDrawings {

	// 8< -----------------------------------------------------------------------------------

	public var isUserInteractionEnabledForSubviewsOnly = false

	override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		if isUserInteractionEnabledForSubviewsOnly {
			return subviews.contains(where: {
				$0.isVisible && $0.point(inside: self.convert(point, to: $0), with: event)
			})
		}
		else
		{
			return super.point(inside: point, with: event)
		}
	}

	// 8< -----------------------------------------------------------------------------------


	@discardableResult
	open func setBorder(			 fill			: UIColor? = nil,
									 color			: UIColor? = nil,
									 insets			: UIEdgeInsets = UIEdgeInsets(),
									 thickness		: CGFloat = 0,
									 cap			: CAShapeLayerLineCap = .butt,
									 join			: CAShapeLayerLineJoin = .bevel,
									 miterLimit		: CGFloat? = nil,
									 pattern		: [CGFloat] = [],
									 phase			: CGFloat = 0) -> CAShapeLayer
	{
		let border = CAShapeLayer()
		//				self.layer.insertSublayer(shape, at: 0)
		self.layer.addSublayer(border)
		border.backgroundColor = nil
		border.shadowColor = nil
		border.borderColor = nil //UIColor.yellow.cgColor
		//		shape.borderWidth = 3

		border.fillColor 			= fill?.cgColor
		border.strokeColor			= color?.cgColor
		if border.strokeColor != nil {
            border.lineCap			= cap
			border.lineJoin			= join
			if let limit = miterLimit {
				border.miterLimit 	= limit
			}
			border.lineWidth			= thickness
			border.lineDashPhase		= phase
			border.lineDashPattern 		= pattern.map { NSNumber(value:$0) }
		}

		self.setNeedsDisplay()

		drawing(add:Drawing(named:"border", draw: { [weak border] view,rect,before in
			guard
				!before,
				let border = border
				else {
					return
			}

			let r						= CGRect.init(
				x			: insets.left,
				y			: insets.top,
				width		: view.bounds.width - insets.left - insets.right,
				height   	: view.bounds.height - insets.top - insets.bottom)

			border.path 				= UIBezierPath(rect: r).cgPath

			}, uninstall: { [weak border] in

				guard
					let border = border
					else {
						return
				}

				border.removeFromSuperlayer()
		}))

		return border
	}


	// 8< -----------------------------------------------------------------------------------

}

