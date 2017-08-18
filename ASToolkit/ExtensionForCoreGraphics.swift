//
//  ExtensionForCoreGraphics.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    public init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
    
    public var asCGSize:CGSize {
        return CGSize(width:x,height:y)
    }
    
    public init(xy:CGFloat) {
        self.init(x:xy, y:xy)
    }
    
    static public var almostZero:CGPoint = {
        return CGPoint(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
    }()
}

extension CGSize {
    public init(side:CGFloat) {
        self.init(width:side, height:side)
    }
    
    public var asCGPoint:CGPoint {
        return CGPoint(x:width,y:height)
    }
    public var diagonal:CGFloat {
        return sqrt(width*width + height*height)
    }
    
    static public var almostZero:CGSize = {
        return CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    }()
}

extension CGRect {
    public init(_ point:CGPoint) {
        self.init(x:point.x, y:point.y, width:0, height:0)
    }
    
    public init(x:CGFloat, y:CGFloat) {
        self.init(x: x, y: y, width: 0, height: 0)
    }
    
    public init(_ size:CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }

    public init(width:CGFloat, height:CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
    
    public init(side:CGFloat) {
        self.init(x: 0, y: 0, width: side, height: side)
    }
    
    public var diagonal:CGFloat {
        return sqrt(width*width + height*height)
    }
    
    static public var almostZero:CGRect = {
        return CGRect(origin:CGPoint.almostZero, size:CGSize.almostZero)
    }()
}

extension CGAffineTransform {
    
    public var sx:CGFloat {
        return sqrt(a * a + c * c)
    }
    
    public var sy:CGFloat {
        return sqrt(b * b + d * d)
    }
}
