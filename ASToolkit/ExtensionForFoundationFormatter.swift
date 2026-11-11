//
//  ExtensionForFoundationFormatter.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 1/9/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public convenience init(withFormat: String) {
        self.init()
        self.dateFormat = withFormat
    }
    
}
