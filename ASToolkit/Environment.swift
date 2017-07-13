//
//  Environment.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 7/13/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public struct Environment
{
    public static let idiom             = UIDevice.current.userInterfaceIdiom
    public static let size              = UIScreen.main.bounds.size
    
    public struct Screen
    {
        static let width                = Int(UIScreen.main.bounds.size.width)
        static let height               = Int(UIScreen.main.bounds.size.height)
        static let side1                = max(width, height)
        static let side0                = min(width, height)
        static let diagonal0            = Int(sqrt(Double(width*width+height*height)))
        static let center               = CGPoint(x:Double(width)/2.0,y:Double(height)/2.0)
        
        static func diagonal(_ fraction:CGFloat = 1) -> CGFloat {
            return CGFloat(diagonal0) * fraction
        }
        
    }
    
    public struct DeviceType
    {
        static let iPhone4              = UIDevice.current.userInterfaceIdiom == .phone && Screen.side1 < 568
        static let iPhone5              = UIDevice.current.userInterfaceIdiom == .phone && Screen.side1 == 568
        static let iPhone6              = UIDevice.current.userInterfaceIdiom == .phone && Screen.side1 == 667
        static let iPhone6plus          = UIDevice.current.userInterfaceIdiom == .phone && Screen.side1 == 736
        static let iPad                 = UIDevice.current.userInterfaceIdiom == .pad   && Screen.side1 == 1024
        static let iPadPro              = UIDevice.current.userInterfaceIdiom == .pad   && Screen.side1 == 1366
    }
    
}
