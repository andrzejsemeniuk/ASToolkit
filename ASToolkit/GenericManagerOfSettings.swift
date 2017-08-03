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
    func encode         (data:inout [String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func decode         (data:[String:Any], withPrefix prefix:String?, withSuffix suffix:String?)
    func reset          (withPrefix prefix:String?, withSuffix suffix:String?)
//    var settings : [GenericSetting] { get }
}

extension GenericManagerOfSettings {
    
//    lazy public var settings : [GenericSetting] = {
//        var result = [GenericSetting]()
//        for child in Mirror(reflecting: self).children {
//            if let setting = child.value as? GenericSetting {
//                result.append(setting)
//            }
//        }
//        return result
//    }()
    
    public func encode(data:inout [String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? ToDictionary {
                setting.to(dictionary:&data)
            }
        }
    }
    
    public func decode(data:[String:Any], withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
        for child in Mirror(reflecting: self).children {
            if let label = child.label {
                if let prefix = prefix, !label.hasPrefix(prefix) {
                    continue
                }
                if let suffix = suffix, !label.hasSuffix(suffix) {
                    continue
                }
            }
            if let setting = child.value as? FromDictionary {
                setting.from(dictionary:data)
            }
        }
    }
    
    public func reset(withPrefix prefix:String? = nil, withSuffix suffix:String? = nil) {
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
    
}
