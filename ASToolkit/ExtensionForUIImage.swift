//
//  ExtensionForUIKitUIImage.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/21/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    func tinted(withColor color: UIColor) -> UIImage {
        
        var image = withRenderingMode(.alwaysTemplate)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()

        return image
    }
    

}
