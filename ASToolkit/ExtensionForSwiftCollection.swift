//
//  ExtensionForSwiftCollection.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation


extension Collection {
    
    public var empty: Bool {
        return startIndex == endIndex
    }
}

