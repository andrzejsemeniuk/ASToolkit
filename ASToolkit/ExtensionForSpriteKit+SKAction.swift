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



public extension SKAction {
    
    func runOn(node:SKNode,delay sec:TimeInterval = 0) -> SKAction {
        let _ = aRun(on:node,action:self,delay:sec)
        return self
    }
    
    func with(timingMode: SKActionTimingMode) -> Self {
        self.timingMode = timingMode
        return self
    }

    func with(timingFunction: @escaping SKActionTimingFunction) -> Self {
        self.timingFunction = timingFunction
        return self
    }
    
    func configured(timingMode: SKActionTimingMode? = nil, timingFunction: SKActionTimingFunction? = nil) -> Self {
        self.timingMode ?= timingMode
        self.timingFunction ?= timingFunction
        return self
    }

    static func wait(_ duration: TimeInterval) -> SKAction {
        return SKAction.wait(forDuration: duration)
    }
    
    static func block(_ block: @escaping Block) -> SKAction {
        return SKAction.run(block)
    }
    
    static func customAction(withDuration duration: TimeInterval, _ block: @escaping (SKNode, _ elapsedTime: CGFloat, _ elapsedTimeRatio: CGFloat)->Void) -> SKAction {
        return SKAction.customAction(withDuration: duration) { n,t in
            block(n,t,CGFloat(t/duration))
        }
    }
    
    
    static func instant(_ block: @escaping Block) -> SKAction {
        .run(block)
    }

    static func instant(_ block: @escaping (SKNode) -> Void) -> SKAction {
        .customAction(withDuration: 0) { n,_,_ in
            block(n)
        }
    }

    static func block(_ duration: TimeInterval, _ block: @escaping Block) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { _,_ in block() })
    }

    static func block(_ duration: TimeInterval, _ block: @escaping (CGFloat)->Void) -> SKAction {
        .customAction(withDuration: duration, { _,_,f in block(f) })
    }

    static func block(duration: TimeInterval, _ block: @escaping Block) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { _,_ in block() })
    }

    static func block(duration: TimeInterval, _ block: @escaping (CGFloat)->Void) -> SKAction {
        .customAction(withDuration: duration, { _,_,f in block(f) })
    }

}

public extension SKAction {
    
    static func test(duration: TimeInterval, timing: SKActionTimingFunction) -> SKAction {
        .customAction(withDuration: duration) { node,t,T in
            print("t=\(t), T=\(T), node: \(node)")
        }
        //                n.run(.test(duration: 0, timing: { v in v}))
        //                t=0.0, T=nan, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, -79.718399047851562} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:0.70
        //                n.run(.test(duration: 1, timing: { v in v}))
        //                t=0.0, T=0.0, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, 130.65599060058594} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.13
        //                t=0.06002183258533478, T=0.06002183258533478, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, 130.65599060058594} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.13
        //                    ...
        //                t=0.9854282140731812, T=0.9854282140731812, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, 130.65599060058594} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.13
        //                t=1.0, T=1.0, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, 130.65599060058594} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.13
        //                n.run(.test(duration: 0.01, timing: { v in v}))
        //                t=0.0, T=0.0, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, -478.01278686523438} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.11
        //                t=0.009999999776482582, T=0.9999999776482582, node: <SKSpriteNode> name:'(null)' texture:[<SKTexture> 'image-ui-text-z-capital.png' (124 x 158)] position:{32, -478.01278686523438} scale:{0.10, 0.10} size:{12.40000057220459, 15.800000190734863} anchor:{0.5, 0.5} rotation:-0.11
    }

    static func transform(_ path: WritableKeyPath<SKNode, CGFloat>, to: CGFloat, with key: String, duration: TimeInterval, timing: @escaping SKActionTimingFunction) -> SKAction {
        return .customAction(withDuration: duration) { n,d,l in
            var n = n
            if l.isNaN || l == 1 {
                n[keyPath: path] = to
                n.userDataClear(key)
            } else if l == 0 {
                n.userDataSet(key, n[keyPath: path])
            } else {
                let from = n.userDataGet(key) as! CGFloat
                let p = timing(Float(l)).asCGFloat
                n[keyPath: path] = p.lerp(from: from, to: to)
            }
        }
    }

    static func transform(_ path: WritableKeyPath<SKNode, CGPoint>, to: CGPoint, with key: String, duration: TimeInterval, timing: @escaping SKActionTimingFunction) -> SKAction {
        return .customAction(withDuration: duration) { n,d,l in
            var n = n
            if l.isNaN || l == 1 {
                n[keyPath: path] = to
                n.userDataClear(key)
            } else if l == 0 {
                n.userDataSet(key, n[keyPath: path])
            } else {
                let from = n.userDataGet(key) as! CGPoint
                let p = timing(Float(l)).asCGFloat
                n[keyPath: path] = CGPoint.init(p.lerp(from: from.x, to: to.x),p.lerp(from: from.y, to: to.y))
            }
        }
    }

    static func transform(_ path: WritableKeyPath<SKNode, CGFloat>, by: CGFloat, with key: String, duration: TimeInterval, timing: @escaping SKActionTimingFunction) -> SKAction {
        return .customAction(withDuration: duration) { n,d,l in
            var n = n
            if l.isNaN || l == 1 {
                let from = n.userDataGet(key) as! CGFloat
                n[keyPath: path] = from + by
                n.userDataClear(key)
            } else if l == 0 {
                n.userDataSet(key, n[keyPath: path])
            } else {
                let from = n.userDataGet(key) as! CGFloat
                let p = timing(Float(l)).asCGFloat
                n[keyPath: path] = from + p.lerp(0, by)
            }
        }
    }

    static func transform(_ path: WritableKeyPath<SKNode, CGPoint>, by: CGPoint, with key: String, duration: TimeInterval, timing: @escaping SKActionTimingFunction) -> SKAction {
        return .customAction(withDuration: duration) { n,d,l in
            var n = n
            if l.isNaN || l == 1 {
                let from = n.userDataGet(key) as! CGPoint
                n[keyPath: path] = from + by
                n.userDataClear(key)
            } else if l == 0 {
                n.userDataSet(key, n[keyPath: path])
            } else {
                let from = n.userDataGet(key) as! CGPoint
                let p = timing(Float(l)).asCGFloat
                n[keyPath: path] = from + .init(p.lerp(0, by.x), p.lerp(0, by.y))
            }
        }
    }

    static func move(to: CGPoint, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .move(to: to, duration: duration)
        }
        return transform(\SKNode.position, to: to, with: "mt", duration: duration, timing: timing)
    }

    static func moveX(to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .moveTo(x: to, duration: duration)
        }
        return transform(\SKNode.position.x, to: to, with: "mxt", duration: duration, timing: timing)
    }

    static func moveY(to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .moveTo(y: to, duration: duration)
        }
        return transform(\SKNode.position.y, to: to, with: "myt", duration: duration, timing: timing)
    }

    static func alignX(to: CGFloat, on: SKNode, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction? {
        guard on.parent != nil else { return nil }
        let x = on.x(forAlignmentX: to)
        guard let timing = timing else {
            return .moveTo(x: x, duration: duration)
        }
        return transform(\SKNode.position.x, to: x, with: "pxt", duration: duration, timing: timing)
    }

    static func alignY(to: CGFloat, on: SKNode, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction? {
        guard on.parent != nil else { return nil }
        let y = on.y(forAlignmentY: to)
        guard let timing = timing else {
            return .moveTo(y: y, duration: duration)
        }
        return transform(\SKNode.position.y, to: y, with: "pyt", duration: duration, timing: timing)
    }

    static func scaleX(to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .scaleX(to: to, duration: duration)
        }
        return transform(\SKNode.xScale, to: to, with: "sxt", duration: duration, timing: timing)
    }

    static func scaleY(to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .scaleY(to: to, duration: duration)
        }
        return transform(\SKNode.yScale, to: to, with: "syt", duration: duration, timing: timing)
    }

    static func scale(to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .scale(to: to, duration: duration)
        }
        return .group([
            transform(\SKNode.xScale, to: to, with: "sxt", duration: duration, timing: timing),
            transform(\SKNode.yScale, to: to, with: "syt", duration: duration, timing: timing)
        ])
    }

    static func rotate(toAngle to: CGFloat, duration: TimeInterval, timing: SKActionTimingFunction?) -> SKAction {
        guard let timing = timing else {
            return .rotate(toAngle: to, duration: duration)
        }
        return transform(\SKNode.zRotation, to: to, with: "zrt", duration: duration, timing: timing)
    }


}

public extension SKAction {
    
    // no easing, no acceleration
    static let timingFunctionForEaseLinear: SKActionTimingFunction = {
        let t: Float = $0
        return t
    }
    
    // accelerating from zero velocity
    static let timingFunctionForEaseInQuad: SKActionTimingFunction = {
        let t: Float = $0
        return t*t
    }
    
    // decelerating to zero velocity
    static let timingFunctionForEaseOutQuad: SKActionTimingFunction = {
        let t: Float = $0
        return t*(2-t)
    }
    
    // acceleration until halfway, then deceleration
    static let timingFunctionForEaseInOutQuad: SKActionTimingFunction = {
        let t: Float = $0
        return t<0.5 ? 2*t*t : -1+(4-2*t)*t
    }
    
    // accelerating from zero velocity
    static let timingFunctionForEaseInCubic: SKActionTimingFunction = {
        let t: Float = $0
        return t*t*t
    }
    
    // decelerating to zero velocity
    static let timingFunctionForEaseOutCubic: SKActionTimingFunction = {
        let t: Float = $0
        return (t - 1)*t*t+1
    }
    
    // acceleration until halfway, then deceleration
    static let timingFunctionForEaseInOutCubic: SKActionTimingFunction = {
        let t: Float = $0
        return t<0.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1
    }
    
    // accelerating from zero velocity
    static let timingFunctionForEaseInQuart: SKActionTimingFunction = {
        let t: Float = $0
        return t*t*t*t
    }
    
    // decelerating to zero velocity
    static let timingFunctionForEaseOutQuart: SKActionTimingFunction = {
        let t: Float = $0
        return 1-(t-1)*t*t*t
    }
    
    // acceleration until halfway, then deceleration
    static let timingFunctionForEaseInOutQuart: SKActionTimingFunction = {
        let t: Float = $0
        return t<0.5 ? 8*t*t*t*t : 1-8*(t-1)*t*t*t
    }
    
    // accelerating from zero velocity
    static let timingFunctionForEaseInQuint: SKActionTimingFunction = {
        let t: Float = $0
        return t*t*t*t*t
    }
    
    // decelerating to zero velocity
    static let timingFunctionForEaseOutQuint: SKActionTimingFunction = {
        let t: Float = $0
        return 1+(t-1)*t*t*t*t
    }
    
    // acceleration until halfway, then deceleration
    static let timingFunctionForEaseInOutQuint: SKActionTimingFunction = {
        let t: Float = $0
        return t<0.5 ? 16*t*t*t*t*t : 1+16*(t-1)*t*t*t*t
    }
    
    static let timingFunctionForEaseInSin: SKActionTimingFunction = {
        let t: Float = $0
        return 1 + sin(Float.pi / 2 * t - Float.pi / 2)
    }
    
    static let timingFunctionForEaseOutSin : SKActionTimingFunction = {
        let t: Float = $0
        return sin(Float.pi / 2 * t)
    }
    
    static let timingFunctionForEaseInOutSin: SKActionTimingFunction = {
        let t: Float = $0
        return (1 + sin(Float.pi * t - Float.pi / 2)) / 2
    }
    
    // elastic bounce effect at the beginning
    static let timingFunctionForEaseInElastic: SKActionTimingFunction = {
        let t: Float = $0
        return (0.04 - 0.04 / t) * sin(25 * t) + 1
    }
    
    // elastic bounce effect at the end
    static let timingFunctionForEaseOutElastic: SKActionTimingFunction = {
        let t: Float = $0
        return 0.04 * t / (t - 1) * sin(25 * t)
    }
    
    // elastic bounce effect at the beginning and end
    static let timingFunctionForEaseInOutElastic: SKActionTimingFunction = {
        let t: Float = $0
        return (t < 0.5) ? (0.01 + 0.01 / t) * sin(50 * t) : (0.02 - 0.01 / t) * sin(50 * t) + 1
    }
}



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

