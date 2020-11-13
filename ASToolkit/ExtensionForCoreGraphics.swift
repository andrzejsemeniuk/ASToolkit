//
//  ExtensionForCoreGraphics.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit




public enum CGDirection {
	case horizontal, vertical
}

public struct CGPosition
{
	public enum Kind {
		case offset, ratio
	}

	public var value 	: CGFloat
	public var kind  	: Kind

	public var isOffset : Bool { return kind == .offset }
	public var isRatio  : Bool { return kind == .ratio }

	public init(_ value:CGFloat, _ kind:Kind) {
		self.value = value
		self.kind = kind
	}

	public init (_ value:CGFloat) {
		self.value = value
		if value <= 1 && -1 <= value {
			self.kind = .ratio
		}
		else {
			self.kind = .offset
		}
	}

	public func offset(_ given:CGFloat) -> CGFloat {
		if isRatio {
			return given * value
		}
		return value
	}
}

public struct CGProportion
{
	public var value:CGFloat = 0

	public init(_ v:CGFloat) {
		self.value = v
	}

	public func of      (length:CGFloat) -> CGFloat                 { return value * length }
	public func lerp    (from:CGFloat,to:CGFloat) -> CGFloat        { return from + value * (to - from) }
	public func lerp01  (from:CGFloat,to:CGFloat) -> CGFloat        { return min(1,max(0,from + value * (to - from))) }

	public func lerp    (from:CGFloat,length:CGFloat) -> CGFloat    { return lerp(from:from,to:from + length) }
	public func lerp01  (from:CGFloat,length:CGFloat) -> CGFloat    { return lerp01(from:from,to:from + length) }
}

public typealias CGRatio = CGProportion

public struct CGDimensions
{
	public var h:CGFloat = 0
	public var v:CGFloat = 0

	public init(_ h:CGFloat, _ v:CGFloat) {
		self.h = h
		self.v = v
	}

	func __conversion() -> (CGFloat, CGFloat)                       { return (h, v) }
}





extension CGPoint {
    
    public init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
    
    public init(xy:CGFloat) {
        self.init(x:xy, y:xy)
    }

	public var length : CGFloat {
        sqrt(x * x + y * y)
	}

    public var clampedTo01      : CGPoint {
        .init(x: x.clampedTo01, y: y.clampedTo01)
    }

    public var asCGSize:CGSize {
        CGSize(width:x,height:y)
    }
    
    static public var almostZero:CGPoint = {
        CGPoint(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
    }()
}

extension CGSize {

	public static let minimal = CGSize(side: 1)

    public init(side:CGFloat) {
        self.init(width:side, height:side)
    }
    
    public var asCGPoint        : CGPoint {
        CGPoint(x:width,y:height)
    }
    public var diagonal         : CGFloat {
        sqrt(width*width + height*height)
    }
    
    public var clampedTo01      : CGSize {
        .init(width: width.clampedTo01, height: height.clampedTo01)
    }
    
    static public var almostZero:CGSize = {
        CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    }()
    
    
}

extension CGRect {

	public static let minimal = CGRect(side:1)

    public init(_ point:CGPoint) {
        self.init(x:point.x, y:point.y, width:0, height:0)
    }
    
    public init(x:CGFloat, y:CGFloat) {
        self.init(x: x, y: y, width: 0, height: 0)
    }
    
    public init(_ size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }

    public init(width: CGFloat, height:CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
    
    public init(side: CGFloat) {
        self.init(x: 0, y: 0, width: side, height: side)
    }
    
	public init(size: CGSize) {
		self.init(x: 0, y: 0, width: size.width, height: size.height)
	}

    public var diagonal: CGFloat {
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

extension CGLineCap {

	public var string : String {
		switch self {
            case .round				: return CAShapeLayerLineCap.round.rawValue
            case .butt				: return CAShapeLayerLineCap.butt.rawValue
            case .square			: return CAShapeLayerLineCap.square.rawValue
		}
	}
}

extension CGLineJoin {

	public var string : String {
		switch self {
            case .round				: return CAShapeLayerLineJoin.round.rawValue
            case .bevel				: return CAShapeLayerLineJoin.bevel.rawValue
            case .miter				: return CAShapeLayerLineJoin.miter.rawValue
		}
	}
}










public typealias CGXY              = (x:CGFloat,y:CGFloat)











public func CGAsRadians(degrees:CGFloat) -> CGFloat                 { return degrees / 180.0 * .pi }
public func CGAsDegrees(radians:CGFloat) -> CGFloat                 { return radians / .pi * 180.0 }

public struct CGDegrees
{
	public var value:CGFloat

	public init(_ value:CGFloat = 0) {
		self.value = value
	}
	public func toRadians   () -> CGFloat           { return CGAsRadians(degrees:value) }
	public func asCGRadians () -> CGRadians         { return CGRadians(toRadians()) }
}

public struct CGRadians
{
	public var value:CGFloat

	public init(_ value:CGFloat = 0) {
		self.value = value
	}
	public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:value) }
	public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(toDegrees()) }
}

public struct CGAngle
{
	private var value:CGFloat

	public      init(degrees value:CGFloat)         { self.value = CGAsRadians(degrees:value) }
	public      init(radians value:CGFloat)         { self.value = value }

	public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:value) }
	public func toRadians   ()  -> CGFloat          { return value }

	public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(toDegrees()) }
	public func asCGRadians ()  -> CGRadians        { return CGRadians(value) }
}

extension CGPoint
{
	// NOTE: USE __conversion TO CONVERT TO TYPES
	func __conversion() -> (CGFloat, CGFloat)           { return (x, y) }
}

extension CGRect
{
	public var midpoint        :CGPoint        { return pointFromRatio(x:0.5,y:0.5) }

	public var tl              :CGPoint        { return pointFromRatio(x:0,y:1) }
	public var tr              :CGPoint        { return pointFromRatio(x:1,y:1) }
	public var bl              :CGPoint        { return pointFromRatio(x:0,y:0) }
	public var br              :CGPoint        { return pointFromRatio(x:1,y:0) }
	public var c               :CGPoint        { return midpoint }

	public var center          :CGPoint        { return midpoint }

	public var top             :CGFloat        { return origin.y }
	public var left            :CGFloat        { return origin.x }
	public var bottom          :CGFloat        { return origin.y + height }
	public var right           :CGFloat        { return origin.x + width }

	public func pointFromRatio         (x:CGFloat, y:CGFloat)      -> CGPoint { return CGPoint(x: origin.x + width * x, y: origin.y + height * y) }
	public func pointFrom              (ratio:CGXY)                -> CGPoint { return pointFromRatio(x:ratio.x,y:ratio.y) }

	public func ratioFrom              (point:CGPoint)             -> CGPoint { return CGPoint(x: width != 0.0 ? ((point.x - origin.x) / width) : 0.0, y: height != 0.0 ? ((point.y - origin.y) / height) : 0.0 ) }
}

extension CGSize
{
	public var midpoint        :CGPoint        { return pointFromRatio(x:0.5,y:0.5) }

	public var tl              :CGPoint        { return pointFromRatio(x:0,y:1) }
	public var tr              :CGPoint        { return pointFromRatio(x:1,y:1) }
	public var bl              :CGPoint        { return pointFromRatio(x:0,y:0) }
	public var br              :CGPoint        { return pointFromRatio(x:1,y:0) }
	public var c               :CGPoint        { return midpoint }

	public var center          :CGPoint        { return midpoint }

	public var top             :CGFloat        { return height }
	public var left            :CGFloat        { return 0 }
	public var bottom          :CGFloat        { return 0 }
	public var right           :CGFloat        { return width }
    public var w               :CGFloat        { return width }
    public var h               :CGFloat        { return height }

	public func pointFromRatio         (x:CGFloat, y:CGFloat)      -> CGPoint { return CGPoint(x: width * x, y: height * y) }
	public func pointFrom              (ratio:CGXY)                -> CGPoint { return pointFromRatio(x:ratio.x, y:ratio.y) }

	public func ratioFrom              (point:CGPoint)             -> CGPoint { return CGPoint(x: width != 0.0 ? (point.x / width) : 0.0, y: height != 0.0 ? (point.y / height) : 0.0 ) }
}

public func UIScreenGetCenter() -> CGPoint {

	return CGPoint(x:UIScreen.main.bounds.width/2.0,
				   y:UIScreen.main.bounds.height/2.0)
}


public struct CGScreen
{
	public static var bounds:CGRect = CGRect(x:UIScreen.main.bounds.origin.x,
											 y:UIScreen.main.bounds.origin.y,
											 width:UIScreen.main.bounds.width * UIScreen.main.scale,
											 height:UIScreen.main.bounds.height * UIScreen.main.scale)

	public static var origin                                                   :CGPoint    { return bounds.origin }
	public static var size                                                     :CGSize     { return bounds.size }
	public static var width                                                    :CGFloat    { return size.width }
	public static var height                                                   :CGFloat    { return size.height }
	public static var scale                                                    :CGFloat    { return UIScreen.main.scale }


	public static func diagonal                (fraction:CGFloat = 1.0)        -> CGFloat  { return Environment.Screen.diagonal(fraction) }

	public static func pointFromRatio          (x:CGFloat, y:CGFloat)          -> CGPoint  { return bounds.pointFromRatio(x:x,y:y) }
	public static func pointFrom               (ratio:CGXY)                    -> CGPoint  { return pointFromRatio(x:ratio.x,y:ratio.y) }

	public static func ratioFrom               (point:CGPoint)                 -> CGPoint  { return bounds.ratioFrom(point:point) }
}

public struct CGSlope {
    public var point0  : CGPoint
    public var point1  : CGPoint
    public var dy      : CGFloat   { point1.y - point0.y }
    public var dx      : CGFloat   { point1.x - point0.x }
    public var slope   : CGFloat?  { dx == 0 ? nil : dy/dx }
    
    public init(point0: CGPoint, point1: CGPoint) {
        self.point0 = point0
        self.point1 = point1
    }
    
    public func y(x: CGFloat) -> CGFloat? {
        // y = mx + b
        guard let slope = slope else { return nil }
        return slope * (x - point0.x) + point0.y
    }
}

public extension Int32 {
    var asCGLineCap     : CGLineCap?    { CGLineCap.init(rawValue: self) }
    var asCGLineJoin    : CGLineJoin?   { CGLineJoin.init(rawValue: self) }
    
    var CGLineJoinBevel : Int32         { CGLineJoin.bevel.rawValue }
    var CGLineJoinMiter : Int32         { CGLineJoin.miter.rawValue }
    var CGLineJoinRound : Int32         { CGLineJoin.round.rawValue }
    
    var CGLineCapButt   : Int32         { CGLineCap.butt.rawValue }
    var CGLineCapRound  : Int32         { CGLineCap.round.rawValue }
    var CGLineCapSquare : Int32         { CGLineCap.square.rawValue }
}

// From GitHub: ldesroziers/CGRect+OperatorsAdditions

/**
// Usage without these operators :
var preferredContentSize = myFlowLayout.itemSize
preferredContentSize.width *= 1.5
preferredContentSize.height *= 1.5
myOtherViewController.preferredContentSize = preferredContentSize


// Usage with these operators :
myOtherViewController.preferredContentSize = myFlowLayout.itemSize * 1.5

Et voilà!
*/


public func += (rect: inout CGRect, size: CGSize) {
	rect.size += size
}
public func -= (rect: inout CGRect, size: CGSize) {
	rect.size -= size
}
public func *= (rect: inout CGRect, size: CGSize) {
	rect.size *= size
}
public func /= (rect: inout CGRect, size: CGSize) {
	rect.size /= size
}
public func += (rect: inout CGRect, origin: CGPoint) {
	rect.origin += origin
}
public func -= (rect: inout CGRect, origin: CGPoint) {
	rect.origin -= origin
}
public func *= (rect: inout CGRect, origin: CGPoint) {
	rect.origin *= origin
}
public func /= (rect: inout CGRect, origin: CGPoint) {
	rect.origin /= origin
}


/** CGSize+OperatorsAdditions */
public func += (size: inout CGSize, right: CGFloat) {
	size.width += right
	size.height += right
}
public func -= (size: inout CGSize, right: CGFloat) {
	size.width -= right
	size.height -= right
}
public func *= (size: inout CGSize, right: CGFloat) {
	size.width *= right
	size.height *= right
}
public func /= (size: inout CGSize, right: CGFloat) {
	size.width /= right
	size.height /= right
}

public func += (left: inout CGSize, right: CGSize) {
	left.width += right.width
	left.height += right.height
}
public func -= (left: inout CGSize, right: CGSize) {
	left.width -= right.width
	left.height -= right.height
}
public func *= (left: inout CGSize, right: CGSize) {
	left.width *= right.width
	left.height *= right.height
}
public func /= (left: inout CGSize, right: CGSize) {
	left.width /= right.width
	left.height /= right.height
}

public func + (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width + right, height: size.height + right)
}
public func - (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width - right, height: size.height - right)
}
public func * (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width * right, height: size.height * right)
}
public func / (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width / right, height: size.height / right)
}

public func + (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width + right.width, height: left.height + right.height)
}
public func - (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width - right.width, height: left.height - right.height)
}
public func * (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width * right.width, height: left.height * right.height)
}
public func / (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width / right.width, height: left.height / right.height)
}

public func += (left: inout CGSize, right: UIEdgeInsets) {
	left.width += right.left + right.right
	left.height += right.top + right.bottom
}
public func -= (left: inout CGSize, right: UIEdgeInsets) {
	left.width -= right.left + right.right
	left.height -= right.top + right.bottom
}
public func + (left: CGSize, right: UIEdgeInsets) -> CGSize {
	return CGSize(width: left.width + right.left + right.right, height: left.height + right.top + right.bottom)
}
public func - (left: CGSize, right: UIEdgeInsets) -> CGSize {
	return CGSize(width: left.width - right.left - right.right, height: left.height - right.top - right.bottom)
}


/** CGPoint+OperatorsAdditions */
public func += (point: inout CGPoint, right: CGFloat) {
	point.x += right
	point.y += right
}
public func -= (point: inout CGPoint, right: CGFloat) {
	point.x -= right
	point.y -= right
}
public func *= (point: inout CGPoint, right: CGFloat) {
	point.x *= right
	point.y *= right
}
public func /= (point: inout CGPoint, right: CGFloat) {
	point.x /= right
	point.y /= right
}

public func += (left: inout CGPoint, right: CGPoint) {
	left.x += right.x
	left.y += right.y
}
public func -= (left: inout CGPoint, right: CGPoint) {
	left.x -= right.x
	left.y -= right.y
}
public func *= (left: inout CGPoint, right: CGPoint) {
	left.x *= right.x
	left.y *= right.y
}
public func /= (left: inout CGPoint, right: CGPoint) {
	left.x /= right.x
	left.y /= right.y
}

public func + (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x + right, y: point.y + right)
}
public func - (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x - right, y: point.y - right)
}
public func * (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x * right, y: point.y * right)
}
public func / (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x / right, y: point.y / right)
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

