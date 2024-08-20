    //
    //  ExtensionsForSwiftUI+Canvas.swift
    //  AppSharkeeForMac
    //
    //  Created by andrzej semeniuk on 1/20/2024.
    //

import Foundation
import SwiftUI
//import AppKit

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension GraphicsContext {

    @discardableResult
    func drawTextWithBackgroundRectangle(_ TEXT: Text, at: CGPoint, bg: Color, size: CGSize) -> Self {
//        let TEXT        = Text(T.title).font(kit.font(gain: -1)).foregroundColor(TEXTcolor)
        let TEXTsize    = resolve(TEXT).measure(in: size)
        let TEXTbgPATH  = Path.init(CGRect.init(center: at, size: .init(TEXTsize.width + 4,TEXTsize.height + 2)))
        fill(TEXTbgPATH, with: .color(bg))
//                    x.fill(pRECT(0.5,T.point.y,0.5,dV), with: .color(.black)) //TEXTcolor.inverseBlackOrWhite(0.1,0.5,0.9))) // pRECT() doesn't work for some reason
        draw(TEXT, at: at, anchor: .center)
        return self
    }
    
    
    class PixelMapper {
        internal init(y0: CGFloat, y1: CGFloat, vMIN: Double, vMAX: Double) {
            // NOTE! y0 > y1 !!!
            self.y0     = y0
            self.y1     = y1
            self.vMIN   = vMIN
            self.vMAX   = vMAX
            self.vRANGE = vMAX - vMIN
            self.HEIGHT = y1 - y0
            
            self.dydv = HEIGHT / vRANGE
            self.dvdy = vRANGE / HEIGHT
        }
        
        let y0      : CGFloat
        let y1      : CGFloat
        let HEIGHT  : CGFloat

        let vMIN    : Double
        let vMAX    : Double
        let vRANGE  : Double
        
        let dydv    : Double
        let dvdy    : Double
        
        func vRATIO(value: Double) -> CGFloat {
            (value - vMIN) / vRANGE
        }
        func yFor(value: Double) -> CGFloat {
            y0 - vRATIO(value: value) * HEIGHT
        }
        func valueFor(y: CGFloat) -> Double {
            vMIN + (max(y1, min(y0, y)) - y0) * dvdy
        }
    }

}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Canvas {
    
    
    struct Helper {
        
        let size : CGSize
        
        let MARGIN : CGFloat
        
        let R   : CGFloat
        
        let W   : CGFloat
        let H   : CGFloat
        
        let X0  : CGFloat
        let Y0  : CGFloat
        
        
        func pX(_ X: CGFloat)                       -> CGFloat      { X0 + X * W }
        func pY(_ Y: CGFloat)                       -> CGFloat      { Y0 - Y * H }
        func pP(_ X: CGFloat, _ Y: CGFloat)         -> CGPoint      { CGPoint(pX(X),pY(Y)) }
        func pW(_ X: CGFloat)                       -> CGFloat      { X * W }
        func pH(_ Y: CGFloat)                       -> CGFloat      { Y * H }

        
        init(size: CGSize, MARGIN: CGFloat) {
            self.size = size
            
            self.MARGIN = MARGIN
            
            R = ceil(size.maxSide * MARGIN)
            
            W = size.width - R - R
            H = size.height - R - R
            
            X0 = R
            Y0 = size.height - R

        }
        
        
        
        func CCIRCLE    (_ X: CGFloat, _ Y: CGFloat, _ S: CGFloat) -> Path {
            Path.init(CGPath.init(ellipseIn: .init(center: .init(x: X * size.width, y: Y * size.height), side: S * size.width), transform: nil))
        }
        func CRECT      (_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> Path {
            return Path.init(CGPath.init(rect: .init(center: .init(x: x * size.width, y: y * size.height), size: CGSize.init(w * size.width, h * size.height)), transform: nil))
        }
        
        func pARC       (_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ angle0: CGFloat, _ angle1: CGFloat, _ cw: Bool) -> Path {
            let CENTER = pP(x,y)
            return Path.init(CGMutablePath.init().moved(to: CENTER).addedArc(center: CENTER, radius: pW(r), startAngle: angle0, endAngle: angle1, clockwise: cw))
        }
            //                let pBANDarc : (CGFloat,CGFloat,CGFloat,CGFloat,CGFloat,CGFloat) -> Path = { x,y,r0,r1,angle0,angle1 in
            //                    let CENTER = pP(x,y)
            //                    return Path.init(CGMutablePath.init().moved(to: CENTER)
            //                        .addedArc(center: CENTER, radius: pW(min(r0,r1)), startAngle: angle0, endAngle: angle1, clockwise: angle0 > angle1)
            //                        .addedArc(center: CENTER, radius: pW(max(r0,r1)), startAngle: angle1, endAngle: angle0, clockwise: angle0 < angle1))
            //                }
            //                let pBANDcircle : (CGFloat,CGFloat,CGFloat,CGFloat) -> Path = { x,y,r0,r1 in
            //                    pBANDarc(x,y,r0,r1,0,360)
            //                }
        func pCIRCLE    (_ X: CGFloat, _ Y: CGFloat, _ S: CGFloat) -> Path {
            return Path.init(CGPath.init(ellipseIn: .init(center: pP(X,Y), side: pW(S)), transform: nil))
        }
        func pCIRCLEs   (_ X: CGFloat, _ Y: CGFloat, _ S: CGFloat) -> Path {
            return Path.init(CGPath.init(ellipseIn: .init(center: pP(X,Y), side: S), transform: nil))
        }
        func pCIRCLER   (_ X: CGFloat, _ Y: CGFloat, _ S: CGFloat) -> Path {
            return Path.init(CGPath.init(ellipseIn: .init(center: pP(X,Y), side: S * R), transform: nil))
        }
        func pRECT      (_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> Path {
            return Path.init(CGPath.init(rect: .init(center: pP(x,y), size: CGSize.init(pW(w),pH(h))), transform: nil))
        }
        func pRECTo     (_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> Path {
            return Path.init(CGPath.init(rect: .init(center: .init(x,y), size: CGSize.init(w,h)), transform: nil))
        }
        func pLINEv     (_ X: CGFloat) -> Path {
            return Path.init(CGPath.line(p0: pP(X,0), p1: pP(X,1)))
        }
        func pLINEh     (_ Y: CGFloat) -> Path {
            return Path.init(CGPath.line(p0: pP(0,Y), p1: pP(1,Y)))
        }
        
        let L1 = StrokeStyle.init(lineWidth: 2, lineCap: .square, lineJoin: .miter, miterLimit: 10, dash: [1], dashPhase: 0)
        let L3 = StrokeStyle.init(lineWidth: 3, lineCap: .square, lineJoin: .miter, miterLimit: 10, dash: [1], dashPhase: 0)
            //                let L9 = StrokeStyle.init(lineWidth: 9, lineCap: .square, lineJoin: .miter, miterLimit: 10, dash: [1], dashPhase: 0)
        
        let STYLE0 = FillStyle.init(eoFill: false, antialiased: false)

    }
    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension GraphicsContext {

    func helper(size: CGSize, mapper: PixelMapper? = nil) -> Helper {
        .init(x: self, size: size, mapper: mapper)
    }
    
    struct Helper {
        
        let x : GraphicsContext
        let size : CGSize
        var mapper : PixelMapper!
        
        func draw(segment SEGMENT: CGSegment, color COLOR: Color, lineWidth: CGFloat = 1, withArrow: Bool, arrowColor: Color = .black.opacity(0.4), withRay: Bool, rayColor : Color = .white.opacity(0.2), withFont: Font? = nil, withFontColor : Color = .black) {
            
            x.stroke(Path.init(.rect(SEGMENT.rect)), with: .color(.white.opacity(0.35)), style: .init(lineWidth: 1, lineCap: .butt, lineJoin: .miter, miterLimit: 10, dash: [1,4], dashPhase: 0))
            
            if withRay, let RAY = SEGMENT.ray(inside: size.asCGRectWithOriginZero) {
                    //                                        x.fill(Path.init(.line(p0: RAY.from, p1: RAY.to).copy(strokingWithWidth: 1, lineCap: .butt, lineJoin: .miter, miterLimit: 10)), with: .color(.white))
                x.stroke(Path.init(.segment(RAY)), with: .color(rayColor), lineWidth: lineWidth)
            }
            do {
                let PATH = CGPath.segment(SEGMENT.stretched(to: -11))
                x.stroke(Path.init(PATH), with: .color(COLOR), lineWidth: lineWidth)
            }
            if withArrow {
                let PATH = CGMutablePath.arrowHead(side: 11, angle: .init(degrees: 22)).rotatedBy(SEGMENT.angle - .ninety).translatedBy(SEGMENT.to)
                x.fill(Path.init(PATH), with: .color(arrowColor))
            }
                //                                    do {
                //                                        let OFFSET : CGFloat = 8
                //                                        let PATH =
                //                                            CGPath.line(SEGMENT.from.added(x: OFFSET), SEGMENT.to.with(y: SEGMENT.y0)) +
                //                                            CGPath.line(SEGMENT.to.added(y: -OFFSET), SEGMENT.to.with(y: SEGMENT.y0)) +
                //                                        x.stroke(Path.init(PATH), with: .color(COLOR), lineWidth: 1)
                //                                    }
            if let FONT = withFont, let MAPPER = mapper {
                let V0 = MAPPER.valueFor(y: SEGMENT.from.y)
                let V1 = MAPPER.valueFor(y: SEGMENT.to.y)
                let DVALUE = (V1 / V0) * 100.0 - 100.0
                let TEXT = Text(" \(DVALUE.asInt)% / \(SEGMENT.point.x.asInt) ").font(FONT).foregroundColor(withFontColor) //.custom(kit.fontName, size: kit.fontSize0ForTextWith - 2)).foregroundColor(.black)
                x.drawTextWithBackgroundRectangle(TEXT, at: SEGMENT.midpoint, bg: .white, size: size)
            }
            
            
        }
    }

    
}
