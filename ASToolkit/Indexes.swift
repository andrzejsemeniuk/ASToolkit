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

	public func array(count:Int) -> [Int] {
		return Array<Int>(0..<count).indexes(self)
	}
}

extension Array {

    public func indexes(_ indexes:Indexes, validate:Bool = true) -> [Int] {
        var r : [Int] = []

        switch indexes {

        case .none:
            break

        case .all:
            r = Array<Int>(0..<count)
        case .one(let v):
            if !validate || v < count {
                r = [v]
            }
        case .two(let a, let b):
            if !validate || a < count {
                r.append(a)
            }
            if !validate || b < count {
                r.append(b)
            }
        case .some(let array):
            for i in array {
                if !validate || i < count {
                    r.append(i)
                }
            }
        case .span(let from, let to):
            for i in from...to {
                if !validate || i < count {
                    r.append(i)
                }
            }
        case .ranges(let ranges):
            for range in ranges {
                r += self.indexes(range, validate:validate)
            }
        case .exceptOne(let a):
            r.remove(a)
        case .exceptTwo(let a, let b):
            r.remove(a)
            r.remove(b)
        case .exceptSome(let some):
            for v in some {
                r.remove(v)
            }
        case .exceptSpan(let from, let to):
            for v in from...to {
                r.remove(v)
            }
        case .exceptRanges(let ranges):
            for range in ranges {
                for v in self.indexes(range, validate:validate) {
                    r.remove(v)
                }
            }
        }

        return r
    }

}

