//
//  UIGlyph.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/9/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreText
import CoreGraphics
import UIKit

public class UIGlyph {
    
    static public func calculateSize(of:String, withFont font:UIFont) -> CGSize {
        
        let ctFont = CTFontCreateWithNameAndOptions(font.fontName as CFString, font.pointSize, nil, [])
        
        var ctGlyph = CTFontGetGlyphWithName(ctFont, of as CFString)
        
        let count = of.characters.count

        let boundingBox = withUnsafePointer(to: &ctGlyph) { pointer -> CGRect in
            /*!
             @function   CTFontGetOpticalBoundsForGlyphs
             @abstract   Calculates the optical bounding rects for an array of glyphs and returns the overall optical bounding rect for the run.
             
             @discussion Fonts may specify the optical edges of glyphs that can be used to make the edges of lines of text line up in a more visually pleasing way. This function returns bounding rects corresponding to this information if present in a font, otherwise it returns typographic bounding rects (composed of the font's ascent and descent and a glyph's advance width).
             
             @param      font
             The font reference.
             
             @param      glyphs
             An array of count number of glyphs.
             
             @param      boundingRects
             An array of count number of CGRects to receive the computed glyph rects. Can be NULL, in which case only the overall bounding rect is calculated.
             
             @param      count
             The capacity of the glyphs and boundingRects buffers.
             
             @param      options
             Reserved, set to zero.
             
             @result     This function returns the overall bounding rectangle for an array or run of glyphs. The bounding rects of the individual glyphs are returned through the boundingRects parameter. These are the design metrics from the font transformed in font space.

             public func CTFontGetOpticalBoundsForGlyphs(   _ font: CTFont,
                                                            _ glyphs: UnsafePointer<CGGlyph>!,
                                                            _ boundingRects: UnsafeMutablePointer<CGRect>?,
                                                            _ count: CFIndex,
                                                            _ options: CFOptionFlags) -> CGRect

             */
            return CTFontGetOpticalBoundsForGlyphs(ctFont,
                                                   pointer,
                                                   nil,
                                                   count,
                                                   0)
//            return CTFontGetBoundingRectsForGlyphs(ctFont,
//                                                   CTFontOrientation.`default`,
//                                                   pointer,
//                                                   nil,
//                                                   1)
        }
        return boundingBox.size
    }
    
    static public func calculateBBox(of:NSAttributedString) -> CGRect {
        
        let context:CGContext? = nil
        
        // http://stackoverflow.com/questions/11739561/core-text-height-of-glyph
        
        let line:CTLine = CTLineCreateWithAttributedString(of as CFAttributedString)
        let runArray:CFArray = CTLineGetGlyphRuns(line)
        var result = CGRect()
        for element in runArray as NSArray {
            let run = element as! CTRun
            let range:CFRange = CFRangeMake(0, CTRunGetGlyphCount(run))
            var glyphRect:CGRect = CTRunGetImageBounds(run, context, range)
            if true {
                let range = CTRunGetStringRange(run)
                let from = range.location
                let to = from+range.length
                print("calculateBBox(of:(\(of.string))): run:(\(of.string.substring(from: from, to: to))) -> glyphRect:(\(glyphRect))")
            }
            glyphRect.origin.x += result.maxX
            result = result.union(glyphRect)
        }

        return result
    }

    static public func calculateBBox(of:String, withFont font:UIFont) -> CGRect {
        return calculateBBox(of: of | font)
    }
    
    static public func calculateSize(of:NSAttributedString,rounded:Bool=true) -> CGSize {
        var bbox = calculateBBox(of: of)
        bbox.size.width -= bbox.origin.x
        bbox.size.height -= bbox.origin.y
        if rounded {
            bbox.size.width = ceil(bbox.size.width)
            bbox.size.height = ceil(bbox.size.height)
        }
        return bbox.size
    }
}
