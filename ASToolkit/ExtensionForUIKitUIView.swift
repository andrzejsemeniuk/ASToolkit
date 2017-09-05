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
    
    open func removeAllConstraints() {
        self.removeConstraints(self.constraints)
    }

    open func constrainXCenter(to:UIView) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerXAnchor.constraint(equalTo: to.centerXAnchor).isActive = true
    }
    
    open func constrainYCenter(to:UIView) {
        self.translatesAutoresizingMaskIntoConstraints=false
        self.centerYAnchor.constraint(equalTo: to.centerYAnchor).isActive = true
    }
    
    open func constrainCenter(to:UIView) {
        self.constrainXCenter(to: to)
        self.constrainYCenter(to: to)
    }
    
    open func constrainCenterToSuperview() {
        if let superview = superview {
            constrainCenter(to:superview)
        }
    }
    
    open func constrainCenterXToSuperview() {
        if let superview = superview {
            constrainXCenter(to:superview)
        }
    }
    
    open func constrainCenterYToSuperview() {
        if let superview = superview {
            constrainYCenter(to:superview)
        }
    }
    
    open func constrainTopLeftCornerToSuperview() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.topAnchor.constraint(equalTo: superview.topAnchor).isActive=true
            self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive=true
        }
    }
    
    open func constrainWidthToSuperview() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.widthAnchor.constraint(equalTo: superview.widthAnchor).isActive=true
        }
    }
    
    open func constrainHeightToSuperview() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints=false
            self.heightAnchor.constraint(equalTo: superview.heightAnchor).isActive=true
        }
    }
    
    open func constrainSizeToSuperview() {
        constrainWidthToSuperview()
        constrainHeightToSuperview()
    }
    
    open func addSubviewCentered(_ view:UIView) {
        self.addSubview(view)
        view.constrainCenterToSuperview()
    }
    
    open func constrainSizeToFrameSize() {
        self.widthAnchor.constraint(equalToConstant: frame.width).isActive=true
        self.heightAnchor.constraint(equalToConstant: frame.height).isActive=true
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
