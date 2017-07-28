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
    static public var rootViewController : UIViewController! {
        return UIApplication.shared.keyWindow!.rootViewController
    }
    
}



public func not(_ A:Bool) -> Bool
{
    return !A
}

public func and(_ A:Bool,_ B:Bool) -> Bool
{
    return A && B
}

public func nand(_ A:Bool,_ B:Bool) -> Bool
{
    return not(and(A,B))
}

public func or(_ A:Bool,_ B:Bool) -> Bool
{
    return A || B
}

public func nor(_ A:Bool,_ B:Bool) -> Bool
{
    return not(or(A,B))
}

public func xor(_ A:Bool,_ B:Bool) -> Bool
{
    return (A && !B) || (!A && B)
}


















