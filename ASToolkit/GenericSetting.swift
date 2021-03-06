//
//  GenericSetting.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/26/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

// TODO: ADD STORAGE-PROTOCOL BASED ON TYPE: SET/GET/REMOVE/UPDATE
// TODO: ADD DEFAULT USER-DEFAULTS IMPLEMENTATION
// TODO: ADD FACTORY PROTOCOL
// TODO: ADD USER-DEFAULTS FACTORY
// TODO: ADD CORE-DATA FACTORY?
// TODO: ADD DYNAMIC GETTER/SETTER CLOSURES/DELEGATES
// TODO: ADD ABILITY TO SPECIFY IF VALUE WILL BE SAVED WHEN SET

open class GenericSetting<TYPE> : CustomStringConvertible, Keyable, Removable, Resettable, AssignableFromDictionary, AssignableToDictionary {
    
    public typealias Key = String
    
    public let key          : Key
    public let first        : TYPE
    
    public var check        : ((TYPE)->(TYPE?))?
    public var inform       : ((TYPE)->())?
    
    public var value        : TYPE {
        didSet {
            if let check = check, let other = check(value) {
                self.value = other
            }
            else {
                store(value)
                inform?(value)
            }
        }
    }
    
    public init                     (key:String, first:TYPE, check:((TYPE)->TYPE?)? = nil) {
        self.key        = key
        self.first      = first
        self.value      = first
        self.check      = check
        
        if let stored = self.stored {
            self.value  = stored
        }
        else {
            store(first)
        }
    }

    open func set                   (_ value:TYPE) {
        assign(value)
    }
    
    open func assign                (_ value:TYPE?) {
        if let value = value {
            self.value = value
        }
    }
    
    open func assign                (fromDictionary dictionary:[String:Any]) {
        if let data = dictionary[key] as? Data {
            assign(NSKeyedUnarchiver.unarchiveObject(with: data) as? TYPE)
        }
    }

    open func assign                (toDictionary dictionary:inout [String:Any]) {
        dictionary[key] = NSKeyedArchiver.archivedData(withRootObject: value)
    }
    
    open func remove                () {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    open func reset                 () {
        self.value = first
    }
    
    open func store                 (_ n:TYPE) {
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
    
    open var stored                 : TYPE? {
        if first is UIColor             { return UserDefaults.standard.color(forKey: key) as? TYPE }
        if first is UIFont              { return UserDefaults.standard.font(forKey: key) as? TYPE }
        
        return UserDefaults.standard.value(forKey: key) as? TYPE
    }
    
    open var description            : String {
        return "GenericSetting<\(first.self)>(key:(\(key)), first:(\(first)), value:(\(value))"
    }
}

//open class GenericSettingWithObserver<TYPE> : GenericSetting<TYPE> {
//    
//    public var observer                 : ((GenericSetting<TYPE>)->())?
//    
//    override open var value             : TYPE {
//        didSet {
//            observer?(self)
//        }
//    }
//}

open class GenericSettingOfArrayOfUIColor : GenericSetting<[UIColor]> {
    
    override open func store            (_ n: [UIColor]) {
        let array : [[CGFloat]] = n.map { $0.arrayOfRGBA }
        UserDefaults.standard.set(array, forKey: key)
    }
    
    override open var stored            : [UIColor]? {
        if let array = UserDefaults.standard.value(forKey: key) as? [[CGFloat]] {
            let result = array.map { UIColor.init(rgba: $0) }
            return result
        }
        return nil
    }
}

public func << <TYPE>(lhs:GenericSetting<TYPE>, rhs:TYPE) {
    lhs.value = rhs
}

