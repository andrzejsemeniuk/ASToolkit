//
//  UIViewCircle.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/9/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

//public class UICircleButton : UIButton {
//    
//    override public init(frame: CGRect) {
//        
//    }
//    
//    override public func draw(_ rect: CGRect) {
//        
//    }
//}


public class UIViewCircle : UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = min(frame.size.width,frame.size.height)/2
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
