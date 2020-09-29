//
//  ExtensionForUIKitUIView.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
	public var isVisible : Bool {
		get {
			return !isHidden
		}
		set {
			isHidden = !newValue
		}
	}
	
    public class func create(withBackgroundColor color:UIColor = .clear, frame:CGRect = CGRect.zero) -> UIView
    {
        let result = UIView(frame:frame)
        result.backgroundColor = color
        return result
    }
}

extension UIView
{
	public var asUIImage : UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}

extension UIView
{
    public func addSublayerCircle(withRadius            : CGFloat,
                                  center                : CGPoint?      = nil,
                                  index                 : UInt32        = 0,
                                  fillColor             : UIColor?      = nil,
                                  strokeColor           : UIColor?      = nil,
                                  lineWidth             : CGFloat?      = nil) -> CAShapeLayer {
        
        // NOTE: SUBLAYER IS RENDERED ABOVE PARENT LAYER
        // NOTE: SUBLAYER IS RENDERED WRT PARENT ORIGIN WHICH IS IN TOP-LEFT CORNER
        // NOTE: POSITIVE X EXTENDS TO THE RIGHT
        // NOTE: POSITIVE Y EXTENDS TO THE BOTTOM
        
        let shape : CAShapeLayer = CAShapeLayer()
        
        let center = center ?? CGPoint.zero
        
        let path  : UIBezierPath = UIBezierPath(arcCenter: CGPoint(x:center.x+self.frame.size.width/2,
                                                                   y:center.y+self.frame.size.height/2),
                                                radius: withRadius,
                                                startAngle: 0,
                                                endAngle: 2 * CGFloat.pi,
                                                clockwise: false)

        shape.path = path.cgPath
        
        if let strokeColor = strokeColor {
            shape.strokeColor = strokeColor.cgColor
        }
        
        if let lineWidth = lineWidth {
            shape.lineWidth = lineWidth
        }
        
        if let fillColor = fillColor {
            shape.fillColor = fillColor.cgColor
        }
        
        self.layer.insertSublayer(shape, at: index)
        
        return shape
    }
}

extension UIView {
    
    open func removeAllConstraints() {
		NSLayoutConstraint.deactivate(self.constraints)
    }

	open func removeAllConstraints(withCondition condition:(NSLayoutConstraint)->Bool) {
		constraints.forEach {
			if condition($0) {
				$0.isActive = false
			}
		}
	}
    
	open func removeAllConstraints(withIdentifier identifier:String) {
		removeAllConstraints(withCondition:{ constrain in
			return constrain.identifier == identifier
		})
	}

	@discardableResult open func constraintGetCenterXToSuperview() -> NSLayoutConstraint? {
		if let superview = superview {
			for c in superview.constraints {
				if (c.firstAnchor == superview.centerXAnchor && c.secondAnchor == self.centerXAnchor) ||
					(c.secondAnchor == superview.centerXAnchor && c.firstAnchor == self.centerXAnchor) {
					return c
				}
			}
		}
		return nil
	}
	
	@discardableResult open func constraintGetCenterYToSuperview() -> NSLayoutConstraint? {
		if let superview = superview {
			for c in superview.constraints {
				if (c.firstAnchor == superview.centerYAnchor && c.secondAnchor == self.centerYAnchor) ||
					(c.secondAnchor == superview.centerYAnchor && c.firstAnchor == self.centerYAnchor) {
					return c
				}
			}
		}
		return nil
	}

	@discardableResult open func constraintGetOrCreateCenterXToSuperview() -> NSLayoutConstraint? {
		return constraintGetCenterXToSuperview() ?? self.constrainCenterXToSuperview()
	}

	@discardableResult open func constraintGetOrCreateCenterYToSuperview() -> NSLayoutConstraint? {
		return constraintGetCenterYToSuperview() ?? self.constrainCenterYToSuperview()
	}

    @discardableResult open func constraintBetween(left:NSLayoutAnchor<NSLayoutXAxisAnchor>, right:NSLayoutAnchor<NSLayoutXAxisAnchor>) -> UILayoutGuide {
        let g = UILayoutGuide()
        self.addLayoutGuide(g)
        g.rightAnchor.constraint(equalTo: right).activated()
        g.leftAnchor.constraint(equalTo: left).activated()
        self.centerXAnchor.constraint(equalTo: g.centerXAnchor).activated()
        return g
    }
    
    @discardableResult open func constraintBetween(top:NSLayoutAnchor<NSLayoutYAxisAnchor>, bottom:NSLayoutAnchor<NSLayoutYAxisAnchor>) -> UILayoutGuide {
        let g = UILayoutGuide()
        self.addLayoutGuide(g)
        g.topAnchor.constraint(equalTo: top).activated()
        g.bottomAnchor.constraint(equalTo: bottom).activated()
        self.centerYAnchor.constraint(equalTo: g.centerYAnchor).activated()
        return g
    }

    @discardableResult open func constrainBetween(left:NSLayoutAnchor<NSLayoutXAxisAnchor>, right:NSLayoutAnchor<NSLayoutXAxisAnchor>) -> UILayoutGuide {
        return constraintBetween(left: left, right: right)
    }
    
    @discardableResult open func constrainBetween(top:NSLayoutAnchor<NSLayoutYAxisAnchor>, bottom:NSLayoutAnchor<NSLayoutYAxisAnchor>) -> UILayoutGuide {
        return constraintBetween(top: top, bottom: bottom)
    }
    
    @discardableResult open func addSubviewCentered(_ view:UIView) -> (x:NSLayoutConstraint, y:NSLayoutConstraint)? {
        self.addSubview(view)
        return view.constrainCenterToSuperview()
    }
    

	@discardableResult open func constrainCenterX(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        let r = self.centerXAnchor.constraint(equalTo: to.centerXAnchor, constant:withMargin)
		r.identified(withIdentifier).isActive = activate
		return r
    }
    
    @discardableResult open func constrainCenterY(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        let r = self.centerYAnchor.constraint(equalTo: to.centerYAnchor, constant:withMargin)
		r.identified(withIdentifier).isActive = activate
		return r
    }
    
	@discardableResult open func constrainCenter(to:UIView, withIdentifier:String? = nil, activate: Bool = true) -> (x:NSLayoutConstraint, y:NSLayoutConstraint) {
		return (x:self.constrainCenterX(to: to, withIdentifier:withIdentifier, activate: activate),
				y:self.constrainCenterY(to: to, withIdentifier:withIdentifier, activate: activate))
    }
    
    @discardableResult open func constrainCenterToSuperview(withIdentifier:String? = nil, activate: Bool = true) -> (x:NSLayoutConstraint, y:NSLayoutConstraint)? {
        if let superview = superview {
            return constrainCenter(to:superview, withIdentifier:withIdentifier, activate: activate)
        }
		return nil
    }
    
    @discardableResult open func constrainCenterXToSuperview(withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        if let superview = superview {
            return constrainCenterX(to:superview, withMargin:withMargin, withIdentifier:withIdentifier, activate: activate)
        }
		return nil
    }
    
    @discardableResult open func constrainCenterYToSuperview(withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        if let superview = superview {
            return constrainCenterY(to:superview, withMargin:withMargin, withIdentifier:withIdentifier, activate: activate)
        }
		return nil
    }
    
	@discardableResult open func constrainTopLeftCornerToSuperview(withIdentifier:String? = nil, activate: Bool = true) -> (top:NSLayoutConstraint,left:NSLayoutConstraint)? {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
			return (
				top		: self.topAnchor.constraint(equalTo: superview.topAnchor).identified(withIdentifier).activated(activate),
				left	: self.leftAnchor.constraint(equalTo: superview.leftAnchor).identified(withIdentifier).activated(activate)
			)
        }
		return nil
    }
    
	@discardableResult open func constrainWidthToSuperview(withIdentifier:String? = nil, withMargin:CGFloat = 0, activate: Bool = true) -> NSLayoutConstraint? {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
			return self.widthAnchor.constraint(equalTo: superview.widthAnchor).extended(withMargin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainHeightToSuperview(withIdentifier:String? = nil, withMargin:CGFloat = 0, activate: Bool = true) -> NSLayoutConstraint? {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            return self.heightAnchor.constraint(equalTo: superview.heightAnchor).extended(withMargin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
	@discardableResult open func constrainSizeToSuperview(withIdentifier:String? = nil, activate: Bool = true) -> (width:NSLayoutConstraint?,height:NSLayoutConstraint?) {
		return (
			width	: constrainWidthToSuperview(withIdentifier:withIdentifier, activate: activate),
			height	: constrainHeightToSuperview(withIdentifier:withIdentifier, activate: activate)
		)
    }
    
    @discardableResult open func constrainSizeToFrameSize(withIdentifier:String? = nil, activate: Bool = true) -> (width:NSLayoutConstraint?,height:NSLayoutConstraint?) {
        self.translatesAutoresizingMaskIntoConstraints=false
		return (
			width	: self.widthAnchor.constraint(equalToConstant: frame.width).identified(withIdentifier).activated(activate),
			height	: self.heightAnchor.constraint(equalToConstant: frame.height).identified(withIdentifier).activated(activate)
		)
    }

    
    
    @discardableResult open func constrainTopToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }

    @discardableResult open func constrainBottomToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }

    @discardableResult open func constrainLeftToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainRightToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }

    
    
    @discardableResult open func constrainTopToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainBottomToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.bottomAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }

    @discardableResult open func constrainLeftToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.leftAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainRightToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.rightAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    
    
	@discardableResult open func constrainToSuperview(withInsets insets:UIEdgeInsets? = nil, withIdentifier:String? = nil, activate: Bool = true) -> (top:NSLayoutConstraint?,left:NSLayoutConstraint?,bottom:NSLayoutConstraint?,right:NSLayoutConstraint?) {
		if let insets = insets {
			return (
				top		: constrainTopToSuperviewTop          (withMargin: insets.top, withIdentifier:withIdentifier, activate: activate),
				left	: constrainLeftToSuperviewLeft        (withMargin: insets.left, withIdentifier:withIdentifier, activate: activate),
				bottom	: constrainBottomToSuperviewBottom    (withMargin: insets.bottom, withIdentifier:withIdentifier, activate: activate),
				right	: constrainRightToSuperviewRight      (withMargin: insets.right, withIdentifier:withIdentifier, activate: activate)
			)
		}
		else {
			return (
				top		: constrainTopToSuperviewTop(withIdentifier:withIdentifier, activate: activate),
				left	: constrainLeftToSuperviewLeft(withIdentifier:withIdentifier, activate: activate),
				bottom	: constrainBottomToSuperviewBottom(withIdentifier:withIdentifier, activate: activate),
				right	: constrainRightToSuperviewRight(withIdentifier:withIdentifier, activate: activate)
			)
		}
	}

    @discardableResult open func constrainToSuperview(withMargins insets:UIEdgeInsets, withIdentifier:String? = nil, activate: Bool = true) -> (top:NSLayoutConstraint?,bottom:NSLayoutConstraint?,left:NSLayoutConstraint?,right:NSLayoutConstraint?) {
		return constrainToSuperview(withInsets: insets, withIdentifier: withIdentifier, activate: activate)
    }
    
    
    
    @discardableResult open func constrainCenterYToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.centerYAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainCenterYToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainCenterXToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.centerXAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    @discardableResult open func constrainCenterXToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            return self.centerXAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
        }
		return nil
    }
    
    
    
    
    @discardableResult open func constrainTopToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.topAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainBottomToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.bottomAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainLeftToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.leftAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainRightToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.rightAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    

    
    
    
    @discardableResult open func constrainTopToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.topAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainBottomToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.bottomAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
	@discardableResult open func constrainLeftToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.leftAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainRightToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.rightAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }

    
    
    
    @discardableResult open func constrainCenterYToCenterY(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.centerYAnchor.constraint(equalTo: of.centerYAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
	@discardableResult open func constrainCenterYToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
		self.translatesAutoresizingMaskIntoConstraints=false
		return self.centerYAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).activated(activate)
	}

    @discardableResult open func constrainCenterYToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.centerYAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
	@discardableResult open func constrainCenterXToCenterX(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
		self.translatesAutoresizingMaskIntoConstraints=false
		return self.centerXAnchor.constraint(equalTo: of.centerXAnchor, constant: margin).identified(withIdentifier).activated(activate)
	}

    @discardableResult open func constrainCenterXToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.centerXAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainCenterXToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.centerXAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }

    
    
    
    @discardableResult open func constrainTopToCenterY(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.topAnchor.constraint(equalTo: of.centerYAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainBottomToCenterY(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.bottomAnchor.constraint(equalTo: of.centerYAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainLeftToCenterX(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.leftAnchor.constraint(equalTo: of.centerXAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainRightToCenterX(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.rightAnchor.constraint(equalTo: of.centerXAnchor, constant: margin).identified(withIdentifier).activated(activate)
    }
    
    
    
    

    @discardableResult open func constrain(width:CGFloat, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.widthAnchor.constraint(equalToConstant: width).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrain(height:CGFloat, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.heightAnchor.constraint(equalToConstant: height).identified(withIdentifier).activated(activate)
    }
    

    @discardableResult open func constrainWidth(to:CGFloat, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.widthAnchor.constraint(equalToConstant: to).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainHeight(to:CGFloat, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.heightAnchor.constraint(equalToConstant: to).identified(withIdentifier).activated(activate)
    }
    
    
    @discardableResult open func constrainWidth(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.widthAnchor.constraint(equalTo:to.widthAnchor, constant:withMargin).identified(withIdentifier).activated(activate)
    }
    
    @discardableResult open func constrainHeight(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil, activate: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints=false
        return self.heightAnchor.constraint(equalTo:to.heightAnchor, constant: withMargin).identified(withIdentifier).activated(activate)
    }

	@discardableResult open func constrain(size:CGSize, withIdentifier:String? = nil, activate: Bool = true) -> (width:NSLayoutConstraint,height:NSLayoutConstraint) {
		return (width:constrain(width:size.width,withIdentifier:withIdentifier, activate: activate),height:constrain(height:size.height,withIdentifier:withIdentifier, activate: activate))
	}


}


extension UIView {



	open func constrain(views: [UIView], producer: (_ previous: UIView, _ current: UIView)->NSLayoutConstraint) -> [NSLayoutConstraint] {
		var previous = self
		var r : [NSLayoutConstraint] = []
		for current in views {
//			current.translatesAutoresizingMaskIntoConstraints=false
			r.append(producer(previous,current))
			previous = current
		}
		return r
	}



	@discardableResult open func constrainViewsCenterXToCenterX(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterX(to: previous, withMargin: offset).activated(activate)
		}
	}

	@discardableResult open func constrainViewsCenterYToCenterY(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterY(to: previous, withMargin: offset).activated(activate)
		}
	}



	@discardableResult open func constrainViewsCenterXToRight(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterXToRight(of: previous, withMargin: offset).activated(activate)
		}
	}

	@discardableResult open func constrainViewsCenterXToLeft(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterXToLeft(of: previous, withMargin: offset).activated(activate)
		}
	}



	@discardableResult open func constrainViewsLeftToRight(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainLeftToRight(of: previous, withMargin: offset).activated(activate)
		}
	}

	@discardableResult open func constrainViewsRightToLeft(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainRightToLeft(of: previous, withMargin: offset).activated(activate)
		}
	}




	@discardableResult open func constrainViewsCenterYToTop(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterYToTop(of: previous, withMargin: offset).activated(activate)
		}
	}

	@discardableResult open func constrainViewsCenterYToBottom(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainCenterYToBottom(of: previous, withMargin: offset).activated(activate)
		}
	}




	@discardableResult open func constrainViewsBottomToTop(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainBottomToTop(of: previous, withMargin: offset).activated(activate)
		}
	}

	@discardableResult open func constrainViewsTopToBottom(for views: [UIView], offset: CGFloat = 0, activate: Bool = true) -> [NSLayoutConstraint] {
		return constrain(views: views) { previous, current in
			current.constrainTopToBottom(of: previous, withMargin: offset).activated(activate)
		}
	}




}





extension UIView {

	public enum LayoutCoordinate {
		case top
		case left
		case bottom
		case right
		case centerX
		case centerY
	}

	@discardableResult open func constrain(_ coordinate:LayoutCoordinate, to:LayoutCoordinate, of view:UIView, margin:CGFloat? = nil) -> NSLayoutConstraint? {
		let margin = margin ?? 0
		switch (coordinate,to) {
		case (.top,.top)                    : return self.constrainTopToTop			(of: view, withMargin: margin)
		case (.top,.centerY)                : return self.constrainTopToCenterY		(of: view, withMargin: margin)
		case (.top,.bottom)                 : return self.constrainTopToBottom		(of: view, withMargin: margin)
		case (.centerY,.top)                : return self.constrainCenterYToTop		(of: view, withMargin: margin)
		case (.centerY,.centerY)            : return self.constrainCenterYToCenterY	(of: view, withMargin: margin)
		case (.centerY,.bottom)             : return self.constrainCenterYToBottom	(of: view, withMargin: margin)
		case (.bottom,.top)                 : return self.constrainBottomToTop		(of: view, withMargin: margin)
		case (.bottom,.centerY)             : return self.constrainBottomToCenterY	(of: view, withMargin: margin)
		case (.bottom,.bottom)              : return self.constrainBottomToBottom	(of: view, withMargin: margin)
		case (.left,.left)                  : return self.constrainLeftToLeft		(of: view, withMargin: margin)
		case (.left,.centerX)               : return self.constrainLeftToCenterX	(of: view, withMargin: margin)
		case (.left,.right)                 : return self.constrainLeftToRight		(of: view, withMargin: margin)
		case (.centerX,.left)               : return self.constrainCenterXToLeft	(of: view, withMargin: margin)
		case (.centerX,.centerX)            : return self.constrainCenterXToCenterX	(of: view, withMargin: margin)
		case (.centerX,.right)              : return self.constrainCenterXToRight	(of: view, withMargin: margin)
		case (.right,.left)                 : return self.constrainRightToLeft		(of: view, withMargin: margin)
		case (.right,.centerX)              : return self.constrainRightToCenterX	(of: view, withMargin: margin)
		case (.right,.right)                : return self.constrainRightToRight	(of: view, withMargin: margin)
		default:
			return nil
		}
	}

	@discardableResult open func constrain(coordinates coordinate:LayoutCoordinate, with:UIView, margin:CGFloat? = nil) -> NSLayoutConstraint? {
		return self.constrain(coordinate, to: coordinate, of: with, margin:margin)
	}

	@discardableResult open func constrain(_ coordinate:LayoutCoordinate, to parent:LayoutCoordinate, margin:CGFloat? =  nil) -> NSLayoutConstraint? {
		return self.constrain(coordinate, to:parent, of:self.superview!, margin:margin)
	}

	@discardableResult open func constrain(_ coordinate:LayoutCoordinate, margin:CGFloat? =  nil) -> NSLayoutConstraint? {
		return self.constrain(coordinate, to:coordinate, of:self.superview!, margin:margin)
	}






	public enum LayoutLocationOfParent {
		case topLeft
		case topCenter
		case topRight
		case centerLeft
		case centerCenter
		case centerRight
		case bottomLeft
		case bottomCenter
		case bottomRight
	}

	open func constrain(toParent location:LayoutLocationOfParent, marginX:CGFloat? = nil, marginY:CGFloat? = nil) {
		let mx = marginX ?? 0
		let my = marginY ?? 0
		switch location {
		case .topLeft:
			constrain(.top, margin:my)
			constrain(.left, margin:mx)
		case .topCenter:
			constrain(.top, margin:my)
			constrain(.centerX, margin:mx)
		case .topRight:
			constrain(.top, margin:my)
			constrain(.right, margin:mx)
		case .bottomLeft:
			constrain(.bottom, margin:my)
			constrain(.left, margin:mx)
		case .bottomCenter:
			constrain(.bottom, margin:my)
			constrain(.centerX, margin:mx)
		case .bottomRight:
			constrain(.bottom, margin:my)
			constrain(.right, margin:mx)
		case .centerLeft:
			constrain(.centerY, margin:my)
			constrain(.left, margin:mx)
		case .centerCenter:
			constrain(.centerY, margin:my)
			constrain(.centerX, margin:mx)
		case .centerRight:
			constrain(.centerY, margin:my)
			constrain(.right, margin:mx)
		}
	}




	public enum LayoutLocation {
		case leftOf             (UIView)
		case rightOf            (UIView)
		case above              (UIView)
		case below              (UIView)

		case centerXWith        (UIView)
		case centerYWith        (UIView)

		case topLeftOf          (UIView)
		case bottomLeftOf       (UIView)
		case topRightOf         (UIView)
		case bottomRightOf      (UIView)
	}

	@discardableResult open func constrain(to location:LayoutLocation, margin:CGFloat) {
		switch location {
		case .leftOf(let other)         :
			self.constrainCenterY(to: other)
			self.constrainCenterXToLeft(of: other, withMargin: margin)
		case .rightOf(let other)        :
			self.constrainCenterY(to: other)
			self.constrainCenterXToRight(of: other, withMargin: margin)
		case .above(let other):
			self.constrainBottomToTop(of: other, withMargin: margin)
			self.constrainCenterX(to: other)
		case .below(let other):
			self.constrainTopToBottom(of: other, withMargin: margin)
			self.constrainCenterX(to: other)
		case .centerXWith(let other):
			self.constrainCenterX(to: other)
		case .centerYWith(let other):
			self.constrainCenterY(to: other)
		case .topLeftOf(let other):
			self.constrainTopToTop(of: other, withMargin: margin)
			self.constrainLeftToLeft(of: other, withMargin: margin)
		case .bottomLeftOf(let other):
			self.constrainBottomToBottom(of: other, withMargin: margin)
			self.constrainLeftToLeft(of: other, withMargin: margin)
		case .topRightOf(let other):
			self.constrainTopToTop(of: other, withMargin: margin)
			self.constrainRightToRight(of: other, withMargin: margin)
		case .bottomRightOf(let other):
			self.constrainBottomToBottom(of: other, withMargin: margin)
			self.constrainRightToRight(of: other, withMargin: margin)
		}
	}







	@discardableResult open func constrain(height multiplier:CGFloat, constant:CGFloat, identifier:String? = nil) -> NSLayoutConstraint {
		return NSLayoutConstraint.init(item		: self,
									   attribute	: .height,
									   relatedBy	: .equal,
									   toItem		: self.superview,
									   attribute	: .height,
									   multiplier	: multiplier,
									   constant		: constant).identified(identifier).activated()
	}

	@discardableResult open func constrain(width multiplier:CGFloat, constant:CGFloat, identifier:String? = nil) -> NSLayoutConstraint {
		return NSLayoutConstraint.init(item		: self,
									   attribute	: .width,
									   relatedBy	: .equal,
									   toItem		: self.superview,
									   attribute	: .width,
									   multiplier	: multiplier,
									   constant		: constant).identified(identifier).activated()
	}


}


extension UIView {
    
    /// Add provided views as subviews all at once.
    ///
    /// - Parameter views: views to add as subviews to this view
    open func addSubviews(_ views:[UIView]) {
        views.forEach { self.addSubview($0) }
    }

}

extension UIView {

	public class func schedule(_ block: @escaping ()->()) {
		DispatchQueue.main.async {
			block()
		}
	}

	public func schedule(_ block: @escaping ()->()) {
		UIView.schedule(block)
	}

	public func scheduleNeedsDisplay(_ block: (()->())? = nil) {
		UIView.schedule { [weak self] in
			self?.setNeedsDisplay()
			block?()
		}
	}

	public func scheduleNeedsLayout(_ block: (()->())? = nil) {
		UIView.schedule { [weak self] in
			self?.setNeedsLayout()
			block?()
		}
	}

	public func scheduleNeedsUpdateConstraints(_ block: (()->())? = nil) {
		UIView.schedule { [weak self] in
			self?.setNeedsUpdateConstraints()
			block?()
		}
	}

}


extension UIView {

	open func subview(withTag:Int) -> UIView? {
		return subviews.first { $0.tag == withTag }
	}

	open func subviews(withTag:Int) -> [UIView] {
		return subviews.filter { $0.tag == withTag }
	}

    open func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
	open func removeAllSubviews(withTag:Int) {
		self.subviews.forEach {
			if $0.tag == withTag {
				$0.removeFromSuperview()
			}
		}
	}

	open func removeAllSubviews(withCondition condition:(UIView)->Bool) {
		self.subviews.forEach {
			if condition($0) {
				$0.removeFromSuperview()
			}
		}
	}

    open func removeSubview(withTag:Int) {
        if let result = subview(withTag: withTag) {
            result.removeFromSuperview()
        }
    }
}


extension UIView {
    
    /// Adds views on on top of the previous
    ///
    /// - Parameters:
    ///   - views: the views to stack
    ///   - constrainCenters: if true will create constraint to center view to previous view's center
    public func pile(views:[UIView], constrainCenters:Bool) {
        var current = self
        for view in views {
            current.addSubview(view)
            if constrainCenters {
                view.constrainCenterToSuperview()
            }
            current = view
        }
    }
    
}

extension UIView {
    
    public func descendant(withTag tag:Int) -> UIView? {
        for subview in subviews {
            if subview.tag == tag {
                return subview
            }
            else if let result = subview.descendant(withTag: tag) {
                return result
            }
        }
        return nil
    }
    
    public func descendants(withTag tag:Int) -> [UIView] {
        var result : [UIView] = []
        for subview in subviews {
            if subview.tag == tag {
                result.append(subview)
            }
            result += subview.descendants(withTag: tag)
        }
        return result
    }
    
    public func descendants() -> [UIView] {
        var result : [UIView] = subviews
        for subview in subviews {
            result += subview.descendants()
        }
        return result
    }
    
}

extension UIView {
    
    public static var association:[String:Weak<UIView>] = [:]
    
}


extension UIView {

	public convenience init(side: CGFloat) {
		self.init(frame: CGRect.init(side: side))
	}
	
}

extension UIView {

	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable public var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor.init(cgColor: color)
			}
			return nil
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}

}

extension UIView {

	// NOTE: VERY IMPORTANT!!! SUBVIEWS OF SELF MUST ALREADY BE PLACED!  OTHERWISE THEY'LL BE OBSCURED
	@discardableResult
    open func blur(style:UIBlurEffect.Style) -> UIVisualEffectView? {

        if !UIAccessibility.isReduceTransparencyEnabled {

			let blurEffect = UIBlurEffect(style: style)

			let blurEffectView = UIVisualEffectView(effect: blurEffect)

			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

			self.insertSubview(blurEffectView, at:0) //if you have more UIViews, use an insertSubview API to place it where needed

			blurEffectView.constrainToSuperview()

			return blurEffectView
		} else {
			return nil
		}

	}


	// NOTE: VERY IMPORTANT!!! SUBVIEWS OF SELF MUST ALREADY BE PLACED!  OTHERWISE THEY'LL BE OBSCURED
	@discardableResult
	open func blur(value:CGFloat) -> UIVisualEffectView? {

        if !UIAccessibility.isReduceTransparencyEnabled {

			let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()

			blurEffect.setValue(value, forKey: "blurRadius")

			let blurEffectView = UIVisualEffectView(effect: blurEffect)

			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

			self.insertSubview(blurEffectView, at:0) //if you have more UIViews, use an insertSubview API to place it where needed

			blurEffectView.constrainToSuperview()

			return blurEffectView

		} else {
			return nil
		}

	}


}







