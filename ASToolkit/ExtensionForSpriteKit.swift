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
    @objc var width   :CGFloat                                                                    { return 0 }
    @objc var height  :CGFloat                                                                    { return 0 }
    
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
    
    
    open func place_01(x: CGFloat? = nil, y: CGFloat? = nil) {
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
    
    open func place_11(x: CGFloat? = nil, y: CGFloat? = nil) {
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
    
    open func place_55(x: CGFloat? = nil, y: CGFloat? = nil) {
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
    
    open func x(forAlignmentX x: CGFloat) -> CGFloat {
        parent!.hFrom(ratio11: x) - parent!.width/2.0
    }
    
    open func y(forAlignmentY y: CGFloat) -> CGFloat {
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
        let c = descendants(named: named)
        c.forEach { $0.removeFromParent() }
        return c
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
    
}




public extension SKLightNode
{
    
}





public extension SKShapeNode
{
    convenience init(lines:[CGPoint],
                     position           : CGPoint? = nil,
                     fillColor          : UIColor? = nil,
                     strokeColor        : UIColor? = nil,
                     glowWidth          : CGFloat? = nil,
                     lineWidth          : CGFloat? = nil,
                     lineCap            : CGLineCap? = nil,
                     lineJoin           : CGLineJoin? = nil,
                     miterLimit        : CGFloat? = nil,
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


}

extension SKShapeNode {
    
    @discardableResult
    open func configured (position          : CGPoint? = nil,
                          fillColor         : UIColor? = nil,
                          strokeColor       : UIColor? = nil,
                          glowWidth         : CGFloat? = nil,
                          lineWidth         : CGFloat? = nil,
                          lineCap           : CGLineCap? = nil,
                          lineJoin          : CGLineJoin? = nil,
                          miterLimit        : CGFloat? = nil,
                          lineDash          : [CGFloat]? = nil) -> Self {
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
        if let miterLimit = miterLimit {
            self.miterLimit = miterLimit
        }
        if let lineDash = lineDash {
            addDashes(lengths: lineDash)
        }
        return self
    }
    
    @discardableResult
    open func with(fillColor        : UIColor? = nil,
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
    
    open func addDashes(phase: CGFloat = 0, lengths: [CGFloat]) {
        path = path?.copy(dashingWithPhase: phase, lengths: lengths)
    }
    
    @discardableResult
    open func with(dash lengths: [CGFloat], phase: CGFloat = 0) -> Self {
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
    
    
    public convenience init(named: String) {
        self.init()
        self.name = named
    }
    
    open func pointFromCenter(rx: CGFloat, ry: CGFloat) -> CGPoint {
        return CGPoint.init(x: rx * self.frame.size.width + self.frame.size.width/2,
                            y: ry * self.frame.size.height + self.frame.size.height/2)
    }
    
    open func pointFromFrameOrigin(rx: CGFloat, ry: CGFloat) -> CGPoint {
        return self.frame.origin + CGPoint.init(x: rx * self.frame.size.width, y: ry * self.frame.size.height)
    }


    @discardableResult
    open func debugAddX(lineWidth:CGFloat = 1, color:UIColor = .white) -> SKNode
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
    open func debugAddCross(lineWidth:CGFloat = 1, color:UIColor = .white) -> SKNode
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
    open func debugAddBorder(lineWidth:CGFloat = 1, corner:CGFloat = 0, color:UIColor = .white) -> SKNode
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
    
    open func runOn(node:SKNode,delay sec:TimeInterval = 0) -> SKAction {
        let _ = aRun(on:node,action:self,delay:sec)
        return self
    }
    
    open func with(timingMode: SKActionTimingMode) -> Self {
        self.timingMode = timingMode
        return self
    }

    open func with(timingFunction: @escaping SKActionTimingFunction) -> Self {
        self.timingFunction = timingFunction
        return self
    }
    
    open func configured(timingMode: SKActionTimingMode? = nil, timingFunction: SKActionTimingFunction? = nil) -> Self {
        self.timingMode ?= timingMode
        self.timingFunction ?= timingFunction
        return self
    }

    public static func wait(_ duration: TimeInterval) -> SKAction {
        return SKAction.wait(forDuration: duration)
    }
    
    public static func block(_ block: @escaping Block) -> SKAction {
        return SKAction.run(block)
    }
    
    public static func customAction(withDuration duration: TimeInterval, _ block: @escaping (SKNode, _ elapsedTime: CGFloat, _ elapsedTimeRatio: CGFloat)->Void) -> SKAction {
        return SKAction.customAction(withDuration: duration) { n,t in
            block(n,t,CGFloat(t/duration))
        }
    }
    
    
    public static func instant(_ block: @escaping Block) -> SKAction {
        .run(block)
    }

    public static func instant(_ block: @escaping (SKNode) -> Void) -> SKAction {
        .customAction(withDuration: 0) { n,_,_ in
            block(n)
        }
    }

    public static func block(_ duration: TimeInterval, _ block: @escaping Block) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { _,_ in block() })
    }

    public static func block(_ duration: TimeInterval, _ block: @escaping (CGFloat)->Void) -> SKAction {
        .customAction(withDuration: duration, { _,_,f in block(f) })
    }

    public static func block(duration: TimeInterval, _ block: @escaping Block) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { _,_ in block() })
    }

    public static func block(duration: TimeInterval, _ block: @escaping (CGFloat)->Void) -> SKAction {
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





public extension SKColor {
    var asColor : Color {
        Color.init(self)
    }
    var asCIColor : CIColor {
        CIColor.init(cgColor: self.cgColor)
    }
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
