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

	public func sibling(withPhrase phrase:String) -> UIFont? {
		if let name = UIFont.fontNames(forFamilyName: familyName).find({ $0.lowercased().range(of:phrase) != nil }) {
			return UIFont.init(name: name, size: self.pointSize)
		}
		return nil
	}

	public func siblings(withPhrase phrase:String) -> [UIFont] {
		return UIFont.fontNames(forFamilyName: familyName).filter({ $0.lowercased().range(of:phrase) != nil }).flatMap {
			UIFont.init(name: $0, size: self.pointSize)
		}
	}

	public func boldSibling() -> UIFont? { return sibling(withPhrase:"bold") }
	public func boldSiblings() -> [UIFont] { return siblings(withPhrase:"bold") }
	public func italicSibling() -> UIFont? { return sibling(withPhrase:"italic") }
	public func italicSiblings() -> [UIFont] { return siblings(withPhrase:"italic") }

}

extension UIFont {
    
    static public let defaultFont : UIFont = {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }()
    
    static public let defaultFontForLabel : UIFont = {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }()

	static public let defaultFontForSmallSize : UIFont = {
		return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
	}()

}

extension UIFont {

	public var fontFace : String {
		return fontName.split(familyName).last ?? ""
	}

	static public func compactedFamilyName(from: String) -> String {
		return from.replacingOccurrences(of: " ", with: "")
	}

	static public var compactedFamilyNames : [String] = {
		var r : [String] = []

		for family in UIFont.familyNames {
			r.append(UIFont.compactedFamilyName(from:family))
		}

		return r.sorted()
	}()

	static public var faceNames : [String] = {
		var faces : Set<String> = .init()

		faces.insert("")

		// "TimesNewRomanPS-Italic"
		// "TimesNewRoman" = condensed family name
		// "PS" = "Post Script" = TM qualifier
		// "Italic" = face name
		// FamilyName + [TM Qualifier] + ['-' + FaceName]

		// given an extended font name, get family/face
		for family in UIFont.familyNames {
			for name in UIFont.fontNames(forFamilyName: family) {
				let chunks = name.split("-")
				if let suffix = chunks[safe:1] {
//					print("name=\(name) suffix=\(suffix)")
					faces.insert(suffix)
				}
//				let family = UIFont.compactedFamilyName(from: family)
//				faces.insert(name.split(family).last ?? "")
			}
		}

		return faces.asArray.sorted()
	}()

	static public var fontNames : [String] = {
		var names : [String] = []

		for family in UIFont.familyNames {
			names += UIFont.fontNames(forFamilyName: family)
		}

		return names.sorted()
	}()

	public func siblings() -> [UIFont] {
		var r = [UIFont]()
		for phrase in UIFont.faceNames {
			r += self.siblings(withPhrase: phrase)
		}
		return r
	}

	static public var familiesAndNames : [String : [String]] = {
		var r : [String : [String]] = [:]
		for family in UIFont.familyNames {
			r[family] = UIFont.fontNames(forFamilyName: family)
		}
		return r
	}()

	static public func familiesAndNames(families: [String], names phrases:[String]) -> [String : [String]] {
		var r : [String : [String]] = [:]
		for (family,names) in UIFont.familiesAndNames {
			var v : [String] = []

			if families.isEmpty || families.contains(family) {
				v = phrases.isEmpty ? names : names.filter({
					for phrase in phrases {
						if $0.contains(phrase) {
							return true
						}
					}
					return false
				})
			}

			if v.isNotEmpty {
				r[family, default: []].append(contentsOf: v)
			}
		}
		return r
	}
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
