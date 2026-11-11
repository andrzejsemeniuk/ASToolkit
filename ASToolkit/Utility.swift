//
//  Utility.swift
//  ASToolkit
//
//  Created by Andrzej Semeniuk on 3/23/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public struct UITableViewTap
{
    public let path:IndexPath
    public let point:CGPoint
    
    public init(path:IndexPath, point:CGPoint) {
        self.path = path
        self.point = point
    }
}

protocol EnumCollection: Hashable {
	static var allValues: [Self] { get }
}

// zbigniew kalafarski
extension EnumCollection {
	static func cases() -> AnySequence<Self> {
		typealias S = Self
		return AnySequence { () -> AnyIterator<S> in
			var raw = 0
			return AnyIterator {
				let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
				guard current.hashValue == raw else { return nil }
				raw += 1
				return current
			}
		}
	}

	static var allValues: [Self] {
		return Array(self.cases())
	}
}

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}




















