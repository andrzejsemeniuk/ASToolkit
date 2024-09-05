//
//  ExtensionForSpriteKit+SKNode.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2024-09-05.
//  Copyright © 2024 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SpriteKit

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif


extension SKNode {
    
    func applyRadialGradient(centerX: CGFloat, centerY: CGFloat, radius: CGFloat, colors: [CIColor]) {
            // Wrap the node in an SKEffectNode if not already
        let effectNode = SKEffectNode()
        effectNode.addChild(self)
        
            // Calculate the position of the center in the node's coordinate space
        let nodeSize = self.calculateAccumulatedFrame().size
        let centerXPoint = centerX * nodeSize.width
        let centerYPoint = centerY * nodeSize.height
        
            // Create the radial gradient filter
        let gradientFilter = CIFilter(name: "CIRadialGradient")!
        gradientFilter.setValue(CIVector(x: centerXPoint, y: centerYPoint), forKey: "inputCenter")
        gradientFilter.setValue(radius, forKey: "inputRadius0")
        gradientFilter.setValue(0.0, forKey: "inputRadius1") // Outer radius set to zero to cover entire node
        
            // Set the colors for the gradient (two colors: inner and outer)
        gradientFilter.setValue(colors[0], forKey: "inputColor0") // Inner color
        gradientFilter.setValue(colors[1], forKey: "inputColor1") // Outer color
        
            // Apply the filter to the effect node
        effectNode.filter = gradientFilter
        
            // Replace the node with the effect node in its parent
        if let parent = self.parent {
            parent.addChild(effectNode)
            effectNode.position = self.position
            self.removeFromParent()
        }
    }
    
}
