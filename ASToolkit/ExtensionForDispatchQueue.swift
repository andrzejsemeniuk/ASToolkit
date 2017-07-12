//
//  ExtensionForDispatchQueue.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/29/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    public var background: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
}
