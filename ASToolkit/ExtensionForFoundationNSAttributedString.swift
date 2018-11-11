//
//  ExtensionForUIKitNSAttributedString.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    public subscript(_ text:String) -> NSRange {
        if let r = self.string.range(of: text) {
            let from = self.string.distance(from:self.string.startIndex, to:r.lowerBound)
            let to   = self.string.distance(from:self.string.startIndex, to:r.upperBound)
            return NSRange(location: from, length: to - from)
        }
        return NSRange()
    }
}

extension NSMutableAttributedString {
    
}



public func << (lhs:NSAttributedString, rhs:NSAttributedString) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString:lhs)
    r.append(rhs)
    return r
}

public func <<= (lhs:inout NSAttributedString, rhs:NSAttributedString) {
    lhs = lhs << rhs
}

public func += (lhs:inout NSAttributedString, rhs:NSAttributedString) {
    lhs = lhs << rhs
}

public func <<= (lhs:inout NSMutableAttributedString, rhs:NSAttributedString) {
    lhs.setAttributedString(lhs << rhs)
}

public func += (lhs:inout NSMutableAttributedString, rhs:NSAttributedString) {
    lhs.setAttributedString(lhs << rhs)
}




public func | (string:String,color:UIColor) -> NSAttributedString {
    let r = NSMutableAttributedString(string:string)
    r.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location:0,length:r.length))
    return r
}

public func | (string:NSAttributedString,color:UIColor) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location:0,length:r.length))
    return r
}


public func | (string:String,font:UIFont) -> NSAttributedString {
    let r = NSMutableAttributedString(string: string)
    r.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location:0,length:r.length))
    return r
}

public func | (string:NSAttributedString,font:UIFont) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location:0,length:r.length))
    return r
}


public func | (string:NSAttributedString,attributes:[NSAttributedStringKey:Any]) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttributes(attributes, range: NSRange(location: 0,length: r.length))
    return r
}

public func | (string:String,attributes:[NSAttributedStringKey:Any]) -> NSAttributedString {
    let r = NSMutableAttributedString(string: string)
    r.addAttributes(attributes, range: NSRange(location: 0,length: r.length))
    return r
}


public func | (string:NSAttributedString,tuple:(attributes:[NSAttributedStringKey:Any],range:NSRange)) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttributes(tuple.attributes, range: tuple.range)
    return r
}

public func | (string:String,tuple:(attributes:[NSAttributedStringKey:Any],range:NSRange)) -> NSAttributedString {
    let r = NSMutableAttributedString(string: string)
    r.addAttributes(tuple.attributes, range: tuple.range)
    return r
}


public func | (string:NSAttributedString,tuple:(name:String,value:Any)) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttributes([NSAttributedStringKey(rawValue: tuple.name):tuple.value], range: NSRange(location: 0,length: r.length))
    return r
}

public func | (string:String,tuple:(name:String,value:Any)) -> NSAttributedString {
    let r = NSMutableAttributedString(string:string)
    r.addAttributes([NSAttributedStringKey(rawValue: tuple.name):tuple.value], range: NSRange(location: 0,length: r.length))
    return r
}




public func | (a:String,b:NSAttributedString) -> NSAttributedString {
    let r = NSMutableAttributedString(string:a)
    r.append(b)
    return r
}




public func | (a:NSAttributedString,b:NSAttributedString) -> NSAttributedString {
    let r = NSMutableAttributedString(attributedString: a)
    r.append(b)
    return r
}

public func |= (a:inout NSAttributedString,b:NSAttributedString)  {
    a = a | b
}







public func |= (string:inout NSAttributedString, color:UIColor) {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location:0,length:r.length))
    string = r
}

public func |= (string:inout NSAttributedString, font:UIFont) {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location:0,length:r.length))
    string = r
}

public func |= (string:inout NSAttributedString, attributes:[NSAttributedStringKey:Any]) {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttributes(attributes, range: NSRange(location: 0,length: r.length))
    string = r
}

public func |= (string:inout NSAttributedString, tuple:(attributes:[NSAttributedStringKey:Any],range:NSRange)) {
    let r = NSMutableAttributedString(attributedString: string)
    r.addAttributes(tuple.attributes, range: tuple.range)
    string = r
}


