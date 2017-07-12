//
//  ASToolkitSwiftMath.swift
//  ASToolkitFrankenbots
//
//  Created by andrzej semeniuk on 5/14/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit



public struct Math
{
    static public let PI           :CGFloat            = CGFloat.pi
    static public let TwoPI        :CGFloat            = CGFloat.pi * 2.0
    
    static public func clamp        (_ l:Double,_ u:Double,_ v:Double) -> Double                        { return v < l ? l : (u < v ? u : v) }
    static public func clamp        (_ lowerbound:Double,upperbound:Double,value:Double) -> Double      { return clamp(lowerbound,upperbound,value) }
    static public func clamp01      (_ value:Double) -> Double                                          { return clamp(0,1,value) }
    static public func clamp11      (_ value:Double) -> Double                                          { return clamp(-1,1,value) }

    static public func lerp         (_ l:Double,_ u:Double,_ v:Double) -> Double                        { return (1.0-v)*l + v*u }
    static public func lerp         (_ lowerbound:Double,upperbound:Double,value:Double) -> Double      { return lerp(lowerbound,upperbound,value) }
    static public func lerp01       (_ l:Double,_ u:Double,_ v:Double) -> Double                        { return lerp(l,u,clamp01(v)) }
    static public func lerp01       (_ lowerbound:Double,upperbound:Double,value:Double) -> Double      { return lerp(lowerbound,upperbound,clamp01(value)) }

    static public func lprogress    (_ f:Double,_ t:Double,_ v:Double) -> Double                        { return f < t ? (v-f)/(t-f) : (f-v)/(f-t) }
    static public func lprogress    (_ from:Double,to:Double,now:Double) -> Double                      { return lprogress(from,to,now) }
    static public func lprogress01  (_ f:Double,_ t:Double,_ v:Double) -> Double                        { return clamp01(lprogress(f,t,v)) }
    static public func lprogress01  (_ from:Double,to:Double,now:Double) -> Double                      { return lprogress01(from,to,now) }
}



private var __randomSourceObject    :GKRandomSource?
private var __randomSource          :RandomSource       = .arc4Random

public enum RandomSource {
    case arc4Random, linearCongruential, mersenneTwister
}

public func randomUseSource(_ source:RandomSource) -> GKRandomSource {
    __randomSource = source
    switch source
    {
        case .arc4Random:           __randomSourceObject = GKARC4RandomSource()
        case .linearCongruential:   __randomSourceObject = GKLinearCongruentialRandomSource()
        case .mersenneTwister:      __randomSourceObject = GKMersenneTwisterRandomSource()
    }
    return __randomSourceObject!
}

public func randomGetSource() -> GKRandomSource {
    return __randomSourceObject ?? randomUseSource(__randomSource)
}




private var __randomDistributionObject  :GKRandomDistribution?
private let __randomDistributionLowestValue                             = 0
private let __randomDistributionHighestValue                            = Int.max
private let __randomDistributionDelta   :Double                         = Double(__randomDistributionHighestValue - __randomDistributionLowestValue)
private var __randomDistribution        :RandomDistribution             = .uniform

public enum RandomDistribution {
    case gaussian,uniform
}

public func randomUseDistribution(_ distribution:RandomDistribution) -> GKRandomDistribution {
    __randomDistribution = distribution
    switch distribution
    {
        case .gaussian:     __randomDistributionObject = GKGaussianDistribution(randomSource:randomGetSource(),
                                                                                lowestValue:__randomDistributionLowestValue,
                                                                                highestValue:__randomDistributionHighestValue)
        case .uniform:      __randomDistributionObject = GKRandomDistribution(randomSource:randomGetSource(),
                                                                              lowestValue:__randomDistributionLowestValue,
                                                                              highestValue:__randomDistributionHighestValue)
    }
    return __randomDistributionObject!
}

public func randomGetDistribution() -> GKRandomDistribution
{
    return __randomDistributionObject ?? randomUseDistribution(.uniform)
}


public func random      (_ from:CGFloat,to:CGFloat)  -> CGFloat  {
    let v = Double(randomGetDistribution().nextInt())
    return from + CGFloat(v/__randomDistributionDelta) * (to-from)
}

public func random01    ()  -> CGFloat  { return random(0,to:1) }
public func random11    ()  -> CGFloat  { return random(-1,to:+1) }

