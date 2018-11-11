//
//  ExtensionForFoundationNSNumber.swift
//  ASToolkit
//
//  Created by andrej on 4/18/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreGraphics

public extension NSNumber {
	public convenience init(value: CGFloat) {
		self.init(value: Double(value))
	}
}

