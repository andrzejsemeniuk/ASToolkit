//
//  Indexes.swift
//  ASToolkit
//
//  Created by andrej on 6/23/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public enum Indexes {

	case none
	case all

	case one(Int)
	case two(Int,Int)
	case some([Int])
	case span(Int,Int)
	case ranges([Indexes])

	case exceptOne(Int)
	case exceptTwo(Int,Int)
	case exceptSome([Int])
	case exceptSpan(Int,Int)
	case exceptRanges([Indexes])
}

