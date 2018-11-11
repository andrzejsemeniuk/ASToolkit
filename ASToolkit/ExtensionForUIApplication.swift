//
//  ExtensionForUIApplication.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 4/29/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication
{
    static public var rootViewController : UIViewController! {
        return UIApplication.shared.keyWindow!.rootViewController
    }    
}

