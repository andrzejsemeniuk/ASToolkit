//
//  ExtensionForUIKitUISlider.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UISlider {
    
    open func setValue(_ value:Float, withAnimationDuration duration:Double) {
        UIView.animate(withDuration: duration) {
            self.setValue(value, animated: true)
        }
    }
    
}
