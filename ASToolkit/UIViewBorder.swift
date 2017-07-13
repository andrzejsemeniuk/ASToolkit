//
//  UIViewBorder.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/2/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public struct UIViewBorderParameters {
    public let thickness        : CGFloat
    public let color            : UIColor
    public let insets           : CGFloat
    
    public init(thickness:CGFloat, color:UIColor, insets:CGFloat) {
        self.thickness      = thickness
        self.color          = color
        self.insets         = insets
    }
}

public class UIViewBorder : UIView {
    
    public enum Style {
        case dash   (space:CGFloat,length:CGFloat)
        case dot    (space:CGFloat,radius:CGFloat)
        case solid  (thickness:CGFloat)
    }
    
    public var sides            : Set<UIViewSide>       = [.top,.left,.bottom,.right]
    public var style            : Style                 = .solid(thickness:1)
    public var color            : UIColor               = .clear
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
