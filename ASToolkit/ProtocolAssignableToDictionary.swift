//
//  ProtocolAssignableToDictionary.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 7/31/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public protocol AssignableToDictionary {
    func assign(toDictionary:inout [String:Any])
}
