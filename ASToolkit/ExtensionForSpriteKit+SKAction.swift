//
//  ExtensionForSpriteKit+SKAction.swift
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


//public extension SKAction {
//    static func animateColorAdjustments(from initialHue: CGFloat? = nil, to finalHue: CGFloat? = nil,
//                                        from initialSaturation: CGFloat? = nil, to finalSaturation: CGFloat? = nil,
//                                        from initialBrightness: CGFloat? = nil, to finalBrightness: CGFloat? = nil,
//                                        duration: TimeInterval) -> SKAction {
//        SKAction.customAction(withDuration: duration) { node, elapsedTime in
//            guard let effectNode = node as? SKEffectNode, let filter = effectNode.filter as? CIFilter else {
//                return
//            }
//
//            let t = CGFloat(elapsedTime / CGFloat(duration)) // Normalize time [0,1]
//
//            // Initialize current values to maintain previous settings if they are nil
//            var currentHue: CGFloat?
//            var currentSaturation: CGFloat?
//            var currentBrightness: CGFloat?
//
//            if let initialHue = initialHue, let finalHue = finalHue {
//                currentHue = initialHue + (finalHue - initialHue) * t
//            }
//
//            if let initialSaturation = initialSaturation, let finalSaturation = finalSaturation {
//                currentSaturation = initialSaturation + (finalSaturation - initialSaturation) * t
//            }
//
//            if let initialBrightness = initialBrightness, let finalBrightness = finalBrightness {
//                currentBrightness = initialBrightness + (finalBrightness - initialBrightness) * t
//            }
//
//            // Update filter values for the provided components
//            if let hueValue = currentHue, let hueFilter = CIFilter(name: "CIHueAdjust") {
//                hueFilter.setValue(hueValue * .pi * 2, forKey: kCIInputAngleKey)
//                effectNode.filter = hueFilter
//            }
//            
//            if let saturationValue = currentSaturation, let brightnessValue = currentBrightness,
//               let colorFilter = CIFilter(name: "CIColorControls") {
//                colorFilter.setValue(saturationValue * 2.0, forKey: kCIInputSaturationKey)
//                colorFilter.setValue(brightnessValue * 2.0 - 1.0, forKey: kCIInputBrightnessKey)
//                effectNode.filter = colorFilter
//            }
//        }
//    }
//}


public extension SKAction {
    
    static func animateColorAdjustments(from initialHue: CGFloat? = nil, to finalHue: CGFloat? = nil,
                                        from initialSaturation: CGFloat? = nil, to finalSaturation: CGFloat? = nil,
                                        from initialBrightness: CGFloat? = nil, to finalBrightness: CGFloat? = nil,
                                        duration: TimeInterval) -> SKAction {
        return SKAction.customAction(withDuration: duration) { node, elapsedTime in
            guard let effectNode = node as? SKEffectNode else {
                return
            }

            let t = CGFloat(elapsedTime / CGFloat(duration)) // Normalize time [0,1]

            // Get current filter from the node
            let originalFilter = effectNode.filter
            
            // Use default values if needed (i.e., the last set value if available)
            let previousHue: CGFloat = 0.0  // Assume default starting hue (or fetch if already used)
            let previousSaturation: CGFloat = 1.0  // Normal saturation (or fetch from node state)
            let previousBrightness: CGFloat = 0.0  // Normal brightness (or fetch from node state)

            // Interpolate values for each component
            let currentHue = (initialHue != nil && finalHue != nil) ? (initialHue! + (finalHue! - initialHue!) * t) : previousHue
            let currentSaturation = (initialSaturation != nil && finalSaturation != nil) ? (initialSaturation! + (finalSaturation! - initialSaturation!) * t) : previousSaturation
            let currentBrightness = (initialBrightness != nil && finalBrightness != nil) ? (initialBrightness! + (finalBrightness! - initialBrightness!) * t) : previousBrightness

            // Create a hue and color filter with the current interpolation values
            let hueFilter = CIFilter(name: "CIHueAdjust")
            let colorFilter = CIFilter(name: "CIColorControls")
            hueFilter?.setValue(currentHue * .pi * 2, forKey: kCIInputAngleKey)
            colorFilter?.setValue(currentSaturation * 2.0, forKey: kCIInputSaturationKey)
            colorFilter?.setValue(currentBrightness * 2.0 - 1.0, forKey: kCIInputBrightnessKey)

            // Create a composite filter to combine the original and new filters
            if let hueOutputImage = hueFilter?.outputImage, let colorOutputImage = colorFilter?.outputImage {
                let compositeFilter = CIFilter(name: "CISourceOverCompositing")
                compositeFilter?.setValue(colorOutputImage, forKey: kCIInputImageKey)

                // If there's an original filter, apply it before the color adjustment
                if let originalOutputImage = originalFilter?.outputImage {
                    compositeFilter?.setValue(originalOutputImage, forKey: kCIInputBackgroundImageKey)
                }

                // Apply the composite filter back to the effect node
                effectNode.filter = compositeFilter
            }
        }
    }
}

