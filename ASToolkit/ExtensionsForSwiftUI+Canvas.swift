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
    func renderTextWithBackgroundRectangle(_ TEXT: Text, at: CGPoint, angle: Angle = .zero, bg: Color, paddingH : CGFloat = 2, paddingV : CGFloat = 1, corner: CGFloat = 0, anchor: UnitPoint = .center, arrows: Set<CGRect.Side> = [], arrowHeight: CGFloat = 4, arrowWidth: CGFloat = 8, size: CGSize) -> ResolvedText {
        
        let RTEXT           = resolve(TEXT)
        let TEXTsize        = RTEXT.measure(in: size)
        let SIZE            = CGSize.init(TEXTsize.width + paddingH * 2, TEXTsize.height + paddingV * 2)
        
        var AT              = at
        
        switch anchor {
//            case .bottom    : AT = at.added(y:  SIZE.height/2)
//            case .top       : AT = at.added(y: -SIZE.height/2)
                
            case .bottom        : AT = at.added(y: -SIZE.height/2)
            case .top           : AT = at.added(y:  SIZE.height/2)
            case .leading       : AT = at.added(x:  SIZE.width/2)
            case .trailing      : AT = at.added(x: -SIZE.width/2)
                
            case .topLeading    : AT = at.added(x:  SIZE.width/2, y:  SIZE.height/2)
            case .bottomLeading : AT = at.added(x:  SIZE.width/2, y: -SIZE.height/2)
            case .topTrailing   : AT = at.added(x: -SIZE.width/2, y:  SIZE.height/2)
            case .bottomTrailing: AT = at.added(x: -SIZE.width/2, y: -SIZE.height/2)
                
//            case .leading   : AT = at.added(x: -SIZE.width/2)
//            case .trailing  : AT = at.added(x:  SIZE.width/2)
                
            default:
                break
        }

//        var SIZE1 : CGSize = .zero
        
        drawLayer { layer in

            let RECT = CGRect(center: AT, size: SIZE)
            
            var basePath: Path
            
            if corner > 0 {
                basePath = RoundedRectangle(cornerRadius: corner, style: .continuous).path(in: RECT)
            } else {
                basePath = Path(RECT)
            }

            if angle != .zero {
                layer.rotate(by: angle)
            }
            
            if arrows.isNotEmpty {
                let POINTS = RECT.pointsWith(arrows: arrows, arrowHeight: arrowHeight, arrowWidth: arrowWidth)
                let PATH4 = Path.from(points: POINTS, close: true)
                
                layer.fill(PATH4, with: .color(bg))
//                basePath.addPath(PATH4)
            }
            
            layer.fill(basePath, with: .color(bg))

//            drawMultilineCenteredText(LINES, at: AT, in: size, bg: { SIZE in
//                layer.fill(basePath, with: .color(bg))
//            }, modifier: { TEXT in
//                TEXT
//            })
            
            layer.draw(RTEXT, at: AT, anchor: .center)
            
//            SIZE1 = RTEXT.measure(in: .init(width: size.maxSide, height: .infinity))
            
//            withCGContext { cg in
//                    cg.saveGState()
//                    cg.translateBy(x: AT.x, y: AT.y)
//                    cg.rotate(by: angle.radians)
//                    cg.translateBy(x: -AT.x, y: -AT.y)
//                    draw(resolved, at: AT, anchor: .center)
//                    cg.restoreGState()
//                }
        }
        
        return RTEXT
    }
    
    
    
    
    
    @discardableResult
    func renderMultilineJustifiedText(lines: [String], justification: CGTextJustification, styling: (Text) -> Text = { $0 }, center: (GraphicsContext,CGSize) -> CGPoint, angle: Angle = .zero, size: CGSize) -> Self {
        
        drawLayer { layer in

            if angle != .zero {
                layer.rotate(by: angle)
            }
            
            layer.renderMultilineJustifiedText(lines, justification: justification, in: size, styling: styling, center: center)
            
        }
        
        return self
    }
    
    
    
    
    @discardableResult
    func renderMultilineCenteredTextWithBackgroundRectangle(lines: [String], justification: CGTextJustification, styling: (Text) -> Text = { $0 }, at: CGPoint, angle: Angle = .zero, bg: Color, corner: CGFloat = 0, anchor: UnitPoint = .center, size: CGSize) -> Self {

        renderMultilineJustifiedText(lines: lines, justification: justification, styling: styling, center: { CONTEXT, SIZE0 in
            
            let SIZE            = CGSize.init(SIZE0.width + 4, SIZE0.height + 2)
            
            var AT              = at
            switch anchor {
                case .bottom    : AT = at.added(y: -SIZE.height/2)
                case .top       : AT = at.added(y:  SIZE.height/2)
                case .leading   : AT = at.added(x: -SIZE.width/2)
                case .trailing  : AT = at.added(x:  SIZE.width/2)
                    
                default:
                    break
            }

            let RECT = CGRect(center: AT, size: SIZE)
            
            let basePath: Path
            if corner > 0 {
                basePath = RoundedRectangle(cornerRadius: corner, style: .continuous).path(in: RECT)
            } else {
                basePath = Path(RECT)
            }

            CONTEXT.fill(basePath, with: .color(bg))
            
            return AT

        }, angle: angle, size: size)

        return self

//            withCGContext { cg in
//                    cg.saveGState()
//                    cg.translateBy(x: AT.x, y: AT.y)
//                    cg.rotate(by: angle.radians)
//                    cg.translateBy(x: -AT.x, y: -AT.y)
//                    draw(resolved, at: AT, anchor: .center)
//                    cg.restoreGState()
        
    }
    
    
    func renderMultilineJustifiedText(
        _ lines: [String],
        justification: CGTextJustification,
        in size: CGSize,
        styling: (Text) -> Text = { $0 },
        center: (GraphicsContext, CGSize) -> CGPoint,
    ) {
        // Resolve each line to ResolvedText and measure
        let resolvedLines: [(text: GraphicsContext.ResolvedText, size: CGSize)] = lines.map { line in
            let resolved = self.resolve(styling(Text(line)))
            let size = resolved.measure(in: size)
            return (resolved, size)
        }

        let dY = resolvedLines.map { $0.size.height }.max!

        // Total height of all lines
        let totalHeight = resolvedLines.count.asCGFloat * dY
        let totalWidth = resolvedLines.map { $0.size.width }.max!

        let CENTER = center(self, CGSize(totalWidth, totalHeight))

        // Starting y-position (top of first line)
        var currentY = CENTER.y - totalHeight / 2

        for (resolved, lineSize) in resolvedLines {
            let x: CGFloat
            switch justification {
                case .Left:
                    x = CENTER.x - totalWidth / 2 + lineSize.width / 2
                case .Right:
                    x = CENTER.x + totalWidth / 2 - lineSize.width / 2
                case .Center:
                    x = CENTER.x
            }

            let y = currentY + dY / 2
            self.draw(resolved, at: CGPoint(x: x, y: y), anchor: .center)
            currentY += dY
        }
    }
    
    

    
    
    struct PixelMapper : Equatable, Codable {
        
        static let invalid : Self = .init(y0: 1, y1: 0, vMIN: 0.1234, vMAX: 1.12345, logarithmic: false)
        
        internal init(y0: CGFloat, y1: CGFloat, vMIN: Double, vMAX: Double, logarithmic: Bool) {
            // NOTE! y0 > y1 !!!
            assert(y1 != y0)
            self.y0     = y0
            self.y1     = y1
            self.Y0     = min(y0,y1)
            self.Y1     = max(y0,y1)
            self.vMIN   = vMIN
            self.vMAX   = vMAX
            self.VMIN   = min(vMIN,vMAX)
            self.VMAX   = max(vMIN,vMAX)
            self.vRANGE = vMAX - vMIN
            self.HEIGHT = (y1 - y0)
            
            self.logarithmic = logarithmic
            
            if logarithmic {
                precondition(vMIN > 0, "Logarithmic mode requires vMIN > 0")
                precondition(vMAX > 0, "Logarithmic mode requires vMAX > 0")
                let logMIN = log(vMIN)
                let logMAX = log(vMAX)
                self.logVMIN = logMIN
                self.logVMAX = logMAX
                self.logVRANGE = logMAX - logMIN
                self.dydv = HEIGHT / logVRANGE
                self.dvdy = logVRANGE / HEIGHT
            } else {
                self.logVMIN = 0
                self.logVMAX = 0
                self.logVRANGE = 0
                self.dydv = HEIGHT / vRANGE
                self.dvdy = vRANGE / HEIGHT
            }
            
        }
        
        let y0      : CGFloat
        let y1      : CGFloat
        let Y0      : CGFloat
        let Y1      : CGFloat
        let HEIGHT  : CGFloat
        

        let vMIN    : Double
        let vMAX    : Double
        let VMIN    : Double
        let VMAX    : Double
        let vRANGE  : Double
        
        let dydv    : Double
        let dvdy    : Double
        
        let logarithmic : Bool
        let logVMIN : Double
        let logVMAX : Double
        let logVRANGE : Double
        
        @inlinable func vRATIO(value: Double) -> CGFloat {
            if logarithmic {
                return CGFloat((log(value) - logVMIN) / logVRANGE)
            } else {
                return (value - vMIN) / vRANGE
            }
        }
        
        @inlinable func yFor(value: Double) -> CGFloat {
            if logarithmic {
                return y0 + CGFloat((log(value) - logVMIN) * dydv)
            } else {
                return y0 + CGFloat((value - vMIN) * dydv)
            }
        }
        @inlinable func valueFor(y: CGFloat) -> Double {
            if logarithmic {
                return exp(logVMIN + (Double(y - y0) * dvdy))
            } else {
                return vMIN + Double((y - y0)) * dvdy
            }
        }
        
        @inlinable func clamped(value: Double) -> Double {
            VMAX.min(VMIN.max(value))
        }
        @inlinable func clamped(y: CGFloat) -> CGFloat {
            Y1.min(Y0.max(y))
        }
        
        @inlinable func contains(y: CGFloat) -> Bool {
            y.inIntervalClosedOpen(Y0, Y1)
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
                let TEXT = Text(" \(DVALUE.asInt)% / \(SEGMENT.point.x.asInt) ").font(FONT).foregroundColor(withFontColor) //.custom(ui.fontName, size: ui.fontSize0 - 2)).foregroundColor(.black)
                x.renderTextWithBackgroundRectangle(TEXT, at: SEGMENT.midpoint, bg: .white, size: size)
            }
            
            
        }
        
        func draw(segment SEGMENT: CGSegment, color COLOR: Color, style: StrokeStyle, stretch: CGFloat? = nil, arrowSide: CGFloat? = nil, arrowColor: Color? = nil, rayColor : Color? = nil, rayStyle: StrokeStyle? = nil, withFont: Font? = nil, withFontColor : Color = .black) {
            
            
            if let rayColor, let rayStyle, let RAY = SEGMENT.ray(inside: size.asCGRectWithOriginZero) {
                    //                                        x.fill(Path.init(.line(p0: RAY.from, p1: RAY.to).copy(strokingWithWidth: 1, lineCap: .butt, lineJoin: .miter, miterLimit: 10)), with: .color(.white))
                x.stroke(Path.init(.segment(RAY)), with: .color(rayColor), style: rayStyle)
            }
            
            if let stretch {
                let PATH = CGPath.segment(SEGMENT.stretched(to: stretch)) // -11))
                x.stroke(Path.init(PATH), with: .color(COLOR), style: style)
            } else {
                x.stroke(Path.init(.segment(SEGMENT)), with: .color(COLOR), style: style)
            }
            
            if let arrowSide {
                let PATH = CGMutablePath.arrowHead(side: /*11*/ arrowSide, angle: .init(degrees: 22)).rotatedBy(SEGMENT.angle - .ninety).translatedBy(SEGMENT.to)
                x.fill(Path.init(PATH), with: .color(arrowColor ?? COLOR))
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
                let TEXT = Text(" \(DVALUE.asInt)% / \(SEGMENT.point.x.asInt) ").font(FONT).foregroundColor(withFontColor) //.custom(ui.fontName, size: ui.fontSize0 - 2)).foregroundColor(.black)
                x.renderTextWithBackgroundRectangle(TEXT, at: SEGMENT.midpoint, bg: .white, size: size)
            }
            
            
        }
        
        
    }

    
}

extension Path {
    
    static func line(_ from: CGPoint, _ to: CGPoint) -> Path {
        var R = Path()
        R.move(to: from)
        R.addLine(to: to)
        return R
    }
    
    static func line(x: CGFloat, y0: CGFloat, y1: CGFloat) -> Path {
        var R = Path()
        R.move(to: .init(x: x, y: y0))
        R.addLine(to: .init(x: x, y: y1))
        return R
    }
    
    static func line(x0: CGFloat, x1: CGFloat, y: CGFloat) -> Path {
        var R = Path()
        R.move(to: .init(x: x0, y: y))
        R.addLine(to: .init(x: x1, y: y))
        return R
    }
    
    static func rect(_ r: CGRect) -> Path {
        var R = Path()
        R.addRect(r)
        return R
    }
    
    static func circle(_ r: CGRect) -> Path {
        var R = Path()
        R.addEllipse(in: r)
        return R
    }
    
    static func from(points: [CGPoint], close: Bool = false) -> Path {
        var R = Path()
        if points.count > 1 {
            R.move(to: points[0])
            for i in 1..<points.count {
                R.addLine(to: points[i])
            }
            if close {
                R.closeSubpath()
            }
        }
        return R
    }
    
}

func + (_ lhs: Path, _ rhs: Path) -> Path {
    var R = lhs
    R.addPath(rhs)
    return R
}
