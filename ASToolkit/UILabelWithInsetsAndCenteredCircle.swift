//
//  UILabelWithInsetsAndCenteredCircle.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/12/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public class UILabelWithInsetsAndCenteredCircle : UILabelWithInsets {
    
    public class Circle : CAShapeLayer {
        open var radius : CGFloat = 0
    }
    
    public var circle : Circle = Circle()
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.layer.insertSublayer(circle, at:0)
    }
    
    public override func draw(_ rect: CGRect) {
        circle.path = UIBezierPath(arcCenter    : CGPoint(x:frame.size.width/2, y:frame.size.height/2),
                                   radius       : circle.radius,
                                   startAngle   : 0,
                                   endAngle     : 2 * .pi,
                                   clockwise    : false).cgPath
        super.draw(rect)
    }
}
