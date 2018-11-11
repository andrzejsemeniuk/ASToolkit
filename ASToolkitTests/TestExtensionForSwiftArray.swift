//
//  TestExtensionForSwiftArray.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 7/31/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest

//func ==<Element : Equatable> (lhs: [[Element]], rhs: [[Element]]) -> Bool {
//	return lhs.count == rhs.count && !zip(lhs, rhs).contains {$0 != $1 }
//}
func ==<Element : Equatable> (lhs: [[Element]], rhs: [[Element]]) -> Bool {
	return lhs.elementsEqual(rhs, by: ==)
}


class TestExtensionForSwiftArray: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSubarray() {
        let empty = [Int]()
        XCTAssertEqual([1,2,3].subarray(from:0,to:3),[1,2,3])
        XCTAssertEqual(empty.subarray(from:0,to:3),empty)
        XCTAssertEqual([1,2].subarray(from:0,to:3),[1,2])
        XCTAssertEqual([1].subarray(from:0,to:3),[1])

        XCTAssertEqual([1,2,3,4].subarray(from:0,to:1),[1])
        XCTAssertEqual([1,2,3,4].subarray(from:1,to:2),[2])
        XCTAssertEqual([1,2,3,4].subarray(from:0,to:3),[1,2,3])
        XCTAssertEqual([1,2,3,4].subarray(from:3,to:3),empty)
        XCTAssertEqual([1,2,3,4].subarray(from:4,to:3),empty)

        XCTAssertEqual([1,2,3,4].subarray(from:3,length:1),[4])
        XCTAssertEqual([1,2,3,4].subarray(from:2,length:2),[3,4])
        XCTAssertEqual([1,2,3,4].subarray(from:1,length:1),[2])
        XCTAssertEqual([1,2,3,4].subarray(from:0,length:3),[1,2,3])
    }
    
    func testTrim() {
        var a = [1,2,3]
        var r = a
        
        XCTAssertEqual(a.count,3)
        
        r = a.trim(to:2)
        XCTAssertEqual(a.count,2)
        XCTAssertEqual(a,[1,2])
        XCTAssertEqual(r.count,1)
        XCTAssertEqual(r,[3])
        

        r = a.trim(to:0)
        XCTAssertEqual(a.count,0)
        XCTAssertEqual(a,[])
        XCTAssertEqual(r.count,2)
        XCTAssertEqual(r,[1,2])

        a = [1,2,3,4,5]
        r = a.trim(to:1)
        XCTAssertEqual(a.count,1)
        XCTAssertEqual(a,[1])
        XCTAssertEqual(r.count,4)
        XCTAssertEqual(r,[2,3,4,5])
        
        a = [1,2,3]
        XCTAssertEqual(a.trim(to:5).count,0)
        a = []
        XCTAssertEqual(a.trim(to:5).count,0)
    }
    
    func testisNotEmpty() {
        XCTAssertTrue([1,2,3].isNotEmpty)
        XCTAssertFalse([].isNotEmpty)
    }

    func testTransposed() {
        XCTAssertTrue([[1]].transposed() == [[1]])
        XCTAssertTrue([[1,2,3],[4,5]].transposed() == [[1,4],[2,5],[3]])
        XCTAssertTrue([[4,1],[5,2],[3]].transposed() == [[4,5,3],[1,2]])
        XCTAssertTrue([[1,2,3]].transposed() == [[1],[2],[3]])
        XCTAssertTrue([[1],[2],[3]].transposed() == [[1,2,3]])
    }

	func testDimensions() {
		XCTAssertTrue([[]].dimensions == (rows:1,columns:0))
		XCTAssertTrue([[2],[1]].dimensions == (rows:2,columns:1))
		XCTAssertTrue([[2,3],[1]].dimensions == (rows:2,columns:2))
		XCTAssertTrue([[2,3]].dimensions == (rows:1,columns:2))
		XCTAssertTrue([[2],[1,2]].dimensions == (rows:2,columns:2))
		XCTAssertTrue([[2]].dimensions == (rows:1,columns:1))
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
