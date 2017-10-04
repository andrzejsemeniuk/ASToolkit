//
//  ExtensionForUIKitUIControlState.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UIControlState : Hashable {
    
    public var hashValue : Int {
        switch self {
        case .normal        : return 1
        case .highlighted   : return 4
        case .disabled      : return 3
        case .selected      : return 2
        case .focused       : return 5
        case .application   : return 6
        case .reserved      : return 7
        default:
            return 8
        }
    }
}

extension UIControlState : Equatable {
    
}
