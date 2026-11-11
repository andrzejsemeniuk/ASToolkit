//
//  TokenizedCollection.swift
//  ASToolkit
//
//  Created by andrej on 5/31/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class TokenizedCollection<Element> : NSObject {

	public typealias Token = UInt64

	private var count : Token = 0
	private var array : [(token:Token,element:Element)] = []

	open func append(_ element:Element) -> Token {
		count += 1
		array.append((token:count,element:element))
		return count
	}

	@discardableResult open func remove(token:Token) -> Element? {
		if let index = array.index(where: { (_token,_) in
			return token == _token
		}) {
			return array.remove(at: index).element
		}
		return nil
	}

	public var elements : [Element] {
		return array.map { $0.element }
	}

	public func forEach(_ block:(Element)->Void) {
		array.forEach {
			block($0.element)
		}
	}
}

