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



public extension SKNode {
    
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

public extension SKEffectNode {

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
    
    convenience init(filter: CIFilter) {
        self.init()
        self.filter = filter
    }
    
    @discardableResult
    func chained(with: SKEffectNode) -> SKEffectNode {
        let C = children
        with.reparent(to: self)
        C.forEach {
            $0.reparent(to: with)
        }
        return with
    }
    
    @discardableResult
    func chained(with filter: CIFilter) -> SKEffectNode {
        chained(with: SKEffectNode.with(filter: filter))
    }
    
    @discardableResult
    func with(filter: CIFilter) -> Self {
        self.filter = filter
        return self
    }
    
    static func with(filter: CIFilter) -> SKEffectNode {
        let R = SKEffectNode.init()
        R.filter = filter
        return R
    }

    
    
        /// @blur in (0,...]
    static func filterFor(blur: CGFloat) -> CIFilter {
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(blur, forKey: kCIInputRadiusKey)
        return blurFilter
    }
    
        /// @hue in [0,1]
    static func filterFor(hue: CGFloat) -> CIFilter {
        let hueFilter = CIFilter(name: "CIHueAdjust")!
        hueFilter.setValue(hue * .pi * 2, forKey: kCIInputAngleKey) // Scale to [0, 2π] range
        return hueFilter
    }
    
        /// @saturation in [0,1], 0.5 is unchanging
    static func filterFor(saturation: CGFloat) -> CIFilter {
        let colorFilter = CIFilter(name: "CIColorControls")!
        colorFilter.setValue(saturation * 2.0, forKey: kCIInputSaturationKey) // Scale to [0,2] range
        return colorFilter
    }
    
        /// @brightness in [0,1], 0.5 is no change, 0 is completely dark/black, 1 is completely bright/white
    static func filterFor(brightness: CGFloat) -> CIFilter {
        let colorFilter = CIFilter(name: "CIColorControls")!
        colorFilter.setValue(brightness * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
        return colorFilter
    }
    
        /// @posterize in (0,n]
    static func filterFor(posterize level: Int) -> CIFilter {
        initialized(CIFilter(name: "CIColorPosterize")!) {
            $0.setValue(level, forKey: "inputLevels")
        }
    }
    
    static var filterForColorInvert : CIFilter {
        CIFilter(name: "CIColorInvert")!
    }
    
    static var filterForPhotoEffectChrome : CIFilter {
        CIFilter(name: "CIPhotoEffectChrome")!
    }
    
    static var filterForPhotoEffectFade : CIFilter {
        CIFilter(name: "CIPhotoEffectFade")!
    }
    
    static var filterForPhotoEffectInstant : CIFilter {
        CIFilter(name: "CIPhotoEffectInstant")!
    }
    
    static var filterForPhotoEffectMono : CIFilter {
        CIFilter(name: "CIPhotoEffectMono")!
    }
    
    static var filterForPhotoEffectNoir : CIFilter {
        CIFilter(name: "CIPhotoEffectNoir")!
    }
    
    static var filterForPhotoEffectProcess : CIFilter {
        CIFilter(name: "CIPhotoEffectProcess")!
    }
    
    static var filterForPhotoEffectTonal : CIFilter {
        CIFilter(name: "CIPhotoEffectTonal")!
    }
    
    static var filterForPhotoEffectTransfer : CIFilter {
        CIFilter(name: "CIPhotoEffectTransfer")!
    }
    
    static func filterFor(sepiaTone intensity: CGFloat) -> CIFilter {
        initialized(CIFilter(name: "CISepiaTone")!) {
            $0.setValue(intensity, forKey: "inputIntensity")
        }
    }

    static func filterFor(vignette intensity: CGFloat /* 0.0 */, radius: CGFloat = 1.0) -> CIFilter {
        initialized(CIFilter(name: "CIVignette")!) {
            $0.setValue(intensity, forKey: "inputIntensity")
            $0.setValue(radius, forKey: "inputRadius")
        }
    }

    static func filterFor(vignetteEffect intensity: CGFloat /* 0.0 */, radius: CGFloat = 1.0, center: CGPoint) -> CIFilter {
        initialized(CIFilter(name: "CIVignetteEffect")!) {
            $0.setValue(intensity, forKey: "inputIntensity")
            $0.setValue(radius, forKey: "inputRadius")
            $0.setValue(center, forKey: "inputCenter")
        }
    }

    
    
    
    @discardableResult
    static func filterForHSB(hue h: CGFloat? = nil, saturation s: CGFloat? = nil, brightness b: CGFloat? = nil) -> CIFilter? {
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
//                colorFilter.setValue(b, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
                colorFilter.setValue(b * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1,1] range
            }
            compositeFilter.setValue(colorFilter.outputImage, forKey: kCIInputBackgroundImageKey)
        }
        
        return compositeFilter
    }

    /// Chains a new CIFilter onto the existing filter of the SKEffectNode
    @discardableResult
    func add(filter newFilter: CIFilter?) -> Bool {
        guard let newFilter else {
            return false
        }
        if let existingFilter = self.filter {
            guard let compositeFilter = CIFilter(name: "CISourceOverCompositing") else {
                return false
            }
            compositeFilter.setValue(filter?.outputImage, forKey: kCIInputBackgroundImageKey)
            compositeFilter.setValue(newFilter.outputImage, forKey: kCIInputImageKey)
            self.filter = compositeFilter
        } else {
            self.filter = newFilter
        }
        return true
    }

    @discardableResult
    static func chainFilters(_ filters: [CIFilter]) -> CIFilter? {
        guard !filters.isEmpty else { return nil }
        
        let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
        var currentImage: CIImage? = nil
        
        for filter in filters {
            if let currentImage = currentImage {
                filter.setValue(currentImage, forKey: kCIInputImageKey) // Use previous filter's output
            }
            
            // Update the current image to the new filter's output
            currentImage = filter.outputImage
        }
        
        // Set the final image on the composite filter
        compositeFilter.setValue(currentImage, forKey: kCIInputImageKey)
        
        return compositeFilter
    }

    enum ColorAdjustment {
        case hue(CGFloat)        // [0, 1]
        case saturation(CGFloat) // [0, 1]
        case brightness(CGFloat) // [-1, 1]
    }

    @discardableResult
    static func filterForColorAdjustments(_ adjustments: [ColorAdjustment]) -> CIFilter? {
        guard !adjustments.isEmpty else {
            return nil
        }
        
        // Start with a composite filter
        let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
        var currentImage: CIImage? = nil
        
        for adjustment in adjustments {
            let filter: CIFilter
            switch adjustment {
            case .hue(let h):
                filter = CIFilter(name: "CIHueAdjust")!
                filter.setValue(h * .pi * 2, forKey: kCIInputAngleKey) // Scale to [0, 2π] range
            case .saturation(let s):
                filter = CIFilter(name: "CIColorControls")!
                filter.setValue(s * 2.0, forKey: kCIInputSaturationKey) // Scale to [0, 2] range
            case .brightness(let b):
                filter = CIFilter(name: "CIColorControls")!
                filter.setValue(b * 2.0 - 1.0, forKey: kCIInputBrightnessKey) // Scale to [-1, 1] range
            }
            
            if let currentImage = currentImage {
                filter.setValue(currentImage, forKey: kCIInputImageKey) // Use previous filter's output
            }
            
            // Update the current image to the new filter's output
            currentImage = filter.outputImage
        }
        
        // Set the final image on the composite filter
        compositeFilter.setValue(currentImage, forKey: kCIInputImageKey)
        
        return compositeFilter
    }

}

