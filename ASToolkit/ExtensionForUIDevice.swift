//
//  ExtensionForUIControl.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension UIDevice {

    static var isPhone : Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isPad : Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isMac : Bool {
        UIDevice.current.userInterfaceIdiom == .mac
    }
    
    static func idiomized<T>(phone: T, pad: T, mac: T) -> T {
        if UIDevice.isPhone { return phone }
        if UIDevice.isPad { return pad }
        return mac
    }
    
    static func idiomized<T>(phone: T, pad: T, _ mac: T) -> T {
        if UIDevice.isPhone { return phone }
        if UIDevice.isPad { return pad }
        return mac
    }
    
    static func idiomized<T>(phone: T, _ otherwise: T) -> T {
        if UIDevice.isPhone { return phone }
        return otherwise
    }
    
}
