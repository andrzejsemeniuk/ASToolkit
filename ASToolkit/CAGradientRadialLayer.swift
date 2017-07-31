//
//  CAGradientRadialLayer.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class CAGradientRadialLayer: CAGradientLayer {
    
    override public init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()
    }

    override public init(layer: Any) {
        super.init(layer:layer)
        if let layer = layer as? CAGradientRadialLayer {
            self.center = layer.center
            self.radius = layer.radius
        }
        needsDisplayOnBoundsChange = true
    }
    

    public var center:CGPoint = CGPoint.zero
    public var radius:CGFloat = 100
    
    override public func draw(in context: CGContext) {
        
        context.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let locations:[CGFloat] = [0.0, 1.0]
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors! as CFArray, locations: locations) {
            context.drawRadialGradient(gradient,
                                       startCenter: center,
                                       startRadius: 0.0,
                                       endCenter: center,
                                       endRadius: radius,
                                       options: CGGradientDrawingOptions(rawValue: 0))
        }
        
    }
    
}
