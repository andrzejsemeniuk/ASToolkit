//
//  ExtensionForSwiftSequence.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/15/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Sequence {

    public var asArray : [Iterator.Element] { return Array(self) }

}
