//
//  ExtensionForSwiftArray.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Array
{
    
    public var isNotEmpty : Bool {
        return !isEmpty
    }

	public mutating func clear() {
		self = []
	}

	public mutating func dump() -> Array {
		let result = self
		clear()
		return result
	}

    public mutating func trim(to:Int) -> Array {
        let to = Swift.min(to,count)
        let result = subarray(from:to, length:count-to)
        let range = startIndex.advanced(by: to)..<endIndex
        self.removeSubrange(range)
        return result
    }
    
    public func subarray(from:Int, to:Int) -> Array {
        var result = [Element]()
        for i in stride(from:Swift.max(0,Swift.min(count,from)), to:Swift.max(0,Swift.min(count, to)), by:1) {
            result.append(self[i])
        }
        return result
    }
    
    public func subarray(from:Int, length:Int) -> Array {
        return subarray(from:from, to:from+length)
    }
    
    public subscript (safe i:Int) -> Array.Element? {
        return 0 <= i && i < self.count ? self[i] : nil
    }

	public func filtered<T>(type:T.Type) -> [T] {
		return self.filter { $0 is T }.map { $0 as! T }
	}

	public var indexForPossibleLastElement : Int? {
		return 0 < count ? count-1 : nil
	}

	public var indexForPossiblePreLastElement : Int? {
		return 1 < count ? count-2 : nil
	}

	public var indexForSafeLastElement : Int {
		return 0 < count ? count-1 : 0
	}

	public var indexForSafePreLastElement : Int {
		return 1 < count ? count-2 : 0
	}

	public var preLast : Element? {
		return self[safe:count-2]
	}
}


extension Array where Element == Character {
    
    public var asArrayOfUInt32      : [UInt32]      { return self.map { $0.unicodeScalarCodePoint } }
    
}


extension Array where Element == Int {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }

}


extension Array where Element == Float {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}


extension Array where Element == CGFloat {
    
    public var asArrayOfDouble      : [Double]      { return self.map { Double($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}


extension Array where Element == Double {
    
    public var asArrayOfCGFloat     : [CGFloat]     { return self.map { CGFloat($0) } }
    public var asArrayOfFloat       : [Float]       { return self.map { Float($0) } }
    public var asArrayOfInt         : [Int]         { return self.map { Int($0) } }
    
}

extension Array {
    
    public func adjacent(_ handle:(Element,Element)->()) {
        for i in stride(from:1,to:count,by:1) {
            handle(self[i-1],self[i])
        }
    }

    public func find(_ where:(Element)->Bool) -> Element? {
        if let index = self.index(where:`where`) {
            return self[index]
        }
        return nil
    }
}

extension Array {
    
    public func appended(_ element:Element) -> Array<Element> {
        var result = self
        result.append(element)
        return result
    }
}

extension Array {
    
    public func split(by:Int) -> [[Element]] {
        var result : [[Element]] = []
        var row : [Element] = []
        for element in self {
            if row.count >= by {
                result.append(row)
                row = []
            }
            row.append(element)
        }
        
        if !row.empty {
            result.append(row)
        }
        
        return result
    }
}

extension Array where Element : Equatable {
    
    public func next(after:Element) -> Element? {
        if let index = self.index(where: { $0 == after }) {
            if index < (count-1) {
                return self[index+1]
            }
            return self[0]
        }
        return nil
    }
}

public func zippy<A,B>(_ a:[A], _ b:[B]) -> [(A,B)] {
    var r = [(A,B)]()
    let limit = min(a.count,b.count)
    for i in stride(from:0,to:limit,by:1) {
        r.append((a[i],b[i]))
    }
    return r
}

extension Array {
    
    public func zipped<B>(with:[B]) -> [(Element,B)] {
        return zippy(self,with)
    }
}

//extension Array where Element: Collection, Element.Iterator.Element: Collection {
extension Array where Element: Collection {

    public func transposed() -> [[Element.Iterator.Element]] {
        var result : [[Element.Iterator.Element]] = [[]]
        for row in self {
            for (y,column) in row.enumerated() {
                while (result.count <= y) {
                    result.append([])
                }
                result[y].append(column)
            }
        }
        return result
    }

	public var dimensions : (rows:Int,columns:Int) {
		let columns = self.reduce(Int(0),{ result,element in
			return Swift.max(result,Int(element.count))
		})
		return (rows:self.count, columns:columns)
	}
}

extension Array where Element: Equatable {

	public func index(of:Element) -> Int? {
		return self.index(where: { element in
			return of == element
		})
	}

	public func contains(_ element:Element) -> Bool {
		return self.index(of:element) != nil
	}

	@discardableResult mutating public func remove(_ element:Element) -> Bool {
		if let index = self.index(of: element) {
			_ = self.remove(at: index)
			return true
		}
		return false
	}

}

extension Array {

	public func index(where q: (Element)->Bool) -> Int? {
		for i in 0..<count {
			if q(self[i]) {
				return i
			}
		}
		return nil
	}

	public func index(default v:Int, where q: (Element)->Bool) -> Int {
		return self.index(where: q) ?? v
	}
}

extension Array {

	public func forEachAssigned(_ block:(Element)->Element) -> [Element] {
		var result = Array<Element>(self)
		for i in 0..<count {
			result[i] = block(self[i])
		}
		return result
	}

	public mutating func forEachAssign(_ block:(Element)->Element) {
		for i in 0..<count {
			self[i] = block(self[i])
		}
	}

}

extension Array {

	public func at(_ index:Int) -> Element {
		return index < 0 ? self[count+index] : self[index]
	}

	public func at(safe index:Int) -> Element? {
		return index < 0 ? self[safe:count+index] : self[safe:index]
	}

	public mutating func at(_ index:Int, set value:Element) {
		if index < 0 {
			self[count+index] = value
		}
		else {
			self[index] = value
		}
	}

	public mutating func at(safe index:Int, set value:Element) {
		if index < 0 {
			let i = (-index) % count
			self[count - i] = value
		}
		else {
			let i = index % count
			self[i] = value
		}
	}

}

extension Array {

	public mutating func assign(_ value:Element) {
		for i in 0..<count {
			self[i] = value
		}
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
