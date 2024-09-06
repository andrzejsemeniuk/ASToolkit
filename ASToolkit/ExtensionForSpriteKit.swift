//
//  ExtensionForSpriteKit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/1/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
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



extension SKNode
{
    @objc var width   :CGFloat                                                                    { return calculateAccumulatedFrame().width } // frame.size.width }
    @objc var height  :CGFloat                                                                    { return calculateAccumulatedFrame().height } //frame.size.height }
    
    public func hFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.width * ratio }
    public func vFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.height * ratio }
    
    public func hFrom                  (ratio01:CGFloat)                                 -> CGFloat  { return self.width * ratio01 }
    public func vFrom                  (ratio01:CGFloat)                                 -> CGFloat  { return self.height * ratio01 }
    
    public func hFrom                  (ratio11:CGFloat)                                 -> CGFloat  { return self.width * (ratio11+1)/2 }
    public func vFrom                  (ratio11:CGFloat)                                 -> CGFloat  { return self.height * (ratio11+1)/2 }
    
    public func hFrom                  (ratio55:CGFloat)                                 -> CGFloat  { return self.width * (ratio55+0.5) }
    public func vFrom                  (ratio55:CGFloat)                                 -> CGFloat  { return self.height * (ratio55+0.5) }
    

    public func xFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.position.x + hFrom(ratio:ratio) }
    public func yFrom                  (ratio:CGFloat)                                 -> CGFloat  { return self.position.y + vFrom(ratio:ratio) }
    
    public func ratioFromH             (h:CGFloat)                                     -> CGFloat  { return h / (width != 0 ? width : 1.0) }
    public func ratioFromV             (v:CGFloat)                                     -> CGFloat  { return v / (height != 0 ? height : 1.0) }
    
    public func ratioFromX             (x:CGFloat)                                     -> CGFloat  { return (x - position.x) / (width != 0 ? width : 1.0) }
    public func ratioFromY             (y:CGFloat)                                     -> CGFloat  { return (y - position.y) / (height != 0 ? height : 1.0) }
    
    public func pointFromRatio         (ratio:CGPoint)                                 -> CGPoint  { return CGPoint(x: hFrom(ratio:ratio.x), y: vFrom(ratio:ratio.y)) }
    public func pointFromRatio         (h:CGFloat, v:CGFloat)                          -> CGPoint  { return CGPoint(x: hFrom(ratio:h),y: vFrom(ratio:v)) }
    
    @objc public func positionFromRatio      (x:CGFloat, y:CGFloat)                          -> CGPoint  { return position + pointFromRatio(h:x,v:y) }
    
    
    public var isShown : Bool {
        get {
            !isHidden
        }
        set(newValue) {
            isHidden = !newValue
        }
    }
    
    public func place_01(x: CGFloat? = nil, y: CGFloat? = nil) {
        guard let parent = parent else {
            return
        }
        if let x = x {
            self.position.x = parent.hFrom(ratio01: x - 0.5)
        }
        if let y = y {
            self.position.y = parent.vFrom(ratio01: y - 0.5)
        }
    }
    
    public func place_11(x: CGFloat? = nil, y: CGFloat? = nil) {
        guard let parent = parent else {
            return
        }
        if let x = x {
            self.position.x = parent.hFrom(ratio11: x) - parent.width/2
        }
        if let y = y {
            self.position.y = parent.vFrom(ratio11: y) - parent.height/2
        }
    }
    
    public func place_55(x: CGFloat? = nil, y: CGFloat? = nil) {
        guard let parent = parent else {
            return
        }
        if let x = x {
            self.position.x = parent.hFrom(ratio55: x) - parent.width/2
        }
        if let y = y {
            self.position.y = parent.vFrom(ratio55: y) - parent.height/2
        }
    }
    
    public func x(forAlignmentX x: CGFloat) -> CGFloat {
        parent!.hFrom(ratio11: x) - parent!.width/2.0
    }
    
    public func y(forAlignmentY y: CGFloat) -> CGFloat {
        parent!.vFrom(ratio11: y) - parent!.height/2.0
    }
    



    public var r: CGFloat {
        get {
            self.zRotation
        }
        set {
            self.zRotation = newValue
        }
    }


    public var s: CGFloat {
        get {
            (xScale + yScale) / 2
        }
        set {
            xScale = newValue
            yScale = newValue
        }
    }

    public var scale: CGFloat {
        get {
            (xScale + yScale) / 2
        }
        set {
            xScale = newValue
            yScale = newValue
        }
    }

    public var sx: CGFloat {
        get {
            xScale
        }
        set {
            xScale = newValue
        }
    }

    public var sy: CGFloat {
        get {
            yScale
        }
        set {
            yScale = newValue
        }
    }


    public func scaled(point: CGPoint) -> CGPoint {
        CGPoint(point.x * xScale, point.y * yScale)
    }
    
    public func unscaled(point: CGPoint) -> CGPoint {
        CGPoint(point.x / xScale, point.y / yScale)
    }
    

    public var z: CGFloat {
        get {
            zPosition
        }
        set {
            zPosition = newValue
        }
    }
    
    public func addChild               (sprite:SKSpriteNode)                    -> SKSpriteNode
    {
        addChild(sprite)
        return sprite
    }
    
//    public func addChildSprite         (imageNamed:String, suffix:String = ".png")                  -> SKSpriteNode
//    {
//        let name = SKNode.resolveResourceImageName(name:imageNamed,suffix:suffix)
//        let node = SKSpriteNode(imageNamed:name)
//        addChild(node)
//        node.anchorPoint = CGPoint(x: 0.5,y: 0.5)
//        return node
//    }
    
    public func addChildSpriteEmpty    ()                                              -> SKSpriteNode
    {
        let node = SKSpriteNode()
        addChild(node)
        node.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        return node
    }
    
    
    
    
    
    
    
#if os(iOS)
public func positionFromScreenRatio  (to:CGXY)
{
    if let parent
    {
        let position = parent.position + CGScreen.pointFrom(ratio:to)
        //            print("positionFromScreen(\(to))=\(position),screen=\(CGScreen.bounds)")
        self.position = (self.parent?.convert(position,from:parent))!
    }
}

public func positionFromScreenRatio          (x:CGFloat,mappingVToY:CGFloat)
{
    positionFromScreenRatio(to:CGXY(x,mappingVToY))
}
#endif

    
    
    
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
    
    public func onNodePositionToParentCenter ()                                           -> SKNode
    {
        return onNodePositionToParentRatio(to:(x:0.5,y:0.5))
    }
    
    
    
    
    public func named(_ title: String) -> Self {
        self.name = title
        return self
    }
    
    public func positioned(at: CGPoint) -> Self {
        self.position = at
        return self
    }

    public func positioned(x: CGFloat? = nil, y: CGFloat? = nil) -> Self {
        self.position.x ?= x
        self.position.y ?= y
        return self
    }

    
    
    public func userDataGet(_ key: String) -> Any? {
        userData?[key]
    }
    
    public func userDataSet(_ key: String, _ new: Any?) {
        if userData == nil {
            if let new = new {
                userData = [key : new]
            }
        } else {
            userData![key] = new
        }
    }
    
    public func userDataClear(_ key: String) {
        userData?.removeObject(forKey: key)
    }


    @discardableResult
    public func offset(x: CGFloat? = nil, y: CGFloat? = nil) -> Self {
        self.position.x += x ?? 0
        self.position.y += y ?? 0
        return self
    }
    
    @discardableResult
    public func offset(size: CGSize) -> Self {
        self.position.x += size.width
        self.position.y += size.height
        return self
    }


    
    public func scaleNormalizedFromParent() {
        guard let parent = parent else { return }
        xScale /= parent.xScale
        yScale /= parent.yScale
    }
    
    public var descendants : [SKNode] {
        var r = children
        r.forEach {
            r += $0.descendants
        }
        return r
    }

    public func descendants(named: String) -> [SKNode] {
        descendants.filter { $0.name?.matches(regex: named) ?? false }
    }
    
    @discardableResult
    public func removeDescendants(named: String) -> [SKNode] {
//        let c = descendants(named: named)
//        c.forEach { $0.removeFromParent() }
//        return c
        var r = children.filter({ $0.name == named })
        r.forEach { $0.removeFromParent() }
        children.forEach {
            r += $0.removeDescendants(named: named)
        }
        return r
    }

    public func children(named: String) -> [SKNode] {
        children.filter { $0.name?.matches(regex: named) ?? false }
    }
    
    @discardableResult
    public func removeChildren(named: String) -> [SKNode] {
        let c = children(named: named)
        c.forEach { $0.removeFromParent() }
        return c
    }
    
    public func position(atGlobalLocation p: CGPoint) {
        guard let SCENE = scene else {
            return
        }
        position ?= parent?.convert(p, from: SCENE)
    }
    
    public func reparent(to: SKNode) {
        move(toParent: to)
    }
    
    public func reparent(to: SKNode, preservingGlobalPositioning: Bool) {
        if preservingGlobalPositioning, let SCENE = scene {
            let POSITION1 = self.convert(.zero, to: SCENE)
            move(toParent: to)
            position ?= parent?.convert(POSITION1, from: SCENE)
        } else {
            move(toParent: to)
        }
    }
    
    public func moveAllChildren(toParent: SKNode, withHiding: Bool) {
        children.forEach {
            $0.move(toParent: toParent)
        }
        if withHiding {
            self.isHidden = true
            toParent.isHidden = false
        }
    }
    
    public func swapAllChildren(toParent: SKNode, withHiding: Bool) {
        let children0 = children
        let children1 = toParent.children
        
        removeAllChildren()
        toParent.removeAllChildren()
        
        children0.forEach {
            $0.move(toParent: toParent)
        }
        children1.forEach {
            $0.move(toParent: self)
        }
        if withHiding {
            self.isHidden = true
            toParent.isHidden = false
        }
    }
    
    
    @discardableResult
    public func prependChildNode(named: String? = nil) -> SKNode {
        let n = SKNode()
        insertChild(n, at: 0)
        n.name = named
        return n
    }
    
    @discardableResult
    public func addChildNode(named: String? = nil) -> SKNode {
        let n = SKNode()
        addChild(n)
        n.name = named
        return n
    }
    
    @discardableResult
    public func addChildNode<NODE: SKNode>(_ n: NODE, named: String? = nil) -> NODE {
        addChild(n)
        n.name ?= named
        return n
    }
    
    @discardableResult
    public func prependChildNode<NODE: SKNode>(_ n: NODE, named: String? = nil) -> NODE {
        insertChild(n, at: 0)
        n.name ?= named
        return n
    }
    
    public func addChild(_ n: SKNode, named: String?) {
        addChild(n)
        n.name ?= named
    }
    
    public func prependChild(_ n: SKNode, named: String? = nil) {
        insertChild(n, at: 0)
        n.name ?= named
    }

}



public extension SKNode {
    
    func positionChildrenVertically(spacing: CGFloat, offset: CGFloat = 0) {
        let children = children
        
        guard children.isNotEmpty else { return }
        
        let HEIGHTS = children.map { $0.calculateAccumulatedFrame().height }
        
        var HEIGHT : CGFloat = HEIGHTS.reduce(0.0, { $0 + $1 }) + spacing * (children.count-1).asCGFloat
        
        var y : CGFloat = -HEIGHT/2.0 + offset
        
        for (i,child) in children.enumerated() {
            y += HEIGHTS[i]/2
            child.position.y = y
            y += HEIGHTS[i]/2 + spacing
        }
    }
    
}




public extension SKSpriteNode {
    
    func point01(ax: CGFloat, ay: CGFloat) -> CGPoint {
        CGPoint(point01(ax: ax), point01(ay: ay))
    }
    func point01(ax: CGFloat01) -> CGFloat {
        size.width * (ax - 0.5) / xScale
    }
    func point01(ay: CGFloat01) -> CGFloat {
        size.height * (ay - 0.5) / yScale
    }
    func point11(ax: CGFloat11, ay: CGFloat11) -> CGPoint {
        CGPoint(point11(ax: ax), point11(ay: ay))
    }
    func point11(ax: CGFloat11) -> CGFloat {
        size.width/2 * (ax) / xScale
    }
    func point11(ay: CGFloat11) -> CGFloat {
        size.height/2 * (ay) / yScale
    }

    @discardableResult
    func ax(_ v: CGFloat?) -> Self {
        guard let p = parent as? SKSpriteNode else { return self }
        guard let v = v else { return self }
        position.x = p.point11(ax: v)
        return self
    }
    
    @discardableResult
    func ay(_ v: CGFloat?) -> Self {
        guard let p = parent as? SKSpriteNode else { return self }
        guard let v = v else { return self }
        position.y = p.point11(ay: v)
        return self
    }
    @discardableResult
    func sx(_ v: CGFloat?) -> Self {
        guard let v = v else { return self }
        xScale = v
        return self
    }
    @discardableResult
    func sy(_ v: CGFloat?) -> Self {
        guard let v = v else { return self }
        yScale = v
        return self
    }
    @discardableResult
    func r(_ v: CGFloat?) -> Self {
        guard let v = v else { return self }
        zRotation = v
        return self
    }
    @discardableResult
    func h(_ v: Bool?) -> Self {
        guard let v = v else { return self }
        isHidden = v
        return self
    }

}




public extension SKNode {
    
    struct Snapshot {
        public init(position: CGPoint = .zero, xScale: CGFloat = 1, yScale: CGFloat = 1, zRotation: CGFloat = 0, zPosition: CGFloat = 0) {
            self.position = position
            self.xScale = xScale
            self.yScale = yScale
            self.zRotation = zRotation
            self.zPosition = zPosition
        }
        
        public var position     : CGPoint = .zero
        public var xScale       : CGFloat = 1
        public var yScale       : CGFloat = 1
        public var zRotation    : CGFloat = 0
        public var zPosition    : CGFloat = 0
    }
    
    var snapshot : Snapshot {
        .init(position  : self.position,
              xScale    : self.xScale,
              yScale    : self.yScale,
              zRotation : self.zRotation,
              zPosition : self.zPosition)
    }
    
    func set(snapshot: Snapshot) {
        self.position   = snapshot.position
        self.xScale     = snapshot.xScale
        self.yScale     = snapshot.yScale
        self.zRotation  = snapshot.zRotation
        self.zPosition  = snapshot.zPosition
    }
    
}




extension SKScene
{
    override var  width   : CGFloat                                                        { return self.size.width }
    override var  height  : CGFloat                                                        { return self.size.height }
    
    // NOTE: NEED TO OVERRIDE position TO FIX BUG IN SpriteKit
    override open var  position:CGPoint {
        get {
            return self.frame.origin
        }
        set {
        }
    }
}




public extension SKNode {
    
    func adjustScaleToFit(size: CGSize) {
        guard frame.width > 0, frame.height > 0, size.width > 0, size.height > 0 else { return }
        
        let sx = size.width / frame.width
        let sy = size.height / frame.height
        
        let s = min(sx,sy)
        
        self.scale = s
    }
}


public extension SKLabelNode {

    // code snippet from: https://stackoverflow.com/questions/32144666/resize-a-sklabelnode-font-size-to-fit
    func adjustFontSizeToFit(rectangle r: CGRect, height factor: CGFloat = 0.45) {
        guard frame.width > 0, frame.height > 0 else { return }
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(r.width / self.frame.width, r.height / self.frame.height)
        // Change the fontSize.
        self.fontSize *= scalingFactor
        // Optionally move the SKLabelNode to the center of the rectangle.
        self.position = CGPoint(x: r.midX, y: r.midY - self.frame.height * factor)
    }

    func adjustFontSizeToFit(w: CGFloat, h: CGFloat, height factor: CGFloat = 0.45) {
        adjustFontSizeToFit(rectangle: CGRect(size: CGSize(width: w, height: h)), height: factor)
    }
    
    func with(text: String?) -> Self {
        self.text = text
        return self
    }
    
    func with(font: String) -> Self {
        self.fontName = font
        return self
    }
    
    func with(size: CGFloat) -> Self {
        self.fontSize = size
        return self
    }

    func with(fg: SKColor) -> Self {
        self.fontColor = fg
        return self
    }

    func with(bg: SKColor, padding: (h: CGFloat, v: CGFloat) = (0,0)) -> SKShapeNode {
        self.removeAllChildren()
        let frame = self.calculateAccumulatedFrame().insetBy(dx: -padding.h, dy: -padding.v)
        let shape = SKShapeNode.init(rectangle: .init(center: .zero, size: frame.size), fillColor: bg, strokeColor: .clear, lineWidth: 0)
        shape.addChild(self)
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .center
        return shape
    }

    func with(alignment: SKLabelHorizontalAlignmentMode) -> Self {
        self.horizontalAlignmentMode = alignment
        return self
    }

}




public extension SKLightNode
{
    
}





public extension SKShapeNode
{
    convenience init(lines              : [CGPoint],
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit         : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) {
        let path = CGMutablePath()
        path.move(to:lines[0])
        for i in stride(from:1,to:lines.count,by:1) {
            path.addLine(to:lines[i])
        }
        self.init(path:path)
        self.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
    }

    convenience init(polygon            : [CGPoint],
                     close              : Bool,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit         : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) {
        let path = CGMutablePath()
        path.move(to:polygon[0])
        for i in stride(from:1,to:polygon.count,by:1) {
            path.addLine(to:polygon[i])
        }
        if close {
            path.closeSubpath()
        }
        self.init(path:path)
        self.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
    }

    convenience init(rectangle          : CGRect,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) {
        self.init(rect:rectangle)
        self.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
    }

    convenience init(circleOfRadius     : CGFloat,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) {
        self.init(circleOfRadius        : circleOfRadius)
        self.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
    }

    convenience init(line: (from: CGPoint, to: CGPoint),
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) {
        self.init(lines:[line.from,line.to])
        self.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
    }


    static func line(x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode(lines:[.init(x0, y0),.init(x1, y1)])
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func line(x0: CGFloat, x1: CGFloat, y0: CGFloat, y1: CGFloat,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode(lines:[.init(x0, y0),.init(x1, y1)])
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func line(from: CGPoint, to: CGPoint,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode(lines:[from,to])
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func lineH(y: CGFloat, x0: CGFloat, x1: CGFloat,
                      position           : CGPoint? = nil,
                      fillColor          : UIColor? = nil,
                      strokeColor        : UIColor? = nil,
                      glowWidth          : CGFloat? = nil,
                      lineWidth          : CGFloat? = nil,
                      lineCap            : CGLineCap? = nil,
                      lineJoin           : CGLineJoin? = nil,
                      miterLimit        : CGFloat? = nil,
                      lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode.line(from: .init(x0,y), to: .init(x1,y))
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }
    static func lineV(x: CGFloat, y0: CGFloat, y1: CGFloat,
                      position           : CGPoint? = nil,
                      fillColor          : UIColor? = nil,
                      strokeColor        : UIColor? = nil,
                      glowWidth          : CGFloat? = nil,
                      lineWidth          : CGFloat? = nil,
                      lineCap            : CGLineCap? = nil,
                      lineJoin           : CGLineJoin? = nil,
                      miterLimit        : CGFloat? = nil,
                      lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode.line(from: .init(x,y0), to: .init(x,y1))
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func circle(withRadius       : CGFloat,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode(circleOfRadius: withRadius)
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func path(_ path             : CGPath,
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode {
        let r = SKShapeNode.init(path: path)
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    static func polygon(_ points             : [CGPoint],
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
                     lineDash           : [CGFloat]? = nil) -> SKShapeNode? {
        guard points.count > 2 else { return nil }
        let path = CGMutablePath.init()
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        if points.last != points.first {
//            path.addLine(to: points[0])
            path.closeSubpath()
        }
        let r = SKShapeNode.init(path: path)
        r.configured(position        : position,
                        fillColor       : fillColor,
                        strokeColor     : strokeColor,
                        glowWidth       : glowWidth,
                        lineWidth       : lineWidth,
                        lineCap         : lineCap,
                        lineJoin        : lineJoin,
                        miterLimit      : miterLimit,
                        lineDash        : lineDash)
        return r
    }

    

}

extension SKShapeNode {
    
    @discardableResult
    public func configured (position        : CGPoint? = nil,
                            fillColor         : UIColor? = nil,
                            strokeColor       : UIColor? = nil,
                            glowWidth         : CGFloat? = nil,
                            lineWidth         : CGFloat? = nil,
                            lineCap           : CGLineCap? = nil,
                            lineJoin          : CGLineJoin? = nil,
                            miterLimit        : CGFloat? = nil,
                            lineDash          : [CGFloat]? = nil) -> Self {
        
        self.position       ?= position
        self.fillColor      ?= fillColor
        self.strokeColor    ?= strokeColor //?? .clear
        self.glowWidth      ?= glowWidth
        self.lineWidth      ?= lineWidth
        self.lineCap        ?= lineCap
        self.lineJoin       ?= lineJoin
        self.miterLimit     ?= miterLimit
        
        if let lineDash = lineDash {
            addDashes(lengths: lineDash)
        }
        return self
    }

    @discardableResult
    public func configured (lineStyle          : CGLineStyle) -> Self {
        self.lineWidth      = lineStyle.lineWidth
        self.lineCap        = lineStyle.lineCap
        self.lineJoin       = lineStyle.lineJoin
        self.miterLimit     = lineStyle.miterLimit
        
        addDashes(lengths: lineStyle.pattern)
        
        return self
    }
    
    @discardableResult
    public func with(fillColor        : UIColor? = nil,
                   strokeColor      : UIColor? = nil,
                   glowWidth        : CGFloat? = nil,
                   lineWidth        : CGFloat? = nil,
                   lineCap          : CGLineCap? = nil,
                   lineJoin         : CGLineJoin? = nil,
                   miterLimit        : CGFloat? = nil,
                   lineDash         : [CGFloat]? = nil) -> Self {
    
        self.fillColor      = fillColor ?? self.fillColor
        self.strokeColor    = strokeColor ?? self.strokeColor
        self.glowWidth      = glowWidth ?? self.glowWidth
        self.lineWidth      = lineWidth ?? self.lineWidth
        self.lineCap        = lineCap ?? self.lineCap
        self.lineJoin       = lineJoin ?? self.lineJoin
        self.miterLimit     = miterLimit ?? self.miterLimit
        if let lengths = lineDash {
            addDashes(lengths: lengths)
        }
        return self
    }
    
    public func addDashes(phase: CGFloat = 0, lengths: [CGFloat]) {
        path = path?.copy(dashingWithPhase: phase, lengths: lengths)
    }
    
    @discardableResult
    public func with(dash lengths: [CGFloat], phase: CGFloat = 0) -> Self {
        path = path?.copy(dashingWithPhase: phase, lengths: lengths)
        return self
    }


}

public extension SKShapeNode {
    
    func gradient(size          : CGSize,
                  colorFill     : SKColor = .white,
                  color0        : SKColor,
                  color1        : SKColor,
                  point0        : CGPoint,
                  point1        : CGPoint) {
        
        self.fillColor       = colorFill
//        let rgba0 = color0.RGBA
//        let rgba1 = color1.RGBA
        self.fillTexture     = SKTexture.init(size   : size,
                                              color0 : color0, //CIColor.init(red: rgba0.red, green: rgba0.green, blue: rgba0.blue, alpha: rgba0.alpha),
                                              color1 : color1, //CIColor.init(red: rgba1.red, green: rgba1.green, blue: rgba1.blue, alpha: rgba1.alpha),
                                              start  : point0,
                                              stop   : point1)
        
    }
    
}

public extension SKTexture {

    convenience init(size       : CGSize,
                     color0     : SKColor,
                     color1     : SKColor,
                     start      : CGPoint,
                     stop       : CGPoint)
    {
        guard size.width > 0, size.height > 0 else {
            self.init()
            return
        }
        
        let coreImageContext    = CIContext(options: nil)
        let gradientFilter      = CIFilter(name: "CILinearGradient")!
        let startVector         : CIVector = .init(x: start.x * size.width, y: start.y * size.height)
        let endVector           : CIVector = .init(x: stop.x * size.width, y: stop.y * size.height)
        
        gradientFilter.setDefaults()
        gradientFilter.setValue(startVector, forKey: "inputPoint0")
        gradientFilter.setValue(endVector, forKey: "inputPoint1")
        gradientFilter.setValue(color0.asCIColor, forKey: "inputColor0")
        gradientFilter.setValue(color1.asCIColor, forKey: "inputColor1")
        
        let coreImage = coreImageContext.createCGImage(gradientFilter.outputImage!, from: .init(size)) //CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        self.init(cgImage: coreImage!)
    }

    convenience init(size       : CGSize,
                     color0     : SKColor,
                     color1     : SKColor,
                     radius0    : CGFloat, // 0
                     radius1    : CGFloat) // 1
    {
        let coreImageContext    = CIContext(options: nil)
        let gradientFilter      = CIFilter(name: "CIRadialGradient")!
        let inputCenter         = CIVector.init(x: size.width/2, y: size.height/2)
        let inputRadius0        = radius0 * size.minSide/2
        let inputRadius1        = radius1 * size.minSide/2
        
        gradientFilter.setDefaults()
        gradientFilter.setValue(inputCenter, forKey: "inputCenter")
        gradientFilter.setValue(inputRadius0, forKey: "inputRadius0")
        gradientFilter.setValue(inputRadius1, forKey: "inputRadius1")
        gradientFilter.setValue(color0.asCIColor, forKey: "inputColor0")
        gradientFilter.setValue(color1.asCIColor, forKey: "inputColor1")
        
        let coreImage = coreImageContext.createCGImage(gradientFilter.outputImage!, from: .init(size)) //CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        self.init(cgImage: coreImage!)
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







public extension SKNode
{
    func run(_ action: SKAction, delay:TimeInterval) {
        self.run(aDelayed(delay:delay, action: action))
    }
    
    func run(_ action: SKAction, delay:TimeInterval, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: action), completion: block)
    }
    
    func run(_ action: SKAction, withKey key: String, delay:TimeInterval) {
        self.run(aDelayed(delay:delay, action: action), withKey: key)
    }
    

    func run(sequence: [SKAction], delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)))
    }
    
    func run(sequence: [SKAction], delay:TimeInterval = 0, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)), completion: block)
    }
    
    func run(sequence: [SKAction], withKey key: String, delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aSequence(sequence)), withKey: key)
    }
    

    func run(group: [SKAction], delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aGroup(group)))
    }
    
    func run(group: [SKAction], delay:TimeInterval = 0, completion block: @escaping () -> Swift.Void) {
        self.run(aDelayed(delay:delay, action: aGroup(group)), completion: block)
    }
    
    func run(group: [SKAction], withKey key: String, delay:TimeInterval = 0) {
        self.run(aDelayed(delay:delay, action: aGroup(group)), withKey: key)
    }
    
    func runAndRemoveFromParent(_ action: SKAction, withKey key: String? = nil, delay:TimeInterval = 0) {
        if let key {
            self.run(aDelayed(delay:delay, action: aSequence([action,aRemoveFromParent()])), withKey: key)
        } else {
            self.run(aDelayed(delay:delay, action: aSequence([action,aRemoveFromParent()])))
        }
    }
    
    
    convenience init(named: String) {
        self.init()
        self.name = named
    }
    
    func pointFromCenter(rx: CGFloat, ry: CGFloat) -> CGPoint {
        return CGPoint.init(x: rx * self.frame.size.width + self.frame.size.width/2,
                            y: ry * self.frame.size.height + self.frame.size.height/2)
    }
    
    func pointFromFrameOrigin(rx: CGFloat, ry: CGFloat) -> CGPoint {
        return self.frame.origin + CGPoint.init(x: rx * self.frame.size.width, y: ry * self.frame.size.height)
    }


    @discardableResult
    func debugAddX(lineWidth:CGFloat = 1, color:UIColor = .white) -> SKNode
    {
        if true
        {
            let path = CGMutablePath()
            
            path.move           (to: CGPoint.zero)
            path.addLine        (to: frame.size.asCGPoint)
            
            let n = SKShapeNode(path:path)
            n.name = "debugAddX"
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
//            n.position          = self.frame.bl
        }
        if true
        {
            let path = CGMutablePath()

            path.move           (to: CGPoint(x:0,y:self.frame.size.height))
            path.addLine        (to: CGPoint(x:self.frame.size.width,y:0))
            
            let n = SKShapeNode(path:path)
            n.name = "debugAddX"
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
//            n.position          = self.frame.tl
        }
        
        return self
    }
    
    @discardableResult
    func debugAddCross(lineWidth:CGFloat = 1, color:UIColor = .white) -> SKNode
    {
        if true
        {
            let path = CGMutablePath()

            path.move           (to: CGPoint(x:self.frame.size.width/2,y:0))
            path.addLine        (to: CGPoint(x:self.frame.size.width/2,y:self.frame.size.height))
            
            let n = SKShapeNode(path:path)
            n.name = "debugAddCross"
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
            n.name = "debugAddCross"
            //            let n = SKShapeNode(rectOfSize:size,cornerRadius:32)
            
            n.strokeColor       = color
            n.lineWidth         = lineWidth
            
            self.addChild(n)
            
            n.position          = self.frame.bl
        }
        
        return self
    }
    
    @discardableResult
    func debugAddBorder(lineWidth:CGFloat = 1, corner:CGFloat = 0, color:UIColor = .white) -> SKNode
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
    
    
    func children(at: CGPoint, in radius: CGFloat) -> [SKNode] {
        children.filter {
            let r = $0.frame.size.maxSide/2
            let d = $0.position - at
            let l = d.length
//            print("examining: \($0.name ?? "?"), L=\(l), r=\(r), L-r=\(l-r), radius=\(radius)")
//            return $0.position.length - $0.radius < radius
            return l-r < radius
        }
    }

}






public extension SKWarpGeometryGrid {
    
    typealias WarpGeometryMatrix = [[(Float,Float)]]

    
    var sourcePositions : [SIMD2<Float>] {
        vertexCount.map { i in
            self.sourcePosition(at: i)
        }
    }
    
    var destinationPositions : [SIMD2<Float>] {
        vertexCount.map { i in
            self.destPosition(at: i)
        }
    }
    
    var sourcePoints : [[CGPoint]] {
        var r : [[CGPoint]] = []
        
        return r
    }
    
    static func array(columns: Int, rows: Int) -> [SIMD2<Float>] {
        let c = 1 + columns
        let r = 1 + rows
        var m = [SIMD2<Float>].init(repeating: SIMD2<Float>.init(), count: c * r)
        let dc = Float(1)/Float(c)
//        var x : [Float] = (0..<c).map { i in i.asFloat * dc }
        let dr = Float(1)/Float(r)
//        var y : [Float] = (0..<r).map { i in i.asFloat * dr }
        for ic in 0..<c {
            for ir in 0..<r {
                let index = ic * r + ir
                m[index].x = ic.asFloat * dc
                m[index].y = ir.asFloat * dr
            }
        }
        print("array: w=\(m)")
        return m
    }
    
    static func array(_ w: WarpGeometryMatrix) -> [SIMD2<Float>] {
//        let columns = w.count
//        let rows = w[0].count
//        let c = 1 + columns
//        let r = 1 + rows
//        var m = [SIMD2<Float>].init(repeating: SIMD2<Float>.init(), count: c * r)
//        for ic in 0..<c {
//            for ir in 0..<r {
//                let index = ic * r + ir
//                m[index].x = w[ic][ir].x.asFloat
//                m[index].y = w[ic][ir].y.asFloat
//            }
//        }
//        return m
        
        let r : [SIMD2<Float>] = w.flatMap {
            $0.compactMap { e in
                .init(x: e.0, y: e.1)
            }
        }
        print("array: w=\(w)")
        print("array, r=\(r)")
        return r
    }
    
    static func from(_ w: WarpGeometryMatrix?) -> SKWarpGeometryGrid? {
        guard let w = w else { return nil }
        guard w.count > 0 else { return nil }
        
        let columns     = w[0].count-1
        let rows        = w.count-1
        let source      = Self.array(columns: columns, rows: rows)
        let destination = Self.array(w)
        
        return SKWarpGeometryGrid.init(columns              : columns,
                                       rows                 : rows,
                                       sourcePositions      : source,
                                       destinationPositions : destination)
    }
    
//    func pointAt(row: Int, column: Int) -> SIMD2<Float> {
//
//    }
    
    /*
    func stretchedLinear(tl: CGPoint, tr: CGPoint, bl: CGPoint, br: CGPoint) -> SKWarpGeometryGrid {
        // interpolate linearly between corners
        
        var positions : [SIMD2<Float>] = sourcePositions
        
        let dxtop    = (tr.x - tl.x) / numberOfColumns.asCGFloat
        let dxbottom = (br.x - bl.x) / numberOfColumns.asCGFloat
        let dyleft   = (tl.y - bl.y) / numberOfRows.asCGFloat
        let dyright  = (tr.y - br.y) / numberOfRows.asCGFloat
        
        dxtop.lerp01(from: T##CGFloat, to: <#T##CGFloat#>)
        
        var matrix : [[CGPoint]] = sourcePoints
        
        matrix[0][0] = bl
        matrix[numberOfRows][0] = tl
        matrix[0][numberOfColumns] = br
        matrix[numberOfRows][numberOfColumns] = tr
        
        for r in 0...numberOfRows {
            for c in 0...numberOfColumns {
                matrix[r][c].x = matrix[r][c].x.progress(from: )
            }
        }
        
        return replacingByDestinationPositions(positions: positions)
    }
 */
    
    func stretchedQuadratic(tl: CGPoint, tm: CGPoint, tr: CGPoint, bl: CGPoint, bm: CGPoint, br: CGPoint) -> SKWarpGeometryGrid {
        // interpolate linearly between corners
        
        var r = self
        
        return r
    }
    
}





public extension SKColor {
    var asColor : Color {
        Color.init(self)
    }
    var asCIColor : CIColor {
        CIColor.init(cgColor: self.cgColor)
    }
    
#if os(macOS)
    var asRGBAValues : RGBAInfo {
        .init(r: redComponent, g: greenComponent, b: blueComponent, a: alphaComponent)
    }
    var asHSBAValues : HSBAInfo {
        .init(h: hueComponent, s: saturationComponent, b: brightnessComponent, a: alphaComponent)
    }
#endif

}









#if os(iOS)
open class SKTouchNode : SKNode {
    
    public enum Condition {
        case began, moved, ended, cancelled
    }
    
    public typealias Handler = (_ condition: Condition, _ touches: Set<UITouch>, _ event: UIEvent?)->Void
    
    public init(handler: Handler? = nil) {
        super.init()
        isUserInteractionEnabled = true
        self.handler = handler
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var handler : Handler?
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?(.began,touches,event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?(.moved,touches,event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?(.ended,touches,event)
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler?(.cancelled,touches,event)
    }
}
#endif









// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------

//
//  ExtensionsForSpriteKit.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 8/1/22.
//


struct CGMeasure : Codable {
    
    enum Kind : String, Codable{
        case absolute
        case ratio
    }
    
    let kind            : Kind
    var value           : CGFloat
    
    var isAbsolute      : Bool      { kind == .absolute }
    var isRatio         : Bool      { kind == .ratio }
    
    static func absolute(_ value: CGFloat) -> CGMeasure { .init(kind: .absolute, value: value) }
    static func ratio   (_ value: CGFloat) -> CGMeasure { .init(kind: .ratio, value: value) }
}

extension Array where Element == CGFloat {
    func toSKColorFromHSBA() -> SKColor {
        .init(hsba: self)
    }
    func toSKColorFromRGBA() -> SKColor {
        .init(rgba: self)
    }
    
    var fromHSBAtoRGBA : Self { toSKColorFromHSBA().arrayOfRGBA }
    var fromRGBAtoHSBA : Self { toSKColorFromRGBA().arrayOfHSBA }
    
    mutating func set(hue: CGFloat)             { self[0] = hue }
    mutating func set(saturation: CGFloat)      { self[1] = saturation }
    mutating func set(brightness: CGFloat)      { self[2] = brightness }
    
    mutating func set(alpha: CGFloat)           { self[3] = alpha }
    
    mutating func set(red: CGFloat)             { self[0] = red }
    mutating func set(green: CGFloat)           { self[1] = green }
    mutating func set(blue: CGFloat)            { self[2] = blue }

    var hue             : CGFloat               { self[0] }
    var saturation      : CGFloat               { self[1] }
    var brightness      : CGFloat               { self[2] }
    
    var alpha           : CGFloat               { self[3] }
    
    var red             : CGFloat               { self[0] }
    var green           : CGFloat               { self[1] }
    var blue            : CGFloat               { self[2] }
}

enum ColorGradientDirection : String, Codable, CaseIterable, Equatable {
    case north,east,south,west
}

#if os(macOS)
public extension SKColor {
    func withAlphaAdded(_ v: CGFloat) -> SKColor {
        self.withAlphaComponent(v + self.alphaComponent)
    }
    func withAlphaMultiplied(_ v: CGFloat) -> SKColor {
        self.withAlphaComponent(v * self.alphaComponent)
    }
}
#endif

class SKLabelWithRectangleNode : SKShapeNode {
    
    private var labelNode : SKLabelNode {
        children.first as! SKLabelNode
    }

    var hpad : CGFloat {
        didSet {
            update()
        }
    }
    
    var vpad : CGFloat {
        didSet {
            update()
        }
    }
    
    init(hpad: CGFloat = 0, vpad: CGFloat = 0, text: String? = nil, fontName: String? = nil, fontSize: CGFloat? = nil, fontColor: SKColor? = nil, fillColor: SKColor? = nil, lineWidth: CGFloat = 0) {
        self.hpad = hpad
        self.vpad = vpad
        super.init()
        addChild(SKLabelNode.init(text: text))
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        if fontName != nil {
            labelNode.fontName ?= fontName
        }
        labelNode.fontSize ?= fontSize
        labelNode.fontColor ?= fontColor
        self.lineWidth = lineWidth
        self.fillColor ?= fillColor
        update()
    }
    
    convenience init(hpad: CGFloat = 0, vpad: CGFloat = 0, attributedText: NSAttributedString, fontName: String? = nil, fontSize: CGFloat? = nil, fontColor: SKColor? = nil, fillColor: SKColor? = nil, lineWidth: CGFloat = 0) {
        self.init(hpad: hpad, vpad: vpad)
        labelNode.attributedText = attributedText
        if fontName != nil {
            labelNode.fontName ?= fontName
        }
        labelNode.fontSize ?= fontSize
        labelNode.fontColor ?= fontColor
        self.lineWidth = lineWidth
        self.fillColor ?= fillColor
        update()
    }
    
    var fontName : String? {
        get { labelNode.fontName }
        set {
            labelNode.fontName = newValue
        }
    }

    var fontSize : CGFloat {
        get { labelNode.fontSize }
        set {
            labelNode.fontSize = newValue
        }
    }

    var fontColor : SKColor? {
        get { labelNode.fontColor }
        set {
            labelNode.fontColor = newValue
        }
    }

    var text : String? {
        get { labelNode.text }
        set {
            labelNode.text = newValue
        }
    }

    var attributedText : NSAttributedString? {
        get { labelNode.attributedText }
        set {
            labelNode.attributedText = newValue
        }
    }
    
    func adjustFontSizeToFit(w: CGFloat, h: CGFloat, height factor: CGFloat = 0.45) {
        labelNode.adjustFontSizeToFit(w: w, h: h, height: height)
    }
    
    func update() {
        let frame = labelNode.calculateAccumulatedFrame()
        self.path = .create(rect: .init(center: .zero, size: .init(frame.width + hpad * 2, frame.height + vpad * 2)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





@discardableResult
func labelWithShapeArrowConnector(position p0              : CGPoint,
                                  insetsX                  : CGFloat,
                                  insetsY                  : CGFloat,
                                  corner                   : CGFloat = 0,
                                  string                   : String,
                                  textOffsetX              : CGFloat = 0,
                                  textOffsetY              : CGFloat = 0,
                                  fontName                 : String,
                                  fontSize                 : CGFloat,
                                  textColor                : SKColor,
                                  fillColor                : SKColor,
                                  connectorColor           : SKColor! = nil,
                                  connectorRadius          : CGFloat = 0,
                                  connectorCircleFill      : Bool = false,
                                  connectorLineStyle       : CGLineStyle! = nil,
                                  offset                   : CGFloat = 0,
                                  placement                : CGPerpendicularPlacement = .none,
                                  arrowHeight              : CGFloat = 8,
                                  arrowWidth               : CGFloat = 8,
                                  arrowColor               : SKColor! = nil,
                                  rotated                  : CGAngle = .zero) -> SKShapeNode
{
    let LABEL = SKLabelNode.init(text: string)
    
    LABEL.fontName      = fontName
    LABEL.fontSize      = fontSize
    LABEL.fontColor     = textColor
    
    LABEL.verticalAlignmentMode = .center
    LABEL.horizontalAlignmentMode = .center
    
    var n : SKShapeNode!
    
    if offset > 0 {
        let RECT = LABEL.calculateAccumulatedFrame().insetBy(dx: insetsX, dy: insetsY).size.asCGRectCenteredOnZero
        
        switch placement {
            case .none:
                n = SKShapeNode.init(rect: RECT, cornerRadius: corner).configured(fillColor: fillColor)
                    .positioned(at: p0)

            case .top:
                var polygon : [CGPoint] = []
                if arrowWidth > 0 {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0.5, y: 0).added(x: +arrowWidth/2),
                        RECT.pointFromRatio(x: 0.5, y: 0).added(y: -arrowHeight),
                        RECT.pointFromRatio(x: 0.5, y: 0).added(x: -arrowWidth/2),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                } else {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0.5, y: 0).added(y: -arrowHeight),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                }
                
                n = SKShapeNode.init(polygon: polygon, close: true, fillColor: fillColor)
                    .positioned(at: p0)

                let FRAME = n.calculateAccumulatedFrame()
                let OFFSET = FRAME.height/2 + offset
                n.offset(y: OFFSET)

                if let cc = connectorColor {
                    if let ls = connectorLineStyle {
                        let FROM = CGPoint.zero.with(y: connectorRadius + 1)
                        let   TO = CGPoint.zero.with(y: OFFSET - arrowHeight/2 - FRAME.height/2 - 2)
                        let c = SKShapeNode.line(from: FROM, to: TO, strokeColor: cc).configured(lineStyle: ls).offset(y: -OFFSET)
                        n.addChild(c)
                    }
                    if connectorRadius > 0 {
                        if connectorCircleFill {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, fillColor: cc).offset(y: -OFFSET)
                            n.addChild(c)
                        } else {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, strokeColor: cc).configured(lineStyle: connectorLineStyle ?? .create(1)).offset(y: -OFFSET)
                            n.addChild(c)
                        }
                    }
                }
                
            case .bottom:
                var polygon : [CGPoint] = []
                if arrowWidth > 0 {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 0.5, y: 1).added(x: -arrowWidth/2),
                        RECT.pointFromRatio(x: 0.5, y: 1).added(y: arrowHeight),
                        RECT.pointFromRatio(x: 0.5, y: 1).added(x: +arrowWidth/2),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                } else {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 0.5, y: 1).added(y: arrowHeight),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                }
                n = SKShapeNode.init(polygon: polygon, close: true, fillColor: fillColor)
                    .positioned(at: p0)
                
                let FRAME = n.calculateAccumulatedFrame()
                let OFFSET = -FRAME.height/2 - offset
                n.offset(y: OFFSET)

                if let cc = connectorColor {
                    if let ls = connectorLineStyle {
                        let FROM = CGPoint.zero.with(y: -(connectorRadius + 1))
                        let   TO = CGPoint.zero.with(y: OFFSET + arrowHeight/2 + FRAME.height/2 + 2)
                        let c = SKShapeNode.line(from: FROM, to: TO, strokeColor: cc).configured(lineStyle: ls).offset(y: -OFFSET)
                        n.addChild(c)
                    }
                    if connectorRadius > 0 {
                        if connectorCircleFill {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, fillColor: cc).offset(y: -OFFSET)
                            n.addChild(c)
                        } else {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, strokeColor: cc).configured(lineStyle: connectorLineStyle ?? .create(1)).offset(y: -OFFSET)
                            n.addChild(c)
                        }
                    }
                }

            case .left:
                var polygon : [CGPoint] = []
                if arrowWidth > 0 {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0.5).added(y: +arrowWidth/2),
                        RECT.pointFromRatio(x: 1, y: 0.5).added(x: +arrowHeight),
                        RECT.pointFromRatio(x: 1, y: 0.5).added(y: -arrowWidth/2),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                } else {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0.5).added(x: +arrowHeight),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                    ]
                }
                
                n = SKShapeNode.init(polygon: polygon, close: true, fillColor: fillColor)
                    .positioned(at: p0)

                let FRAME = n.calculateAccumulatedFrame()
                let OFFSET = -FRAME.width/2 - offset
                n.offset(x: OFFSET)
                
                if let cc = connectorColor {
                    if let ls = connectorLineStyle {
                        let FROM = CGPoint.zero.with(x: -(connectorRadius + 1))
                        let   TO = CGPoint.zero.with(x: OFFSET + arrowHeight/2 + FRAME.width/2 + 2)
                        let c = SKShapeNode.line(from: FROM, to: TO, strokeColor: cc).configured(lineStyle: ls).offset(x: -OFFSET)
                        n.addChild(c)
                    }
                    if connectorRadius > 0 {
                        if connectorCircleFill {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, fillColor: cc).offset(x: -OFFSET)
                            n.addChild(c)
                        } else {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, strokeColor: cc).configured(lineStyle: connectorLineStyle ?? .create(1)).offset(x: -OFFSET)
                            n.addChild(c)
                        }
                    }
                }

            case .right:
                var polygon : [CGPoint] = []
                if arrowWidth > 0 {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0.5).added(y: -arrowWidth/2),
                        RECT.pointFromRatio(x: 0, y: 0.5).added(x: -arrowHeight),
                        RECT.pointFromRatio(x: 0, y: 0.5).added(y: +arrowWidth/2),
                    ]
                } else {
                    polygon = [
                        RECT.pointFromRatio(x: 0, y: 1),
                        RECT.pointFromRatio(x: 1, y: 1),
                        RECT.pointFromRatio(x: 1, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0),
                        RECT.pointFromRatio(x: 0, y: 0.5).added(x: -arrowHeight),
                    ]
                }
                
                n = SKShapeNode.init(polygon: polygon, close: true, fillColor: fillColor)
                    .positioned(at: p0)

                let FRAME = n.calculateAccumulatedFrame()
                let OFFSET = FRAME.width/2 + offset
                n.offset(x: OFFSET)

                if let cc = connectorColor {
                    if let ls = connectorLineStyle {
                        let FROM = CGPoint.zero.with(x: connectorRadius + 1)
                        let   TO = CGPoint.zero.with(x: OFFSET - arrowHeight/2 - FRAME.width/2 - 2)
                        let c = SKShapeNode.line(from: FROM, to: TO, strokeColor: cc).configured(lineStyle: ls).offset(x: -OFFSET)
                        n.addChild(c)
                    }
                    if connectorRadius > 0 {
                        if connectorCircleFill {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, fillColor: cc).offset(x: -OFFSET)
                            n.addChild(c)
                        } else {
                            let c = SKShapeNode.circle(withRadius: connectorRadius, strokeColor: cc).configured(lineStyle: connectorLineStyle ?? .create(1)).offset(x: -OFFSET)
                            n.addChild(c)
                        }
                    }
                }


        }
    }
    
    n.addChild(LABEL)

    LABEL.verticalAlignmentMode = .center
    LABEL.horizontalAlignmentMode = .center
    
//    let RR = LABEL.calculateAccumulatedFrame()
    
//    LABEL.position.y += insetsY / 2
//    LABEL.position.x += insetsX / 2
    
    LABEL.offset(x: textOffsetX, y: textOffsetY)
    
    
    
    n.zRotation = rotated.radians

    return n
}


class SKTagNode : SKNode {
    enum Location {
        case center, top, right, bottom, left
    }
    
    weak var shape       : SKShapeNode!
    weak var label       : SKLabelNode!
    
    typealias Connector = (location: Location, point: CGPoint)
    
    let connectors  : [Connector]
    
    init(shape: SKShapeNode, label: SKLabelNode, connectors: [Connector]) {
        self.shape = shape
        self.label = label
        self.connectors = connectors
        super.init()
        self.addChild(shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func create(position p0              : CGPoint,
                       insetsX                  : CGFloat,
                       insetsY                  : CGFloat,
                       string                   : String,
                       textOffsetX              : CGFloat = 0,
                       textOffsetY              : CGFloat = 0,
                       fontInfo                 : SKLabelNode.FontInfo,
                       fillColor                : SKColor,
                       lineWidth                : CGFloat = 0,
                       strokeColor              : SKColor = .white,
                       anchor                   : SKTagNode.Location? = nil,
                       offset                   : CGFloat = 0,
                       arrows                   : [SKTagNode.Location],
                       arrowHeight              : CGFloat = 4,
                       arrowWidth               : CGFloat = 8,
                       rotated                  : CGAngle = .zero) -> SKTagNode
    {
        let LABEL = SKLabelNode.init(text: string)
        
        LABEL.textInfo = fontInfo
        
        LABEL.verticalAlignmentMode = .center
        LABEL.horizontalAlignmentMode = .center
        
        LABEL.offset(x: textOffsetX, y: textOffsetY)
        
        return create(position: p0, label: LABEL, insetsX: insetsX, insetsY: insetsY, fillColor: fillColor, lineWidth: lineWidth, strokeColor: strokeColor, anchor: anchor, offset: offset, arrows: arrows, arrowHeight: arrowHeight, arrowWidth: arrowWidth, rotated: rotated)
    }
    
    static func create(position p0              : CGPoint,
                       label LABEL              : SKLabelNode,
                       insetsX                  : CGFloat,
                       insetsY                  : CGFloat,
                       fillColor                : SKColor,
                       lineWidth                : CGFloat = 0,
                       strokeColor              : SKColor = .white,
                       anchor                   : SKTagNode.Location? = nil,
                       offset                   : CGFloat = 0,
                       arrows                   : [SKTagNode.Location],
                       arrowHeight              : CGFloat = 4,
                       arrowWidth               : CGFloat = 8,
                       rotated                  : CGAngle = .zero) -> SKTagNode
    {
        var connectors  : [SKTagNode.Connector] = []
        
        var polygon     : [CGPoint] = []
        
        
        
        let RECT = LABEL.calculateAccumulatedFrame().insetBy(dx: -insetsX, dy: -insetsY).size.asCGRectCenteredOnZero
        
        
        
        
        polygon += [
            RECT.pointFromRatio(x: 0, y: 1)
        ]
        
        if arrows.contains(.top) {
            let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.width - 1
            polygon += [
                RECT.pointFromRatio(x: 0.5, y: 1).added(x: -arrowWidth/2),
                RECT.pointFromRatio(x: 0.5, y: 1).added(y:  arrowHeight),
                RECT.pointFromRatio(x: 0.5, y: 1).added(x: +arrowWidth/2),
            ]
            connectors.append((location: .top, point: RECT.pointFromRatio(x: 0.5, y: 1).added(y: +arrowHeight)))
        }
        
        
        polygon += [
            RECT.pointFromRatio(x: 1, y: 1)
        ]
        
        if arrows.contains(.right) {
            let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.height - 1
            polygon += [
                RECT.pointFromRatio(x: 1, y: 0.5).added(y: +arrowWidth/2),
                RECT.pointFromRatio(x: 1, y: 0.5).added(x:  arrowHeight),
                RECT.pointFromRatio(x: 1, y: 0.5).added(y: -arrowWidth/2),
            ]
            connectors.append((location: .right, point: RECT.pointFromRatio(x: 1, y: 0.5).added(x: +arrowHeight)))
        }
        
        
        polygon += [
            RECT.pointFromRatio(x: 1, y: 0),
        ]
        
        if arrows.contains(.bottom) {
            let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.width - 1
            polygon += [
                RECT.pointFromRatio(x: 0.5, y: 0).added(x: +arrowWidth/2),
                RECT.pointFromRatio(x: 0.5, y: 0).added(y: -arrowHeight),
                RECT.pointFromRatio(x: 0.5, y: 0).added(x: -arrowWidth/2),
            ]
            connectors.append((location: .bottom, point: RECT.pointFromRatio(x: 0.5, y: 0).added(y: -arrowHeight)))
        }
        
        
        polygon += [
            RECT.pointFromRatio(x: 0, y: 0),
        ]
        
        if arrows.contains(.left) {
            let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.height - 1
            polygon += [
                RECT.pointFromRatio(x: 0, y: 0.5).added(y: -arrowWidth/2),
                RECT.pointFromRatio(x: 0, y: 0.5).added(x: -arrowHeight),
                RECT.pointFromRatio(x: 0, y: 0.5).added(y: +arrowWidth/2),
            ]
            connectors.append((location: .left, point: RECT.pointFromRatio(x: 0, y: 0.5).added(x: -arrowHeight)))
        }
        
 
        let SHAPE = SKShapeNode.init(polygon: polygon, close: true, position: p0, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth)

        SHAPE.isAntialiased = true
        
        SHAPE.addChild(LABEL)
        
        if let anchor = anchor {
            switch anchor {
                case .top       : SHAPE.position.y = -offset - (arrows.contains(anchor) ? arrowHeight : 0) - RECT.height/2
                case .bottom    : SHAPE.position.y = +offset + (arrows.contains(anchor) ? arrowHeight : 0) + RECT.height/2
                case .left      : SHAPE.position.x = +offset + (arrows.contains(anchor) ? arrowHeight : 0) + RECT.width/2
                case .right     : SHAPE.position.x = -offset - (arrows.contains(anchor) ? arrowHeight : 0) - RECT.width/2
                case .center:
                    break
            }
        }
        
        SHAPE.zRotation = rotated.radians
        
        return .init(shape: SHAPE, label: LABEL, connectors: connectors)
    }
    
}


//
//
//let RECT = LABEL.calculateAccumulatedFrame().insetBy(dx: -insetsX, dy: -insetsY).size.asCGRect
//
//
//let SHAPE = SKShapeNode.init(rectangle: RECT, position: p0, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth)
//
//
////        polygon += [
////            RECT.pointFromRatio(x: 0, y: 1)
////        ]
//
//if arrows.contains(.top) {
//    let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.width - 1
//    SHAPE.addChildNode(SKShapeNode.init(polygon: [
//        RECT.pointFromRatio(x: 0.5, y: 1).adding(x: -arrowWidth/2),
//        RECT.pointFromRatio(x: 0.5, y: 1).adding(y:  arrowHeight),
//        RECT.pointFromRatio(x: 0.5, y: 1).adding(x: +arrowWidth/2),
//    ], close: true, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth))
//    connectors.append((location: .top, point: RECT.pointFromRatio(x: 0.5, y: 1).adding(y: +arrowHeight)))
//}
//
//
////        polygon += [
////            RECT.pointFromRatio(x: 1, y: 1)
////        ]
//
//if arrows.contains(.right) {
//    let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.height - 1
//    SHAPE.addChildNode(SKShapeNode.init(polygon: [
//        RECT.pointFromRatio(x: 1, y: 0.5).adding(y: +arrowWidth/2),
//        RECT.pointFromRatio(x: 1, y: 0.5).adding(x:  arrowHeight),
//        RECT.pointFromRatio(x: 1, y: 0.5).adding(y: -arrowWidth/2),
//    ], close: true, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth))
//    connectors.append((location: .right, point: RECT.pointFromRatio(x: 1, y: 0.5).adding(x: +arrowHeight)))
//}
//
//
////        polygon += [
////            RECT.pointFromRatio(x: 1, y: 0),
////        ]
//
//if arrows.contains(.bottom) {
//    let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.width - 1
//    SHAPE.addChildNode(SKShapeNode.init(polygon: [
//        RECT.pointFromRatio(x: 0.5, y: 0).adding(x: +arrowWidth/2),
//        RECT.pointFromRatio(x: 0.5, y: 0).adding(y: -arrowHeight),
//        RECT.pointFromRatio(x: 0.5, y: 0).adding(x: -arrowWidth/2),
//    ], close: true, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth))
//    connectors.append((location: .bottom, point: RECT.pointFromRatio(x: 0.5, y: 0).adding(y: -arrowHeight)))
//}
//
//
////        polygon += [
////            RECT.pointFromRatio(x: 0, y: 0),
////        ]
//
//if arrows.contains(.left) {
//    let arrowWidth = arrowWidth > 0 ? arrowWidth : RECT.height - 1
//    SHAPE.addChildNode(SKShapeNode.init(polygon: [
//        RECT.pointFromRatio(x: 0, y: 0.5).adding(y: -arrowWidth/2),
//        RECT.pointFromRatio(x: 0, y: 0.5).adding(x: -arrowHeight),
//        RECT.pointFromRatio(x: 0, y: 0.5).adding(y: +arrowWidth/2),
//    ], close: true, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth))
//    connectors.append((location: .left, point: RECT.pointFromRatio(x: 0, y: 0.5).adding(x: -arrowHeight)))
//}
//
//
////        let SHAPE = SKShapeNode.init(polygon: polygon, close: true, position: p0, fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth)


//func connectorLine() -> SKShapeNode {
//    SKShapeNode.init(named: "")
//}
//
//func connectorPoint() -> SKNode {
//    SKShapeNode.init(named: "")
//}

extension SKNode {
    
    @discardableResult
    func alignedOn(left x: CGFloat) -> Self {
        let FRAME = calculateAccumulatedFrame()
        self.position.x = x + FRAME.width/2
        return self
    }
    
    @discardableResult
    func alignedOn(right x: CGFloat) -> Self {
        let FRAME = calculateAccumulatedFrame()
        self.position.x = x - FRAME.width/2
        return self
    }
    
    @discardableResult
    func aligned11(on: CGPoint, ax: CGFloat, ay: CGFloat) -> Self {
        let FRAME = calculateAccumulatedFrame()
        self.position.x = on.x + -FRAME.width/2 * ax
        self.position.y = on.y + -FRAME.height/2 * ay
        return self
    }
    
    @discardableResult
    func aligned01(on: CGPoint, ax: CGFloat, ay: CGFloat) -> Self {
        aligned11(on: on, ax: 2 * ax - 1, ay: 2 * ay - 1)
    }
    
}

extension SKLabelNode {

    struct FontInfo {
        var fontName    : String?
        var fontSize    : CGFloat
        var fontColor   : SKColor?
    }

    var textInfo : FontInfo {
        get {
            .init(fontName: self.fontName, fontSize: self.fontSize, fontColor: self.fontColor)
        }
        set {
            self.fontName = newValue.fontName
            self.fontSize = newValue.fontSize
            self.fontColor = newValue.fontColor
        }
    }
    
}

// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------
// 8< ----------------------------------------------------------------------------------

extension CIColor {
    convenience init(swiftUIColor: Color) {
        // Convert SwiftUI Color to UIColor
        #if canImport(UIKit)
        let uiColor = UIColor(swiftUIColor)
        #elseif canImport(AppKit)
        let uiColor = NSColor(swiftUIColor)
        #endif
        
        // Convert UIColor/NSColor to CIColor
        self.init(color: uiColor)
    }
}
