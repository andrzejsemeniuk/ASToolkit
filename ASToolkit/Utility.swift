//
//  Utility.swift
//  ASToolkit
//
//  Created by Andrzej Semeniuk on 3/23/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

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


















