//
//  ExtensionForFoundationUserDefaults.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UserDefaults
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

extension UserDefaults {
    public func set(string:String, forKey:String) {
        set(string, forKey: forKey)
    }
    public func set(bool:Bool, forKey:String) {
        set(bool, forKey: forKey)
    }
    public func set(date:Date, forKey:String) {
        set(date, forKey: forKey)
    }
    public func date(forKey string:String) -> Date? {
        return value(forKey: string) as? Date
    }
}


