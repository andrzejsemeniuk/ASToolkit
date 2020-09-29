//
//  UILabelWithInsets.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class UILabelWithInsets: UILabel {
    
    open var insets : UIEdgeInsets = UIEdgeInsets() {
        didSet {
            super.invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }
    
    override open func drawText(in rect: CGRect) {
        return super.drawText(in: rect.inset(by: insets))
    }
    
}

open class UITextFieldWithInsets: UITextField {
    
    open var insets : UIEdgeInsets = UIEdgeInsets() {
        didSet {
            super.invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }
    
    override open func drawText(in rect: CGRect) {
        return super.drawText(in: rect.inset(by: insets))
    }
    
}
