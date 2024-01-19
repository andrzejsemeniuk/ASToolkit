//
//  ExtensionForCoreGraphics.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif
#if os(tvOS)
import UIKit
#endif


public typealias CGFloat01      = CGFloat
public typealias CGFloat11      = CGFloat



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





public enum CGRelativePlacement : String, Codable, Hashable, Equatable, RawRepresentable, CaseIterable {
    case none,above,right,below,left
}

public enum CGPerpendicularPlacement : String, Codable, Hashable, Equatable, RawRepresentable, CaseIterable {
    case none,top,right,bottom,left
}

public enum CGDiagonalPlacement : String, Codable, Hashable, Equatable, RawRepresentable, CaseIterable {
    case none,tl,tr,br,bl
}

public enum CG8DirectionPlacement : String, Codable, Hashable, Equatable, RawRepresentable, CaseIterable {
    case none,top,tr,right,br,bottom,bl,left,tl
}





public extension CGPoint {
    
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
    
    init(xy:CGFloat) {
        self.init(x:xy, y:xy)
    }

    init(length: CGFloat, angle: CGAngle) {
        self = angle.point(radius: length)
    }
    
	var length : CGFloat {
        sqrt(x * x + y * y)
	}

    var lengthSquared : CGFloat {
        x * x + y * y
    }

    var clampedTo01      : CGPoint {
        .init(x: x.clampedTo01, y: y.clampedTo01)
    }

    var asCGSize:CGSize {
        CGSize(width:x,height:y)
    }
    
    static var almostZero:CGPoint = {
        CGPoint(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
    }()
    
    func with(y: CGFloat) -> CGPoint {
        .init(x: x, y: y)
    }
    
    func with(x: CGFloat) -> CGPoint {
        .init(x: x, y: y)
    }
    
    func with(y point: CGPoint) -> CGPoint {
        .init(x: x, y: point.y)
    }
    
    func with(x point: CGPoint) -> CGPoint {
        .init(x: point.x, y: y)
    }
    
    func adding(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
        .init(x: self.x + (x ?? 0), y: self.y + (y ?? 0))
    }
    
    func offset(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
        adding(x: x, y: y)
    }
    
    static func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        .init(x,y)
    }
}

extension CGPoint : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Array where Element == CGPoint {
    
    var bounds : CGRect? {
        guard count > 0 else { return nil }
        let X = map { $0.x }
        let Y = map { $0.y }
        return .init(x0: X.min()!, x1: X.max()!, y0: Y.min()!, y1: Y.max()!)
    }
    
    func indexOfPointWithMinimalDistance(to: CGPoint) -> Int? {
        guard isNotEmpty else { return nil }
        var minimalIndex : Int = 0
        let measure = { (a: CGPoint, b: CGPoint) -> CGFloat in
//            abs(a.x - b.x) + abs(a.y - b.y)
            (a-b).lengthSquared
        }
        var minimalDistance : CGFloat = measure(.zero,self[0])
        for i in 1..<count {
//            let d = self[i].distance(to: to)
            let d = measure(self[i],to)
            if d < minimalDistance {
                minimalDistance = d
                minimalIndex = i
            }
        }
        return minimalIndex
    }
}

public extension CGSize {

    static let minimal = CGSize(side: 1)
    static let zero = CGSize(side: 0)

    init(side:CGFloat) {
        self.init(width:side, height:side)
    }
    
    init(_ w: CGFloat, _ h: CGFloat) {
        self.init(width: w, height: h)
    }
    
    var asCGPoint        : CGPoint {
        CGPoint(x:width,y:height)
    }

    var asCGRectCenteredOnZero         : CGRect {
        .init(center: .zero, size: self)
    }

    var asCGRectWithOriginZero : CGRect {
        .init(origin: .zero, size: self)
    }

    var diagonal         : CGFloat {
        sqrt(width*width + height*height)
    }
    
    var clampedTo01      : CGSize {
        .init(width: width.clampedTo01, height: height.clampedTo01)
    }
    
    static var almostZero:CGSize = {
        CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    }()
    
    func insetBy(w: CGFloat = 0, h: CGFloat = 0) -> CGSize {
        var r = self
        r.width -= w
        r.height -= h
        return r
    }
    
    var inverted : CGSize {
        .init(height, width)
    }
    
}

public struct CGSegment : Codable, Equatable, Hashable {
    var from : CGPoint
    var to : CGPoint
    
    var midpoint : CGPoint {
        (from+to)/2
    }
    
    var slope : CGSlope {
        .init(point0: from, point1: to)
    }
    
    var reversed : Self {
        .init(from: to, to: from)
    }
    
    var angle : CGAngle {
        (to - from).angle
    }
    
    func intersection(with s: CGSegment) -> CGPoint? {
        // https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = to.x - from.x
        let delta1y = to.y - from.y
        let delta2x = s.to.x - s.from.x
        let delta2y = s.to.y - s.from.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((from.y - s.from.y) * delta2x - (from.x - s.from.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((from.y - s.from.y) * delta1x - (from.x - s.from.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = from.x + ab * delta1x
                let intersectY = from.y + ab * delta1y
                return .init(intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }
    
    public func ray(inside bounds: CGRect) -> CGSegment? {
        
        let X0 = from.x, X1 = to.x, Y0 = from.y, Y1 = to.y
        
        guard bounds.contains(to) else {
            return nil
        }
        
        let FROM = to

        var TO : CGPoint
        
        let X2 : CGFloat = X0 < X1 ? bounds.x1 : bounds.x0
            
        if let Y2 = slope.y(x: X2)
        {
            TO = CGPoint.init(X2, Y2)
        }
        else
        {
            let Y2 = Y0 < Y1 ? bounds.y1 : bounds.y0

            TO = CGPoint.init(X1, Y2)
        }

        TO ?= CGSegment.init(from: FROM, to: TO).intersection(with: .init(from: bounds.tl, to: bounds.tr))
        TO ?= CGSegment.init(from: FROM, to: TO).intersection(with: .init(from: bounds.bl, to: bounds.br))

        return .init(from: FROM, to: TO)
    }
    
    public func arrow(length: CGFloat, angle: CGAngle, distance: CGFloat? = nil, offset: CGFloat = 0) -> [CGPoint] {
        ending(length: length, angle: angle, distance: distance, offset: offset)
    }
    
    public func ending(length: CGFloat, angle: CGAngle, distance: CGFloat? = nil, offset: CGFloat = 0) -> [CGPoint] {
        
        var R : [CGPoint] = []
        
        if let distance {
            
            R = [
                to,
                to + .init(length: length, angle:  angle), // 90 + a
                to - CGPoint.init(length: distance, angle: self.angle),
                to + .init(length: length, angle: -angle), // 90 - a
                to
            ]
            
        } else {
            
            R = [
                to,
                to + .init(length: length, angle:  angle), // 90 + a
                to + .init(length: length, angle: -angle), // 90 - a
                to
            ]
            
        }
        
        if offset != 0 {
            // offset each point in direction of ray by offset distance
            R = R + CGPoint.init(length: offset, angle: self.angle)
        }
        
        return R
    }
    

}

public struct CGArrow  : Codable, Equatable, Hashable {
    
    var length      : CGFloat
    var angle       : CGAngle
    var distance    : CGFloat?
    var offset      : CGFloat = 0
    
    func points(on segment: CGSegment) -> [CGPoint] {
        segment.arrow(length: length, angle: angle, distance: distance, offset: offset)
    }
    
}

public struct CGSegmentArrow : Codable, Equatable, Hashable {
    
    var segment     : CGSegment
    var arrow       : CGArrow
    
    var points      : [CGPoint] { arrow.points(on: segment) }
}



public struct CGPolygon : Codable, Equatable, Hashable {
    
    var points : [CGPoint]
    
}





public extension CGRect {

	static let minimal = CGRect(side:1)

    var x0 : CGFloat { minX }
    var x1 : CGFloat { maxX }
    var y0 : CGFloat { minY }
    var y1 : CGFloat { maxY }
    
    init(_ point:CGPoint) {
        self.init(x:point.x, y:point.y, width:0, height:0)
    }
    
    init(x:CGFloat, y:CGFloat) {
        self.init(x: x, y: y, width: 0, height: 0)
    }
    
    init(_ size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }

    init(width: CGFloat, height:CGFloat, centered: Bool = false) {
        self.init(x: centered ? -width/2 : 0, y: centered ? -height/2 : 0, width: width, height: height)
    }
    
    init(origin: CGPoint = .zero, side: CGFloat) {
        self.init(x: origin.x, y: origin.y, width: side, height: side)
    }
    
    init(center: CGPoint, side: CGFloat) {
        self.init(x: center.x - side/2, y: center.y - side/2, width: side, height: side)
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width/2, y: center.y - size.height/2, width: size.width, height: size.height)
    }
    
	init(size: CGSize) {
		self.init(x: 0, y: 0, width: size.width, height: size.height)
	}

    init(x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat) {
        self.init(x: min(x0,x1), y: min(y0,y1), width: max(x0,x1)-min(x0,x1), height: max(y0,y1)-min(y0,y1))
    }
    
    init(x0: CGFloat, x1: CGFloat, y0: CGFloat, y1: CGFloat) {
        self.init(x: min(x0,x1), y: min(y0,y1), width: max(x0,x1)-min(x0,x1), height: max(y0,y1)-min(y0,y1))
    }
    
    init(_ p0: CGPoint, _ p1: CGPoint) {
        self.init(x0: p0.x, x1: p1.x, y0: p0.y, y1: p1.y)
    }
    
    var diagonal: CGFloat {
        return sqrt(width*width + height*height)
    }
    
    static var almostZero:CGRect = {
        return CGRect(origin:CGPoint.almostZero, size:CGSize.almostZero)
    }()
    
    func scaled(_ factor: CGFloat) -> Self {
        var r = self
        r.size.width *= factor
        r.size.height *= factor
        r.origin.x += (size.width - r.width)/2
        r.origin.y += (size.height - r.height)/2
        return r
    }
    
    func centered(at: CGPoint = .zero) -> Self {
        var r = self
        r.origin.x = -r.width/2 + at.x
        r.origin.y = +r.height/2 + at.y
        return r
    }
    
    func ray(from: CGSegment) -> CGSegment? {
        from.ray(inside: self)
    }
    
}

extension CGAffineTransform {
    
    public var sx:CGFloat {
        return sqrt(a * a + c * c)
    }
    
    public var sy:CGFloat {
        return sqrt(b * b + d * d)
    }
    
    public func translatedBy(_ point: CGPoint) -> Self {
        self.translatedBy(x: point.x, y: point.y)
    }
    
}






extension CGLineCap {

	public var string : String {
		switch self {
            case .round				: return CAShapeLayerLineCap.round.rawValue
            case .butt				: return CAShapeLayerLineCap.butt.rawValue
            case .square			: return CAShapeLayerLineCap.square.rawValue
            @unknown default:
//                fatalError()
                return "?"
        }
	}
    
    public var name : String {
        switch self {
            case .round             : return "Round"
            case .butt              : return "Butt"
            case .square            : return "Square"
            @unknown default:
//                fatalError()
                return "?"
        }
    }
    
    public var previousLooped : Self {
        switch self {
            case .round             : return .square
            case .butt              : return .round
            case .square            : return .butt
            @unknown default:
//                fatalError()
                return .square
        }
    }

    public var nextLooped : Self {
        switch self {
            case .round             : return .butt
            case .butt              : return .square
            case .square            : return .round
            @unknown default:
//                fatalError()
                return .round
        }
    }
}

extension CGLineJoin {

	public var string : String {
		switch self {
            case .round				: return CAShapeLayerLineJoin.round.rawValue
            case .bevel				: return CAShapeLayerLineJoin.bevel.rawValue
            case .miter				: return CAShapeLayerLineJoin.miter.rawValue
            @unknown default:
//                fatalError()
                return "?"
		}
	}

    public var name : String {
        switch self {
            case .round             : return "Round"
            case .bevel             : return "Bevel"
            case .miter             : return "Miter"
            @unknown default:
//                fatalError()
                return "?"
        }
    }

    public var previousLooped : Self {
        switch self {
            case .round             : return .miter
            case .bevel             : return .round
            case .miter             : return .bevel
            @unknown default:
//                fatalError()
                return .miter
        }
    }

    public var nextLooped : Self {
        switch self {
            case .round             : return .bevel
            case .bevel             : return .miter
            case .miter             : return .round
            @unknown default:
//                fatalError()
                return .round
        }
    }
}










public typealias CGXY              = (x:CGFloat,y:CGFloat)











public func CGAsRadians(degrees:CGFloat) -> CGFloat                 { return degrees / 180.0 * .pi }
public func CGAsDegrees(radians:CGFloat) -> CGFloat                 { return radians / .pi * 180.0 }

public struct CGDegrees : Codable, Equatable, Hashable
{
	public var value:CGFloat

	public init(_ value:CGFloat = 0) {
		self.value = value
	}
	public func toRadians   () -> CGFloat           { return CGAsRadians(degrees:value) }
	public func asCGRadians () -> CGRadians         { return CGRadians(toRadians()) }
}

public struct CGRadians : Codable, Equatable, Hashable
{
	public var value:CGFloat

	public init(_ value:CGFloat = 0) {
		self.value = value
	}
	public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:value) }
	public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(toDegrees()) }
}

public struct CGAngle : Codable, Equatable, Hashable
{
	private var value:CGFloat

	public      init(degrees value:CGFloat)         { self.value = CGAsRadians(degrees:value) }
	public      init(radians value:CGFloat)         { self.value = value }
    public      init(y: CGFloat, x: CGFloat) {
        if y == 0 {
            self.init(degrees: 90)
        } else {
            self.init(radians: atan2(y,x))
        }
    }
    public      init(point: CGPoint)                { self.init(y: point.y, x: point.x)}
    public      init(_ a: CGPoint, _ b: CGPoint)    {
        self.init(y: b.y - a.y, x: b.x - a.x)
    }
    
	public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:value) }
	public func toRadians   ()  -> CGFloat          { return value }

	public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(toDegrees()) }
	public func asCGRadians ()  -> CGRadians        { return CGRadians(value) }
    
    public var radians      : CGFloat               { value }
    public var degrees      : CGFloat               { CGAsDegrees(radians: value) }
    
    public var  point                       : CGPoint      { CGPoint.from(angle: self) }
    public func point(radius: CGFloat)      -> CGPoint     { CGPoint.from(angle: self, radius: radius) }
    
    public var negated      : CGAngle               { -self }
    
    static let zero                         : CGAngle = .init(radians: 0)
    static let ninety                       : CGAngle = .init(degrees: 90)
    static let fortyfive                    : CGAngle = .init(degrees: 45)
}

public prefix func - (angle: CGAngle) -> CGAngle {
    .init(radians: -angle.radians)
}

public func + (left: CGAngle, right: CGAngle) -> CGAngle {
    return CGAngle(radians: left.radians + right.radians)
}
public func - (left: CGAngle, right: CGAngle) -> CGAngle {
    return CGAngle(radians: left.radians - right.radians)
}
public func += (left: inout CGAngle, right: CGAngle) {
    left = CGAngle(radians: left.radians + right.radians)
}
public func -= (left: inout CGAngle, right: CGAngle) {
    left = CGAngle(radians: left.radians - right.radians)
}
public func + (left: CGAngle, right: CGFloat) -> CGAngle {
    return CGAngle(radians: left.radians + right)
}
public func - (left: CGAngle, right: CGFloat) -> CGAngle {
    return CGAngle(radians: left.radians - right)
}
public func += (left: inout CGAngle, right: CGFloat) {
    left = CGAngle(radians: left.radians + right)
}
public func -= (left: inout CGAngle, right: CGFloat) {
    left = CGAngle(radians: left.radians - right)
}



public extension CGPoint
{
	// NOTE: USE __conversion TO CONVERT TO TYPES
	func __conversion() -> (CGFloat, CGFloat)           { return (x, y) }

    var asTuple                 : (CGFloat, CGFloat)           { return (x, y) }

    static func from            (angle: CGAngle) -> CGPoint                  { CGPoint(cos(angle.radians), sin(angle.radians)) }
    static func from            (angle: CGAngle, radius: CGFloat) -> CGPoint { from(angle: angle) * radius }

    var angle                   : CGAngle { .init(point: self) }
    
    var unit                    : CGPoint   {
        let d = length
        return d == 0 ? .zero : .init(x / d, y / d)
    }
    
    var negated                 : CGPoint                       { -self }

    func distance               (to: CGPoint) -> CGFloat { (to-self).length }
    func distanceSquared        (to: CGPoint) -> CGFloat { (to-self).lengthSquared }
    
    func distanceSquaredToSegment(_ v: CGPoint, _ w: CGPoint) -> CGFloat {
        let pv_dx = x - v.x
        let pv_dy = y - v.y
        let wv_dx = w.x - v.x
        let wv_dy = w.y - v.y

        let dot = pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq

        var int_x, int_y: CGFloat /* intersection of normal to vw that goes through p */

        if param < 0 || (v.x == w.x && v.y == w.y) {
            int_x = v.x
            int_y = v.y
        } else if param > 1 {
            int_x = w.x
            int_y = w.y
        } else {
            int_x = v.x + param * wv_dx
            int_y = v.y + param * wv_dy
        }

        /* Components of normal */
        let dx = x - int_x
        let dy = y - int_y

        return dx * dx + dy * dy
    }
    func distanceToSegment(_ v: CGPoint, _ w: CGPoint) -> CGFloat {
        sqrt(distanceSquaredToSegment(v,w))
    }
    func distanceSquaredToSegment(_ s: CGSegment) -> CGFloat {
        distanceSquaredToSegment(s.from,s.to)
    }
    func distanceToSegment(_ s: CGSegment) -> CGFloat {
        sqrt(distanceSquaredToSegment(s.from,s.to))
    }
    
    func isLeft                 (of: CGPoint) -> Bool   { x < of.x }
    func isRight                (of: CGPoint) -> Bool   { x > of.x }
    func isDown                 (of: CGPoint) -> Bool   { y < of.y }
    func isUp                   (of: CGPoint) -> Bool   { y > of.y }
    func isBelow                (_ of: CGPoint) -> Bool   { y < of.y }
    func isAbove                (_ of: CGPoint) -> Bool   { y > of.y }
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

    public var minSide          : CGFloat       { size.minSide }
    public var maxSide          : CGFloat       { size.maxSide }

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

    public var minSide          : CGFloat       { min(width,height) }
    public var maxSide          : CGFloat       { max(width,height) }

    public var asMaxSquare      : CGSize        { .init(maxSide, maxSide) }
    public var asMinSquare      : CGSize        { .init(minSide, minSide) }
    public var asSquareFromDiagonal      : CGSize        { .init(diagonal, diagonal) }

	public func pointFromRatio         (x:CGFloat, y:CGFloat)      -> CGPoint { return CGPoint(x: width * x, y: height * y) }
	public func pointFrom              (ratio:CGXY)                -> CGPoint { return pointFromRatio(x:ratio.x, y:ratio.y) }

	public func ratioFrom              (point:CGPoint)             -> CGPoint { return CGPoint(x: width != 0.0 ? (point.x / width) : 0.0, y: height != 0.0 ? (point.y / height) : 0.0 ) }
}

#if os(iOS)
public func UIScreenGetCenter() -> CGPoint {
	return CGPoint(x:UIScreen.main.bounds.width/2.0,
				   mappingVToY:UIScreen.main.bounds.height/2.0)
}
#endif
#if os(macOS)
public extension NSScreen {
    var center : CGPoint {
        self.frame.center
    }
}
#endif


#if os(iOS)
public struct CGScreen
{
	public static var bounds:CGRect = CGRect(x:UIScreen.main.bounds.origin.x,
											 mappingVToY:UIScreen.main.bounds.origin.mappingVToY,
											 width:UIScreen.main.bounds.width * UIScreen.main.scale,
											 height:UIScreen.main.bounds.height * UIScreen.main.scale)

	public static var origin                                                   :CGPoint    { return bounds.origin }
	public static var size                                                     :CGSize     { return bounds.size }
	public static var width                                                    :CGFloat    { return size.width }
	public static var height                                                   :CGFloat    { return size.height }
	public static var scale                                                    :CGFloat    { return UIScreen.main.scale }


	public static func diagonal                (fraction:CGFloat = 1.0)        -> CGFloat  { return Environment.Screen.diagonal(fraction) }

	public static func pointFromRatio          (x:CGFloat, mappingVToY:CGFloat)          -> CGPoint  { return bounds.pointFromRatio(x:x,mappingVToY:mappingVToY) }
	public static func pointFrom               (ratio:CGXY)                    -> CGPoint  { return pointFromRatio(x:ratio.x,mappingVToY:ratio.mappingVToY) }

	public static func ratioFrom               (point:CGPoint)                 -> CGPoint  { return bounds.ratioFrom(point:point) }
}
#endif

public struct CGSlope {
    public let point0  : CGPoint
    public let point1  : CGPoint
    public let dy      : CGFloat
    public let dx      : CGFloat
    public let slope   : CGFloat!
    public let b       : CGFloat!

    public init(point0: CGPoint, point1: CGPoint) {
        self.point0 = point0
        self.point1 = point1
        dy      = point1.y - point0.y
        dx      = point1.x - point0.x
        slope   = dx == 0 ? nil : dy/dx
        b       = dx == 0 ? nil : (point0.y - slope * point0.x)
    }
    
    public static func create(_ point0: CGPoint, _ point1: CGPoint) -> Self {
        .init(point0: point0, point1: point1)
    }
    
    public func y(x: CGFloat) -> CGFloat! {
        // y = mx + b
        guard let slope = slope else { return nil }
//        return slope * (x - point0.x) + point0.y
        return slope * x + b
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








public struct CGLineStyle : Codable, Equatable, Hashable, RawRepresentable {
    
    internal init(lineWidth: CGFloat? = 1, lineCap: CGLineCap? = .butt, lineJoin: CGLineJoin? = .miter, miterLimit: CGFloat? = 10, dashPhase: CGFloat? = 0, dashPattern: [CGFloat]? = []) {
        self.lineWidth ?= lineWidth
        self.lineCap ?= lineCap
        self.lineJoin ?= lineJoin
        self.miterLimit ?= miterLimit
        self.dashPhase ?= dashPhase
        self.dashPattern ?= dashPattern
    }
    
    
    public init?(rawValue: String) {
        let split = rawValue.split("|")
        lineWidth ?= split[safe: 0]?.asCGFloat
        lineCap ?= split[safe: 1]?.asInt == nil ? nil : CGLineCap.init(rawValue: split[1].asInt?.asInt32 ?? 0)
        lineJoin ?= split[safe: 2]?.asInt == nil ? nil : CGLineJoin.init(rawValue: split[2].asInt?.asInt32 ?? 0)
        miterLimit ?= split[safe: 3]?.asCGFloat
        dashPhase ?= split[safe: 4]?.asCGFloat
        dashPattern ?= split[safe: 5]?.asArrayOfDouble().asArrayOfCGFloat
    }
    
    public var rawValue : String {
        "\(lineWidth.format2)"
        + "|\(lineCap.rawValue.asString)"
        + "|\(lineJoin.rawValue.asString)"
        + "|\(miterLimit.format2)"
        + "|\(dashPhase.format2)"
        + "|\(dashPattern.asArrayOfString())"
    }
    
//    enum LineCap : Int, Codable, Equatable, Hashable {
//        case butt = 0
//        case round = 1
//        case square = 2
//    }
//
//    enum LineJoin : Int, Codable, Equatable, Hashable {
//        case miter = 0
//        case butt = 1
//        case bevel = 2
//
//        var asCGLineJoin : CGLineJoin {
//
//        }
//    }
    
    public typealias RawValue = String
    
    var lineWidth       : CGFloat       = 1
    var lineCap         : CGLineCap     = .butt
    var lineJoin        : CGLineJoin    = .miter
    var miterLimit      : CGFloat       = 10
    var dashPhase       : CGFloat       = 0
    var dashPattern     : [CGFloat]     = []
    
    var thickness       : CGFloat {
        get { lineWidth }
        set { lineWidth = newValue }
    }
    
    var cap             : CGLineCap {
        get { lineCap }
        set { lineCap = newValue }
    }
    
    var join            : CGLineJoin {
        get { lineJoin }
        set { lineJoin = newValue }
    }

    var pattern         : [CGFloat] {
        get { dashPattern }
        set { dashPattern = newValue }
    }

    var linePattern     : [CGFloat]! {
        get { dashPattern }
        set { dashPattern = newValue }
    }

    
    
    func with(thickness: CGFloat? = nil, cap: CGLineCap? = nil, join: CGLineJoin? = nil, pattern: [CGFloat]? = nil) -> Self {
        var r = self
        r.thickness ?= thickness
        r.cap ?= cap
        r.join ?= join
        r.pattern ?= pattern
        return r
    }
    
    func rounded() -> Self {
        with(cap: .round, join: .round)
    }
    
    
//    func filled(with: CGLineStyle?) -> CGLineStyle {
//        var r = self
//        r.lineWidth         ?= with?.lineWidth
//        r.lineCap           ?= with?.lineCap
//        r.lineJoin          ?= with?.lineJoin
//        r.miterLimit        ?= with?.miterLimit
//        r.dashPhase         ?= with?.dashPhase
//        r.dashPattern       ?= with?.dashPattern
//        return r
//    }
    
    enum CodingKeys : String, CodingKey {
        case lineWidth      = "w"
        case lineCap        = "c"
        case lineJoin       = "j"
        case miterLimit     = "m"
        case dashPhase      = "p"
        case dashPattern    = "d"
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.dashPattern  =  c.decode(.dashPattern,  [])
        self.dashPhase    =  c.decode(.dashPhase,    0)
        self.lineCap      =  c.decode(.lineCap,      .butt)
        self.lineJoin     =  c.decode(.lineJoin,     .miter)
        self.lineWidth    =  c.decode(.lineWidth,    1)
        self.miterLimit   =  c.decode(.miterLimit,   10)
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.dashPattern, forKey: .dashPattern)
        try c.encode(self.dashPhase, forKey: .dashPhase)
        try c.encode(self.lineCap, forKey: .lineCap)
        try c.encode(self.lineJoin, forKey: .lineJoin)
        try c.encode(self.lineWidth, forKey: .lineWidth)
        try c.encode(self.miterLimit, forKey: .miterLimit)
    }
    
    static func create(_ width: CGFloat, _ pattern: [CGFloat] = []) -> CGLineStyle {
        .init(lineWidth: width, lineCap: .butt, lineJoin: .miter, miterLimit: 10, dashPhase: 0, dashPattern: pattern)
    }
    
    static let line1 : CGLineStyle = .create(1)
    static let line2 : CGLineStyle = .create(2)
    static let line3 : CGLineStyle = .create(3)
    
}

extension CGLineCap : Codable {
    
}

extension CGLineJoin : Codable {
    
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

#if os(iOS)
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
#endif


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

public prefix func - (point: CGPoint) -> CGPoint {
    CGPoint(-point.x, -point.y)
}

public extension CGPath {
    
    static func line(p0: CGPoint, p1: CGPoint) -> CGPath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addLine(to: p1)
//        r.closeSubpath()
        return r
    }
    
    static func quadratic(p0: CGPoint, c0: CGPoint, p1: CGPoint) -> CGPath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addQuadCurve(to: p1, control: c0)
//        r.closeSubpath()
        return r
    }
    
    static func cubic(p0: CGPoint, c0: CGPoint, c1: CGPoint, p1: CGPoint) -> CGPath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addCurve(to: p1, control1: c0, control2: c1)
//        r.closeSubpath()
        return r
    }
    
    static func create(rect: CGRect) -> CGPath {
        let r = CGMutablePath.init()
            //        r.move(to: .zero)
        r.addRect(rect)
//        r.closeSubpath()
        return r
    }
    
    static func create(polygon points: [CGPoint]) -> CGPath {
        CGMutablePath.polygon(points: points)
    }
    

    func rotatedBy(_ angle: CGAngle) -> CGPath {
        rotatedBy(angle.radians)
    }
    
    func rotatedBy(_ radians: CGFloat) -> CGPath {
        CGMutablePath.init().addedPath(self, transform: .identity.rotated(by: radians))
    }

    func translatedBy(_ point: CGPoint) -> CGPath {
        CGMutablePath.init().addedPath(self, transform: .identity.translatedBy(point))
    }
}

public extension CGMutablePath {
    
    static func line(p0: CGPoint, p1: CGPoint, closed: Bool) -> CGMutablePath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addLine(to: p1)
        if closed {
            r.closeSubpath()
        }
        return r
    }
    
    static func quadratic(p0: CGPoint, c0: CGPoint, p1: CGPoint, closed: Bool) -> CGMutablePath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addQuadCurve(to: p1, control: c0)
        if closed {
            r.closeSubpath()
        }
        return r
    }
    
    static func cubic(p0: CGPoint, c0: CGPoint, c1: CGPoint, p1: CGPoint, closed: Bool) -> CGMutablePath {
        let r = CGMutablePath.init()
        r.move(to: p0)
        r.addCurve(to: p1, control1: c0, control2: c1)
        if closed {
            r.closeSubpath()
        }
        return r
    }
    
    static func polygon(points: [CGPoint]) -> CGMutablePath {
        let r = CGMutablePath.init()
        if points.isNotEmpty {
            r.move(to: points[0])
            for i in 1..<points.count {
                r.addLine(to: points[i])
            }
            r.closeSubpath()
        }
        return r
    }
    
    static func arrowHeadOrientedUpWithTipAtOrigin(side length: CGFloat, angle /* from y axis [0,90] */: CGAngle, opposite /* distance from origin */: CGFloat) -> CGMutablePath {
        let r = CGMutablePath.init()
        r.move(to: .zero)
        r.addLine(to: (CGAngle.ninety - angle).negated.point(radius: length))
//        r.addLine(to: .init(length, -opposite))
        r.addLine(to: .init(0, -opposite))
//        r.addLine(to: .init(-length, -opposite))
        r.addLine(to: (CGAngle.ninety + angle).negated.point(radius: length))
        r.addLine(to: .zero)
//        r.closeSubpath()
        return r
    }
    
    static func arrow(from: CGPoint, to: CGPoint, thickness: CGFloat, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, lineMiterLimit: CGFloat = 0, side length: CGFloat, angle /* from y axis [0,90] */: CGAngle, opposite /* distance from origin */: CGFloat) -> CGMutablePath {
        let r = CGMutablePath.init()
        let ARROWHEAD = arrowHeadOrientedUpWithTipAtOrigin(side: length, angle: angle, opposite: opposite)
        let P1 = to-from
        let ANGLE = P1.angle
        let LINE = CGMutablePath.init().moved(to: -P1).addedLine(to: .zero, transform: .identity.rotated(by: -ANGLE.radians).translatedBy(x: 0, y: -P1.length - opposite/2.0))
        r.addPath(ARROWHEAD)
//        r.addPath(LINE.copy(strokingWithWidth: thickness, lineCap: lineCap, lineJoin: lineJoin, miterLimit: lineMiterLimit))
        return CGMutablePath.init().addedPath(r) //, transform: .identity.rotated(by: ANGLE.radians))
    }
    
//    static func arrow(points: [CGPoint], lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, lineMiterLimit: CGFloat = 0, side length: CGFloat, angle /* from y axis [0,90] */: CGAngle, opposite /* distance from origin */: CGFloat) -> CGMutablePath {
//        let r = CGMutablePath.init()
//        return r
//    }
    
    func moved(to: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        move(to: to, transform: transform)
        return self
    }
    
    func addedRoundedRect(in rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        addRoundedRect(in: rect, cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: transform)
        return self
    }
    
    func addedLine(to: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        addLine(to: to, transform: transform)
        return self
    }
    
    func addedQuadCurve(to end: CGPoint, control: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        addQuadCurve(to: end, control: control, transform: transform)
        return self
    }

    func addedCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint, transform: CGAffineTransform = .identity) -> Self {
        addCurve(to: end, control1: control1, control2: control2, transform: transform)
        return self
    }

    func addedRect(_ rect: CGRect, transform: CGAffineTransform = .identity) -> Self {
        addRect(rect, transform: transform)
        return self
    }

    func addedRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) -> Self {
        addRects(rects, transform: transform)
        return self
    }

    func addedLines(between points: [CGPoint], transform: CGAffineTransform = .identity) -> Self {
        addLines(between: points, transform: transform)
        return self
    }

    func addedEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) -> Self {
        addEllipse(in: rect, transform: transform)
        return self
    }

    func addedRelativeArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, delta: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: delta, transform: transform)
        return self
    }

    func addedArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool, transform: CGAffineTransform = .identity) -> Self {
        addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise, transform: transform)
        return self
    }

    func addedArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) -> Self {
        addArc(tangent1End: tangent1End, tangent2End: tangent2End, radius: radius, transform: transform)
        return self
    }
    
    func addedPath(_ path: CGPath, transform: CGAffineTransform = .identity) -> Self {
        addPath(path, transform: transform)
        return self
    }
    
    func closedSubpath() -> Self {
        closeSubpath()
        return self
    }
    
}
