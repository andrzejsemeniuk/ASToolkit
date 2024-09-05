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


//extension SKAction {
//    static func animateColorAdjustments(from initialHue: CGFloat? = nil, to finalHue: CGFloat? = nil,
//                                        from initialSaturation: CGFloat? = nil, to finalSaturation: CGFloat? = nil,
//                                        from initialBrightness: CGFloat? = nil, to finalBrightness: CGFloat? = nil,
//                                        duration: TimeInterval) -> SKAction {
//        return SKAction.customAction(withDuration: duration) { node, elapsedTime in
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


extension SKAction {
    static func animateColorAdjustments(from initialHue: CGFloat? = nil, to finalHue: CGFloat? = nil,
                                        from initialSaturation: CGFloat? = nil, to finalSaturation: CGFloat? = nil,
                                        from initialBrightness: CGFloat? = nil, to finalBrightness: CGFloat? = nil,
                                        duration: TimeInterval) -> SKAction {
        return SKAction.customAction(withDuration: duration) { node, elapsedTime in
            guard let effectNode = node as? SKEffectNode, let filter = effectNode.filter as? CIFilter else {
                return
            }

            let t = CGFloat(elapsedTime / CGFloat(duration)) // Normalize time [0,1]

            // Use default values if needed (i.e., the last set value if available)
            let previousHue = filter.value(forKey: kCIInputAngleKey) as? CGFloat ?? 0.0
            let previousSaturation = filter.value(forKey: kCIInputSaturationKey) as? CGFloat ?? 1.0
            let previousBrightness = filter.value(forKey: kCIInputBrightnessKey) as? CGFloat ?? 0.0

            // Interpolate values for each component
            let currentHue = (initialHue != nil && finalHue != nil) ? (initialHue! + (finalHue! - initialHue!) * t) : previousHue
            let currentSaturation = (initialSaturation != nil && finalSaturation != nil) ? (initialSaturation! + (finalSaturation! - initialSaturation!) * t) : previousSaturation
            let currentBrightness = (initialBrightness != nil && finalBrightness != nil) ? (initialBrightness! + (finalBrightness! - initialBrightness!) * t) : previousBrightness

            // Update the filter with the new values
            if let hueFilter = CIFilter(name: "CIHueAdjust"),
               let colorFilter = CIFilter(name: "CIColorControls") {
                hueFilter.setValue(currentHue * .pi * 2, forKey: kCIInputAngleKey)
                colorFilter.setValue(currentSaturation * 2.0, forKey: kCIInputSaturationKey)
                colorFilter.setValue(currentBrightness * 2.0 - 1.0, forKey: kCIInputBrightnessKey)

                // Composite filters
                let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
                compositeFilter.setValue(hueFilter.outputImage, forKey: kCIInputImageKey)
                compositeFilter.setValue(colorFilter.outputImage, forKey: kCIInputBackgroundImageKey)

                effectNode.filter = compositeFilter
            }
        }
    }
}


