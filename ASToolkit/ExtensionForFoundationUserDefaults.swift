//
//  ExtensionForFoundationUserDefaults.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension UserDefaults
{
    public class func clear()
    {
        let domain      = Bundle.main.bundleIdentifier
        
        let defaults    = UserDefaults.standard
        
        if let name = domain {
            defaults.removePersistentDomain(forName: name)
        }
    }
}

public extension UserDefaults {
    open func date(forKey key:String) -> Date? {
        return value(forKey: key) as? Date
    }
    
    @nonobjc
    open func set(_ value:UIColor, forKey:String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        set(data, forKey: forKey)
    }
    
    open func color(forKey:String) -> UIColor? {
        if let data = value(forKey: forKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
        }
        return nil
    }
    
    @nonobjc
    open func set(_ value:UIFont, forKey:String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        set(data, forKey: forKey)
    }
    
    open func font(forKey:String) -> UIFont? {
        if let data = value(forKey: forKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIFont
        }
        return nil
    }
}


