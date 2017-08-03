//
//  GenericSetting.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/26/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class GenericSetting<TYPE> : Removable, Resettable, FromDictionary, ToDictionary {
    
    public typealias Key = String
    
    public let key         : Key
    public let first       : TYPE
    public var value       : TYPE {
        willSet (newValue) {
            self.store(newValue)
        }
    }
    
    public init(key:String, first:TYPE) {
        self.key = key
        self.first = first
        self.value = first
        
        if let stored = self.stored {
            self.value = stored
        }
        else {
            store(first)
        }
    }

    open func assign(_ value:TYPE?) {
        if value != nil {
            self.value = value!
        }
    }
    
    open func from(dictionary:[String:Any]) {
        if let value = dictionary[key] as? TYPE {
            self.value = value
        }
    }

    open func to(dictionary:inout [String:Any]) {
        dictionary[key] = self.value
    }
    
    open func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    open func reset() {
        self.value = first
    }
    
    private func store(_ n:TYPE) {
        if n is UIColor {
            UserDefaults.standard.set(n as! UIColor, forKey: key)
        }
        else if n is UIFont {
            UserDefaults.standard.set(n as! UIFont, forKey: key)
        }
        else {
            UserDefaults.standard.set(n, forKey: key)
        }
    }
    
    internal var stored:TYPE? {
        if first is UIColor             { return UserDefaults.standard.color(forKey: key) as? TYPE }
        if first is UIFont              { return UserDefaults.standard.font(forKey: key) as? TYPE }
        
        return UserDefaults.standard.value(forKey: key) as? TYPE
    }
    

}

// TODO: ADD STORAGE-PROTOCOL BASED ON TYPE: SET/GET/REMOVE/UPDATE
// TODO: ADD DEFAULT USER-DEFAULTS IMPLEMENTATION
// TODO: ADD FACTORY PROTOCOL
// TODO: ADD USER-DEFAULTS FACTORY
// TODO: ADD CORE-DATA FACTORY?
// TODO: ADD DYNAMIC GETTER/SETTER CLOSURES/DELEGATES
// TODO: ADD ABILITY TO SPECIFY IF VALUE WILL BE SAVED WHEN SET

