//
//  ExtensionForSpriteKit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/1/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


public typealias CGXY              = (x:CGFloat,y:CGFloat)





public struct CGProportion
{
    public var value:CGFloat = 0
    
    public func of      (length:CGFloat) -> CGFloat                 { return value * length }
    public func lerp    (from:CGFloat,to:CGFloat) -> CGFloat        { return from + value * (to - from) }
    public func lerp01  (from:CGFloat,to:CGFloat) -> CGFloat        { return min(1,max(0,from + value * (to - from))) }
    
    public func lerp    (from:CGFloat,length:CGFloat) -> CGFloat    { return lerp(from:from,to:from + length) }
    public func lerp01  (from:CGFloat,length:CGFloat) -> CGFloat    { return lerp01(from:from,to:from + length) }
}

public struct CGRatio
{
    public var h:CGFloat = 0
    public var v:CGFloat = 0
    
    func __conversion() -> (CGFloat, CGFloat)                       { return (h, v) }
}

public func CGAsRadians(degrees:CGFloat) -> CGFloat                 { return degrees / 180.0 * .pi }
public func CGAsDegrees(radians:CGFloat) -> CGFloat                 { return radians / .pi * 180.0 }

public struct CGDegrees
{
    public let angle:CGFloat
    
    public init(angle:CGFloat) {
        self.angle = angle
    }
    public func toRadians   () -> CGFloat           { return CGAsRadians(degrees:angle) }
    public func asCGRadians () -> CGRadians         { return CGRadians(angle:toRadians()) }
}

public struct CGRadians
{
    public let angle:CGFloat
    
    public init(angle:CGFloat) {
        self.angle = angle
    }
    public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:angle) }
    public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(angle:toDegrees()) }
}

public struct CGAngle
{
    private var angle:CGFloat
    
    public      init(degrees angle:CGFloat)         { self.angle = CGAsRadians(degrees:angle) }
    public      init(radians angle:CGFloat)         { self.angle = angle }
    
    public func toDegrees   ()  -> CGFloat          { return CGAsDegrees(radians:angle) }
    public func toRadians   ()  -> CGFloat          { return angle }
    
    public func asCGDegrees ()  -> CGDegrees        { return CGDegrees(angle:toDegrees()) }
    public func asCGRadians ()  -> CGRadians        { return CGRadians(angle:angle) }
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
    
    public var top             :CGFloat        { return origin.y + height }
    public var left            :CGFloat        { return origin.x }
    public var bottom          :CGFloat        { return origin.y }
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



extension SKNode
{
    @objc var width   :CGFloat                                                                    { return 0 }
    @objc var height  :CGFloat                                                                    { return 0 }
    
    public func hFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.width * ratio }
    public func vFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.height * ratio }
    
    public func xFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.position.x + hFrom(ratio:ratio) }
    public func yFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.position.y + vFrom(ratio:ratio) }
    
    public func ratioFromH             (h:CGFloat)                                     -> CGFloat  { return h / (width != 0 ? width : 1.0) }
    public func ratioFromV             (v:CGFloat)                                     -> CGFloat  { return v / (height != 0 ? height : 1.0) }
    
    public func ratioFromX             (x:CGFloat)                                     -> CGFloat  { return (x - position.x) / (width != 0 ? width : 1.0) }
    public func ratioFromY             (y:CGFloat)                                     -> CGFloat  { return (y - position.y) / (height != 0 ? height : 1.0) }
    
    public func pointFromRatio         (ratio:CGPoint)                                 -> CGPoint  { return CGPoint(x: hFrom(ratio:ratio.x), y: vFrom(ratio:ratio.y)) }
    public func pointFromRatio         (h:CGFloat, v:CGFloat)                          -> CGPoint  { return CGPoint(x: hFrom(ratio:h),y: vFrom(ratio:v)) }
    
    @objc public func positionFromRatio      (x:CGFloat, y:CGFloat)                          -> CGPoint  { return position + pointFromRatio(h:x,v:y) }
    
    
    public var z:CGFloat {
        get {
            return zPosition
        }
        set {
            zPosition = newValue
        }
    }
    
    
    class public func resolveResourceImageName(name:String, suffix:String = ".png") -> String {
        
        // if has .suffix
        // if is suffixed with ~5
        // if not has .suffix
        
        if Environment.DeviceType.iPhone5 {
            return name + (name.hasSuffix("~5") ? "" : "~5") + suffix
        }
        if Environment.DeviceType.iPhone6 {
            return name + (name.hasSuffix("~6") ? "" : "~6") + suffix
        }
        if Environment.DeviceType.iPhone6plus {
            return name + (name.hasSuffix("~6+") ? "" : "~6+") + suffix
        }
        
        return name
    }
    
    public func addChild               (sprite:SKSpriteNode)                    -> SKSpriteNode
    {
        addChild(sprite)
        return sprite
    }
    
    public func addChildSprite         (imageNamed:String, suffix:String = ".png")                  -> SKSpriteNode
    {
        let name = SKNode.resolveResourceImageName(name:imageNamed,suffix:suffix)
        let node = SKSpriteNode(imageNamed:name)
        addChild(node)
        node.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        return node
    }
    
    public func addChildSpriteEmpty    ()                                              -> SKSpriteNode
    {
        let node = SKSpriteNode()
        addChild(node)
        node.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        return node
    }
    
    
    
    
    
    
    public func positionFromScreenRatio  (to:CGXY)
    {
        if let parent = self.scene
        {
            let position = parent.position + CGScreen.pointFrom(ratio:to)
            //            print("positionFromScreen(\(to))=\(position),screen=\(CGScreen.bounds)")
            self.position = (self.parent?.convert(position,from:parent))!
        }
    }
    
    public func positionFromScreenRatio          (x:CGFloat,y:CGFloat)
    {
        positionFromScreenRatio(to:CGXY(x,y))
    }
    
    
    
    
    public func positionFromSceneRatio  (to:CGXY)
    {
        if let parent = self.scene
        {
            self.position.x = parent.xFrom(ratio:to.x)
            self.position.y = parent.yFrom(ratio:to.y)
            
            self.position = (self.parent?.convert(position,from:parent))!
        }
    }
    
    public func positionFromSceneRatio          (x:CGFloat,y:CGFloat)
    {
        positionFromSceneRatio(to:CGXY(x,y))
    }
    
    
    
    
    public func positionFromParentRatio  (to:CGXY)
    {
        if let parent = self.parent as? SKSpriteNode {
            self.position.x = parent.xFrom(ratio:to.x - parent.anchorPoint.x)
            self.position.y = parent.yFrom(ratio:to.y - parent.anchorPoint.y)
        }
        else if let parent = self.parent as? SKScene {
            self.position.x = parent.xFrom(ratio:to.x)
            self.position.y = parent.yFrom(ratio:to.y)
        }
    }
    
    public func positionFromParentRatio          (x:CGFloat,y:CGFloat)
    {
        positionFromParentRatio(to:CGXY(x,y))
    }
    
    public func positionFromParentCenter ()
    {
        positionFromParentRatio(to:(x:0.5,y:0.5))
    }
    
    
    
    
    public func onNodePositionToParentRatio  (to:CGXY)                                    -> SKNode
    {
        positionFromParentRatio(to:to)
        return self
    }
    
    public func onNodePositionToParentCenter ()                                              -> SKNode
    {
        return onNodePositionToParentRatio(to:(x:0.5,y:0.5))
    }
    
    
    
}





extension SKScene
{
    override var  width   :CGFloat                                                                    { return self.size.width }
    override var  height  :CGFloat                                                                    { return self.size.height }
    
    // NOTE: NEED TO OVERRIDE position TO FIX BUG IN SpriteKit
    override open var  position:CGPoint {
        get {
            return self.frame.origin
        }
        set {
        }
    }
}




extension SKLightNode
{
    
}



extension SKShapeNode
{
    public convenience init(lines:[CGPoint], strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil, lineCap:CGLineCap? = nil, lineJoin:CGLineJoin? = nil) {
        let path = CGMutablePath()
        path.move(to:lines[0])
        for i in stride(from:1,to:lines.count,by:1) {
            path.addLine(to:lines[i])
        }
        self.init(path:path)
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        else {
            self.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
        if let lineCap = lineCap {
            self.lineCap = lineCap
        }
        if let lineJoin = lineJoin {
            self.lineJoin = lineJoin
        }
    }

    public convenience init(rectangle:CGRect, fillColor:UIColor? = nil, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil, lineCap:CGLineCap? = nil, lineJoin:CGLineJoin? = nil) {
        self.init(rect:rectangle)
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        else {
            self.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
        if let lineCap = lineCap {
            self.lineCap = lineCap
        }
        if let lineJoin = lineJoin {
            self.lineJoin = lineJoin
        }
    }

    public convenience init(circleOfRadius:CGFloat, position:CGPoint, fillColor:UIColor? = nil, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil) {
        self.init(circleOfRadius:circleOfRadius)
        self.position = position
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        else {
            self.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
    }

    public convenience init(circleOfRadius:CGFloat, fillColor:UIColor, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil) {
        self.init(circleOfRadius:circleOfRadius)
        self.fillColor = fillColor
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        else {
            self.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
    }
    
    public convenience init(circleOfRadius:CGFloat, strokeColor:UIColor, fillColor:UIColor? = nil, lineWidth:CGFloat? = nil) {
        self.init(circleOfRadius:circleOfRadius)
        self.strokeColor = strokeColor
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
    }
    
    static public func circle(withRadius:CGFloat, position:CGPoint? = nil, fillColor:UIColor? = nil, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil) -> SKShapeNode {
        let r = SKShapeNode(circleOfRadius: withRadius)
        if let position = position {
            r.position = position
        }
        if let fillColor = fillColor {
            r.fillColor = fillColor
        }
        if let strokeColor = strokeColor {
            r.strokeColor = strokeColor
        }
        else {
            r.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            r.lineWidth = lineWidth
        }
        return r
    }
    
    static public func line(from:CGPoint, to:CGPoint, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil, lineCap:CGLineCap? = nil, lineJoin:CGLineJoin? = nil) -> SKShapeNode {
        let r = SKShapeNode(lines:[from,to])
        if let strokeColor = strokeColor {
            r.strokeColor = strokeColor
        }
        else {
            r.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            r.lineWidth = lineWidth
        }
        if let lineCap = lineCap {
            r.lineCap = lineCap
        }
        if let lineJoin = lineJoin {
            r.lineJoin = lineJoin
        }
        return r
    }

    public func configure(position:CGPoint? = nil, fillColor:UIColor? = nil, strokeColor:UIColor? = nil, lineWidth:CGFloat? = nil, lineCap:CGLineCap? = nil, lineJoin:CGLineJoin? = nil) {
        if let position = position {
            self.position = position
        }
        if let fillColor = fillColor {
            self.fillColor = fillColor
        }
        if let strokeColor = strokeColor {
            self.strokeColor = strokeColor
        }
        else {
            self.strokeColor = .clear
        }
        if let lineWidth = lineWidth {
            self.lineWidth = lineWidth
        }
        if let lineCap = lineCap {
            self.lineCap = lineCap
        }
        if let lineJoin = lineJoin {
            self.lineJoin = lineJoin
        }
    }
}



extension SKSpriteNode
{
    
    override var  width   :CGFloat                                                                    { return self.size.width }
    override var  height  :CGFloat                                                                    { return self.size.height }
    
    
    
    
    
    override public func positionFromRatio      (x:CGFloat, y:CGFloat)                     -> CGPoint { return CGPoint(x:xFrom(ratio:x - anchorPoint.x),y:yFrom(ratio:y - anchorPoint.y)) }
    
    
    
    
    
    public func onSpriteAlignX                 (from:CGFloat, to:CGFloat)                  -> SKSpriteNode
    {
        // POSITION IS WRT TO PARENT'S ANCHOR
        
        self.position.x = to - from
        
        return self
    }
    
    public func onSpriteAlignX                 (fromRatio:CGFloat, to:CGFloat)             -> SKSpriteNode
    {
        let from        = hFrom(ratio:fromRatio - anchorPoint.x)
        
        self.position.x = to - from
        
        return self
    }
    
    public func onSpriteAlignX                 (fromRatio:CGFloat, toRatio:CGFloat)        -> SKSpriteNode
    {
        if let parent = self.parent as? SKSpriteNode {
            let from        = self  .hFrom(ratio:fromRatio - anchorPoint.x)
            let to          = parent.hFrom(ratio:toRatio - parent.anchorPoint.x)
            self.position.x = to - from
        }
        else if let parent = self.parent as? SKScene {
            let from        = self  .hFrom(ratio:fromRatio - anchorPoint.x)
            let to          = parent.hFrom(ratio:toRatio - parent.anchorPoint.x)
            self.position.x = to - from
        }
        return self
    }
    
    public func onSpriteAlignX                 (from:CGFloat, toRatio:CGFloat)             -> SKSpriteNode
    {
        if let parent = self.parent as? SKSpriteNode {
            let to          = parent.hFrom(ratio:toRatio - parent.anchorPoint.x)
            self.position.x = to - from
        }
        else if let parent = self.parent as? SKScene {
            let to          = parent.hFrom(ratio:toRatio - parent.anchorPoint.x)
            self.position.x = to - from
        }
        return self
    }
    
    
    
    
    
    public func onSpriteAlignY                 (from:CGFloat, to:CGFloat)                  -> SKSpriteNode
    {
        self.position.y = to - from
        
        return self
    }
    
    public func onSpriteAlignY                 (fromRatio:CGFloat, to:CGFloat)             -> SKSpriteNode
    {
        let from        = vFrom(ratio:fromRatio - anchorPoint.y)
        
        self.position.y = to - from
        
        return self
    }
    
    public func onSpriteAlignY                 (fromRatio:CGFloat, toRatio:CGFloat)        -> SKSpriteNode
    {
        if let parent = self.parent as? SKSpriteNode {
            let from        = self  .vFrom(ratio:fromRatio - anchorPoint.y)
            let to          = parent.vFrom(ratio:toRatio - parent.anchorPoint.y)
            self.position.y = to - from
        }
        else if let parent = self.parent as? SKScene {
            let from        = self  .vFrom(ratio:fromRatio - anchorPoint.y)
            let to          = parent.vFrom(ratio:toRatio - parent.anchorPoint.y)
            self.position.y = to - from
        }
        return self
    }
    
    public func onSpriteAlignY                 (from:CGFloat, toRatio:CGFloat)             -> SKSpriteNode
    {
        if let parent = self.parent as? SKSpriteNode {
            let to          = parent.vFrom(ratio:toRatio - parent.anchorPoint.y)
            self.position.x = to - from
        }
        else if let parent = self.parent as? SKScene {
            let to          = parent.vFrom(ratio:toRatio - parent.anchorPoint.y)
            self.position.x = to - from
        }
        return self
    }
    
    
    
    
    
    
    public func onSpriteAlign                  (from:CGPoint, to:CGPoint)                  -> SKSpriteNode
    {
        let _ = onSpriteAlignX(from:from.x,to:to.x)
        let _ = onSpriteAlignY(from:from.y,to:to.y)
        return self
    }
    
    public func onSpriteAlign                  (fromRatio:CGPoint, to:CGPoint)             -> SKSpriteNode
    {
        let _ = onSpriteAlignX(fromRatio:fromRatio.x,to:to.x)
        let _ = onSpriteAlignY(fromRatio:fromRatio.y,to:to.y)
        return self
    }
    
    public func onSpriteAlign                  (fromRatio:CGXY, toRatio:CGXY)              -> SKSpriteNode
    {
        let _ = onSpriteAlignX(fromRatio:fromRatio.x,toRatio:toRatio.x)
        let _ = onSpriteAlignY(fromRatio:fromRatio.y,toRatio:toRatio.y)
        return self
    }
    
    public func onSpriteAlign                  (fromRatio:CGPoint, toRatio:CGPoint)        -> SKSpriteNode
    {
        let _ = onSpriteAlignX(fromRatio:fromRatio.x,toRatio:toRatio.x)
        let _ = onSpriteAlignY(fromRatio:fromRatio.y,toRatio:toRatio.y)
        return self
    }
    
    public func onSpriteAlign                  (from:CGPoint, toRatio:CGPoint)             -> SKSpriteNode
    {
        let _ = onSpriteAlignX(from:from.x,toRatio:toRatio.x)
        let _ = onSpriteAlignY(from:from.y,toRatio:toRatio.y)
        return self
    }
    
    public func onSpriteAlign                  (fromRatio:CGPoint)                         -> SKSpriteNode
    {
        return onSpriteAlign(fromRatio:fromRatio,
                             toRatio  :CGPoint(x: 0.5,y: 0.5))
    }
    
    public func onSpriteAlign                  (toRatio:CGPoint)                           -> SKSpriteNode
    {
        return onSpriteAlign(fromRatio:CGPoint(x: 0.5,y: 0.5),
                             toRatio  :toRatio)
    }
    
    public func onSpriteAlignCenters           ()                                          -> SKSpriteNode
    {
        return onSpriteAlign(fromRatio:CGPoint(x: 0.5,y: 0.5),
                             toRatio  :CGPoint(x: 0.5,y: 0.5))
    }
    
    // onSpriteAlign(r:(0.5,0.3),p=(320,120))
    
}







extension SKNode
{
    open func run(_ action: SKAction, delay:TimeInterval) {
        self.run(aDelayed(delay:delay, action: action))
    }
    
    open func run(_ action: SKAction, delay:TimeInterval, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: action), completion: block)
    }
    
    open func run(_ action: SKAction, withKey key: String, delay:TimeInterval) {
        self.run(aDelayed(delay:delay, action: action), withKey: key)
    }
    

    open func run(sequence: [SKAction], delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)))
    }
    
    open func run(sequence: [SKAction], delay:TimeInterval = 0, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)), completion: block)
    }
    
    open func run(sequence: [SKAction], withKey key: String, delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)), withKey: key)
    }
    

    open func run(group: [SKAction], delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aGroup(group)))
    }
    
    open func run(group: [SKAction], delay:TimeInterval = 0, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: aGroup(group)), completion: block)
    }
    
    open func run(group: [SKAction], withKey key: String, delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aGroup(group)), withKey: key)
    }
    

    open func debugAddX(lineWidth:CGFloat = 1, color:UIColor = .red) -> SKNode
    {
        if true
        {
            let path = CGMutablePath()
            
            path.move           (to: CGPoint.zero)
            path.addLine        (to: frame.size.asCGPoint)
            
            let n = SKShapeNode(path:path)
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.bl
        }
        if true
        {
            let path = CGMutablePath()

            path.move           (to: CGPoint(x:0,y:self.frame.size.height))
            path.addLine        (to: CGPoint(x:self.frame.size.width,y:0))
            
            let n = SKShapeNode(path:path)
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.tl
        }
        
        return self
    }
    
    open func debugAddCross(lineWidth:CGFloat = 1, color:UIColor = .red) -> SKNode
    {
        if true
        {
            let path = CGMutablePath()

            path.move           (to: CGPoint(x:self.frame.size.width/2,y:0))
            path.addLine        (to: CGPoint(x:self.frame.size.width/2,y:self.frame.size.height))
            
            let n = SKShapeNode(path:path)
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.bl
        }
        if true
        {
            let path = CGMutablePath()
            
            path.move           (to:CGPoint(x: 0.0,y: self.frame.size.height/2))
            path.addLine        (to:CGPoint(x: self.frame.size.width,y: self.frame.size.height/2))
            
            let n = SKShapeNode(path:path)
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.bl
        }
        
        return self
    }
    
    open func debugAddBorder(lineWidth:CGFloat = 1, corner:CGFloat = 16, color:UIColor = .green) -> SKNode
    {
        if true
        {
            let n = SKShapeNode(rectOf:self.frame.size,cornerRadius:corner)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.center
        }
        
        return self
    }
}





extension SKAction {
    
    public func runOn(node:SKNode,delay sec:TimeInterval = 0) -> SKAction {
        let _ = aRun(on:node,action:self,delay:sec)
        return self
    }
}


public func aRun            (on node:SKNode,action:SKAction,delay sec:TimeInterval = 0) -> SKNode       { node.run(aDelayed(delay:sec,action:action)); return node }
public func aRun            (action:SKAction,node:SKNode,delay sec:TimeInterval = 0)    -> SKNode       { node.run(aDelayed(delay:sec,action:action)); return node }
public func aRun            (action:SKAction,on:SKNode,delay sec:TimeInterval = 0)      -> SKNode       { on.run(aDelayed(delay:sec,action:action)); return on }

public func aRunOnChild     (named:String,action:SKAction,delay sec:TimeInterval = 0)   -> SKAction     { return SKAction.run(aDelayed(delay:sec,action:action), onChildWithName:named); }

public func aForever        (action:SKAction)                                           -> SKAction     { return SKAction.repeatForever(action) }
public func aRepeat         (action:SKAction,count:UInt)                                -> SKAction     { return SKAction.repeat(action,count:Int(count)) }

public func aSequence       (_ actions:[SKAction])                                      -> SKAction     { return SKAction.sequence(actions) }
public func aGroup          (_ actions:[SKAction])                                      -> SKAction     { return SKAction.group(actions) }

public func aWait           (sec:TimeInterval)                                          -> SKAction     { return SKAction.wait(forDuration: sec) }
public func aWait           (sec:TimeInterval,range:TimeInterval)                       -> SKAction     { return SKAction.wait(forDuration: sec,withRange:range) }

//extension SKAction {
//    public func delayed     (by sec:TimeInterval)                                   -> SKAction         { return 0.0 < sec ? aSequence([aWait(sec), self]) : self }
//    public func aDelayed    (by sec:TimeInterval)                                   -> SKAction         { return delayed(by:sec) }
//}

public func aDelayed        (action:SKAction,delay sec:TimeInterval = 0)                -> SKAction     { return 0.0 < sec ? aSequence([aWait(sec:sec), action]) : action }
public func aDelayed        (delay sec:TimeInterval = 0,action:SKAction)                -> SKAction     { return aDelayed(action:action,delay:sec) }

public func aPerform        (selector:Selector,on:AnyObject)                            -> SKAction     { return SKAction.perform(selector,onTarget:on) }

public func aBlock          (delay:TimeInterval,block: @escaping ()->())                -> SKAction     { return aDelayed(action:SKAction.run(block),delay:delay) }
public func aBlock          (block: @escaping ()->())                                   -> SKAction     { return SKAction.run(block) }
public func aBlock          (queue:DispatchQueue, block: @escaping ()->())              -> SKAction     { return SKAction.run(block,queue:queue) }
public func aBlock          (duration sec:TimeInterval,
                             delay:TimeInterval = 0,
                             lerped:Bool = true,
                             block: @escaping (SKNode,CGFloat) -> Void)                 -> SKAction     {
    if lerped {
        return aDelayed(delay:delay,action:SKAction.customAction(withDuration: sec,actionBlock:{ node,time in
            block(node,time/CGFloat(sec))
        }))
    }
    return aDelayed(delay:delay,action:SKAction.customAction(withDuration: sec,actionBlock:block))
}






public func aWithTiming         (function f:@escaping SKActionTimingFunction,on:SKAction)-> SKAction { on.timingFunction=f; return on }
public func aWithTiming         (on:SKAction,_ f:@escaping SKActionTimingFunction)      -> SKAction { on.timingFunction=f; return on }

public func aWithTimingMode     (mode:SKActionTimingMode,on:SKAction)                   -> SKAction { on.timingMode=mode; return on }

public func aWithSpeed          (speed:CGFloat,on:SKAction)                             -> SKAction { on.speed=speed; return on }

public func aReversed           (on:SKAction)                                           -> SKAction { return on.reversed() }

public func aRemoveFromParent   ()                                                      -> SKAction { return SKAction.removeFromParent() }
public func aRemove             ()                                                      -> SKAction { return SKAction.removeFromParent() }






public func aMoveBy             (x:CGFloat,y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)         -> SKAction { return aDelayed(delay:delay,action:SKAction.moveBy(x: x,y:y,duration:sec)) }
public func aMoveBy             (x:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.moveBy(x: x,y:0,duration:sec)) }
public func aMoveBy             (y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.moveBy(x: 0,y:y,duration:sec)) }
public func aMoveBy             (move:CGVector,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return aDelayed(delay:delay,action:SKAction.move(by: move,duration:sec)) }

public func aMoveTo             (move:CGPoint,duration sec:TimeInterval,delay:TimeInterval = 0)                -> SKAction { return aDelayed(delay:delay,action:SKAction.move(to: move,duration:sec)) }
public func aMoveTo             (x:CGFloat,y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)         -> SKAction { return aDelayed(delay:delay,action:SKAction.move(to: CGPoint(x: x,y: y),duration:sec)) }
public func aMoveTo             (x:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.moveTo(x: x,duration:sec)) }
public func aMoveTo             (y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.moveTo(y: y,duration:sec)) }

public func aFollow             (path:CGPath,duration sec:TimeInterval)                 -> SKAction { return SKAction.follow(path,duration:sec) }
public func aFollow             (path:CGPath,speed:CGFloat)                             -> SKAction { return SKAction.follow(path,speed:speed) }
public func aFollow             (path:CGPath,asOffset:Bool,orientToPath:Bool,duration sec:TimeInterval) -> SKAction { return SKAction.follow(path,asOffset:asOffset,orientToPath:orientToPath,duration:sec) }
public func aFollow             (path:CGPath,asOffset:Bool,orientToPath:Bool,speed:CGFloat) -> SKAction { return SKAction.follow(path,asOffset:asOffset,orientToPath:orientToPath,speed:speed) }

public func aRotateBy           (degrees angle:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)       -> SKAction { return aDelayed(delay:delay,action:SKAction.rotate(byAngle: CGAsRadians(degrees:angle),duration:sec)) }
public func aRotateBy           (radians angle:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)       -> SKAction { return aDelayed(delay:delay,action:SKAction.rotate(byAngle: angle,duration:sec)) }

public func aRotateTo           (degrees angle:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0,alongShortestArc:Bool = false) -> SKAction   { return aDelayed(delay:delay,action:SKAction.rotate(toAngle: CGAsRadians(degrees:angle),duration:sec,shortestUnitArc:alongShortestArc)) }
public func aRotateTo           (radians angle:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0,alongShortestArc:Bool = false) -> SKAction   { return aDelayed(delay:delay,action:SKAction.rotate(toAngle: angle,duration:sec,shortestUnitArc:alongShortestArc)) }

public func aSpeedBy            (speed:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return aDelayed(delay:delay,action:SKAction.speed(by: speed,duration:sec)) }
public func aSpeedTo            (speed:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return aDelayed(delay:delay,action:SKAction.speed(to: speed,duration:sec)) }

public func aScaleBy            (scale:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return aDelayed(delay:delay,action:SKAction.scale(by: scale,duration:sec)) }
public func aScaleTo            (scale:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return aDelayed(delay:delay,action:SKAction.scale(to: scale,duration:sec)) }

public func aScaleBy            (x:CGFloat,y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)         -> SKAction { return aDelayed(delay:delay,action:SKAction.scaleX(by: x,y:y,duration:sec)) }
public func aScaleTo            (x:CGFloat,y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)         -> SKAction { return aDelayed(delay:delay,action:SKAction.scaleX(to: x,y:y,duration:sec)) }

public func aScaleTo            (x:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.scaleX(to: x,duration:sec)) }
public func aScaleTo            (y:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)                   -> SKAction { return aDelayed(delay:delay,action:SKAction.scaleY(to: y,duration:sec)) }

public func aHide               ()                                                      -> SKAction { return SKAction.hide() }
public func aShow               ()                                                      -> SKAction { return SKAction.unhide() }
public func aShow               (flag:Bool)                                             -> SKAction { return flag ? SKAction.unhide() : SKAction.hide() }

public func aFadeIn             (duration sec:TimeInterval,delay:TimeInterval = 0)                             -> SKAction { return SKAction.fadeIn(withDuration: sec) }
public func aFadeOut            (duration sec:TimeInterval,delay:TimeInterval = 0)                             -> SKAction { return SKAction.fadeOut(withDuration: sec) }

public func aFadeBy             (alpha:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return SKAction.fadeAlpha(by: alpha,duration:sec) }
public func aFadeTo             (alpha:CGFloat,duration sec:TimeInterval,delay:TimeInterval = 0)               -> SKAction { return SKAction.fadeAlpha(to: alpha,duration:sec) }




public func aSpriteColorTo      (color:UIColor,duration sec:TimeInterval)               -> SKAction { return SKAction.colorize(with: color,colorBlendFactor:color.RGBAalpha,duration:sec) }
public func aSpriteColorTo      (color:UIColor,blendFactor:CGFloat,duration sec:TimeInterval) -> SKAction { return SKAction.colorize(with: color,colorBlendFactor:color.RGBAalpha,duration:sec) }
public func aSpriteColor        (blendFactorTo blendFactor:CGFloat,duration sec:TimeInterval) -> SKAction { return SKAction.colorize(withColorBlendFactor: blendFactor,duration:sec) }

//public func aAnimate            (textures:[SKTexture],timePerFrame:NSTimeInterval) -> SKAction { return SKAction.animateWithNormalTextures(textures,timePerFrame:timePerFrame) }
public func aSpriteAnimate      (textures:[SKTexture],timePerFrame:TimeInterval,resize:Bool=false,restore:Bool=true) -> SKAction { return SKAction.animate(with: textures,timePerFrame:timePerFrame,resize:resize,restore:restore) }
public func aSpriteAnimate      (normalTextures textures:[SKTexture],timePerFrame:TimeInterval,resize:Bool=false,restore:Bool=true) -> SKAction { return SKAction.animate(withNormalTextures: textures,timePerFrame:timePerFrame,resize:resize,restore:restore) }
public func aSpriteTexture      (texture:SKTexture,resize:Bool=false)                   -> SKAction { return SKAction.setTexture(texture,resize:resize) }
public func aSpriteTexture      (normal texture:SKTexture,resize:Bool=false)            -> SKAction { return SKAction.setNormalTexture(texture,resize:resize) }

public func aSpriteResizeBy     (width:CGFloat=0,height:CGFloat=0,duration sec:TimeInterval) -> SKAction { return SKAction.resize(byWidth: width,height:height,duration:sec) }
public func aSpriteResizeTo     (width:CGFloat,height:CGFloat,duration sec:TimeInterval) -> SKAction { return SKAction.resize(toWidth: width,height:height,duration:sec) }
public func aSpriteResizeTo     (width:CGFloat,duration sec:TimeInterval)               -> SKAction { return SKAction.resize(toWidth: width,duration:sec) }
public func aSpriteResizeTo     (height:CGFloat,duration sec:TimeInterval)              -> SKAction { return SKAction.resize(toHeight: height,duration:sec) }




public func aAudioPlay          (file:String,waitForCompletion wait:Bool)               -> SKAction { return SKAction.playSoundFileNamed(file,waitForCompletion:wait) }
public func aAudioPlay          ()                                                      -> SKAction { return SKAction.play() }
public func aAudioPause         ()                                                      -> SKAction { return SKAction.pause() }
public func aAudioStop          ()                                                      -> SKAction { return SKAction.stop() }
public func aAudioRate          (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changePlaybackRate(to: to,duration:duration) }
public func aAudioRate          (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changePlaybackRate(by: by,duration:duration) }
public func aAudioVolume        (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeVolume(to: to,duration:duration) }
public func aAudioVolume        (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeVolume(by: by,duration:duration) }
public func aAudioObstruction   (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeObstruction(to: to,duration:duration) }
public func aAudioObstruction   (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeObstruction(by: by,duration:duration) }
public func aAudioOcclusion     (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeOcclusion(to: to,duration:duration) }
public func aAudioOcclusion     (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeOcclusion(by: by,duration:duration) }
public func aAudioReverb        (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeReverb(to: to,duration:duration) }
public func aAudioReverb        (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.changeReverb(by: by,duration:duration) }
public func aAudioPan           (to:Float,duration:TimeInterval)                        -> SKAction { return SKAction.stereoPan(to: to,duration:duration) }
public func aAudioPan           (by:Float,duration:TimeInterval)                        -> SKAction { return SKAction.stereoPan(by: by,duration:duration) }





public func aPhysicsApply       (force v:CGVector,duration:TimeInterval)                -> SKAction { return SKAction.applyForce(v,duration:duration) }
public func aPhysicsApply       (force v:CGVector,point:CGPoint,duration:TimeInterval)  -> SKAction { return SKAction.applyForce(v,at:point,duration:duration) }
public func aPhysicsApply       (torque v:CGFloat,duration:TimeInterval)                -> SKAction { return SKAction.applyTorque(v,duration:duration) }
public func aPhysicsApply       (impulse v:CGVector,duration:TimeInterval)              -> SKAction { return SKAction.applyImpulse(v,duration:duration) }
public func aPhysicsApply       (angular impulse:CGFloat,duration:TimeInterval)         -> SKAction { return SKAction.applyAngularImpulse(impulse,duration:duration) }
public func aPhysicsApply       (impulse v:CGVector,point:CGPoint,duration:TimeInterval)-> SKAction { return SKAction.applyImpulse(v,at:point,duration:duration) }

public func aPhysicsCharge      (to v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.changeCharge(to: v,duration:duration) }
public func aPhysicsCharge      (by v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.changeCharge(by: v,duration:duration) }

public func aPhysicsMass        (to v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.changeMass(to: v,duration:duration) }
public func aPhysicsMass        (by v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.changeMass(by: v,duration:duration) }

public func aPhysicsStrength    (to v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.strength(to: v,duration:duration) }
public func aPhysicsStrength    (by v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.strength(by: v,duration:duration) }

public func aPhysicsFalloff     (to v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.falloff(to: v,duration:duration) }
public func aPhysicsFalloff     (by v:Float,point:CGPoint,duration:TimeInterval)        -> SKAction { return SKAction.falloff(by: v,duration:duration) }






