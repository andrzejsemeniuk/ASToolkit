//
//  State.swift
//  ASToolkit
//
//  Created by andrej on 4/19/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class State : NSObject {
	public typealias Value = Int

	public typealias Block = (_ from:Value,_ to:Value)->()

	public class Blocks {
		public var enter	: [Block] = []
		public var exit 	: [Block] = []
	}

	public var transitions : [Value:Blocks] = [:]

	public private(set) var current : Int = 0

	public override init() {
		super.init()
	}

	open func transition(to:Value) {
		let current = self.current
		transitions[current]?.exit.forEach { block in
			block(current,to)
		}
		self.current = current
		transitions[to]?.enter.forEach { block in
			block(current,to)
		}
	}
}
