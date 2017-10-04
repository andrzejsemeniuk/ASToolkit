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
    public class func create(withBackgroundColor color:UIColor = .clear, frame:CGRect = CGRect.zero) -> UIView
    {
        let result = UIView(frame:frame)
        result.backgroundColor = color
        return result
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
        self.removeConstraints(self.constraints)
    }
    
    
    open func constraintBetween(left:NSLayoutAnchor<NSLayoutXAxisAnchor>, right:NSLayoutAnchor<NSLayoutXAxisAnchor>) -> UILayoutGuide {
        let g = UILayoutGuide()
        self.addLayoutGuide(g)
        g.rightAnchor.constraint(equalTo: right).isActive=true
        g.leftAnchor.constraint(equalTo: left).isActive=true
        self.centerXAnchor.constraint(equalTo: g.centerXAnchor).isActive=true
        return g
    }
    
    open func constraintBetween(top:NSLayoutAnchor<NSLayoutYAxisAnchor>, bottom:NSLayoutAnchor<NSLayoutYAxisAnchor>) -> UILayoutGuide {
        let g = UILayoutGuide()
        self.addLayoutGuide(g)
        g.topAnchor.constraint(equalTo: top).isActive=true
        g.bottomAnchor.constraint(equalTo: bottom).isActive=true
        self.centerYAnchor.constraint(equalTo: g.centerYAnchor).isActive=true
        return g
    }

    open func constrainBetween(left:NSLayoutAnchor<NSLayoutXAxisAnchor>, right:NSLayoutAnchor<NSLayoutXAxisAnchor>) {
        _ = constraintBetween(left: left, right: right)
    }
    
    open func constrainBetween(top:NSLayoutAnchor<NSLayoutYAxisAnchor>, bottom:NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        _ = constraintBetween(top: top, bottom: bottom)
    }
    
    open func addSubviewCentered(_ view:UIView) {
        self.addSubview(view)
        view.constrainCenterToSuperview()
    }
    

    open func constrainCenterX(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerXAnchor.constraint(equalTo: to.centerXAnchor, constant:withMargin).identified(withIdentifier).isActive = true
    }
    
    open func constrainCenterY(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerYAnchor.constraint(equalTo: to.centerYAnchor, constant:withMargin).identified(withIdentifier).isActive = true
    }
    
    open func constrainCenter(to:UIView, withIdentifier:String? = nil) {
        self.constrainCenterX(to: to, withIdentifier:withIdentifier)
        self.constrainCenterY(to: to, withIdentifier:withIdentifier)
    }
    
    open func constrainCenterToSuperview(withIdentifier:String? = nil) {
        if let superview = superview {
            constrainCenter(to:superview, withIdentifier:withIdentifier)
        }
    }
    
    open func constrainCenterXToSuperview(withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        if let superview = superview {
            constrainCenterX(to:superview, withMargin:withMargin, withIdentifier:withIdentifier)
        }
    }
    
    open func constrainCenterYToSuperview(withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        if let superview = superview {
            constrainCenterY(to:superview, withMargin:withMargin, withIdentifier:withIdentifier)
        }
    }
    
    open func constrainTopLeftCornerToSuperview(withIdentifier:String? = nil) {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.topAnchor.constraint(equalTo: superview.topAnchor).identified(withIdentifier).isActive=true
            self.leftAnchor.constraint(equalTo: superview.leftAnchor).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainWidthToSuperview(withIdentifier:String? = nil) {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.widthAnchor.constraint(equalTo: superview.widthAnchor).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainHeightToSuperview(withIdentifier:String? = nil) {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.heightAnchor.constraint(equalTo: superview.heightAnchor).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainSizeToSuperview(withIdentifier:String? = nil) {
        constrainWidthToSuperview(withIdentifier:withIdentifier)
        constrainHeightToSuperview(withIdentifier:withIdentifier)
    }
    
    open func constrainSizeToFrameSize(withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.widthAnchor.constraint(equalToConstant: frame.width).identified(withIdentifier).isActive=true
        self.heightAnchor.constraint(equalToConstant: frame.height).identified(withIdentifier).isActive=true
    }

    
    
    open func constrainTopToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }

    open func constrainBottomToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }

    open func constrainLeftToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainRightToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }

    
    
    open func constrainTopToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainBottomToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.bottomAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainLeftToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.leftAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainRightToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.rightAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    
    
    open func constrainToSuperview(withInsets insets:UIEdgeInsets? = nil, withIdentifier:String? = nil) {
        if let insets = insets {
            constrainTopToSuperviewTop          (withMargin: insets.top, withIdentifier:withIdentifier)
            constrainBottomToSuperviewBottom    (withMargin: insets.bottom, withIdentifier:withIdentifier)
            constrainLeftToSuperviewLeft        (withMargin: insets.left, withIdentifier:withIdentifier)
            constrainRightToSuperviewRight      (withMargin: insets.right, withIdentifier:withIdentifier)
        }
        else {
            constrainTopToSuperviewTop(withIdentifier:withIdentifier)
            constrainBottomToSuperviewBottom(withIdentifier:withIdentifier)
            constrainLeftToSuperviewLeft(withIdentifier:withIdentifier)
            constrainRightToSuperviewRight(withIdentifier:withIdentifier)
        }
    }
    
    open func constrainToSuperview(withMargins insets:UIEdgeInsets, withIdentifier:String? = nil) {
        constrainToSuperview(withInsets: insets, withIdentifier: withIdentifier)
    }
    
    
    
    open func constrainCenterYToSuperviewTop(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.centerYAnchor.constraint(equalTo: superview.topAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainCenterYToSuperviewBottom(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainCenterXToSuperviewLeft(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.centerXAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    open func constrainCenterXToSuperviewRight(withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        if let superview = superview {
            self.centerXAnchor.constraint(equalTo: superview.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
        }
    }
    
    
    
    
    open func constrainTopToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.topAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainBottomToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.bottomAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainLeftToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.leftAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainRightToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.rightAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    

    
    
    
    open func constrainTopToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.topAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainBottomToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.bottomAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainLeftToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.leftAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainRightToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.rightAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
    }

    
    
    
    open func constrainCenterYToTop(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerYAnchor.constraint(equalTo: of.topAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainCenterYToBottom(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerYAnchor.constraint(equalTo: of.bottomAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainCenterXToLeft(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerXAnchor.constraint(equalTo: of.leftAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainCenterXToRight(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerXAnchor.constraint(equalTo: of.rightAnchor, constant: margin).identified(withIdentifier).isActive=true
    }

    
    
    
    open func constrainTopToCenterY(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.topAnchor.constraint(equalTo: of.centerYAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainBottomToCenterY(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.bottomAnchor.constraint(equalTo: of.centerYAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainLeftToCenterX(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.leftAnchor.constraint(equalTo: of.centerXAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    open func constrainRightToCenterX(of:UIView, withMargin margin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.rightAnchor.constraint(equalTo: of.centerXAnchor, constant: margin).identified(withIdentifier).isActive=true
    }
    
    
    
    

    open func constrain(width:CGFloat, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.widthAnchor.constraint(equalToConstant: width).identified(withIdentifier).isActive=true
    }
    
    open func constrain(height:CGFloat, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.heightAnchor.constraint(equalToConstant: height).identified(withIdentifier).isActive=true
    }
    

    open func constrainWidth(to:CGFloat, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.widthAnchor.constraint(equalToConstant: to).identified(withIdentifier).isActive=true
    }
    
    open func constrainHeight(to:CGFloat, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.heightAnchor.constraint(equalToConstant: to).identified(withIdentifier).isActive=true
    }
    
    
    open func constrainWidth(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.widthAnchor.constraint(equalTo:to.widthAnchor, constant:withMargin).identified(withIdentifier).isActive=true
    }
    
    open func constrainHeight(to:UIView, withMargin:CGFloat = 0, withIdentifier:String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.heightAnchor.constraint(equalTo:to.heightAnchor, constant: withMargin).identified(withIdentifier).isActive=true
    }
    
    
}


extension UIView {
    
    /// Add provided views as subviews all at once.
    ///
    /// - Parameter views: views to add as subviews to this view
    open func addSubviews(_ views:[UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    open func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    open func subview(withTag:Int) -> UIView? {
        var result:UIView?
        if let index = self.subviews.index(where: {
            $0.tag == withTag
        }) {
            result = self.subviews[index]
        }
        return result
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

