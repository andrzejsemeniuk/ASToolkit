//
//  CyclicQueue.swift
//  ASToolkit
//
//  Created by andrej on 5/18/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class CyclicQueue<T> : NSObject {

	public private(set) var array : [T]

	public init(_ array: [T]) {
		self.array = array
	}

	public var next : T {
		array.append(array.remove(at: 0))
		return array.last!
	}

}
