//
//  ExtensionForSwiftUI.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 11/14/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import SwiftUI
//import UIKit
import SpriteKit
import Combine

@available(iOS 13, *)
public extension View {
   
    var inZStack : some View {
        ZStack {
            self
        }
    }
    
    var asAnyView : AnyView {
        AnyView.init(self)
    }
    
    var _av : AnyView {
        AnyView.init(self)
    }

    func padding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
    
    func padding(_ top: CGFloat, _ leading: CGFloat, _ bottom: CGFloat, _ trailing: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
    
    func padding(t: CGFloat, l: CGFloat, b: CGFloat, r: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: t, leading: l, bottom: b, trailing: r))
    }
    
    func padding(top: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: top, leading: 0, bottom: 0, trailing: 0))
    }
    
    func padding(bottom: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: 0, leading: 0, bottom: bottom, trailing: 0))
    }
    
    func padding(leading: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: 0, leading: leading, bottom: 0, trailing: 0))
    }
    
    func padding(trailing: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: trailing))
    }
    
    func padding(h: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: 0, leading: h, bottom: 0, trailing: h))
    }
    
    func padding(v: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: v, leading: 0, bottom: v, trailing: 0))
    }
    
    func padding(h: CGFloat, v: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: v, leading: h, bottom: v, trailing: h))
    }
    
    func padding(v: CGFloat, h: CGFloat) -> some View {
        self.padding(EdgeInsets.init(top: v, leading: h, bottom: v, trailing: h))
    }
    
    
    func offset(_ point: CGPoint) -> some View {
        self.offset(CGSize(width: point.x, height: point.y))
    }
}

@available(iOS 13, *)
public extension Text {
    //    public func fontSize(_ size: CGFloat?) -> Text {
    //        if let size = size {
    //            self.font()
    //        }
    //        return self
    //    }
}

@available(iOS 13, *)
public extension View {

    func fxBlur(radius: CGFloat) -> some View {
        self.blur(radius: radius)
    }
    func fxBlur(radius: CGFloat, opaque: Bool) -> some View {
        self.blur(radius: radius, opaque: opaque)
    }

}

@available(iOS 13, *)
public extension View {
    
    func borderRectangle(
        corner      : CGFloat = 0,
        lineColor   : Color = .black,
        lineWidth   : CGFloat = 1,
        lineCap     : CGLineCap = .butt,
        lineJoin    : CGLineJoin = .miter,
        miterLimit  : CGFloat = 10,
        dash        : [CGFloat] = [CGFloat](),
        dashPhase   : CGFloat = 0) -> some View {
        
        self.overlay(RoundedRectangle.init(cornerRadius: corner)
            .strokeBorder(style: StrokeStyle.init(lineWidth     : lineWidth,
                                                  lineCap       : lineCap,
                                                  lineJoin      : lineJoin,
                                                  miterLimit    : miterLimit,
                                                  dash          : dash,
                                                  dashPhase     : dashPhase))
            .foregroundColor(lineColor)
        )
        
    }
    
    func border(
        corner      : CGFloat = 0,
        lineColor   : Color = .black,
        lineWidth   : CGFloat = 1,
        lineCap     : CGLineCap = .butt,
        lineJoin    : CGLineJoin = .miter,
        miterLimit  : CGFloat = 10,
        dash        : [CGFloat] = [CGFloat](),
        dashPhase   : CGFloat = 0) -> some View {
        
        self.overlay(RoundedRectangle.init(cornerRadius: corner)
            .stroke(lineColor, style: StrokeStyle.init(lineWidth     : lineWidth,
                                                       lineCap       : lineCap,
                                                       lineJoin      : lineJoin,
                                                       miterLimit    : miterLimit,
                                                       dash          : dash,
                                                       dashPhase     : dashPhase))
        )
        
    }
    
    func border(
        color       : Color,
        thickness   : CGFloat                   = 1,
        dash        : [CGFloat]                 = [],
        phase       : CGFloat                   = 0
    ) -> some View {
        self.borderRectangle(corner: 0, lineColor: color, lineWidth: thickness, lineCap: .butt, lineJoin: .bevel, miterLimit: 0, dash: dash, dashPhase: phase)
    }

    func frameUnbounded() -> some View {
        //        return self.edgesIgnoringSafeArea(.all)
        //        return self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func frame(_ w: CGFloat, _ h: CGFloat) -> some View {
        frame(width: w, height: h)
    }

}

//@available(iOS 13, *)
public extension Color {
    
    init(hsba   : [Double], alpha: Double = 1)                      { self.init(hue: hsba[0].clampedTo01, saturation: hsba[1].clampedTo01, brightness: hsba[2].clampedTo01, opacity: hsba[safe: 3]?.clampedTo01 ?? alpha) }
    init(hsb    : [Double], opacity: Double = 1)                    { self.init(hue: hsb[0].clampedTo01, saturation: hsb[1].clampedTo01, brightness: hsb[2].clampedTo01, opacity: opacity.clampedTo01) }
    init(HSBA hsba   : [Double], alpha: Double = 1)                      { self.init(hue: hsba[0].clampedTo01, saturation: hsba[1].clampedTo01, brightness: hsba[2].clampedTo01, opacity: hsba[safe: 3]?.clampedTo01 ?? alpha) }
    init(HSB hsb    : [Double], opacity: Double = 1)                    { self.init(hue: hsb[0].clampedTo01, saturation: hsb[1].clampedTo01, brightness: hsb[2].clampedTo01, opacity: opacity.clampedTo01) }
    init(hsva   : [Double], alpha: Double = 1)                      { self.init(hue: hsva[0].clampedTo01, saturation: hsva[1].clampedTo01, brightness: hsva[2].clampedTo01, opacity: hsva[safe: 3]?.clampedTo01 ?? alpha) }
    init(hsv    : [Double], opacity: Double = 1)                    { self.init(hue: hsv[0].clampedTo01, saturation: hsv[1].clampedTo01, brightness: hsv[2].clampedTo01, opacity: opacity.clampedTo01) }
    init(hue    : Double, opacity: Double = 1)                      { self.init(hue: hue.clampedTo01, saturation: 1, brightness: 1, opacity: opacity.clampedTo01) }
    init(rgba   : [Double])                                         { self.init(red: rgba[0].clampedTo01, green: rgba[1].clampedTo01, blue: rgba[2].clampedTo01, opacity: rgba[3].clampedTo01) }
    init(rgb    : [Double], opacity: Double = 1)                    { self.init(red: rgb[0].clampedTo01, green: rgb[1].clampedTo01, blue: rgb[2].clampedTo01, opacity: opacity.clampedTo01) }
    init(RGBA rgba: [Double])                                         { self.init(red: rgba[0].clampedTo01, green: rgba[1].clampedTo01, blue: rgba[2].clampedTo01, opacity: rgba[3].clampedTo01) }
    init(RGB rgb  : [Double], opacity: Double = 1)                    { self.init(red: rgb[0].clampedTo01, green: rgb[1].clampedTo01, blue: rgb[2].clampedTo01, opacity: opacity.clampedTo01) }

    static func hsba    (_ hsba     : [Double])                                         -> Color { Color.init(hsba: hsba) }
    static func hsba    (_ h: Double, _ s: Double, _ b: Double, _ a: Double)            -> Color { Color.init(hsba: [h,s,b,a]) }
    static func hsb     (_ hsb      : [Double], opacity: Double = 1)                    -> Color { Color.init(hsb: hsb, opacity: opacity) }
    static func hsb     (_ h: Double, _ s: Double, _ b: Double)                         -> Color { Color.init(hsb: [h,s,b]) }
    static func hsva    (_ hsva     : [Double])                                         -> Color { Color.init(hsva: hsva) }
    static func hsv     (_ hsv      : [Double], opacity: Double = 1)                    -> Color { Color.init(hsv: hsv) }
    static func hue     (_ hue      : Double, opacity: Double = 1)                      -> Color { Color.init(hue: hue, opacity: opacity) }
    static func rgba    (_ rgba     : [Double])                                         -> Color { Color.init(rgba: rgba) }
    static func rgb     (_ rgb      : [Double], opacity: Double = 1)                    -> Color { Color.init(rgb: rgb, opacity: opacity) }

    init(white: Double, alpha: Double)                              { self.init(rgba: [white,white,white,alpha]) }

    static let whites : [Color] = [
        .init(white: 1, alpha: 0.05),
        .init(white: 1, alpha: 0.1),
        .init(white: 1, alpha: 0.2),
        .init(white: 1, alpha: 0.3),
        .init(white: 1, alpha: 0.4),
        .init(white: 1, alpha: 0.5),
        .init(white: 1, alpha: 0.6),
        .init(white: 1, alpha: 0.7),
        .init(white: 1, alpha: 0.8),
        .init(white: 1, alpha: 0.9),
    ]
    
    static let blacks : [Color] = [
        .init(white: 0, alpha: 0.05),
        .init(white: 0, alpha: 0.1),
        .init(white: 0, alpha: 0.2),
        .init(white: 0, alpha: 0.3),
        .init(white: 0, alpha: 0.4),
        .init(white: 0, alpha: 0.5),
        .init(white: 0, alpha: 0.6),
        .init(white: 0, alpha: 0.7),
        .init(white: 0, alpha: 0.8),
        .init(white: 0, alpha: 0.9),
    ]
    
    static let brown    = Color.init(hsb: [0.07, 0.8, 0.8])
    static let beige    = Color.init(hsb: [0.10, 0.6, 0.8])
    
    static let gray1    = Color.init(white: 0.1)
    static let gray2    = Color.init(white: 0.2)
    static let gray25   = Color.init(white: 0.25)
    static let gray3    = Color.init(white: 0.3)
    static let gray35   = Color.init(white: 0.35)
    static let gray4    = Color.init(white: 0.4)
    static let gray45   = Color.init(white: 0.45)
    static let gray48   = Color.init(white: 0.48)
    static let gray5    = Color.init(white: 0.5)
    static let gray55   = Color.init(white: 0.55)
    static let gray6    = Color.init(white: 0.6)
    static let gray65   = Color.init(white: 0.65)
    static let gray66   = Color.init(white: 0.66)
    static let gray67   = Color.init(white: 0.67)
    static let gray68   = Color.init(white: 0.68)
    static let gray69   = Color.init(white: 0.69)
    static let gray7    = Color.init(white: 0.7)
    static let gray75   = Color.init(white: 0.75)
    static let gray8    = Color.init(white: 0.8)
    static let gray81   = Color.init(white: 0.81)
    static let gray82   = Color.init(white: 0.82)
    static let gray83   = Color.init(white: 0.83)
    static let gray84   = Color.init(white: 0.84)
    static let gray85   = Color.init(white: 0.85)
    static let gray86   = Color.init(white: 0.86)
    static let gray87   = Color.init(white: 0.87)
    static let gray88   = Color.init(white: 0.88)
    static let gray89   = Color.init(white: 0.89)
    static let gray9    = Color.init(white: 0.9)
    static let gray91   = Color.init(white: 0.91)
    static let gray92   = Color.init(white: 0.92)
    static let gray93   = Color.init(white: 0.93)
    static let gray94   = Color.init(white: 0.94)
    static let gray95   = Color.init(white: 0.95)
    static let gray96   = Color.init(white: 0.96)
    static let gray97   = Color.init(white: 0.97)
    static let gray98   = Color.init(white: 0.98)
    static let gray99   = Color.init(white: 0.99)
    
    static let transparent = Color.init(white: 1, alpha: 0.00001)
    
    static let almostTransparent = Color.init(white: 1, alpha: 0.001)
    
    static var offWhite = Color.init(hsba: [0, 0, 0.94, 1])
    
    var name : String { self.description }
    
    #if os(iOS) || os(tvOS)
    func uiColor(_ c: UIColor = .white) -> UIKit.UIColor {
        UIColor(self)
//        if let rgba = name.rgba {
//            return UIKit.UIColor.init(r: CGFloat(rgba.r) / CGFloat(255.0) , g: CGFloat(rgba.g) / CGFloat(255.0) , b: CGFloat(rgba.b) / CGFloat(255.0) , a: CGFloat(rgba.a) / CGFloat(255.0) )
//        } else {
//            return c
//        }
    }

    func asUIColor(_ c: UIColor = .white) -> UIKit.UIColor {
        uiColor(c)
    }
    
    var hsva : [Double] {
        self.uiColor(.purple).arrayOfHSBA.map { Double($0) }
    }

    var hsba : [Double] {
        self.uiColor(.purple).arrayOfHSBA.map { Double($0) }
    }
    #endif
    
    var asSKColor : SKColor {
        SKColor.init(hsba: self.hsba.asArrayOfCGFloat)
    }
    
    #if os(macOS)
    func nsColor() -> NSColor {
        NSColor(self)
    }

    var asNSColor : NSColor {
//        NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor(self).usingColorSpace(.extendedSRGB) ?? NSColor(self).usingColorSpace(.genericRGB) ?? NSColor(self)
//        NSColor(self) // crash during getHue() for some colors ... requires setting colorspace
        NSColor(self).usingColorSpace(.deviceRGB)!
//        NSColor(self).usingColorSpace(.extendedSRGB)!
//        NSColor(self).usingColorSpace(.genericRGB)!
    }
    
    var hsva : [Double] {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        var a : CGFloat = 1
        asNSColor.getHue(&h, saturation: &s, brightness: &v, alpha: &a) // crash if NSColor has not set colorspace
        
//        https://stackoverflow.com/questions/15682923/convert-nscolor-to-rgb
//        NSColor *testColor = [[NSColor colorWithCalibratedWhite:0.65 alpha:1.0] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
        
        return [h,s,v,a]
    }

    var hsba : [Double] {
        hsva
    }
    #endif

    var isBlack : Bool {
        name == "black"
    }
    
    var isWhite : Bool {
        name == "white"
    }
    
    func inverseBlackOrWhite(_ min: CGFloat = 0, _ mid: CGFloat = 0.5, _ max: CGFloat = 1.0) -> Color {
        let hsva0 = hsva
        return Color.init(HSBA: [hsva0[0],0,hsva0[2] < mid ? max : min,hsva0[3]])
    }
    
    struct HSBA : Codable, Equatable {
        
        public enum Component : CaseIterable {
            case hue, saturation, brightness, alpha
        }
        
        public var h       : CGFloat
        public var s       : CGFloat
        public var b       : CGFloat
        public var a       : CGFloat
        
        public var asSKColor            : SKColor       { SKColor.init(hsba: [h,s,b,a]) }
        public var asUIColor            : UIColor       { UIColor.init(hsba: [h,s,b,a]) }
        public var asColor              : Color         { Color.init(hsba: [h.asDouble,s.asDouble,b.asDouble,a.asDouble]) }
        public var asArrayOfDouble      : [Double]      { [h,s,b,a].asArrayOfDouble }
        public var asArrayOfCGFloat     : [CGFloat]     { [h,s,b,a] }
        public var asString             : String        { "\(h),\(s),\(b),\(a)" }

        public init(h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1) {
            self.h = h
            self.s = s
            self.b = b
            self.a = a
        }
        
        public init(white: CGFloat, alpha: CGFloat = 1) {
            h = 0
            s = 0
            b = white
            a = alpha
        }
        
        public init(from: SKColor) {
            let hsba = from.arrayOfHSBA
            h = hsba[0].clampedTo01
            s = hsba[1].clampedTo01
            b = hsba[2].clampedTo01
            a = hsba[3].clampedTo01
        }
        
        public init(from: Color) {
            self.init(hsba: from.hsva)
        }
        
        public init(hsba: [Double]) {
//            print("0 Color.HSBA.init(hsba: \(hsba))")
            h = hsba[0].asCGFloat.clampedTo01
            s = hsba[1].asCGFloat.clampedTo01
            b = hsba[2].asCGFloat.clampedTo01
            a = hsba[3].asCGFloat.clampedTo01
//            print("1 Color.HSBA.init(hsba: \(hsba)), hsba=\(h),\(s),\(b),\(a)")
        }

        public init(hsb: [Double], a alpha: CGFloat = 1) {
            print("0 Color.HSBA.init(hsb: \(hsb))")
            h = hsb[0].asCGFloat.clampedTo01
            s = hsb[1].asCGFloat.clampedTo01
            b = hsb[2].asCGFloat.clampedTo01
            a = alpha.clampedTo01
            print("1 Color.HSBA.init(hsb: \(hsb)), hsba=\(h),\(s),\(b),\(a)")
        }

        public static let clear     : HSBA = .init(white: 1, alpha: 0)
        public static let black     : HSBA = .init(white: 0, alpha: 0)
        public static let white     : HSBA = .init(white: 1, alpha: 1)

        public static func white(_ value: CGFloat, opacity: CGFloat) -> HSBA {
            .init(white: value, alpha: opacity)
        }
        public static func white(_ value: CGFloat, alpha: CGFloat) -> HSBA {
            .init(white: value, alpha: alpha)
        }

        public var isClear          : Bool { a <= 0 }
        public var isTransparent    : Bool { a <= 0 }
        public var isOpaque         : Bool { a > 0 }
        
        public func get(component: Component) -> CGFloat {
            switch component {
                case .hue           : return h
                case .saturation    : return s
                case .brightness    : return b
                case .alpha         : return a
            }
        }
        
        mutating public func set(component: Component, _ v: CGFloat) {
            let v = v.clampedTo01
            switch component {
                case .hue           : h = v
                case .saturation    : s = v
                case .brightness    : b = v
                case .alpha         : a = v
            }
        }

    }

}

public extension Array where Element == Double {
    var asColorHSBA     : Color     { .init(hsba: self) }
    var asColorHSB      : Color     { .init(hsb: self) }
    var asColorRGBA     : Color     { .init(rgba: self) }
    var asColorRGB      : Color     { .init(rgb: self) }
    var asUIColorHSBA   : UIColor   { UIColor.init(hsba: self.asArrayOfCGFloat) }
    var asUIColorHSB    : UIColor   { UIColor.init(hsb: self.asArrayOfCGFloat) }
    var asUIColorRGBA   : UIColor   { UIColor.init(rgba: self.asArrayOfCGFloat) }
    var asUIColorRGB    : UIColor   { UIColor.init(rgb: self.asArrayOfCGFloat) }
}

public extension Array where Element == CGFloat {
    var asColorHSBA     : Color     { .init(hsba: self.asArrayOfDouble) }
    var asColorHSB      : Color     { .init(hsb: self.asArrayOfDouble) }
    var asColorRGBA     : Color     { .init(rgba: self.asArrayOfDouble) }
    var asColorRGB      : Color     { .init(rgb: self.asArrayOfDouble) }
    var asUIColorHSBA   : UIColor   { UIColor.init(hsba: self) }
    var asUIColorHSB    : UIColor   { UIColor.init(hsb: self) }
    var asUIColorRGBA   : UIColor   { UIColor.init(rgba: self) }
    var asUIColorRGB    : UIColor   { UIColor.init(rgb: self) }
}

@available(iOS 13, *)
public extension ViewDimensions {
    
    func ratio(w: CGFloat) -> CGFloat {
        w * width
    }
    
    func ratio(h: CGFloat) -> CGFloat {
        h * height
    }
    
}

@available(iOS 13, *)
public extension ForEach where Content : View {
    
    //    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content)
    
    //    public init(array: Array<Data.Element>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
    //        self.init(0..<array.count, id: \.self, content: { index in
    //            content(array[index])
    //        })
    //    }
    
}

/*
 @available(iOS 13, *)
 struct NilView : View {
 
 var body: some View {
 EmptyView()
 }
 }
 
 @available(iOS 13, *)
 struct ConditionView<Content> : View where Content : View {
 
 let condition                   : ()->Bool
 @ViewBuilder  let contentWhenConditionIsTrue  : ()->Content
 @ViewBuilder  let contentWhenConditionIsFalse : ()->Content
 
 init(condition: @escaping ()->Bool, @ViewBuilder ifTrue: @escaping ()->Content, @ViewBuilder ifFalse: @escaping ()->Content = { NilView() } ) {
 self.condition = condition
 self.contentWhenConditionIsTrue = ifTrue
 self.contentWhenConditionIsFalse = ifFalse
 }
 
 init(_ flag: Bool, @ViewBuilder ifTrue: @escaping ()->Content, @ViewBuilder ifFalse: @escaping ()->Content = { NilView() } ) {
 self.condition = { flag }
 self.contentWhenConditionIsTrue = ifTrue
 self.contentWhenConditionIsFalse = ifFalse
 }
 
 var body: some View {
 if condition() {
 return contentWhenConditionIsTrue()
 } else {
 return contentWhenConditionIsTrue()
 }
 }
 
 }
 
 // ConditionView(condition: { self.x > 0 }, ifTrue: { Text("Yes") }, ifFalse: { Text("No") })
 */


@available(iOS 13, *)
public struct Lines : View {
    
    public init(horizontal  : Bool,
                offsets     : [CGFloat]     = [],
                ratios      : [CGFloat]     = [],
                color       : Color         = .gray,
                lineWidth   : CGFloat       = 1,
                lineCap     : CGLineCap     = .butt,
                lineJoin    : CGLineJoin    = .miter,
                miterLimit  : CGFloat       = 10,
                dash        : [CGFloat]     = [],
                dashPhase   : CGFloat       = 0
    ) {
        self._horizontal    = State.init(initialValue: horizontal)
        self._offsets       = State.init(initialValue: offsets)
        self._ratios        = State.init(initialValue: ratios)
        self._color         = State.init(initialValue: color)
        self._lineWidth     = State.init(initialValue: lineWidth)
        self._lineCap       = State.init(initialValue: lineCap)
        self._lineJoin      = State.init(initialValue: lineJoin)
        self._miterLimit    = State.init(initialValue: miterLimit)
        self._dash          = State.init(initialValue: dash)
        self._dashPhase     = State.init(initialValue: dashPhase)
    }
    
    @State var horizontal   : Bool
    
    @State var offsets      : [CGFloat]     = []
    @State var ratios       : [CGFloat]     = []
    @State var color        : Color         = .gray
    @State var lineWidth    : CGFloat       = 1
    @State var lineCap      : CGLineCap     = .butt
    @State var lineJoin     : CGLineJoin    = .miter
    @State var miterLimit   : CGFloat       = 10
    @State var dash         : [CGFloat]     = []
    @State var dashPhase    : CGFloat       = 0
    
    var style               : StrokeStyle  {
        .init(lineWidth     : lineWidth,
              lineCap       : lineCap,
              lineJoin      : lineJoin,
              miterLimit    : miterLimit,
              dash          : dash,
              dashPhase     : dashPhase)
    }
    
    public static func create(horizontal: Bool, offsets: [CGFloat] = [0], ratios: [CGFloat] = [], color: Color, style: StrokeStyle) -> Lines {
        .init(horizontal    : horizontal,
              offsets       : offsets,
              ratios        : ratios,
              color         : color,
              lineWidth     : style.lineWidth,
              lineCap       : style.lineCap,
              lineJoin      : style.lineJoin,
              miterLimit    : style.miterLimit,
              dash          : style.dash,
              dashPhase     : style.dashPhase)
    }
    
    public static func horizontal(color: Color, style: StrokeStyle) -> Lines {
        .init(horizontal    : true,
              offsets       : [0],
              ratios        : [],
              color         : color,
              lineWidth     : style.lineWidth,
              lineCap       : style.lineCap,
              lineJoin      : style.lineJoin,
              miterLimit    : style.miterLimit,
              dash          : style.dash,
              dashPhase     : style.dashPhase)
    }
    
    public static func vertical(color: Color, style: StrokeStyle) -> Lines {
        .init(horizontal    : false,
              offsets       : [0],
              ratios        : [],
              color         : color,
              lineWidth     : style.lineWidth,
              lineCap       : style.lineCap,
              lineJoin      : style.lineJoin,
              miterLimit    : style.miterLimit,
              dash          : style.dash,
              dashPhase     : style.dashPhase)
    }
    
    public var body : some View {
        GeometryReader { proxy in
            Path() { path in
                for ratio in self.ratios {
                    if self.horizontal {
                        path.move(to: .init(x: 0, y: ratio * proxy.size.height))
                        path.addLine(to: .init(x: proxy.size.width, y: ratio * proxy.size.height))
                    } else {
                        path.move(to: .init(x: ratio * proxy.size.width, y: 0))
                        path.addLine(to: .init(x: ratio * proxy.size.width, y: proxy.size.height))
                    }
                }
                for offset in self.offsets {
                    if self.horizontal {
                        path.move(to: .init(x: 0, y: offset < 0 ? proxy.size.height + offset : offset))
                        path.addLine(to: .init(x: proxy.size.width, y: offset < 0 ? proxy.size.height + offset : offset))
                    } else {
                        path.move(to: .init(x: offset < 0 ? proxy.size.width + offset : offset, y: 0))
                        path.addLine(to: .init(x: offset < 0 ? proxy.size.width + offset : offset, y: proxy.size.height))
                    }
                }
            }
            .strokedPath(self.style)
        }
            //        .frame(width: nil, height: self.horizontal && self.ratios.isEmpty && self.offsets.count == 1 && self.offsets.first! == 0 ? self.lineWidth : nil) //proxy.size.height)
            .foregroundColor(self.color)
    }
    
}


@available(iOS 13, *)
public extension EdgeInsets {
    
    init(_ all: CGFloat) { self.init(top: all, leading: all, bottom: all, trailing: all) }
    
    init(top: CGFloat) { self.init(top: top, leading: 0, bottom: 0, trailing: 0) }
    init(leading: CGFloat) { self.init(top: 0, leading: leading, bottom: 0, trailing: 0) }
    init(bottom: CGFloat) { self.init(top: 0, leading: 0, bottom: bottom, trailing: 0) }
    init(trailing: CGFloat) { self.init(top: 0, leading: 0, bottom: 0, trailing: trailing) }
    
    init(h: CGFloat) { self.init(top: 0, leading: h, bottom: 0, trailing: h) }
    init(v: CGFloat) { self.init(top: v, leading: 0, bottom: v, trailing: 0) }
    init(h: CGFloat, v:CGFloat) { self.init(top: v, leading: h, bottom: v, trailing: h) }

    init(t: CGFloat, b: CGFloat, l: CGFloat, r: CGFloat) { self.init(top: t, leading: l, bottom: b, trailing: r) }

    static let zero : EdgeInsets = .init()
    
}


@available(iOS 13, *)
public struct LayeredSystemImage : View {
    
    public init(foregroundSystemName: String, foregroundColor: Color = Color.blue, foregroundScale: CGFloat = 1, backgroundSystemName: String, backgroundColor: Color = Color.white) {
        self.foregroundSystemName = foregroundSystemName
        self.foregroundColor = foregroundColor
        self.foregroundScale = foregroundScale
        self.backgroundSystemName = backgroundSystemName
        self.backgroundColor = backgroundColor
    }
    
    
    
    public var foregroundSystemName    : String
    
    public var foregroundColor         : Color = Color.blue
    
    public var foregroundScale         : CGFloat = 1
    
    public var backgroundSystemName    : String
    
    public var backgroundColor         : Color = Color.white
    
    
    public var body : some View {
        
        Image(systemName: foregroundSystemName)
            .scaleEffect(CGSize.init(width: foregroundScale, height: foregroundScale))
            .foregroundColor(foregroundColor)
            .background(Image(systemName: backgroundSystemName)
                //                .scaleEffect(CGSize.init(side: 1.0/foregroundScale))
                .foregroundColor(backgroundColor))
        
    }
    
}

@available(iOS 13, *)
public class EnumeratedHashableIdentifiableElement<T : Hashable> : Hashable, Identifiable {
    
    public static func == (lhs: EnumeratedHashableIdentifiableElement, rhs: EnumeratedHashableIdentifiableElement) -> Bool {
        lhs.index == rhs.index && lhs.element == rhs.element
    }
    
    public func hash(into hasher: inout Hasher) {
        //        hasher.combine(element)
        hasher.combine("\(index)\(element)")
    }
    
    public var index : Int
    public var element : T
    
    public var id:Int {
        index
    }
    
    public init(index: Int, element: T) {
        self.index = index
        self.element = element
    }
    
    public static func from(array collection: [T]) -> [EnumeratedHashableIdentifiableElement<T>] {
        collection.enumerated().map { .init(index: $0, element: $1) }
    }
}



//@available(iOS 13, *)
//public extension View {
    
    func hline(_ color: Color, _ thickness: CGFloat = 1, discrete: [Int]) -> some View {
        hline(color, thickness, discrete.asArrayOfCGFloat)
    }

    func hline(_ color: Color, _ thickness: CGFloat = 1, _ dash: [CGFloat] = []) -> some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: thickness/2))
                path.addLine(to: .init(x: geometry.size.width, y: thickness/2))
            }
            .strokedPath(.init(lineWidth: thickness, dash: dash))
        }
        .frame(height:thickness)
        .foregroundColor(color)
    }
    
    func hline(color: Color, width thickness: CGFloat, cap: CGLineCap, join: CGLineJoin, limit: CGFloat = 10, phase: CGFloat = 0, pattern dash: [CGFloat]) -> some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: thickness/2))
                path.addLine(to: .init(x: geometry.size.width, y: thickness/2))
            }
            .strokedPath(.init(lineWidth: thickness, lineCap: cap, lineJoin: join, miterLimit: limit, dash: dash, dashPhase: phase))
        }
        .frame(height:thickness)
        .foregroundColor(color)
    }


    func vline(_ color: Color, _ thickness: CGFloat = 1, discrete: [Int]) -> some View {
        vline(color, thickness, discrete.asArrayOfCGFloat)
    }

    func vline(_ color: Color, _ thickness: CGFloat = 1, _ dash: [CGFloat] = []) -> some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: thickness/2, y: 0))
                path.addLine(to: .init(x: thickness/2, y: geometry.size.height))
            }
            .strokedPath(.init(lineWidth: thickness, dash: dash))
        }
        .frame(width:thickness)
        .foregroundColor(color)
    }
    
    func separator(color: Color = Color.gray7, thickness: CGFloat = 1, dash: [CGFloat] = []) -> some View {
        hline(color, thickness, dash)
//        Lines.create(horizontal: true, color: Color.gray7, style: StrokeStyle.init(lineWidth: 1, lineCap: .butt, lineJoin: .bevel, miterLimit: 0, dash: [], dashPhase: 0))
//            .frame(height:1)
    }



func zigzag(points: [CGPoint], color: Color, width thickness: CGFloat, cap: CGLineCap, join: CGLineJoin, limit: CGFloat = 10, phase: CGFloat = 0, pattern dash: [CGFloat]) -> some View {
    GeometryReader { geometry in
        Path { path in
            guard points.isNotEmpty else { return }
            path.move(to: points[0])
            for i in points.range {
                if i > 0 {
                    path.addLine(to: points[i])
                }
            }
        }
        .strokedPath(.init(lineWidth: thickness, lineCap: cap, lineJoin: join, miterLimit: limit, dash: dash, dashPhase: phase))
    }
    .foregroundColor(color)
}



//}







@available(iOS 13, *)
public extension View {
    
    
    func frame(side: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: side, height: side, alignment: alignment)
    }

//    static var neomorphicFillColorDefault = Color.offWhite
    
    func neomorphic(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        return self
            .background(
                RoundedRectangle.init(cornerRadius: radius)
                    .fill(fill)
                    .shadow(color: Color.black.opacity(opacity), radius: depth, x: depth, y: depth)
                    .shadow(color: Color.white.opacity(1.0-opacity), radius: depth/2, x: -depth/2, y: -depth/2)
        )
    }
    
    func neomorphicCapsule(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        return self
            .background(
                Capsule.init()
                    .fill(fill)
                    .shadow(color: Color.black.opacity(opacity), radius: depth, x: depth, y: depth)
                    .shadow(color: Color.white.opacity(1.0-opacity), radius: depth/2, x: -depth/2, y: -depth/2)
        )
    }
    
    func neomorphicCircle(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        return self.background(Circle().neomorphic(fill: fill, opacity: opacity, depth: depth, radius: radius))
    }
    
    func neomorphicRectangle(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        return self
            .background(
                Rectangle.init()
                    .fill(fill)
                    .shadow(color: Color.black.opacity(opacity), radius: depth, x: depth, y: depth)
                    .shadow(color: Color.white.opacity(1.0-opacity), radius: depth/2, x: -depth/2, y: -depth/2)
        )
    }
    
    func neomorphicRoundedRectangle(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        return self
            .background(
                RoundedRectangle.init(cornerRadius: radius)
                    .fill(fill)
                    .shadow(color: Color.black.opacity(opacity), radius: depth, x: depth, y: depth)
                    .shadow(color: Color.white.opacity(1.0-opacity), radius: depth/2, x: -depth/2, y: -depth/2)
        )
    }

}

@available(iOS 13, *)
public extension Circle {
    
    func neomorphic(fill: Color = Color.offWhite, opacity: Double = 0.2, depth: CGFloat = 8, radius: CGFloat = 16) -> some View {
        Circle.init()
            .fill(fill)
            //                    .frame(side: radius/2)
            .shadow(color: Color.black.opacity(opacity), radius: depth, x: depth, y: depth)
            .shadow(color: Color.white.opacity(1.0-opacity), radius: depth/2, x: -depth/2, y: -depth/2)
    }
        
}

@available(iOS 13, *)
public extension View {
    
    func neomorphicHint() -> some View {
        self
            .neomorphic(depth: 3, radius: 16)
    }
    
    func neomorphicHintForPicks() -> some View {
        self
            .neomorphic(fill: .gray5, depth: 3, radius: 16)
    }
    
    func neomorphicButton(enabled: Bool = true, on: Bool, color: Color = Color.orange) -> some View {
        self
            .neomorphic(fill: enabled ? color : Color.gray8, depth: 4, radius: 16)
    }
    
    func styleForHint(_ font: Font, disabled: Bool) -> some View {
        self
            //            .font(Font.custom("Gill Sans", size: 10))
            .font(font)
            .font(.caption)
//            .foregroundColor(disabled ? Color.gray4.opacity(0.4) : Color.gray4)
            .foregroundColor(disabled ? Color.blue.opacity(0.3) : Color.blue)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .padding(6)
//            .neomorphicHint()
        //            .background(disabled ? Color.gray4 : Color.clear)
    }
    
    func styleForHintForPicks(_ font: Font) -> some View {
        self
            //            .font(Font.custom("Gill Sans", size: 10))
            .font(font)
            .font(.caption)
            .foregroundColor(.white)
            //                .shadow(color: .gray5, radius: 4, x: 0, y: 0)
            .padding(6)
            .neomorphicHintForPicks()
    }
    
    
    func opaque(_ flag: Bool) -> some View {
        self
            .opacity(flag ? 1 : 0)
    }
    
}


@available(iOS 13, *)
public extension HorizontalAlignment {

    private enum HCenterAlignment: AlignmentID {

        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            return dimensions[HorizontalAlignment.center]
        }

    }

    static let hCentered = HorizontalAlignment(HCenterAlignment.self)
}





@available(iOS 13, *)
public struct CorrectedScrollView<Content> : View where Content : View {
    
    
    @State private var offset : CGPoint = .zero
    
    var axes : Axis.Set = [.horizontal, .vertical]
    
    var showsIndicators = false
    
    @State var content : ()->Content
    
    
    public var body : some View {
        
        ScrollView(axes, showsIndicators: showsIndicators) {
            
            content()
                .background(geometryReader)
                .offset(x: offset.x, y: offset.y)
            
        }
    }
    
    
    private var geometryReader : some View {
        
        GeometryReader { geometry in
            
            AsyncBlockView {
                
                let offset : CGPoint = CGPoint.init(
                    x: -geometry.frame(in: .global).minX,
                    y: -geometry.frame(in: .global).minY
                )
                
                if self.offset == .zero {
                    self.offset = offset
                }
                
            }
            
        }
        
    }
    
    
}


@available(iOS 13, *)
public struct AsyncBlockView : View {
    
    @State var view     : ()->AnyView = {
        AnyView(Rectangle().fill(Color.clear))
    }
    
    var block           : ()->()
    
    public var body            : some View {
        
        DispatchQueue.main.async {
            self.block()
        }
        
        return view()
    }
    
}



@available(iOS 13, *)
public struct HalfCapsule : Shape {
    
    public var offset      : CGFloat
    public var padding     : CGFloat
    public var mirrored    : Bool
    
    public init(offset: CGFloat = 0, padding: CGFloat = 0, mirrored: Bool = false) {
        self.offset     = offset
        self.padding    = padding
        self.mirrored   = mirrored
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let d = (rect.height + padding + padding)/2
        
        let x0 = rect.minX + offset //- padding
        let x1 = rect.maxX + padding
        let y0 = rect.minY - padding
        let y1 = rect.maxY + padding
        
        path.move(to: CGPoint(x: x0 - d/2, y: y1))
        path.addLine(to: CGPoint(x: x0 + d/2, y: y0 ))
        path.addLine(to: CGPoint(x: x1 - d/2, y: y0))
        path.addArc(center: CGPoint(x: x1 - d/2, y: y0 + d), radius: d, startAngle: Angle.init(degrees: +90), endAngle: Angle.init(degrees: -90), clockwise: true)
        path.addLine(to: CGPoint(x: x1 - d/2, y: y1))
        path.addLine(to: CGPoint(x: x0 - d/2, y: y1))
        
        if mirrored {
            path = path.applying(.init(translationX: -rect.midX, y: -rect.midY))
            path = path.applying(.init(scaleX: -1, y: -1))
            path = path.applying(.init(translationX: rect.midX, y: rect.midY))
        }
        
        return path
    }
    
}



@available(iOS 13, *)
public struct Pie : Shape {
    
    public var start           : Angle
    public var value           : Binding<Double>
    //        var bg              : (_ value: Double)->Color = { value in .gray }
    //        var fg              : (_ value: Double)->Color = { value in .gray9 }
    public var offset      : CGFloat
    public var padding     : CGFloat
    public var mirrored    : Bool
    
    
    public init(value: Binding<Double>, start: Angle = Angle.init(degrees: -90), offset: CGFloat = 0, padding: CGFloat = 0, mirrored: Bool = false) {
        self.value      = value
        self.start      = start
        self.offset     = offset
        self.padding    = padding
        self.mirrored   = mirrored
    }
    
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let r = min(rect.height,rect.width)/2
        
        //            let x0 = rect.minX + offset //- padding
        //            let x1 = rect.maxX + padding
        //            let y0 = rect.minY - padding
        //            let y1 = rect.maxY + padding
        //
        //            path.move(to: CGPoint(x: x0 - d/2, y: y1))
        //            path.addLine(to: CGPoint(x: x0 + d/2, y: y0 ))
        //            path.addLine(to: CGPoint(x: x1 - d/2, y: y0))
        //            path.addArc(center: CGPoint(x: x1 - d/2, y: y0 + d), radius: d, startAngle: Angle.init(degrees: +90), endAngle: Angle.init(degrees: -90), clockwise: true)
        //            path.addLine(to: CGPoint(x: x1 - d/2, y: y1))
        //            path.addLine(to: CGPoint(x: x0 - d/2, y: y1))
        
        path.move(to: rect.center)
        //            path.addArc(center: rect.center, radius: r, startAngle: start, endAngle: Angle.init(degrees: (value.wrappedValue*360.0)-start.degrees), clockwise: false)
        
        if mirrored {
            let angle = Angle.init(degrees: start.degrees - (value.wrappedValue*360.0))
            path.addArc(center: rect.center, radius: r, startAngle: start, endAngle: angle, clockwise: true)
        } else {
            let angle = Angle.init(degrees: (value.wrappedValue*360.0)-start.degrees)
            path.addArc(center: rect.center, radius: r, startAngle: start, endAngle: angle, clockwise: false)
        }
        
        
        return path
    }
    
}

#if os(iOS)
@available(iOS 13, *)
public struct ActivityIndicator: UIViewRepresentable {
    
    public init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style) {
        self.isAnimating = isAnimating
        self.style = style
    }
    

    var isAnimating: Binding<Bool>
    
    let style: UIActivityIndicatorView.Style

    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating.wrappedValue ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
#endif


@available(iOS 13, *)
public extension View {
    
    func disabledWithColor(_ flag: Bool) -> some View {
        self
            .opacity(flag ? 0.25 : 1) // TODO COLOR FROM STYLE
            .saturation(flag ? 0 : 1) // TODO COLOR FROM STYLE
            .disabled(flag)
    }
}

@available(iOS 13, *)
public extension String {
    
    func color(_ default: Color = .red) -> Color {
//        counter += 1
        if let rgba = self.rgba {
//            print("[\(counter)] color name recognized: \(self) = \(rgba)")
            return Color.init(red: Double(rgba.r) / 255.0, green: Double(rgba.g) / 255.0, blue: Double(rgba.b) / 255.0, opacity: Double(rgba.a) / 255.0)
        } else {
//            print("[\(counter)] color name unrecognized: \(self)")
            switch self {
                case "accent"       : return .accentColor
                case "accentColor"  : return .accentColor
                case "black"        : return .black
                case "blue"         : return .blue
                case "clear"        : return .clear
                case "gray"         : return .gray
                case "green"        : return .green
                case "orange"       : return .orange
                case "pink"         : return .pink
                case "primary"      : return .primary
                case "purple"       : return .purple
                case "red"          : return .red
                case "secondary"    : return .secondary
                case "white"        : return .white
                case "yellow"       : return .yellow
                
                default             : return `default`
            }
        }
    }
    
    var rgba : (r: UInt8, g: UInt8, b: UInt8, a: UInt8)? {
        
        // "#AB0C4DFF
        let trimmed = self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard trimmed.length == 8 && self[0] == "#" else {
            return nil
        }
        let scanner = Scanner(string: trimmed)
        var hexNumber: UInt64 = 0
        //        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0
        var a: UInt8 = 0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = UInt8((hexNumber & 0xff000000) >> 24)
            g = UInt8((hexNumber & 0x00ff0000) >> 16)
            b = UInt8((hexNumber & 0x0000ff00) >> 8)
            a = UInt8(hexNumber  & 0x000000ff)
            return (r, g, b, a)
        }
        return nil
    }
        
}

//@available(iOS 13, *)
//public struct TestStruct : View {
//    public init(lines: [String], v: String = "v") {
//        self._lines = State.init(initialValue: lines)
//        self.v = v
//    }
//
//
//    @State private var lines: [String]
//
//    private var v: String = "v"
//
//    public var body: some View {
//        Text("lines: \(lines.count), v:\(v)")
//    }
//}

@available(iOS 13, *)
public struct LinesOfStringsStack<Content> : View where Content : View {
    
    public init(lines: [[String]], vspacing: CGFloat = 8, hspacing: CGFloat = 8, alignment: HorizontalAlignment = .center, builder: @escaping (String) -> Content) {
        self._lines = State.init(initialValue: lines)
        self._vspacing = State.init(initialValue: vspacing)
        self._hspacing = State.init(initialValue: hspacing)
        self._alignment = State.init(initialValue: alignment)
        self.builder = builder
    }
    

    @State public var lines : [[String]]

    @State var vspacing : CGFloat
    @State var hspacing : CGFloat
    @State var alignment : HorizontalAlignment

    let builder : (String) -> Content

    public var body : some View {
//        HStack {
//            Spacer()
        VStack(alignment: self.alignment, spacing: vspacing) {
                ForEach(lines, id: \.self) { line in
                    HStack(spacing: hspacing) {
                        ForEach(line, id: \.self) { word in
                            self.builder(word)
                        }
                    }
                }
            }
//            Spacer()
//        }
    }
}

public extension View {
    func width(_ v: CGFloat) -> some View {
        self.frame(minWidth: v, idealWidth: v, maxWidth: v)
    }
    func height(_ v: CGFloat) -> some View {
        self.frame(minHeight: v, idealHeight: v, maxHeight: v)
    }
}

public extension View {
    func circleBorder(color: Color, bg: Color = .clear, thickness: CGFloat, dash: [CGFloat] = []) -> some View {
        self
            .background(Circle().fill(bg))
            .overlay(Circle().strokeBorder(color, style: .init(lineWidth: thickness, lineCap: .butt, lineJoin: .miter, miterLimit: 1, dash: dash, dashPhase: 0)))
    }
    
    func hCentered() -> some View {
        self.alignmentGuide(HorizontalAlignment.hCentered, computeValue: { $0.width / 2 })
    }
}

@available(iOS 13, *)
public struct OrEmptyView<VIEW> : View where VIEW : View {
    
//    condition: Binding<SharkeeApp.Model.LoadState>.init(get: { self.model.loadState(for: name) }, set: { _ in }),

    public init(condition: Binding<Bool>, view: VIEW) {
        self.condition = condition
        self._view = State.init(initialValue: view)
    }

    var condition  : Binding<Bool>
    
    @State var view         : VIEW
    
    public var body: some View {
        if condition.wrappedValue {
            view
        } else {
            EmptyView()
        }
    }
}

public extension Binding {

    init(get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }

    static func get(_ get: @escaping () -> Value) -> Binding<Value> {
        Binding<Value>.init(get: get, set: { _ in })
    }

    static func constant(_ value: Value) -> Binding<Value> {
        Binding<Value>.init(get: { value }, set: { _ in })
    }
}

public extension View {
    
    func visible(_ flag: Bool) -> AnyView {
        if flag {
            return self.asAnyView
        } else {
            return EmptyView().asAnyView
        }
    }
}

public extension Color {
    
    struct HSBASpans : Codable {
        
        public struct Span : Codable {
            public var v0 : CGFloat
            public var v1 : CGFloat?
            
            public var isRange : Bool {
                v1 != nil
            }
            
            public init(v0: CGFloat = 1, v1: CGFloat? = nil) {
                self.v0 = v0
                self.v1 = v1
            }
        }
        
        public var h   : Span
        public var s   : Span
        public var b   : Span
        public var a   : Span
        
        public init(h: Span = .init(),
                    s: Span = .init(),
                    b: Span = .init(),
                    a: Span = .init())
        {
            self.h = h
            self.s = s
            self.b = b
            self.a = a
        }
    }
    
}

#if os(iOS)
public struct Blur: UIViewRepresentable {
    
    public var style: UIBlurEffect.Style = .systemMaterial

    public init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    // create UIView
    public func makeUIView(context: Context) -> UIVisualEffectView {
        var r = UIVisualEffectView(effect: UIBlurEffect(style: style))
//        r.alpha = 0.5 // does not blur when alpha/opacity is < 1
        return r
    }

    // update UIView
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

public extension View {
    
    var isPhone : Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isPad : Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isMac : Bool {
        UIDevice.current.userInterfaceIdiom == .mac
    }
    
    var idiom : UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
    
    var isLandscape : Bool {
        UIDevice.current.orientation.isLandscape
    }
    
    var isPortrait : Bool {
        UIDevice.current.orientation.isPortrait
    }
}


public struct TapGestureWithLocation : UIViewRepresentable {
    
    public typealias Callback = (CGPoint) -> Void
    
    var tappedCallback: Callback

    public init(_ callback: @escaping Callback) {
        self.tappedCallback = callback
    }
    
    public func makeUIView(context: UIViewRepresentableContext<TapGestureWithLocation>) -> UIView {
        let mappingYToV = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.tapped))
        mappingYToV.addGestureRecognizer(gesture)
        return mappingYToV
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TapGestureWithLocation>) {
    }

    public class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)
        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.viewForChartMonthly10years)
            self.tappedCallback(point)
        }
    }

    public func makeCoordinator() -> TapGestureWithLocation.Coordinator {
        Coordinator(tappedCallback:self.tappedCallback)
    }
}




extension UIView {
    var screenshot : UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil) {
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
        }

        return image
    }
}

struct SaveScreenshotView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let someView = UIView(frame: UIScreen.main.bounds)
        _ = someView.screenshot
        return someView
    }

    func updateUIView(_ viewForChartMonthly10years: UIView, context: Context) {
    }
}

#endif



#if os(macOS)

public extension Scene {
    
    func defaultSizeFullscreen(size: CGSize = .init(1024, 768)) -> some Scene {
        self.defaultSize(NSScreen.main?.frame.size ?? size)
    }
}

public extension View {
    
    func defaultSizeFullscreen(size: CGSize = .init(1024, 768)) -> some View {
        self.frame(NSScreen.main!.frame.size.width,NSScreen.main!.frame.size.height)
//        self.frame(size: NSScreen.main!.frame.size)
//        return self.frame(size: NSScreen.main?.frame.size ?? size)
    }
    
}

#endif

public extension UnitPoint {
    
    func asAlignment(_ fallback: Alignment = .center) -> Alignment {
        if self == .bottom { return .bottom }
        if self == .top { return .top }
        if self == .leading { return .leading }
        if self == .trailing { return .trailing }
        if self == .center { return .center }
        return fallback
    }
}

public extension Alignment {
    
    var asUnitPoint : UnitPoint {
        switch self {
            case .center                    : return .init(x: 0, y: 0)
                
            case .top                       : return .init(x: 0, y: +1)
            case .bottom                    : return .init(x: 0, y: -1)
            case .leading                   : return .init(x: -1, y: 0)
            case .trailing                  : return .init(x: +1, y: 0)

            case .topLeading                : return .init(x: -1, y: +1)
            case .topTrailing               : return .init(x: +1, y: +1)
            case .bottomLeading             : return .init(x: -1, y: -1)
            case .bottomTrailing            : return .init(x: +1, y: -1)
                
            default:
                return .init()
        }
    }
}


extension View {
    func onAppearStartTimer(_ seconds: TimeInterval, _ block: @escaping Block) -> some View {
        self
            .onAppear {
                Timer.publish(every: seconds, on: .main, in: .default)
                    .autoconnect()
                    .sink { (_) in
                        block()
                    }
                    .store(in: &cancellables)
            }
    }
    
}

fileprivate var cancellables = Set<AnyCancellable>()







//extension View {
    
    struct ViewSize : Equatable, Codable {
        
        struct Length : Equatable, Codable {
            
            enum Kind : Equatable, Codable {
                case unbound, unspecified, fixed, min, max, infinity
                
                var usesPixels : Bool {
                    switch self {
                        case .unbound, .unspecified, .infinity:
                            return false
                        case .min, .fixed, .max:
                            return true
                    }
                }
            }
            
            var kind : Kind = .unbound
            var pixels : CGFloat = 256
            
            var usesPixels : Bool {
                kind.usesPixels
            }
        }
        
        var width  : Length
        var height : Length
        
        func frame(width on: some View, proportion: CGFloat = 1) -> some View {
            Group {
                switch width.kind {
                    case .unspecified:
                        on
                    case .unbound:
                        on.frame(maxWidth: nil)
                    case .infinity:
                        on.frame(maxWidth: .infinity)
                    case .fixed:
                        on.frame(width: width.pixels * proportion)
                    case .min:
                        on.frame(minWidth: width.pixels * proportion)
                    case .max:
                        on.frame(maxWidth: width.pixels * proportion)
                }
            }
        }
        
        func frame(height on: some View, proportion: CGFloat = 1) -> some View {
            Group {
                switch height.kind {
                    case .unspecified:
                        on
                    case .unbound:
                        on.frame(maxHeight: nil)
                    case .infinity:
                        on.frame(maxHeight: .infinity)
                    case .fixed:
                        on.frame(height: height.pixels * proportion)
                    case .min:
                        on.frame(minHeight: height.pixels * proportion)
                    case .max:
                        on.frame(maxHeight: height.pixels * proportion)
                }
            }
        }
        
        func frame(on: some View, hfactor : CGFloat = 1, vfactor: CGFloat = 1) -> some View {
            frame(width: frame(height: on, proportion: vfactor), proportion: hfactor)
        }
        
    }
    

extension View {
    
    func frame(size: ViewSize, hfactor : CGFloat = 1, vfactor: CGFloat = 1) -> some View {
        size.frame(on: self, hfactor: hfactor, vfactor: vfactor)
    }
    
}

extension EdgeInsets : RawRepresentable {
    
    public typealias RawValue = String

    public init?(rawValue: String) {
        let SPLIT = rawValue.splitByComma
        self.init(top: SPLIT[safe: 0]?.asCGFloat ?? 0, leading: SPLIT[safe: 1]?.asCGFloat ?? 0, bottom: SPLIT[safe: 2]?.asCGFloat ?? 0, trailing: SPLIT[safe: 3]?.asCGFloat ?? 0)
    }
    
    public var rawValue: String {
        "\(top),\(bottom),\(leading),\(trailing)"
    }
}


// https://stackoverflow.com/questions/57577462/get-width-of-a-view-using-in-swiftui

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func save(size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
