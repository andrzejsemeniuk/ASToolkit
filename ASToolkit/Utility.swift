//
//  Utility.swift
//  productWikieHere
//
//  Created by Andrzej Semeniuk on 3/23/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public struct TGF
{
    public struct Environment
    {
        public static let IDIOM             = UIDevice.current.userInterfaceIdiom
        public static let SCREEN            = UIScreen.main.bounds.size
        
        public struct Screen
        {
            static let WIDTH                = Int(UIScreen.main.bounds.size.width)
            static let HEIGHT               = Int(UIScreen.main.bounds.size.height)
            static let LENGTH1              = max(WIDTH, HEIGHT)
            static let LENGTH0              = min(WIDTH, HEIGHT)
            static let DIAGONAL             = Int(sqrt(Double(WIDTH*WIDTH+HEIGHT*HEIGHT)))
            static let CENTER               = CGPoint(x:Double(WIDTH)/2.0,y:Double(HEIGHT)/2.0)
            static func diagonal(_ fraction:CGFloat = 1) -> CGFloat {
                return CGFloat(DIAGONAL) * fraction
            }
            
        }
        
        public struct DeviceType
        {
            static let IPHONE4              = UIDevice.current.userInterfaceIdiom == .phone && Screen.LENGTH1 < 568
            static let IPHONE5              = UIDevice.current.userInterfaceIdiom == .phone && Screen.LENGTH1 == 568
            static let IPHONE6              = UIDevice.current.userInterfaceIdiom == .phone && Screen.LENGTH1 == 667
            static let IPHONE6p             = UIDevice.current.userInterfaceIdiom == .phone && Screen.LENGTH1 == 736
            static let IPAD                 = UIDevice.current.userInterfaceIdiom == .pad   && Screen.LENGTH1 == 1024
            static let IPADPRO              = UIDevice.current.userInterfaceIdiom == .pad   && Screen.LENGTH1 == 1366
        }
        
    }
    
    public struct Utility
    {
        
    }
}

public struct UITableViewTap
{
    public let path:IndexPath
    public let point:CGPoint
    
    public init(path:IndexPath, point:CGPoint) {
        self.path = path
        self.point = point
    }
}



extension UIApplication
{
    static var rootViewController : UIViewController! {
        return UIApplication.shared.keyWindow!.rootViewController
    }
    
}





func NOT(_ A:Bool) -> Bool
{
    return !A
}

func AND(_ A:Bool,_ B:Bool) -> Bool
{
    return A && B
}

func NAND(_ A:Bool,_ B:Bool) -> Bool
{
    return NOT(AND(A,B))
}

func OR(_ A:Bool,_ B:Bool) -> Bool
{
    return A || B
}

func NOR(_ A:Bool,_ B:Bool) -> Bool
{
    return NOT(OR(A,B))
}

func XOR(_ A:Bool,_ B:Bool) -> Bool
{
    return (A && !B) || (!A && B)
}


















