//
//  ProtocolToDictionary.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 7/31/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public protocol ToDictionary {
    func to(dictionary:inout [String:Any])
}
