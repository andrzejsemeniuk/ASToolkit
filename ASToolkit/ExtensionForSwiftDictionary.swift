//
//  ExtensionForSwiftDictionary.swift
//  ASToolkit
//
//  Created by andrej on 11/24/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Dictionary {

	public func json(options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> String? {
		guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else {
			return nil
		}
		return String(data: jsonData, encoding: .utf8)
	}

	static public func from(json text: String, options: JSONSerialization.ReadingOptions = []) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: options) as? [String: Any]
			}
			catch {

			}
		}
		return nil
	}

}
