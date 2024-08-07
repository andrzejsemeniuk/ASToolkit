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

public extension Array where Element == Int {
    init(_ range: Range<Int>) {
        self = range.asArray
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

    mutating func discardFromFront(keeping: Int) {
//        let range = startIndex.advanced(by: from)..<endIndex
//        self.removeSubrange(range)
        while count > keeping {
            popFirst()
        }
    }
    mutating func discardFromBack(keeping: Int) {
//        let range = startIndex.advanced(by: from)..<endIndex
//        self.removeSubrange(range)
        while count > keeping {
            popLast()
        }
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
        return count <= from ? self : subarray(from: 0, to:from)
    }
    
    @discardableResult
    mutating func keep(to:Int) -> Array {
        let R = to < count ? subarray(from: to, to: count) : []
        if R.isNotEmpty {
            self = trimmed(from: to)
        }
        return R
    }
    
    @discardableResult
    mutating func keepFirst(_ count1: Int) -> Array {
        keep(to: count1)
    }
    
    @discardableResult
    mutating func keepLast(_ count1: Int) -> Array {
        keep(from: count - count1)
    }
    
    @discardableResult
    mutating func keep(from:Int) -> Array {
        let R = 0 < from ? subarray(from: 0, to: from) : []
        if R.isNotEmpty {
            self = trimmed(to: from)
        }
        return R
    }
    
    func kept(to:Int) -> Array {
        trimmed(from: to)
    }
    
    func kept(from:Int) -> Array {
        trimmed(to: from)
    }
    
    func subarray(from:Int, to:Int) -> Array {
        let to = Swift.min(to,count)
        var result = [Element]()
        for i in stride(from:Swift.max(0,Swift.min(count,from)), to:Swift.max(0,Swift.min(count, to)), by:1) {
            result.append(self[i])
        }
        return result
    }
    
    func subarray(from:Int, length:Int? = nil) -> Array {
        return subarray(from: from, to: from + (length == nil ? (count - from) : length!))
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
    
    var firstElement : Element {
        first!
    }
    
    var lastElement : Element {
        last!
    }
    
    func indexForNextLooped(_ i: Int) -> Int {
        count < 1 ? 0 : (i + 1) % count
    }
    
    func indexForPreviousLooped(_ i: Int) -> Int {
        count < 1 ? 0 : i > 0 ? i - 1 : count-1
    }
    
    @discardableResult
    mutating func popFirst() -> Element? {
        count > 0 ? remove(at: 0) : nil
    }

    @discardableResult
    mutating func popLast() -> Element? {
        count > 0 ? remove(at: count-1) : nil
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

public extension Array {
    
    mutating func rotate(_ amount: Int) {
        
        if isEmpty || amount % count == 0 {
            return
        }
        var amount1 = abs(amount) % count
        if amount > 0 {
            amount1 = count-amount1
        }
        self = Array(self[amount1..<count] + self[0..<amount1])
    }
    
    func rotated(_ amount: Int) -> Self {
        var r = self
        r.rotate(amount)
        return r
    }

    mutating func shift(_ amount: Int, fill: Element) {
        guard isNotEmpty else {
            return
        }
        var amount = amount
        while amount < 0 {
            self.removeFirst()
            self.append(fill)
            amount += 1
        }
        while amount > 0 {
            self.removeLast()
            self.prepend(fill)
            amount -= 1
        }
    }
    
    func shifted(_ amount: Int, fill: Element) -> Self {
        var r = self
        r.shift(amount, fill: fill)
        return r
    }
    
}



public extension Array{

    func sortedCombinedWithSorted(other: Array, comparing comparator: (Element,Element)->Int, uniqued: Bool) -> Array {
        var r : Self = []
        var i0 = 0
        var i1 = 0
        while i0 < count, i1 < other.count {
            let c = comparator(self[i0], other[i1])
            if c < 0 {
                r.append(self[i0])
                i0 += 1
            } else if c > 0 {
                r.append(other[i1])
                i1 += 1
            } else {
                r.append(self[i0])
                if !uniqued {
                    r.append(other[i0])
                }
                i0 += 1
                i1 += 1
            }
        }
        if i0 < count {
            r += self[i0..<count]
        } else if i1 < other.count {
            r += other[i1..<other.count]
        }
        
        return r
    }
}



public extension Array where Element : Numeric {
    
    var sum                         : Element      { self.reduce(0, { $0 + $1 }) }
    
    func sum(if condition: (Element)->Bool) -> Element {
//        reduce(0, { $0 + (condition($1) ? $1 : 0)})
        reduce(0, { condition($1) ? $0 + $1 : $0 })
    }
    
    var product                     : Element? {
        guard isNotEmpty else { return nil }
        return reduce(1, { $0 * $1 })
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

public extension Array where Element == String {
    
    func uppercased() -> Self {
        map { $0.uppercased() }
    }
    
    func lowercased() -> Self {
        map { $0.lowercased() }
    }
    
    func filteredOutEmpty() -> Self {
        filter { $0.isNotEmpty }
    }
    
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

public extension Array {
    
    func appended(_ element:Element) -> Self {
        var result = self
        result.append(element)
        return result
    }
    
    func prepended(_ element:Element) -> Self {
        var result = self
        result.prepend(element)
        return result
    }
    
    func replaced(_ element: Element, at: Int) -> Self {
        if at < count, 0 <= at {
            var r = self
            r[at] = element
            return r
        }
        return self
    }
    
    func replaced(_ elements: Self, at: [Int]) -> Self {
        var r = self
        for index in at {
            if r.valid(index: index) {
                r[index] = elements[index]
            }
        }
        return r
    }
    
    func valid(index: Int) -> Bool {
        index < count && 0 <= index 
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

public extension Array where Element : Equatable {
    
    func next(after:Element, wrap: Bool = true) -> Element? {
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
    
    func inserted(_ element:Element, at: Int) -> Self {
        var result = self
        if at < count {
            result.insert(element, at: at)
        } else {
            result.append(element)
        }
        return result
    }
    
    func inserted(_ element:Element, after: Int) -> Self {
        var result = self
        if (after+1) < count {
            result.insert(element, at: 1+after)
        } else {
            result.append(element)
        }
        return result
    }
    
    func removed(_ element:Element) -> Self {
        var result = self
        if let index = result.firstIndex(where: { $0 == element }) {
            result.remove(at: index)
        }
        return result
    }
    
    func removed(at index: Int) -> Self {
        var result = self
        result.remove(at: index)
        return result
    }
    
    @discardableResult
    mutating func removeEvery(_ element: Element) -> Int {
        let count0 = count
        removeAll(where: { $0 == element })
        return count0 - count
    }
    
    mutating func removedEvery(_ element: Element) -> Self {
        var r = self
        r.removeEvery(element)
        return r
    }
    
    func uniquedOnAdjacentElementsKeepingOrder() -> Self {
        reduce([], {
            if $0.isEmpty {
                return [$1]
            } else if $0.last == $1 {
                return $0
            } else {
                return $0 + [$1]
            }
        })
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

public extension Array where Element: Equatable {

	func index(of:Element) -> Int? {
		return self.index(where: { element in
			return of == element
		})
	}

	func contains(_ element:Element) -> Bool {
		return self.index(of:element) != nil
	}

    func missing(_ element:Element) -> Bool {
        return !contains(element)
    }

	@discardableResult mutating func remove(_ element:Element) -> Bool {
		if let index = self.index(of: element) {
			_ = self.remove(at: index)
			return true
		}
		return false
	}
    
    mutating func toggle(append element: Element) {
        if contains(element) {
            remove(element)
        } else {
            append(element)
        }
    }
    
    mutating func toggle(prepend element: Element) {
        if contains(element) {
            remove(element)
        } else {
            prepend(element)
        }
    }

    mutating func enlist(append element: Element) {
        if missing(element) {
            append(element)
        }
    }

    mutating func enlist(prepend element: Element) {
        if missing(element) {
            prepend(element)
        }
    }
    
    mutating func append(missing: Element) {
        enlist(append: missing)
    }
    
    mutating func prepend(missing: Element) {
        enlist(prepend: missing)
    }

}

public extension Array {
    
    func contains(_ element: Element, equatable: (Element,Element)->Bool) -> Bool {
        first(where: { equatable($0, element) }) != nil
    }
    
    func predicate(_ predicate: (Element)->Bool) -> Bool {
        first(where: { predicate($0) }) != nil
    }
}

public extension Array {

    func compacted() -> [Element] {
//        return self.filter({ $0 != nil }).map { $0! })
        return self.compactMap({
            return $0
        })
    }
    
    func withCompacted<T>(perform: ([Element])->T) -> T {
        perform(compacted())
    }
    
    func withCompacted<T>(perform: ([Element])->T?) -> T? {
        perform(compacted())
    }
    
    func ensured(count: Int, fill: Element) -> Self {
        var R = self
        while R.count < count {
            R.append(fill)
        }
        return R
    }
    
    func assigned(value: Element, at: Int) -> Self {
        if at < count {
            var R = self
            R[at] = value
            return R
        }
        return self
    }

}

public extension Array {
    
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

public extension Array where Element : Equatable {
    
    func has(_ element: Element) -> Bool {
        contains(element)
    }
    
    func has(none array: [Element]) -> Bool {
        contains(none: array)
    }
    
    func has(all array: [Element]) -> Bool {
        contains(all: array)
    }
    
    func has(any array: [Element]) -> Bool {
        contains(any: array)
    }
    
    func contains(none array: [Element]) -> Bool {
        array.none { self.contains($0) }
    }
    
    func contains(all array: [Element]) -> Bool {
        array.all { self.contains($0) }
    }
    
    func contains(any array: [Element]) -> Bool {
        array.any { self.contains($0) }
    }
    
    func missing(none array: [Element]) -> Bool {
        contains(all: array)
    }
    
    func missing(all array: [Element]) -> Bool {
        contains(none: array)
    }
    
    func missing(any array: [Element]) -> Bool {
        !contains(all: array)
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
    
    var asArrayOfString : [String] {
        map { "\($0)"}
    }
}

public extension Array {
    
    func orderedIndex(with sorting: (Element,Element)->Bool) -> [Int] {
        self.enumerated().sorted(by: { sorting($0.1,$1.1) }).map { $0.0 }
    }

}

public extension Array {
    
    func removedEqualAdjacent(_ equal: (Element,Element)->Bool) -> Self {
        guard count > 1 else { return self }
        var r : Self = []
        r.reserveCapacity(count)
        r.append(self[0])
        for i in 1..<count {
            if !equal(r.last!,self[i]) {
                r.append(self[i])
            }
        }
        return r
    }
    
    func sortedAndUniqued(_ less: (Element,Element)->Bool) -> Self {
        guard count > 1 else { return self }
        return self.sorted(by: less).removedEqualAdjacent { a,b in
            !less(a,b) && !less(b,a)
        }
    }
}

public extension Array {
    
    var range : Range<Int> {
        0..<count
    }
    
}


public extension Array where Element == Int {
    
    func inverseMapped(to: Int) -> Self {
        self.map { to - $0 }
    }
    
}


public extension Array {
    
    @discardableResult
    mutating func prepad(with: Element, upto limit: Int) -> Self {
        while count < limit {
            prepend(with)
        }
        return self
    }
    
    func prepadded(with: Element, upto limit: Int) -> Self {
        var r = self
        r.prepad(with: with, upto: limit)
        return r
    }
    
    func padded(with: Element, upto limit: Int) -> Self {
        var r = self
        while r.count < limit {
            r.append(with)
        }
        return r
    }
    
    func padded(with: Element, till limit: Int) -> Self {
        padded(with: with, upto: limit + 1)
    }
    
}

public extension Array {
    
    func asDictionary<K: Hashable & Equatable,V>(_ f: (Element)->(K,V)) -> [K:V] {
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

//public extension Array where Element == (K,V), K: Hashable & Equatable {
////public extension Array where Element == <K: Hashable & Equatable, V>(K,V) {
//
//    func asDictionary<K: Hashable & Equatable,V>() -> [K:V] {
//        self.map {
//            f($0.0,$0.1)
//        }.reduce([:], {
//            var d = $0
//            let (k,v) = $1
//            d[k] = v
//            return d
//        })
//    }
//}

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
    
    
    func previousLooped(_ e: Element) -> Element! {
        if let index = firstIndex(of: e) {
            return index > 0 ? self[index-1] : self.last
        }
        return nil //e
    }
    
    func nextLooped(_ e: Element) -> Element! {
        if let index = firstIndex(of: e) {
            return index < count-1 ? self[index+1] : self.first
        }
        return nil //e
    }
}

public extension Array where Element : Hashable {
    func uniqued() -> Self {
        Set<Element>.init(self).map { $0 }
    }
    func uniquedInOrderKeepingFirst() -> Self {
        var T = Set<Element>.init(self)
        var r : Self = []
        for e in self {
            if T.contains(e) {
                r.append(e)
                T.remove(e)
            }
        }
        return r
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

public extension Array where Element : Comparable {
    
    func minimal(_ less: (Element,Element)->Bool) -> Element? {
        guard isNotEmpty else { return nil }
        return self.reduce(first!, { before,current in
            less(before,current) ? before : current
        })
    }
    func maximal(_ less: (Element,Element)->Bool) -> Element? {
        guard isNotEmpty else { return nil }
        return self.reduce(first!, { before,current in
            less(before,current) ? current : before
        })
    }
    func minimalIndex(_ less: (Element,Element)->Bool) -> Int? {
        guard isNotEmpty else { return nil }
        let E = self.enumerated()
        return E.reduce(0, { before,current in
            less(self[before],current.1) ? before : current.0
        })
    }
    func maximalIndex(_ less: (Element,Element)->Bool) -> Int? {
        guard isNotEmpty else { return nil }
        let E = self.enumerated()
        return E.reduce(0, { before,current in
            less(self[before],current.1) ? current.0 : before
        })
    }

    var minAndMax : (min: Element, max: Element)? {
        let MM = arrayMinMaxIndexes(of: self)
        if let iMIN = MM.0, let iMAX = MM.1 {
            return (self[iMIN],self[iMAX])
        }
        return nil
    }
    
    var min                         : Element? { minimal(<) }
    var max                         : Element? { maximal(<) }

}

//public extension Array where Element : Optional<Comparable> {
//}

func arrayMinMaxIndexes<T: Comparable>(of VALUES: [T?]) -> (Int?,Int?) {
    var iMIN : Int!
    var vMIN : T!
    var iMAX : Int!
    var vMAX : T!
    for i in VALUES.range {
        if let V = VALUES[i] {
            if iMIN != nil {
                if V < vMIN {
                    iMIN = i
                    vMIN = V
                }
            } else {
                iMIN = i
                vMIN = V
            }
            if iMAX != nil {
                if V > vMAX {
                    iMAX = i
                    vMAX = V
                }
            } else {
                iMAX = i
                vMAX = V
            }
        }
    }
    return (iMIN,iMAX)
}


public extension Array where Element: Equatable {
    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = index(of: item) {
            move(at: index, to: newIndex)
        }
    }
    
    mutating func bringToFront(item: Element) {
        move(item, to: 0)
    }
    
    mutating func sendToBack(item: Element) {
        move(item, to: endIndex-1)
    }
    
    mutating func moveUp(_ item: Element, loop: Bool = true) {
        guard count > 1 else { return }
        if let index = index(of: item) {
            let newIndex = index + 1
            if newIndex >= count {
                if loop {
                    move(at: index, to: 0)
                }
            } else {
                move(at: index, to: newIndex)
            }
        }
    }
    
    mutating func moveDown(_ item: Element, loop: Bool = true) {
        guard count > 1 else { return }
        if let index = index(of: item) {
            let newIndex = index - 1
            if newIndex < 0 {
                if loop {
                    move(at: index, to: count-1)
                }
            } else {
                move(at: index, to: newIndex)
            }
        }
    }
    
    mutating func moveUp(index: Index, loop: Bool = true) {
        guard count > 1 else { return }
        let newIndex = index + 1
        if newIndex >= count {
            if loop {
                move(at: index, to: 0)
            }
        } else {
            move(at: index, to: Swift.max(0,newIndex))
        }
    }
    
    mutating func moveDown(index: Index, loop: Bool = true) {
        guard count > 1 else { return }
        let newIndex = index - 1
        if newIndex < 0 {
            if loop {
                move(at: index, to: count-1)
            }
        } else {
            move(at: index, to: Swift.min(count-1,newIndex))
        }
    }

    mutating func moveUp(index: Index, by: Int, loop: Bool = true) {
        guard count > 1 else { return }
        var by = by
        while by > 0 {
            moveUp(index: index, loop: loop)
            by -= 1
        }
    }
    
    mutating func moveDown(index: Index, by: Int, loop: Bool = true) {
        guard count > 1 else { return }
        var by = by
        while by > 0 {
            moveDown(index: index, loop: loop)
            by -= 1
        }
    }
    
}

public extension Array {
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}


public extension Array where Element == Double {
    var indexOfMaxValue : Int? {
        var imax : Int!
        var vmax : Double!
        for i in range {
            if vmax == nil || vmax < self[i] {
                imax = i
                vmax = self[i]
            }
        }
        return imax
    }
    var indexOfMinValue : Int? {
        var imin : Int!
        var vmin : Double!
        for i in range {
            if vmin == nil || vmin > self[i] {
                imin = i
                vmin = self[i]
            }
        }
        return imin
    }
    
//    var indexOfMinValue1 : Int? {
//        var v : Double!
//        return reduce(v, {
//            $0 == nil ? $1 : $0 > $1 ? $1 : $0
//        })
//    }
    
    func indexMatchingTest(from: Int, til: Int, test: (_ stored: Double, _ current: Double)->Bool) -> Int? {
        
        let from = from.clamped(minimum: 0, maximum: count)
        let til  = til.clamped(minimum: from, maximum: count)
        
        guard from < til else {
            return nil
        }
        
        var V0 : Double!
        var I0 : Index?
        
        for i in from..<til {
            if V0 == nil {
                V0 = self[i]
                I0 = i
                continue
            }
            let V = self[i]
            if test(V0,V) {
                V0 = V
                I0 = i
            }
        }
        
        return I0
    }

    func indexWithMinimumValue(from: Int, til: Int) -> Int? {
        indexMatchingTest(from: from, til: til, test: { v0,v1 in
            v1 < v0
        })
    }

    func indexWithMaximumValue(from: Int, til: Int) -> Int? {
        indexMatchingTest(from: from, til: til, test: { v0,v1 in
            v0 < v1
        })
    }

    func indexesMatchingSpans(from: Int, til: Int, span: Int, test: (ArraySlice<Double>)->Bool) -> [Int] {
        
        guard span > 0 else {
            return []
            
        }
        let from = from.clamped(minimum: 0, maximum: count - span)
        let til  = til.clamped(minimum: from - span, maximum: count - span)
        
        guard from < til else {
            return []
        }
        
//        var INDEXES : [Int] = []
//        
//        for i in from..<til {
//            if test(self[i...i+span]) {
//                INDEXES.append(i)
//            }
//        }
//        
//        return INDEXES
        
        return (from..<til).compactMap { i in
            test(self[i...i+span]) ? i : nil
        }
    }


}


public extension Array where Element : Hashable {
    var asDictionaryIndex : [Element : Int] {
        range.asArray.asDictionary { i in
            (self[i],i)
        }
    }
    
    func asArrayIndex(in other: [Element]) -> [Int?] {
        let indices = other.asDictionaryIndex
        return self.map { e in
            indices[e]
        }
    }
    
    func asArrayIndex(in other: [Element], fallback: Int) -> [Int] {
        let indices = other.asDictionaryIndex
        return self.map { e in
            indices[e] ?? fallback
        }
    }
}


extension Array {

    @discardableResult
    func assigned<Value>(value: Value, to: WritableKeyPath<Element,Value>) -> Self {
        var r = self
        r.assign(value: value, to: to)
        return r
    }

    @discardableResult
    func assigned<Value>(_ value: Value, to: WritableKeyPath<Element,Value>) -> Self {
        assigned(value: value, to: to)
    }
    
    mutating func assign<Value>(value: Value, to: WritableKeyPath<Element,Value>) {
        for i in range {
            self[i][keyPath: to] = value
        }
    }
    
    mutating func assign<Value>(_ value: Value, to: WritableKeyPath<Element,Value>) {
        assign(value: value, to: to)
    }

    func collect<Value>(on: WritableKeyPath<Element,Value>) -> [Value] {
        map { $0[keyPath: on] }
    }
    
    
}

public extension Array where Element : Equatable {
    
    @inlinable func startsWith<PossiblePrefix>(_ possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element {
        starts(with: possiblePrefix)
    }
    @inlinable func endsWith<PossiblePrefix>(_ possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element {
        ends(with: possiblePrefix)
    }
    @inlinable func ends<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element {
        reversed().starts(with: possiblePrefix.reversed())
    }

}

public extension Sequence {
    
//    func sorted<Value>(
//        by keyPath: KeyPath<Self.Element, Value>,
//        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool)
//        rethrows -> [Self.Element]
//    {
//        try self.sorted(by: {
//            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
//        })
//    }

    func sorted<Value: Comparable>(by keyPath: KeyPath<Self.Element, Value>, ascending: Bool) -> [Self.Element]
    {
        ascending ?
            self.sorted(by: { $0[keyPath: keyPath]  <  $1[keyPath: keyPath] })
        :
            self.sorted(by: { $0[keyPath: keyPath]  >  $1[keyPath: keyPath] })
    }
    
    func sorted<Value: Comparable>( by keyPath: KeyPath<Self.Element, Value>) -> [Self.Element]
    {
        self.sorted(by: keyPath, ascending: true)
    }
    
}

public extension Array {
    
    func firstWith<V: Equatable>(_ path: KeyPath<Element,V>, equal to: V) -> Element? {
        self.first(where: { e in
            e[keyPath: path] == to
        })
    }

    func firstIndexWith<V: Equatable>(_ path: KeyPath<Element,V>, equal to: V) -> Int? {
        self.firstIndex(where: { e in
            e[keyPath: path] == to
        })
    }

}

public extension Array {
    
    mutating func swapLeft(at i: Int, loop: Bool) {
        if i > 0 {
            swapAt(i, i-1)
        } else {
            append(remove(at: 0))
        }
    }

    mutating func swapLeft(_ i: Int, _ loop: Bool = true) {
        swapLeft(at: i, loop: loop)
    }

    mutating func swapRight(at i: Int, loop: Bool) {
        if i < count-1 {
            swapAt(i, i+1)
        } else {
            prepend(remove(at: i))
        }
    }

    mutating func swapRight(_ i: Int, _ loop: Bool = true) {
        swapRight(at: i, loop: loop)
    }
}

public extension Array {
    
    @inlinable func minElement(where predicate: (Element) throws -> Double?) rethrows -> (Element,Double)? {
        var R : Element!
        var V : Double!
        for e in self {
            if let D = try predicate(e) {
                if V != nil {
                    if D < V {
                        V = D
                        R = e
                    }
                } else {
                    V = D
                    R = e
                }
            }
        }
        return R == nil ? nil : (R!,V!)
    }

    @inlinable func maxElement(where predicate: (Element) throws -> Double?) rethrows -> (Element,Double)? {
        var R : Element!
        var V : Double!
        for e in self {
            if let D = try predicate(e) {
                if V != nil {
                    if V < D {
                        V = D
                        R = e
                    }
                } else {
                    V = D
                    R = e
                }
            }
        }
        return R == nil ? nil : (R!,V!)
    }

    @inlinable func minIndex(where predicate: (Element) throws -> Double?) rethrows -> (Int,Double)? {
        var R : Int!
        var V : Double!
        for i in self.range {
            let e = self[i]
            if let D = try predicate(e) {
                if V != nil {
                    if D < V {
                        V = D
                        R = i
                    }
                } else {
                    V = D
                    R = i
                }
            }
        }
        return R == nil ? nil : (R!,V!)
    }

    @inlinable func maxIndex(where predicate: (Element) throws -> Double?) rethrows -> (Int,Double)? {
        var R : Int!
        var V : Double!
        for i in self.range {
            let e = self[i]
            if let D = try predicate(e) {
                if V != nil {
                    if V < D {
                        V = D
                        R = i
                    }
                } else {
                    V = D
                    R = i
                }
            }
        }
        return R == nil ? nil : (R!,V!)
    }


}


extension Array {
    
    init(loop: ()->Element?) {
        var V : [Element] = []
        while let v = loop() {
            V.append(v)
        }
        self.init(V)
    }
    
    init(initial: Element, loop: (Element)->Element?) {
        var V = [initial]
        while let v = loop(V.last!) {
            V.append(v)
        }
        self.init(V)
    }
    
}

extension Array where Element : Comparable & Numeric {
    
    init(initial: Element, delta: Element, limit: Element) {
        var V : Self = []
        var v = initial
        if delta > 0 {
            while v < limit {
                V.append(v)
                v += delta
            }
        } else if delta < 0 {
            while v > limit {
                V.append(v)
                v += delta
            }
        }
        self.init(V)
    }
    
}

extension Array : RawRepresentable where Element == Bool {
    
    public init?(rawValue: String) {
        self = rawValue.splitByComma.map { $0 == "T" }
    }
    
    public var rawValue: String {
        map { $0 ? "T" : "F" }.joinedByComma
    }
    
    
    public typealias RawValue = String
    
}

