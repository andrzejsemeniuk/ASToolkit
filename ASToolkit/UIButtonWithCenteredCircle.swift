//
//  UIButtonWithCenteredCircle.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/12/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIButtonWithCenteredCircle : UIButton {
    
    open class Circle : CAShapeLayer {
        open var radius				  : CGFloat           = 0
    }
    
    private var circles:[UIControl.State:Circle] = [:]
    
    open func circle(for state:UIControl.State) -> Circle {
        if let r = self.circles[state] {
            return r
        }
        let r = Circle()
        self.circles[state] = r
        self.layer.insertSublayer(r, at: 0)
        return r
    }
    
    open override func draw(_ rect: CGRect) {
        for (key,circle) in circles {
            if key==state {
                circle.path = UIBezierPath(arcCenter    : rect.center,
                                           radius       : circle.radius,
                                           startAngle   : 0,
                                           endAngle     : 2 * CGFloat.pi,
                                           clockwise    : false).cgPath
            }
            else {
                circle.path = nil
            }
        }
        super.draw(rect)
    }
    
    public func titleRect2(forContentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: forContentRect)
        if let text = self.attributedTitle(for: self.state) {
            print("titleRect: text(\(text.string), rect(\(rect)), content(\(forContentRect)))")
            let bbox = UIGlyph.calculateBBox(of: text)
//            bbox.height += 3
//            bbox.width += 1
            switch (self.contentHorizontalAlignment,self.contentVerticalAlignment) {
            case (.left,.top):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.left,.center):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.left,.bottom):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.center,.top):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.center,.center):
//                return CGRect(x         : forContentRect.center.x - bbox.origin.x/2 - bbox.width/2,
//                              y         : forContentRect.center.y - bbox.origin.y/2 - bbox.height/2,
//                              width     : bbox.width,
//                              height    : bbox.height)
                return CGRect(x         : rect.origin.x, //forContentRect.center.x - bbox.origin.x/2 - bbox.width/2,
                    y         : rect.origin.y, //forContentRect.center.y - bbox.origin.y/2 - bbox.height/2,
                              width     : bbox.width,
                              height    : rect.height) //bbox.height)
            case (.center,.bottom):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.right,.top):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            case (.right,.bottom):
                return CGRect(x         : forContentRect.center.x - bbox.width/2,
                              y         : forContentRect.center.y - bbox.height/2,
                              width     : bbox.width,
                              height    : bbox.height)
            default:
                break
            }
        }
        return rect
    }

}
