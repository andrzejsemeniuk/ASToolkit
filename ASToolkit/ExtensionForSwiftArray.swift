//
//  ExtensionForSwiftArray.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 10/9/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension RangeReplaceableCollection {
    var combinations: [Self] { generate(2) }
    func generate(_ n: Int) -> [Self] {
        repeatElement(self, count: n).reduce([.init()]) { result, element in
            result.flatMap { elements in
                element.map { elements + CollectionOfOne($0) }
            }
        }
    }
}

public extension Array
{
    
    var isNotEmpty : Bool {
        return !isEmpty
    }

    mutating func clear() {
		self = []
	}

    mutating func dump() -> Array {
		let result = self
		clear()
		return result
	}
    
    mutating func prepend(_ element: Element) {
        self.insert(element, at: 0)
    }

    @discardableResult
    mutating func trim(to: Int) -> Array {
        if to >= count {
            defer {
                self = []
            }
            return self
        }
        if to <= -count || to == 0 {
            return []
        }
        var to = to
        if to < 0 {
            to = count + to
        }
        let result = subarray(from:0, length:to)
        let range = startIndex..<startIndex.advanced(by: to)
        self.removeSubrange(range)
        return result
    }
    
    @discardableResult
    mutating func trim(from: Int) -> Array {
        if from >= count {
            return []
        }
        if from <= -count || from == 0 {
            defer {
                self = []
            }
            return self
        }
        var from = from
        if from < 0 {
            from = count + from
        }
        let result = subarray(from:from, length:count-from)
        let range = startIndex.advanced(by: from)..<endIndex
        self.removeSubrange(range)
        return result
    }
    
    func trimmed(to:Int) -> Array {
        if count <= to {
            return []
        }
        return subarray(from: to, to: count)
    }
    
    func trimmed(from:Int) -> Array {
        if from < 1 {
            return []
        }
        return subarray(from: 0, to:from)
    }
    
    @discardableResult
    mutating func keep(to:Int) -> Array {
        trimmed(from: to)
    }
    
    @discardableResult
    mutating func keep(from:Int) -> Array {
        trimmed(to: from)
    }
    
    func kept(to:Int) -> Array {
        trimmed(from: to)
    }
    
    func kept(from:Int) -> Array {
        trimmed(to: from)
    }
    
    func subarray(from:Int, to:Int) -> Array {
        var result = [Element]()
        for i in stride(from:Swift.max(0,Swift.min(count,from)), to:Swift.max(0,Swift.min(count, to)), by:1) {
            result.append(self[i])
        }
        return result
    }
    
    func subarray(from:Int, length:Int) -> Array {
        return subarray(from:from, to:from+length)
    }
    
    subscript (safe i:Int) -> Array.Element? {
        return 0 <= i && i < self.count ? self[i] : nil
    }

	func filtered<T>(type:T.Type) -> [T] {
		return self.filter { $0 is T }.map { $0 as! T }
	}

	var indexForPossibleLastElement : Int? {
		return 0 < count ? count-1 : nil
	}

	var indexForPossiblePreLastElement : Int? {
		return 1 < count ? count-2 : nil
	}

	var indexForSafeLastElement : Int {
		return 0 < count ? count-1 : 0
	}

	var indexForSafePreLastElement : Int {
		return 1 < count ? count-2 : 0
	}

	var preLast : Element? {
		return self[safe:count-2]
	}
    
    func indexForNextLooped(_ i: Int) -> Int {
        count < 1 ? 0 : (i + 1) % count
    }
    
    func indexForPreviousLooped(_ i: Int) -> Int {
        count < 1 ? 0 : i > 0 ? i - 1 : count-1
    }
}

public extension Array {

	init(creating: ()->Element, count: Int) {
		self.init()
		count.loop {
			self.append(creating())
		}
	}
}

extension Array {
    
    mutating public func rotate(_ amount: Int) {
        
        if isEmpty || amount % count == 0 {
            return
        }
        var amount1 = abs(amount) % count
        if amount > 0 {
            amount1 = count-amount1
        }
        self = Array(self[amount1..<count] + self[0..<amount1])
    }
    
    public func rotated(_ amount: Int) -> Self {
        var r = self
        r.rotate(amount)
        return r
    }
}


extension Array where Element == Character {
    
    public var asArrayOfUInt32      : [UInt32]      { return self.map { $0.unicodeScalarCodePoint } }
    
}

public extension Array where Element : Numeric {
    
    var sum                         : Element      { self.reduce(0, { $0 + $1 }) }
    
    func sum(if condition: (Element)->Bool) -> Element {
//        reduce(0, { $0 + (condition($1) ? $1 : 0)})
        reduce(0, { condition($1) ? $0 + $1 : $0 })
    }

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
    
    public func forEachAdjacent(_ handle:(Element,Element)->Void) {
        for i in stride(from:1,to:count,by:1) {
            handle(self[i-1],self[i])
        }
    }

	mutating public func forEachSubsequent(_ handle:(Element,inout Element)->Void) {
		for i in stride(from:1,to:count,by:1) {
			handle(self[i-1],&self[i])
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
        
        if row.isNotEmpty {
            result.append(row)
        }
        
        return result
    }
}

extension Array where Element : Equatable {
    
    public func next(after:Element, wrap: Bool = true) -> Element? {
        if let index = self.index(where: { $0 == after }) {
            if index < (count-1) {
                return self[index+1]
            }
            if wrap {
                return self[0]
            }
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

public extension Array {

	func compacted() -> [Element] {
//		return self.filter({ $0 != nil }).map { $0! })
		return self.compactMap({
			return $0
		})
	}
    
    var odd : [Element] {
        enumerated().filter { $0.0.isOdd }.map { $0.1 }
    }
    
    var even : [Element] {
        enumerated().filter { $0.0.isEven }.map { $0.1 }
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

    public mutating func assign(_ value:Element) {
        for i in 0..<count {
            self[i] = value
        }
    }

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

public extension Array {
    
    var random : Element {
        return self[ Int.random(n: UInt32(count)) ]
    }

    var pick : Element {
        return random
    }

    func picked(_ count: Int) -> Self {
        // EXPENSIVE O(n)
        self.shuffled().enumerated().filter { $0.0 < count }.map { $0.1 }
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


public func + <T:Equatable>(lhs:Array<T>, rhs:Array<T>) -> Array<T> {
	var r = lhs
	r.append(contentsOf:rhs)
	return r
}

public func + <T:Equatable>(lhs:Array<T>, rhs:T) -> Array<T> {
	return lhs + [rhs]
}


public func - <T:Equatable>(lhs:Array<T>, rhs:Array<T>) -> Array<T> {
	return lhs.filter { v in
		return !rhs.contains(v)
	}
}

public func -= <T:Equatable>(lhs: inout Array<T>, rhs: Array<T>) {
	lhs = lhs - rhs
}

public func - <T:Equatable>(lhs:Array<T>, rhs:T) -> Array<T> {
	return lhs.filter { v in
		return v != rhs
	}
}

public func -= <T:Equatable>(lhs: inout Array<T>, rhs: T) {
	lhs = lhs - rhs
}


public extension Array where Element : Equatable {
    
    func count(element: Element) -> Int {
        count(where: { $0 == element })
    }

}

public extension Array {
    
    func count(where q: (Element)->Bool) -> Int {
        self.reduce(0, { $0 + (q($1) ? 1 : 0) } )
    }
    
    func all(where q: (Element)->Bool) -> Bool {
        for e in self {
            if !q(e) {
                return false
            }
        }
        return true
    }
    
    func some(where q: (Element)->Bool, count: Int = 1) -> Bool {
        var c = count
        for e in self {
            if q(e) {
                c -= 1
                if c < 1 {
                    return true
                }
            }
        }
        return false
    }
    
    func any(where q: (Element)->Bool) -> Bool {
        return some(where: q, count: 1)
    }
    
    func most(where q: (Element)->Bool) -> Bool {
        var count = 0
        let half = self.count/2
        for e in self {
            if q(e) {
                count += 1
                if count > half {
                    return true
                }
            }
        }
        return false
    }
    
    func none(where q: (Element)->Bool) -> Bool {
        for e in self {
            if q(e) {
                return false
            }
        }
        return true
    }

}

public extension Array where Element == Int {
    
    func invertedIndex() -> Self {
        var r = self
        for i in 0..<count {
            r[self[i]] = i
        }
        return r
    }
    

}

public extension Array {
    
    func orderedIndex(with sorting: (Element,Element)->Bool) -> [Int] {
        self.enumerated().sorted(by: { sorting($0.1,$1.1) }).map { $0.0 }
    }

}

public extension Array {
    
    func removedEqualAdjacent(_ equal: (Element,Element)->Bool) -> Self {
        var r : Self = []
        r.reserveCapacity(count)
        if count > 0 {
            r.append(self[0])
        }
        for i in 1..<count {
            if equal(self[i-1],self[i]) {
                continue
            }
            r.append(self[i])
        }
        return r
    }
    
    func sortedAndUniqued(_ less: (Element,Element)->Bool) -> Self {
        self.sorted(by: less).removedEqualAdjacent { a,b in
            !less(a,b) && !less(b,a)
        }
    }
}

public extension Array {
    
    var range : Range<Int> {
        0..<count
    }
    
}

public extension Array {
    
    func padded(with: Element, upto limit: Int) -> Self {
        var r = self
        while r.count < limit {
            r.append(with)
        }
        return r
    }
    
}

public extension Array {
    
    func asDictionary<K,V>(_ f: (Element)->(K,V)) -> [K:V] {
        self.map {
            f($0)
        }.reduce([:], {
            var d = $0
            let (k,v) = $1
            d[k] = v
            return d
        })
    }
}

public extension Array {
    
    func indexGroups(where f: (Element)->Bool) -> [[Int]] {
        var groups : [[Int]] = []
        var group : [Int] = []
        for i in 0..<count {
            if f(self[i]) {
                group.append(i)
            } else if group.isNotEmpty {
                groups.append(group)
                group = []
            }
        }
        if group.isNotEmpty {
            groups.append(group)
            group = []
        }
        return groups
    }
}





public extension Array where Element : Equatable {
    
    func count(first: Int = -1, of: Element) -> Int {
        var r = 0
        let first = first > -1 ? Swift.min(first,count) : count
        for i in 0..<first {
            if self[i] == of { r += 1 }
        }
        return r
    }
    
    func runCounts(of: Element) -> [Int : Int] {
        guard count > 0 else { return [:] }
        var r : [Int : Int] = [:]
        var counter = 0
        for i in 0..<count {
            if self[i] != of {
                if counter > 0 {
                    r[counter, default: 0] += 1
                    counter = 0
                }
            } else {
                counter += 1
            }
        }
        if counter > 0 {
            r[counter, default: 0] += 1
        }
        return r
    }
    
    func runCountsAsArray(of: Element) -> [Int] {
        let c = runCounts(of: of)
        let max = c.keys.max() ?? 0
        guard max > 0 else { return [] }
        var r : [Int] = .init(repeating: 0, count: max)
        for (k,v) in c {
            r[k-1] = v
        }
        return r
    }
    
    func runsSum(of: Element) -> Int {
        runCountsAsArray(of: of).enumerated().map { index,run in (index + 1) * run }.sum
    }
    
}

public extension Array where Element : Hashable {
    func uniqued() -> Self {
        Set<Element>.init(self).map { $0 }
    }
}

public extension Array where Element == Int {
    var sumOfPositives : Int {
        self.reduce(0, {
            $0 + ($1 > 0 ? $1 : 0)
        })
    }
    var sumOfNegatives : Int {
        self.reduce(0, {
            $0 + ($1 < 0 ? $1 : 0)
        })
    }
    var ratios : [Double] {
        guard count > 1 else { return [] }
        var r : [Double] = []
        for i in 1..<count {
            if self[i] != 0 {
                r.append(Double(self[i-1])/Double(self[i]))
            } else {
                r.append(Double.nan)
            }
        }
        return r
    }

}

public extension Array where Element == Bool {
    
    var sequence : [Int] {
        guard count > 0 else { return [] }
        var r : [Int] = []
        var counter = 1
        var last : Bool = self[0]
        for i in 1..<count {
            if self[i] != last {
                r.append(last ? counter : -counter)
                counter = 1;
                last = self[i]
            } else {
                counter += 1
            }
        }
        if counter > 0 {
            r.append(last ? counter : -counter)
        }
        return r
    }

    var sequenceNormzalizedTo11 : [Double] {
        let values = sequence
        let min = values.min() ?? 0
        let max = values.max() ?? 0
        let m = Double(Swift.max(abs(max),abs(min)))
        return values.map { v in
            Double(v)/m
        }
    }
    
    func sequenceWeighted(_ weight: Double = 1.0) -> [Double] {
        sequence.enumerated().map { i,v in Double(1+i) * Double(v) * weight }
    }
    
    var runCountsOf0Summary : String {
        let r = runCountsAsArray(of: false)
        return r.description.replacingOccurrences(of: ", ", with: " ") + " |\(r.count)|"
    }
    var runCountsOf1Summary : String {
        let r = runCountsAsArray(of: true)
        return r.description.replacingOccurrences(of: ", ", with: " ") + " |\(r.count)|"
    }

    func runIndexes(of: Bool) -> [Int : [Int]] {
        var r : [Int : [Int]] = [:]
        var index = 0
        for run in sequence {
            r[run, default: []].append(index)
            index += abs(run)
        }
        return r
    }
    func runIndexesAsArray(of: Bool) -> [Int] {
        let i = runIndexes(of: of)
        return i.keys.sorted().map { k in i[k]! }.flatMap { $0 }
    }
    
    var asStringOf01 : String {
        map { $0 ? "1" : "0" }.joined(separator: "")
    }

    func countOf(pattern: [Bool]) -> Int {
        var r = 0
        var i = 0
        let end = count-pattern.count+1
        while i < end {
            var j = i
            while j < count, j-i < pattern.count, self[j] == pattern[j-i] {
                j += 1
            }
            if (j-i) == pattern.count {
                r += 1
                i += pattern.count
            } else {
                i += 1
            }
        }
        return r
    }

    static func allPermutations(n: Int) -> [[Bool]] {
        return [false,true].generate(n)
    }
}
