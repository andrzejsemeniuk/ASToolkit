//
//  ExtensionForSpriteKit+SKEffectNode.swift
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

import SwiftUI
import CoreImage



extension SKNode {
    
    func applyColorAdjustments(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        // Wrap the node in an SKEffectNode if not already
        let effectNode = SKEffectNode()
        effectNode.addChild(self)
        
        // Create the CIFilter
        let colorFilter = CIFilter(name: "CIColorControls")!
        colorFilter.setValue(saturation * 2.0, forKey: kCIInputSaturationKey) // Scale to [0,2] range
        colorFilter.setValue(brightness * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
        
        // Apply the hue adjustment using a hue filter
        let hueFilter = CIFilter(name: "CIHueAdjust")!
        hueFilter.setValue(hue * .pi * 2, forKey: kCIInputAngleKey) // Scale to [0, 2π] range
        
        // Combine the filters using a CICategory filter
        let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
        compositeFilter.setValue(hueFilter.outputImage, forKey: kCIInputImageKey)
        compositeFilter.setValue(colorFilter.outputImage, forKey: kCIInputBackgroundImageKey)
        
        // Apply the combined filter to the effect node
        effectNode.filter = compositeFilter
        
        // Replace the node with the effect node in its parent
        if let parent = self.parent {
            parent.addChild(effectNode)
            effectNode.position = self.position
            self.removeFromParent()
        }
    }
}

extension SKEffectNode {

//    var hue : CGFloat? {
//        get {
//            value(forKey: "astoolkit-hue") as? CGFloat
//        }
//        set {
//            setValue(newValue, forKey: "astoolkit-hue")
//            if let newValue {
//                
//            }
//        }
//    }
    
    func filterFor(hue: CGFloat) -> CIFilter {
        let hueFilter = CIFilter(name: "CIHueAdjust")!
        hueFilter.setValue(hue * .pi * 2, forKey: kCIInputAngleKey) // Scale to [0, 2π] range
        return hueFilter
    }
    
    func filterFor(saturation: CGFloat) -> CIFilter {
        let colorFilter = CIFilter(name: "CIColorControls")!
        colorFilter.setValue(saturation * 2.0, forKey: kCIInputSaturationKey) // Scale to [0,2] range
        return colorFilter
    }
    
    func filterFor(brightness: CGFloat) -> CIFilter {
        let colorFilter = CIFilter(name: "CIColorControls")!
        colorFilter.setValue(brightness * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
        return colorFilter
    }
    
    @discardableResult
    func filterFor(hue h: CGFloat? = nil, saturation s: CGFloat? = nil, brightness b: CGFloat? = nil) -> CIFilter? {
            // Wrap the node in an SKEffectNode if not already
        guard h != nil || s != nil || b != nil else {
            return nil
        }
        
        let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
        
        if let h {
            let hueFilter = CIFilter(name: "CIHueAdjust")!
            hueFilter.setValue(h * .pi * 2, forKey: kCIInputAngleKey) // Scale to [0, 2π] range
            compositeFilter.setValue(hueFilter.outputImage, forKey: kCIInputImageKey)
        }
        
        if s != nil || b != nil {
            let colorFilter = CIFilter(name: "CIColorControls")!
            if let s {
                colorFilter.setValue(s * 2.0, forKey: kCIInputSaturationKey) // Scale to [0,2] range
            }
            if let b {
                colorFilter.setValue(b * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
            }
            compositeFilter.setValue(colorFilter.outputImage, forKey: kCIInputBackgroundImageKey)
        }
        
        return compositeFilter
    }

    /// Chains a new CIFilter onto the existing filter of the SKEffectNode
    func add(filter newFilter: CIFilter) {
        // If there's no existing filter, simply set the new filter
        if filter == nil {
            self.filter = newFilter
        } else if let existingFilter = self.filter {
            // Create a compositing filter to combine the existing filter and the new one
            let compositeFilter = CIFilter(name: "CISourceOverCompositing")
            
            // Get the output image of the existing filter and the new filter
            if let existingOutputImage = existingFilter.outputImage, let newOutputImage = newFilter.outputImage {
                // Set the existing filter's output as the background image in the composite filter
                compositeFilter?.setValue(existingOutputImage, forKey: kCIInputBackgroundImageKey)
                
                // Set the new filter's output as the input image in the composite filter
                compositeFilter?.setValue(newOutputImage, forKey: kCIInputImageKey)
                
                // Set the composite filter as the new filter for the effect node
                self.filter = compositeFilter
            }
        }
    }

}

