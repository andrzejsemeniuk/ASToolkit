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
    public class func createWithBackgroundColor(_ color:UIColor) -> UIView
    {
        let result = UIView()
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
    
}

