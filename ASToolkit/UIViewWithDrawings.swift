//
//  UIViewWithDrawings.swift
//  ASToolkit
//
//  Created by andrej on 5/11/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit


open class UIViewWithDrawings : UIView {

	public struct Drawing : Equatable {

		public typealias FunctionForUpdate 		= (_ view:UIView,_ before:Bool)->Void
		public typealias FunctionForDraw 		= (_ view:UIView,_ rect:CGRect,_ before:Bool)->Void
		public typealias FunctionForUninstall 	= ()->Void

		public var name			: String
		public var update		: FunctionForUpdate?
		public var draw			: FunctionForDraw?
		public var uninstall    : FunctionForUninstall?

		public init(named			:String,
					update			:FunctionForUpdate? = nil,
					draw			:@escaping FunctionForDraw,
					uninstall		:FunctionForUninstall? = nil) {
			self.name = named
			self.update = update
			self.draw = draw
			self.uninstall = uninstall
		}

		static public func ==(lhs:Drawing, rhs:Drawing) -> Bool {
			return lhs.name == rhs.name
		}
	}

	public private(set) var drawings : [Drawing] = []

	public func clear() {
		self.drawings = []
	}

	public func drawing(add: Drawing) {
		if let index = drawings.index(where: { $0 == add || $0.name == add.name }) {
			let previous = drawings[index]
			previous.uninstall?()
			drawings[index] = add
		}
		else {
			drawings.append(add)
		}
	}

	public func drawing(remove:Drawing) {
		drawings.remove(remove)
	}

	override open func layoutSubviews() {

		for drawing in drawings {
			drawing.update?(self,true)
		}

		super.layoutSubviews()

		for drawing in drawings {
			drawing.update?(self,false)
		}
	}

	override open func draw(_ rect: CGRect) {
		for drawing in drawings {
			drawing.draw?(self,rect,true)
		}

		super.draw(rect)

		for drawing in drawings {
			drawing.draw?(self,rect,false)
		}

	}

}

extension UIViewWithDrawings {

	public enum DebugDrawingType {
		case grid
		case centers(width:CGFloat, color:UIColor, pattern:[CGFloat])
		case centerX(width:CGFloat, color:UIColor, pattern:[CGFloat])
		case centerY(width:CGFloat, color:UIColor, pattern:[CGFloat])
		case h(CGPosition,width:CGFloat, color:UIColor, pattern:[CGFloat])
		case v(CGPosition,width:CGFloat, color:UIColor, pattern:[CGFloat])
	}

	public func drawingAdd(named			: String? = nil,
						   debug type    	: DebugDrawingType,
						   before _before	: Bool = false,
						   after _after		: Bool = false)
	{
		guard _before || _after else {
			assert(false)
            return
		}

		switch type {

		case .grid:
			break
		case .centers(let width, let color, let pattern):
			self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "centers",
														 draw : { view,rect,before in
															guard before==_before || (!before)==_after else {
																return
															}
															if let X = UIGraphicsGetCurrentContext() {
																let path = CGMutablePath()
																path.move(to: CGPoint(x:rect.midX,y:rect.top))
																path.addLine(to: CGPoint(x:rect.midX,y:rect.bottom))
																path.closeSubpath()
																path.move(to: CGPoint(x:rect.left,y:rect.midY))
																path.addLine(to: CGPoint(x:rect.right,y:rect.midY))
																path.closeSubpath()
																X.addPath(path)
																X.setLineWidth(width)
																X.setStrokeColor(color.cgColor)
																X.setLineDash(phase: 0, lengths: pattern)
																X.drawPath(using: .stroke)
															}
			}))

		case .centerX(let width, let color, let pattern):
			self.drawingAdd(debug: .h(CGPosition(0.5,.ratio),width:width,color:color,pattern:pattern))

		case .centerY(let width, let color, let pattern):
			self.drawingAdd(debug: .v(CGPosition(0.5,.ratio),width:width,color:color,pattern:pattern))

		case .h(let position, let width, let color, let pattern):
			self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "h(\(position)",
				draw : { view,rect,before in
					guard before==_before || (!before)==_after else {
						return
					}
					if let X = UIGraphicsGetCurrentContext() {
						let path = CGMutablePath()
						let y = position.value < 0 ? 	rect.bottom + position.offset(rect.height) :
							rect.top + position.offset(rect.height)
						path.move(to: CGPoint(x:rect.left,y:y))
						path.addLine(to: CGPoint(x:rect.right,y:y))
						path.closeSubpath()
						X.addPath(path)
						X.setLineWidth(width)
						X.setStrokeColor(color.cgColor)
						X.setLineDash(phase: 0, lengths: pattern)
						X.drawPath(using: .stroke)
					}
			}))

		case .v(let position, let width, let color, let pattern):
			self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "v(\(position)",
				draw : { view,rect,before in
					guard before==_before || (!before)==_after else {
						return
					}
					if let X = UIGraphicsGetCurrentContext() {
						let path = CGMutablePath()
						let x = position.value < 0 ? 	rect.right + position.offset(rect.width) :
							rect.left + position.offset(rect.width)
						path.move(to: CGPoint(x:x,y:rect.top))
						path.addLine(to: CGPoint(x:x,y:rect.bottom))
						path.closeSubpath()
						X.addPath(path)
						X.setLineWidth(width)
						X.setStrokeColor(color.cgColor)
						X.setLineDash(phase: 0, lengths: pattern)
						X.drawPath(using: .stroke)
					}
			}))
		}
	}
}


extension UIViewWithDrawings {

	public func drawingAddLineHorizontal(named			: String? = nil,
										 position		: CGPosition,
										 stroke			: CGStroke,
										 before 		: Bool = false,
										 after 			: Bool = false)
	{
		self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "h(\(position)",
			draw : { view,rect,before_ in
				guard before_==before || (!before_)==after else {
					return
				}
				if let X = UIGraphicsGetCurrentContext() {
					let path = CGMutablePath()
					let y = position.value < 0 ?
						rect.bottom + position.offset(rect.height)
						:
						rect.top + position.offset(rect.height)
					path.move(to: CGPoint(x:rect.left,y:y))
					path.addLine(to: CGPoint(x:rect.right,y:y))
					path.closeSubpath()
					X.addPath(path)
					stroke.apply(X)
					X.drawPath(using: .stroke)
				}
		}))

	}


	public func drawingAddLineVertical	(named			: String? = nil,
										 position		: CGPosition,
										 stroke			: CGStroke,
										 before 		: Bool = false,
										 after 			: Bool = false)
	{
		self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "h(\(position)",
			draw : { view,rect,before_ in
				guard before_==before || (!before_)==after else {
					return
				}
				if let X = UIGraphicsGetCurrentContext() {
					let path = CGMutablePath()
					let x = position.value < 0 ?
						rect.right + position.offset(rect.width)
						:
						rect.left + position.offset(rect.width)
					path.move(to: CGPoint(x:x,y:rect.top))
					path.addLine(to: CGPoint(x:x,y:rect.bottom))
					path.closeSubpath()
					X.addPath(path)
					stroke.apply(X)
					X.drawPath(using: .stroke)
				}
		}))

	}


	public func drawingAddRectangle		(named			: String? 		= nil,
										 frame 			: CGRect,
										 stroke			: CGStroke,
										 fill 			: UIColor? 		= nil,
										 before 		: Bool 			= false,
										 after 			: Bool 			= false)
	{
		self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "r(\(frame)",
			draw : { view,rect,before_ in
				guard before_==before || (!before_)==after else {
					return
				}
				if let X = UIGraphicsGetCurrentContext() {
					let path = CGMutablePath()
					path.addRect(frame)
					path.closeSubpath()
					X.addPath(path)
					stroke.apply(X)
					X.drawPath(using: .stroke)
				}
		}))

	}




	public func drawingAddRectangles		(named			: String? 		= nil,
											frames 			: [CGRect],
											stroke			: CGStroke,
											fill 			: UIColor? 		= nil,
											before 			: Bool 			= false,
											after 			: Bool 			= false)
	{
		self.drawing(add: UIViewWithDrawings.Drawing(named: named ?? "rrr(\(frame)",
			draw : { view,rect,before_ in
				guard before_==before || (!before_)==after else {
					return
				}
				if let X = UIGraphicsGetCurrentContext() {
					let path = CGMutablePath()
					for frame in frames {
						path.addRect(frame)
					}
					path.closeSubpath()
					X.addPath(path)
					stroke.apply(X)
					X.drawPath(using: .stroke)
				}
		}))

	}


}

