//
//  Math.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/14/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit





open class Math
{
    
    static private var __randomSourceObject    :GKRandomSource?
    static private var __randomSource          :RandomSource       = .arc4Random
    
    public enum RandomSource {
        case arc4Random, linearCongruential, mersenneTwister
    }
    
    static public func randomUseSource(_ source:RandomSource) -> GKRandomSource {
        Math.__randomSource = source
        switch source
        {
        case .arc4Random:           Math.__randomSourceObject = GKARC4RandomSource()
        case .linearCongruential:   Math.__randomSourceObject = GKLinearCongruentialRandomSource()
        case .mersenneTwister:      Math.__randomSourceObject = GKMersenneTwisterRandomSource()
        }
        return Math.__randomSourceObject!
    }
    
    static public func randomGetSource() -> GKRandomSource {
        return __randomSourceObject ?? randomUseSource(__randomSource)
    }
    
    
    fileprivate static var __randomDistributionObject          :GKRandomDistribution?
    fileprivate static let __randomDistributionLowestValue                                     = 0
    fileprivate static let __randomDistributionHighestValue                                    = Int.max
    fileprivate static let __randomDistributionDelta           :Double                         = Double(__randomDistributionHighestValue - __randomDistributionLowestValue)
    fileprivate static var __randomDistribution                :RandomDistribution             = .uniform
    
    
    public enum RandomDistribution {
        case gaussian,uniform
    }
    
    static public func randomUseDistribution(_ distribution:RandomDistribution) -> GKRandomDistribution {
        Math.__randomDistribution = distribution
        switch distribution
        {
        case .gaussian:     Math.__randomDistributionObject = GKGaussianDistribution(randomSource   : randomGetSource(),
                                                                                     lowestValue    : Math.__randomDistributionLowestValue,
                                                                                     highestValue   : Math.__randomDistributionHighestValue)
        case .uniform:      Math.__randomDistributionObject = GKRandomDistribution(randomSource     : randomGetSource(),
                                                                                   lowestValue      : Math.__randomDistributionLowestValue,
                                                                                   highestValue     : Math.__randomDistributionHighestValue)
        }
        return Math.__randomDistributionObject!
    }
    
    static public func randomGetDistribution() -> GKRandomDistribution
    {
        return Math.__randomDistributionObject ?? randomUseDistribution(.uniform)
    }
    
    
    static public func random      (from:CGFloat,to:CGFloat)  -> CGFloat  {
        let v = Double(randomGetDistribution().nextInt())
        let w = Math.__randomDistributionDelta
        let x = CGFloat(v/w)
        let y = to-from
        return from + x * y
    }
    
    static public func random01    ()  -> CGFloat  { return random(from: 0,to: 1) }
    static public func random11    ()  -> CGFloat  { return random(from:-1,to:+1) }
    
    static public func arcrandom01 ()  -> Double   { return Double(arc4random()) / Double(UInt32.max) }
    static public func arcrandom   (from:Double, to:Double)  -> Double   { return from+arcrandom01()*(to-from) }

}


