//
//  UIBorder.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

//
//  UIBorder.swift
//  UIPage
//
//  Created by andrej on 4/9/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIBorder : UIView {

	public enum LineCap {
		case butt
		case round
		case square

		public var string : String {
			switch self {
			case .round				: return kCALineCapRound
			case .butt				: return kCALineCapButt
			case .square			: return kCALineCapSquare
			}
		}
	}

	public enum LineJoin {
		case round
		case bevel
		case miter(limit:CGFloat)

		public var string : String {
			switch self {
			case .round				: return kCALineJoinRound
			case .bevel				: return kCALineJoinBevel
			case .miter				: return kCALineJoinMiter
			}
		}
	}

	public var margin 			: UIEdgeInsets			= UIEdgeInsets()
	public var color 			: UIColor				= .white
	public var lineWidth		: CGFloat				= 1
	public var lineCap 			: LineCap 				= .butt
	public var lineJoin			: LineJoin				= .bevel
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
								   join			: LineJoin? = .bevel,
								   cap			: LineCap? = .butt)
	{
		self.lineWidth 			= thickness ?? self.lineWidth
		self.lineDashPattern 	= [NSNumber(value:length),NSNumber(value:spacing)]
		self.lineDashPhase 		= phase ?? self.lineDashPhase
		self.lineJoin			= join ?? self.lineJoin
		self.lineCap			= cap ?? self.lineCap
	}

	open func makeDotted		(thickness		: CGFloat? = nil,
								   spacing		: CGFloat,
								   phase			: CGFloat? = 0,
								   join			: LineJoin? = .round,
								   cap			: LineCap? = .round)
	{
		let width 				= thickness ?? self.lineWidth
		self.lineWidth 			= width
		self.lineDashPattern 	= [NSNumber(value:width),NSNumber(value:spacing)]
		self.lineDashPhase 		= phase ?? self.lineDashPhase
		self.lineJoin			= join ?? self.lineJoin
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
		case .butt				: border.lineCap = kCALineCapButt
		case .round				: border.lineCap = kCALineCapRound
		case .square			: border.lineCap = kCALineCapSquare
		}

		switch self.lineJoin {
		case .bevel				: border.lineJoin = kCALineJoinBevel
		case .round				: border.lineJoin = kCALineJoinRound
		case .miter(limit: let limit) :
			border.lineJoin 	= kCALineJoinMiter
			border.miterLimit 	= limit
		}
	}
}
