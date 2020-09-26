//
//  ExtensionForSwiftUI.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 11/14/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13, *)
extension Text {
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
                    radius      : CGFloat = 0,
                    lineColor   : Color = .black,
                    lineWidth   : CGFloat = 1,
                    lineCap     : CGLineCap = .butt,
                    lineJoin    : CGLineJoin = .miter,
                    miterLimit  : CGFloat = 10,
                    dash        : [CGFloat] = [CGFloat](),
                    dashPhase   : CGFloat = 0) -> some View {
        self.overlay(RoundedRectangle.init(cornerRadius: radius)
            .strokeBorder(style: StrokeStyle.init(lineWidth     : lineWidth,
                                                  lineCap       : lineCap,
                                                  lineJoin      : lineJoin,
                                                  miterLimit    : miterLimit,
                                                  dash          : dash,
                                                  dashPhase     : dashPhase))
            .foregroundColor(lineColor)
        )
    }
    
    
}

@available(iOS 13, *)
public extension Color {
    
    init(hsba:[Double]) {
        self.init(hue: hsba[0], saturation: hsba[1], brightness: hsba[2], opacity: hsba[3])
    }
    init(hsb:[Double], opacity: Double = 1) {
        self.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2], opacity: opacity)
    }
    
    init(rgba:[Double]) {
        self.init(red: rgba[0], green: rgba[1], blue: rgba[2], opacity: rgba[3])
    }
    init(rgb:[Double], opacity: Double = 1) {
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2], opacity: opacity)
    }
}

@available(iOS 13, *)
extension HorizontalAlignment {
    
    private enum HCenterAlignment: AlignmentID {
        
        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            return dimensions[HorizontalAlignment.center]
        }
        
    }
    
    static public let hCentered = HorizontalAlignment(HCenterAlignment.self)
}


