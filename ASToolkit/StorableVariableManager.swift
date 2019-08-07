//
//  StorableVariable.swift
//  ASToolkit
//
//  Created by andrzej on 5/14/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation


private func log(_ error: Error, file: String = #file, line: Int = #line) {
	print("\(file):\(line):error: \(error)")
}

private func log(_ string: String, file: String = #file, line: Int = #line) {
	print("\(file):\(line): \(string)")
}




open class StorableVariableManager : CustomStringConvertible {


	public let key 							: String

	public private(set) var variables 		: [StorableVariable] = []




	public init(key: String) {
		self.key = key
	}

	public init(key: String, variables: [StorableVariable]) {
		self.key = key
		self.variables = variables
	}




	public func copy(key: String, cloneListeners: Bool) -> StorableVariableManager {
		return StorableVariableManager.init(key: key, variables: variables.compactMap {
			$0.copy(cloneListener: cloneListeners)
		})
	}



	open func filter(prefix: String) -> [StorableVariable] {
		return variables.filter {
			$0.key.starts(with: prefix)
		}
	}

	open func filter(pattern: String) -> [StorableVariable] {
		return variables.filter {
			$0.key.matches(regex: pattern)
		}
	}


	open subscript (key: String) -> StorableVariable! {
		return variables.first {
			$0.key == key
		}
	}




	open func filtered(forKeyRegexPattern pattern: String) -> [StorableVariable] {
		return variables.filter({ $0.key.matches(regex: pattern) }).map { $0 }
	}

	open func variable(_ key: String) -> StorableVariable! {
		return variables.first(where: { $0.key == key } )
	}




	open func put(variable p: StorableVariable, overwrite: Bool, store: Bool = true) {
		if let variable = self.variables.first(where: { $0.key == p.key }) {
			if overwrite {
				variable.assign(from: p)
				if store {
					self.store()
				}
			}
		} else {
			self.variables.append(p)
			if store {
				self.store()
			}
		}
	}

	open func put(variables: [StorableVariable], clear: Bool = false, overwrite: Bool, store: Bool = false) {
		if clear {
			self.variables = []
		}
		variables.forEach {
			put(variable: $0, overwrite: overwrite, store: false)
		}
		if store {
			self.store()
		}
	}




	open var description : String {

		let array = self.variables.sorted(by: { $0.key < $1.key })

		var buffer = "StorableVariableManager: properties=\(array.count), key=\"\(key)\""

		for (index,property) in array.enumerated() {
			buffer += "\n property[\(index)] = \(property) for key \"\(property.key)\""
		}

		return buffer
	}





	open func clear(store: Bool = false) {
		if store {
			self.store()
		}
		self.variables = []
	}

	open func store() {
		do {
			log("store: \n\(self)")

			let data = try JSONEncoder.init().encode(variables)

			log("store, data: \(data)")

			UserDefaults.standard.set(data, forKey: key)
		} catch let error {
			log(error)
		}
	}

	open func load(clear: Bool = false, overwrite: Bool = false) {
		do {
			if let data = UserDefaults.standard.data(forKey: key) {

				log("load, for key \(key) data: \(String(describing: String.init(data: data, encoding: .utf8)))")

				let decoded = try JSONDecoder.init().decode([StorableVariable].self, from: data)

				self.put(variables: decoded, clear: clear, overwrite: overwrite)

				log("loaded: \n\(self)")
			}
		} catch let error {
			log(error)
		}
	}

	open func purge() {
		do {
			let array : [StorableVariable] = []

			let data = try JSONEncoder.init().encode(array)

			UserDefaults.standard.set(data, forKey: key)
		} catch let error {
			log(error)
		}

	}




}


