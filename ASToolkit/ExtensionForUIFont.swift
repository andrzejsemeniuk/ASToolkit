//
//  ExtensionForUIKitUIFont.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/12/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreText

extension UIFont {

    public func highestCharacter() -> UInt32 {
        let characterSet = CTFontCopyCharacterSet(self as CTFont)
        let c = characterSet as NSCharacterSet
        return c.highest
    }

    public func countOfCharacters() -> UInt32 {
        let characterSet = CTFontCopyCharacterSet(self as CTFont)
        let c = characterSet as NSCharacterSet
//        c.characterIsMember(unichar)
        return c.total
    }
    
    public func isMember(character:UInt32) -> Bool {
        if let cs = self.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.characterSet) as? NSCharacterSet {
//            return cs.characterIsMember(unichar(character))
            return cs.longCharacterIsMember(character)
        }
        return false
    }
    
    public func hasGlyph(utf16 character:UInt16) -> Bool {
        var code_point: [UniChar] = [character]
        var glyphs: [CGGlyph] = [0]
        let result = CTFontGetGlyphsForCharacters(self as CTFont, &code_point, &glyphs, glyphs.count)
        return result
    }
    
    public func hasGlyph(utf32 character:UInt32) -> Bool {
        
//        var code_point: [UniChar] = [UInt16(point) & 0xFFFF, UInt16(point >> 16) & 0xFFFF]
        var code_point: [UniChar] = [
            UniChar.init(truncatingIfNeeded: character),
            UniChar.init(truncatingIfNeeded: character >> 16)
        ]
        var glyphs: [CGGlyph] = [0,0]
        let result = CTFontGetGlyphsForCharacters(self as CTFont, &code_point, &glyphs, glyphs.count)
        return result
    }
    
    public func countOfGlyphs() -> Int {
        return CTFontGetGlyphCount(self as CTFont) as Int
    }
    
    public func glyphCharactersUTF16(usingSupportedFonts:Bool = false) -> [UInt16] {
        var result:[UInt16] = []
        if usingSupportedFonts {
            let glypher = Glypher(for: self)
            for i in 0..<UInt16.max {
                let i32 = UInt32(i)
                if glypher.isGlyph(i32) {
                    result.append(i)
                }
            }
        }
        else {
            for i in 0..<UInt16.max {
                if hasGlyph(utf16: i) {
                    result.append(i)
                }
            }
        }
        return result
    }
    
    public func glyphCharactersUTF32(usingSupportedFonts:Bool = false, limitPoint:UInt32 = Glypher.maxPoint) -> [UInt32] {
        var result:[UInt32] = []
        if usingSupportedFonts {
            let glypher = Glypher(for: self)
            for i in 0..<limitPoint {
                let i = UInt32(i)
                if glypher.isGlyph(i) {
                    result.append(i)
                }
            }
        }
        else {
            for i in 0..<limitPoint {
                let i = UInt32(i)
                if hasGlyph(utf32:i) {
                    result.append(i)
                }
            }
        }
        return result
    }

    public var glypher:Glypher {
        return Glypher(for:self)
    }
}

extension UIFont {
    
    static public let defaultFont : UIFont = {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }()
    
    static public let defaultFontForLabel : UIFont = {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }()
    
}

public func + (lhs:UIFont, rhs:CGFloat) -> UIFont {
    return lhs.withSize(lhs.pointSize + rhs)
}

public func - (lhs:UIFont, rhs:CGFloat) -> UIFont {
    return lhs.withSize(rhs < lhs.pointSize ? lhs.pointSize - rhs : 1)
}

public func += (lhs:inout UIFont, rhs:CGFloat) {
    lhs = lhs + rhs
}

public func -= (lhs:inout UIFont, rhs:CGFloat) {
    lhs = lhs - rhs
}

// TODO: MOVE TO OWN FILE
public class Glypher {
    
    fileprivate let font:UIFont
    
    fileprivate var support:[CTFont] = []
    
    fileprivate init(for font:UIFont, languages:[String] = ["en"]) {
        self.font = font
        let languages = languages as CFArray
        let result = CTFontCopyDefaultCascadeListForLanguages(font as CTFont, languages)
        let array = result as! Array<CTFontDescriptor>
        for descriptor in array {
            support.append(CTFontCreateWithFontDescriptor(descriptor,18,nil))
        }
    }
    
    // 12 * 2^16 = 12 * 65336 = 1.1m
    
    public func isGlyph(_ point:UInt32) -> Bool {
        return font.hasGlyph(utf32:point) || isGlyphSupported(point)
    }
    
    public func isGlyphSupported(_ point:UInt32) -> Bool {
        // check in order if point is supported by cascading fonts
        for font in support {
            //            var code_point: [UniChar] = [UInt16(point) & 0xFFFF, UInt16(point >> 16) & 0xFFFF]
            var code_point: [UniChar] = [
                UniChar.init(truncatingIfNeeded: point),
                UniChar.init(truncatingIfNeeded: point >> 16)
            ]
            var glyphs: [CGGlyph] = [0, 0]
            let result = CTFontGetGlyphsForCharacters(font as CTFont, &code_point, &glyphs, glyphs.count)
            if result {
                return true
            }
        }
        return false
    }
    
    public static let pointsPerPlane:UInt32 = UInt32(UInt16.max)
    
    public static func plane(ofPoint point:UInt32) -> UInt? {
        return UInt(point / Glypher.pointsPerPlane)
    }
    
    public static let maxPoint:UInt32 = UInt32(Glypher.pointsPerPlane * UInt32(12))
}
