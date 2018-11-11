//
//  UILine.swift
//  ASToolkit
//
//  Created by andrej on 6/19/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public struct CGStroke {
	public var color		: CGColor 		= UIColor.white.cgColor
	public var thickness	: CGFloat 		= 0
	public var cap			: CGLineCap 	= .butt
	public var join			: CGLineJoin 	= .bevel
	public var miterLimit	: CGFloat? 		= nil
	public var pattern		: [CGFloat] 	= []
	public var phase		: CGFloat 		= 0
}
