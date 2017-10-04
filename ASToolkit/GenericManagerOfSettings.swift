//
//  GenericManagerOfSettings.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/29/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public protocol GenericManagerOfSettings : class {
    func synchronize    ()
    func encode         (dictionary:inout [String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func decode         (dictionary:[String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func reset          (withPrefix prefix:String?, withSuffix suffix:String?)
    func collect        (withPrefix prefix:String?, withSuffix suffix:String?) -> [(label:String,object:AnyObject)]
}

extension GenericManagerOfSettings {
    
    public func encode              (dictionary:inout [String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? AssignableToDictionary {
                setting.assign(toDictionary:&dictionary)
            }
        }
    }
    
    public func decode              (dictionary:[String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? AssignableFromDictionary {
                setting.assign(fromDictionary:dictionary)
            }
        }
    }
    
    public func reset               (withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? Resettable {
                setting.reset()
            }
        }
    }
    
    public func collect             (withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) -> [(label:String,object:AnyObject)] {
        var result : [(label:String,object:AnyObject)] = []
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
                
                let setting = child.value as AnyObject
                
                result.append((label:label,object:setting))
            }
        }
        return result
    }
    
}

