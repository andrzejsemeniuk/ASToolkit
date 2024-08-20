//
//  ExtensionsForAppKit.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 8/1/22.
//

import Foundation

#if os(macOS)

import AppKit

extension NSBezierPath {
    
    static let twothirds : Double = 2.0/3.0
    
    func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint, fraction: Double = 2.0/3.0) {
        let startPoint = self.currentPoint
        let controlPoint1 = CGPoint(x: (startPoint.x + (controlPoint.x - startPoint.x) * fraction), y: (startPoint.y + (controlPoint.y - startPoint.y) * fraction))
        let controlPoint2 = CGPoint(x: (endPoint.x + (controlPoint.x - endPoint.x) * fraction), y: (endPoint.y + (controlPoint.y - endPoint.y) * fraction))
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    func addArc(withCenter: NSPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        appendArc(withCenter: withCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath:
                    path.closeSubpath()
                case .cubicCurveTo:
                    fatalError()
                case .quadraticCurveTo:
                    path.addQuadCurve(to: points[1], control: points[0])
                @unknown default:
                    break
            }
        }
        return path
    }
    
}



// https://stackoverflow.com/questions/39925248/swift-on-macos-how-to-save-nsimage-to-disk
extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func writePNG(to url: URL, options: Data.WritingOptions = .atomic) throws {
        try pngData?.write(to: url, options: options)
    }
}

#endif
