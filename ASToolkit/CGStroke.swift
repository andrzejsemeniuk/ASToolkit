//
//  CGStroke.swift
//  ASToolkit
//
//  Created by andrej on 6/19/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public struct CGStroke {

	public var color		: CGColor 		= UIColor.white.cgColor
	public var thickness	: CGFloat 		= 0
	public var cap			: CGLineCap 	= .butt
	public var join			: CGLineJoin 	= .bevel
	public var miterLimit	: CGFloat 		= 0
	public var pattern		: [CGFloat] 	= []
	public var phase		: CGFloat 		= 0

	public init(color		: UIColor 		= UIColor.white,
				thickness	: CGFloat 		= 0,
				cap			: CGLineCap 	= .butt,
				join		: CGLineJoin 	= .bevel,
				miterLimit	: CGFloat 		= 0,
				pattern		: [CGFloat] 	= [],
				phase		: CGFloat 		= 0) {
		self.color			= color.cgColor
		self.thickness		= thickness
		self.cap			= cap
		self.join			= join
		self.miterLimit		= miterLimit
		self.pattern		= pattern
		self.phase			= phase
	}

	public func apply(_ context:CGContext) {
		context.setStrokeColor	(color)
		context.setLineWidth	(thickness)
		context.setLineDash		(phase: phase, lengths: pattern)
		context.setLineCap		(cap)
		context.setLineJoin		(join)
		context.setMiterLimit	(miterLimit)
	}
}
