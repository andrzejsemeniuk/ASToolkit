//
//  ExtensionForUIWindow.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 4/29/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    public static func createMainWindow() -> UIWindow {
        let window                  = UIWindow()
        
        window.screen               = UIScreen.main
        window.bounds               = window.screen.bounds
        window.windowLevel          = UIWindow.Level.normal
        
        return window
    }

    public static func createMainWindow(withRootViewController controller:UIViewController!, makeKey:Bool = false) -> UIWindow {
        let window                  = UIWindow.createMainWindow()
        
        window.rootViewController   = controller
        
        if makeKey {
            window.makeKeyAndVisible()
        }
        
        return window
    }
    
}
