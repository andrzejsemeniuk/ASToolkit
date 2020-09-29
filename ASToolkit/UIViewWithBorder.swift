//
//  UIViewWithBorder.swift
//  ASToolkit
//
//  Created by andrzej on 4/9/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIViewWithBorder : UIView {

	public var margin 			: UIEdgeInsets			= UIEdgeInsets()
	public var color 			: UIColor				= .white
	public var lineWidth		: CGFloat				= 1
	public var lineCap 			: CGLineCap 			= .butt
	public var lineJoin			: CGLineJoin			= .bevel
	public var miterLimit		: CGFloat				= 0
	public var lineDashPattern	: [NSNumber]			= []
	public var lineDashPhase	: CGFloat 				= 0

	open func makeSolid		(width:CGFloat? = nil) {
		self.lineDashPattern 	= []
		self.lineDashPhase 		= 0
	}

	open func makeDashed		(thickness		: CGFloat? = nil,
								 length			: CGFloat,
								 spacing		: CGFloat,
								 phase			: CGFloat? = 0,
								 join			: CGLineJoin? = .bevel,
								 miterLimit		: CGFloat? = nil,
								 cap			: CGLineCap? = .butt)
	{
		self.lineWidth 			= thickness ?? self.lineWidth
		self.lineDashPattern 	= [NSNumber(value:length),NSNumber(value:spacing)]
		self.lineDashPhase 		= phase ?? self.lineDashPhase
		self.lineJoin			= join ?? self.lineJoin
		self.miterLimit			= miterLimit ?? self.miterLimit
		self.lineCap			= cap ?? self.lineCap
	}

	open func makeDotted		(thickness		: CGFloat? = nil,
								 spacing		: CGFloat,
								 phase			: CGFloat? = 0,
								 join			: CGLineJoin? = .round,
								 miterLimit		: CGFloat? = nil,
								 cap			: CGLineCap? = .round)
	{
		let width 				= thickness ?? self.lineWidth
		self.lineWidth 			= width
		self.lineDashPattern 	= [NSNumber(value:width),NSNumber(value:spacing)]
		self.lineDashPhase 		= phase ?? self.lineDashPhase
		self.lineJoin			= join ?? self.lineJoin
		self.miterLimit			= miterLimit ?? self.miterLimit
		self.lineCap			= cap ?? self.lineCap
	}

	private var layout = [NSLayoutConstraint]()

	//	private var observation : NSKeyValueObservation?

	override open func willMove(toSuperview: UIView?) {
		super.willMove(toSuperview: toSuperview)

		//		observation?.invalidate()

		if toSuperview == nil {
			layout.forEach {
				$0.isActive=false
			}
			layout = []
		}
	}

	override open func didMoveToSuperview() {
		super.didMoveToSuperview()

		guard let superview = self.superview else {
			return
		}

		self.translatesAutoresizingMaskIntoConstraints=false

		layout = [
			self.leftAnchor.constraint(equalTo: superview.leftAnchor),
			self.rightAnchor.constraint(equalTo: superview.rightAnchor),
			self.topAnchor.constraint(equalTo: superview.topAnchor),
			self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
		]
		layout.forEach {
			$0.isActive = true
		}

		//		observation = self.superview!.observe(\.bounds) { view,value in
		//			self.update()
		//		}

		self.update()
	}

	override open func layoutSubviews() {
		super.layoutSubviews()
		self.update()
	}

	public private(set) var border : CAShapeLayer!

	open func update() {
		guard let superview = self.superview else {
			return
		}

		if border == nil {
			self.border = CAShapeLayer()
			self.layer.addSublayer(border)
		}

		let frame = CGRect(x		: margin.left,
						   y		: margin.top,
						   width	: superview.bounds.width - margin.right - margin.left,
						   height	: superview.bounds.height - margin.bottom - margin.top)

		border.frame 			= self.bounds
		border.path 			= CGPath.init(rect: frame, transform: nil)
		border.fillColor 		= nil
		border.strokeColor 		= color.cgColor
		border.lineWidth 		= self.lineWidth
		border.lineDashPattern 	= self.lineDashPattern
		border.lineDashPhase 	= self.lineDashPhase

		switch self.lineCap {
            case .butt				: border.lineCap = CAShapeLayerLineCap.butt
            case .round				: border.lineCap = CAShapeLayerLineCap.round
            case .square			: border.lineCap = CAShapeLayerLineCap.square
		}

		switch self.lineJoin {
            case .bevel				: border.lineJoin = CAShapeLayerLineJoin.bevel
            case .round				: border.lineJoin = CAShapeLayerLineJoin.round
		case .miter				:
            border.lineJoin 	= CAShapeLayerLineJoin.miter
			border.miterLimit 	= miterLimit
		}
	}
}
